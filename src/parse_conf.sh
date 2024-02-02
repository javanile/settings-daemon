#!/bin/bash

settings_daemon_parse_conf() {
  echo "Parsing configuration file"

  SETTINGS_DAEMON_PLAN=

  if [ ! -f "$1" ]; then
    echo "File not exists: '$1'"
    exit 1
  fi

  config_file=$1
  newline=$'\n'
  while IFS= read -r line || [[ -n "${line}" ]]; do
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    line_number=$((line_number + 1))
    [[ -z "${line}" ]] && continue
    [[ "${line::1}" == "#" ]] && continue

    echo "L: $line"

    case "${line}" in
      \[[a-z]*\])
        [ -n "$service" ] && settings_daemon_plan "$service" "$service_args"
        service=$(echo "$line" | tr -d '[]')
        service_args=
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

            service_args="${service_args}${field}=${value} "
            echo "LLL"
            ;;
        esac
        ;;
      *)
        ;;
    esac
    #echo "L: $line"
  done < "$config_file"

  [ -n "$service" ] && settings_daemon_plan "$service" "$service_args"
}

settings_daemon_plan() {
  newline=$'\n'
  service=$1
  service_config=$2
  service_files=$3
  SETTINGS_DAEMON_PLAN="${SETTINGS_DAEMON_PLAN}SERVICE ${service}${newline}"
  SETTINGS_DAEMON_PLAN="${SETTINGS_DAEMON_PLAN}CONFIG ${service_config}${newline}"
  SETTINGS_DAEMON_PLAN="${SETTINGS_DAEMON_PLAN}FILES ${service_files}${newline}"
  SETTINGS_DAEMON_PLAN="${SETTINGS_DAEMON_PLAN}RUN${newline}"
  SETTINGS_DAEMON_PLAN="${SETTINGS_DAEMON_PLAN}${newline}"
}