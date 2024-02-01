FROM ubuntu:22.04

#RUN apt-get update \
#    && apt-get install -y --no-install-recommends \
#       software-properties-common rsyslog systemd systemd-cron sudo make \
#    && rm -rf /var/lib/apt/lists/*


#ENTRYPOINT ["docker-entrypoint.sh"]ls

RUN echo 'root:root' | chpasswd
RUN printf '#!/bin/sh\nexit 0' > /usr/sbin/policy-rc.d
RUN apt-get update
RUN apt-get install -y systemd systemd-sysv dbus dbus-user-session make
RUN printf "systemctl start systemd-logind" >> /etc/profile

COPY test-runner.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/test-runner.sh

ENTRYPOINT ["/sbin/init"]
