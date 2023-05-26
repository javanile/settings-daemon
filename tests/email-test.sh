#!/usr/bin/env bash
set -e

source .env

s-nail -v \
  -S smtp-use-starttls \
  -S ssl-verify=ignore \
  -S smtp-auth=login \
  -S smtp=smtp://smtp.gmail.com:587 \
  -S from="javanile.develop@gmail.com" \
  -S smtp-auth-user=javanile.develop@gmail.com \
  -S "smtp-auth-password=${SETTINGS_DAEMON_SMTP_PASSWORD}" \
  -S ssl-verify=ignore \
  -S nss-config-dir=~/.certs \
  -s "[BACKUP] Settings Daemon: Ufficio" \
  -M "text/html" \
  -a tests/fixtures/attachment.zip \
  info.francescobianco@gmail.com \
  < assets/html/email.html
