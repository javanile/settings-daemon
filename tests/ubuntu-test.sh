#!/usr/bin/env bash
set -e

echo "root\nroot" | docker compose -f tests/env/docker-compose.yml run --rm --build ubuntu
