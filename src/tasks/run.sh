
settings_daemon_run() {
  local plan=

  plan=$(settings_daemon_parse_conf "${SETTINGS_DAEMON_CONFIG}")

  SETTINGS_DAEMON_BUILD=build

  echo "===[ Settings Daemon Plan ]==="
  echo "${plan}"
  echo "--"


  mkdir -p "${SETTINGS_DAEMON_BUILD}"
  mkdir -p "${SETTINGS_DAEMON_BUILD}/packet"

  local service_name
  local service_type
  echo "${plan}" | while read -r entry; do
    entry_type=$(echo "${entry}" | cut -d' ' -f1)
    case "${entry_type}" in
      SERVICE)
        service_name=$(echo "${entry}" | cut -d' ' -f2)
        service_type=$(echo "${entry}" | cut -d' ' -f3)
        ;;
      CONFIG)
        service_config=$(echo "${entry}" | cut -d' ' -f2-)
        ;;
      FILES)
        service_files=$(echo "${entry}" | cut -d' ' -f2-)
        echo "$service_files"
        ;;
      RUN)
        "settings_daemon_type_${service_type}" "${service_name}" "${service_config}" "${service_files}"
        service_name=
        service_type=
        service_config=
        service_files=
        ;;
      *)
        echo "Unknown entry type: ${entry_type}"
        exit 1
        ;;
    esac
  done
}


settings_daemon_build() {

      echo "Packet: ${packet}"
      packet_dir=$(realpath "${packet}")
      packet_file=${packet_dir}.zip
      touch "${packet_dir}/test"
      run_pwd=${PWD}
      cd "${packet_dir}"
      zip -o -r "${packet_file}" .
      cd "${run_pwd}"
}