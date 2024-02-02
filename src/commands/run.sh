
settings_daemon_run() {
settings_daemon_parse_conf "${SETTINGS_DAEMON_CONFIG}"

SETTINGS_DAEMON_BUILD=build

mkdir -p "${SETTINGS_DAEMON_BUILD}"

mkdir -p "${SETTINGS_DAEMON_BUILD}/packet"

find "${SETTINGS_DAEMON_BUILD}" -type d -depth 1 | while read packet; do
    echo "Packet: ${packet}"
    packet_dir=$(realpath "${packet}")
    packet_file=${packet_dir}.zip
    touch "${packet_dir}/test"
    run_pwd=${PWD}
    cd "${packet_dir}"
    zip -o -r ${packet_file} .
    cd "${run_pwd}"
done
}
