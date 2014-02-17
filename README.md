## docker-mail
===========

Postfix+Dovecot in Docker


### Usage
docker run -d -p 25:25 -p 143:143 -p 993:993 cpuguy83/mail

You'll want to proivde your on main.cf and dovecot.conf, this will just use the postfix default.<br />
For conveneince the configurations are available as a volume. <br />
You can edit these directly by doing "docker inspect $container_id" and look for the Volume json node.
