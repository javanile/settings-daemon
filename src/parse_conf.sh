#!/bin/bash

settings_daemon_parse_conf() {
  echo "Parsing configuration file"

  SETTINGS_DAEMON_PLAN=

  if [ ! -f "$1" ]; then
    echo "File not exists: '$1'"
    exit 1
  fi

  local config_file
  local service_name
  local service_type
  local service_config
  local service_files

  local field
  local value
  local state

  newline=$'\n'
  config_file=$1

  service=
  service_name=
  service_type=
  service_config=
  service_files=

  field=
  value=
  state=

  sed '$a\[end]' "$config_file" | while IFS= read -r line; do
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    line_number=$((line_number + 1))
    [[ -z "${line}" ]] && continue
    [[ "${line::1}" == "#" ]] && continue

    echo "L: $line - F: $field - S: $service"

    case "${line}" in
      \[[a-z]*\]) state=new_entry ;;
        echo "!!LINE: $line"
        ;;
    esac

    if [ -n "${field}" ]; then
              if [ "${service}" = "settings-daemon" ]; then
                eval "SETTINGS_DAEMON_${field}=\$value"
              fi
              case "${field}" in
                NAME)
                  service_name="${value}"
                  ;;
                TYPE)
                  service_type="${value}"
                  ;;
                FILES)
                  echo "Files: $value"
                  service_files="${service_files}${value},"
                  ;;
                *)
                  service_config="${service_config}${field}=${value} "
                  ;;
              esac
            fi


    [ -n "$service" ] && settings_daemon_plan "$service_name" "$service_type" "$service_config" "$service_files"
            service=$(echo "$line" | tr -d '[]')
            service_name=$service
            service_type=files
            service_config=
            service_files=

    case "${line}" in
      \[[a-z]*\])

        ;;
      [a-z_-\ ]*=.*)
        field=$(echo "$line" | cut -d'=' -f1 | xargs | tr '-' '_' | awk '{ print toupper($0) }')
        value=$(echo "$line" | cut -d'=' -f2 | xargs)
        ;;
      *)
        value="${value}${line}"
        ;;
    esac



    #echo "L: $line"
  done

  [ -n "$service" ] && settings_daemon_plan "$service_name" "$service_type" "$service_config" "$service_files"
}

settings_daemon_plan() {
  local newline
  local service_name
  local service_type
  local service_config
  local service_files

  newline=$'\n'
  service_name=$1
  service_type=$2
  service_config=$3
  service_files=$4

  SETTINGS_DAEMON_PLAN="${SETTINGS_DAEMON_PLAN}SERVICE ${service_name} ${service_type}${newline}"
  SETTINGS_DAEMON_PLAN="${SETTINGS_DAEMON_PLAN}CONFIG ${service_config}${newline}"
  SETTINGS_DAEMON_PLAN="${SETTINGS_DAEMON_PLAN}FILES ${service_files}${newline}"
  SETTINGS_DAEMON_PLAN="${SETTINGS_DAEMON_PLAN}RUN${newline}"
  SETTINGS_DAEMON_PLAN="${SETTINGS_DAEMON_PLAN}${newline}"
}
