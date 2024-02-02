#!/bin/bash
settings_daemon_parse_conf(){

local config_file
config_file=$1
newline=$'\n'
    while IFS= read line || [[ -n "${line}" ]]; do
      line="${line#"${line%%[![:space:]]*}"}"
      line="${line%"${line##*[![:space:]]}"}"
      line_number=$((line_number + 1))
      [[ -z "${line}" ]] && continue
      [[ "${line::1}" == "#" ]] && continue
      echo "L: $line"
      case $line in
        \[[a-z]*\])
          [ -n "$service" ] && process_service "$service" "$service_args"
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
              service_args="${service_args}${field}=${value}${newline}"
              echo "LLL"
              ;;
          esac
          ;;
        *)
          ;;
      esac
      #echo "L: $line"
    done < "$config_file"


[ -n "$service" ] && process_service "$service" "$service_args"

}

