#!/bin/bash
set -e

## Start SystemD daemon
/lib/systemd/systemd --system &

cd /opt/settings-daemon
make install

journalctl -fu settings-daemon.service
