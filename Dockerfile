FROM phpmanual/repos-pt-br:latest

MAINTAINER rogeriopradoj <rogeriopradoj@gmail.com>

COPY .scripts/ /scripts

VOLUME /volume

ENTRYPOINT ["/scripts/0-default.sh"]
