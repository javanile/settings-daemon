#!/usr/bin/env bash
set -e

docker compose -f tests/env/docker-compose.yml run --build ubuntu
