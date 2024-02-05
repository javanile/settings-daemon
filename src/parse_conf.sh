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

  newline=$'\n'
  config_file=$1

  service=
  service_name=
  service_type=
  service_config=
  service_files=

  while IFS= read -r line || [[ -n "${line}" ]]; do
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    line_number=$((line_number + 1))
    [[ -z "${line}" ]] && continue
    [[ "${line::1}" == "#" ]] && continue

    echo "L: $line"

    case "${line}" in
      \[[a-z]*\])
        [ -n "$service" ] && settings_daemon_plan "$service_name" "$service_type" "$service_config" "$service_files"
        service=$(echo "$line" | tr -d '[]')
        service_name=$service
        service_type=files
        service_config=
        service_files=
        ;;
      [a-z_-]*)
        case $service in
          settings-daemon)
            field=$(echo "$line" | cut -d'=' -f1 | xargs | awk '{ print toupper($0) }')
            value=$(echo "$line" | cut -d'=' -f2 | xargs)
            eval "SETTINGS_DAEMON_${field}=\$value"
            ;;
          *)
            field=$(echo "$line" | cut -d'=' -f1 | xargs | tr '-' '_')
            value=$(echo "$line" | cut -d'=' -f2 | xargs)
            case "${field}" in
              name)
                service_name="${value}"
                ;;
              type)
                service_type="${value}"
                ;;
              files)
                echo "Files: $value"
                service_files="${service_files}${value} "
                ;;
              *)
                service_config="${service_config}${field}=${value} "
                ;;
            esac
          ;;
        esac
        ;;
      *)
        ;;
    esac
    #echo "L: $line"
  done < "$config_file"

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
