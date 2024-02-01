#!/bin/bash
set -e

## Start SystemD daemon


cd /opt/settings-daemon
make install

journalctl -fu settings-daemon.service
