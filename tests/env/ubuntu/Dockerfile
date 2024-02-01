FROM ubuntu:22.04

#RUN apt-get update \
#    && apt-get install -y --no-install-recommends \
#       software-properties-common rsyslog systemd systemd-cron sudo make \
#    && rm -rf /var/lib/apt/lists/*

#COPY docker-entrypoint.sh /usr/local/bin/

#RUN chmod +x /usr/local/bin/docker-entrypoint.sh

#ENTRYPOINT ["docker-entrypoint.sh"]

RUN echo 'root:root' | chpasswd
RUN printf '#!/bin/sh\nexit 0' > /usr/sbin/policy-rc.d
RUN apt-get update
RUN apt-get install -y systemd systemd-sysv dbus dbus-user-session
RUN printf "systemctl start systemd-logind" >> /etc/profile

ENTRYPOINT ["/sbin/init"]
