#!/bin/bash
set -e

## Start SystemD daemon
systemctl --help

cd /opt/settings-daemon
make install

journalctl -fu settings-daemon.service
