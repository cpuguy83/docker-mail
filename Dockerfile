FROM ubuntu:12.04
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq && apt-get install -y postfix dovecot-imapd dovecot-ldap postfix-ldap runit -qq
RUN rm -rf /etc/sv/getty-5

RUN echo "protocols = imap" >> /etc/dovecot/dovecot.conf
RUN echo -e "smtpd_sasl_auth_enable = yes\nsmtpd_sasl_type = dovecot\nsmtpd_sasl_path = private/auth\nsmtpd_relay_restrictionsi = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination" >> /etc/postfix/main.cf

ADD 10-postfix-listener.conf /etc/dovecot/conf.d/

RUN mkdir -p /etc/sv/postfix
RUN mkdir -p /etc/sv/dovecot
ADD postfix_run /etc/sv/postfix/run
ADD postfix_finish /etc/sv/postfix/finish
ADD dovecot_run /etc/sv/dovecot/run
RUN chmod 0755 /home

RUN useradd vmail -g mail -s /sbin/nologin -d /var/mail && chmod 0777 /var

VOLUME ["/etc/postfix", "/var/mail", "/var/spool/mail", "/etc/dovecot"]

EXPOSE 25/tcp 143/tcp 993/tcp
ENTRYPOINT ["/usr/bin/runsvdir", "/etc/sv"]
