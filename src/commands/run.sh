
settings_daemon_run() {
settings_daemon_parse_conf "${SETTINGS_DAEMON_CONFIG}"

SETTINGS_DAEMON_BUILD=build

mkdir -p "${SETTINGS_DAEMON_BUILD}"

mkdir -p "${SETTINGS_DAEMON_BUILD}/packet"

find "${SETTINGS_DAEMON_BUILD}" -type d -depth 1 | while read packet; do
    echo "Packet: ${packet}"
done
}
