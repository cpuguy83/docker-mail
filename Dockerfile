FROM ubuntu:12.04
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq && apt-get install -y postfix dovecot-imapd dovecot-ldap runit -qq
RUN rm -rf /etc/sv/getty-5

RUN echo "protocols = imap" >> /etc/dovecot/dovecot.conf

ADD submission.cf /tmp/
RUN cat /tmp/submission.cf >> /etc/master.cf

ADD 10-postfix-listener.conf /etc/dovecot/conf.d/

RUN mkdir -p /etc/sv/postfix
RUN mkdir -p /etc/sv/dovecot
ADD postfix_run /etc/sv/postfix/run
ADD postfix_finish /etc/sv/postfix/finish
ADD dovecot_run /etc/sv/dovecot/run
RUN chmod 0755 /home

RUN useradd vmail -g mail -s /sbin/nologin -d /var/vmail

VOLUME ["/etc/postfix", "/var/mail", "/var/spool/mail", "/etc/dovecot"]

EXPOSE 25/tcp 143/tcp 993/tcp
ENTRYPOINT ["/usr/bin/runsvdir", "/etc/sv"]
