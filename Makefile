
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

install:
	@cp assets/systemd/settings-daemon.timer /etc/systemd/system/
	@cp assets/systemd/settings-daemon.service /etc/systemd/system/
	@systemctl daemon-reload
	@systemctl enable settings-daemon.service
	@systemctl start settings-daemon.service

install-duplicati-client:
	@git clone https://github.com/pectojin/duplicati-client.git lib/duplicati-client || true
	@cd lib/duplicati-client && pip3 install -r requirements.txt
	@sudo ln -s $(ROOT_DIR)/lib/duplicati-client/duplicati_client.py bin/duc

fix-permissions:
	@chmod +x bin/settings-daemon

test-duplicati: fix-permissions
	@bash tests/duplicati-test.sh

test-email: fix-permissions
	@bash tests/email-test.sh

test-config:
	@bash tests/config-test.sh

test-ubuntu:
	@bash tests/ubuntu-test.sh
