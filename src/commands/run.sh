
settings_daemon_run() {
  settings_daemon_parse_conf "${SETTINGS_DAEMON_CONFIG}"

  SETTINGS_DAEMON_BUILD=build

  echo "===[ Settings Daemon Plan ]==="
  echo "${SETTINGS_DAEMON_PLAN}"
  echo "--"

  mkdir -p "${SETTINGS_DAEMON_BUILD}"
  mkdir -p "${SETTINGS_DAEMON_BUILD}/packet"

  echo "${SETTINGS_DAEMON_PLAN}" | while read -r entry; do
    echo "Packet: ${packet}"
    packet_dir=$(realpath "${packet}")
    packet_file=${packet_dir}.zip
    touch "${packet_dir}/test"
    run_pwd=${PWD}
    cd "${packet_dir}"
    zip -o -r "${packet_file}" .
    cd "${run_pwd}"
    entry_type=$(echo "${entry}" | cut -d' ' -f1)
    case "${entry_type}" in
      "RUN")
        ${service_driver} "${service_settings}" "${service_files}"
        ;;
      *)
        echo "Unknown entry type: ${entry_type}"
        exit 1
        ;;
    esac
  done
}
