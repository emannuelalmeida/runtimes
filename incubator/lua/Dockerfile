FROM bitnami/minideb:buster

LABEL maintainer "Ícaro Menezes <emannuelalmeida@gmail.com>"

RUN install_packages wget gnupg2 ca-certificates software-properties-common
RUN wget -O - https://openresty.org/package/pubkey.gpg | apt-key add -
RUN add-apt-repository -y "deb http://openresty.org/package/debian buster openresty"
RUN apt-get update
RUN install_packages lua5.3 liblua5.3-dev curl ca-certificates git luarocks gcc openresty gettext-base

ADD webDir /

ENV FUNC_PROCESS="./start.sh"

ADD proxy /

CMD [ "/proxy" ]
