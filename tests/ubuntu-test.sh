#!/usr/bin/env bash
set -e

docker compose -f tests/env/docker-compose.yml up --build -d ubuntu && sleep 5

docker compose -f tests/env/docker-compose.yml exec ubuntu test-runner.sh