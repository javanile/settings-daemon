#!/usr/bin/env bash
set -e

export SETTINGS_DAEMON_CONFIG=tests/fixtures/settings-daemon.conf

./bin/settings-daemon

