#!/bin/bash
set -e

source src/parse_conf.sh
#source src/process_resource.sh
source src/tasks/run.sh

SETTINGS_DAEMON_CONFIG=tests/fixtures/settings-daemon.conf

settings_daemon_run

