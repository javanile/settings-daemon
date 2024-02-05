
settings_daemon_run() {
  settings_daemon_parse_conf "${SETTINGS_DAEMON_CONFIG}"

  SETTINGS_DAEMON_BUILD=build

  echo "===[ Settings Daemon Plan ]==="
  echo "${SETTINGS_DAEMON_PLAN}"
  echo "--"

  exit

  mkdir -p "${SETTINGS_DAEMON_BUILD}"
  mkdir -p "${SETTINGS_DAEMON_BUILD}/packet"

  local service_name
  local service_driver
  echo "${SETTINGS_DAEMON_PLAN}" | while read -r entry; do
    entry_type=$(echo "${entry}" | cut -d' ' -f1)
    case "${entry_type}" in
      "SERVICE")
        service_name=$(echo "${entry}" | cut -d' ' -f2)
        service_driver=$(echo "${entry}" | cut -d' ' -f3)
        ;;
      "CONFIG")
        service_config=$(echo "${entry}" | cut -d' ' -f2)
        ;;
      "FILES")
        service_config=$(echo "${entry}" | cut -d' ' -f2)
        ;;
      "RUN")
        "settings_daemon_service_${service_driver}" "${service_name}" "${service_config}" "${service_files}"
        service_name=
        service_driver=
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