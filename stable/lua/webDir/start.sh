#!/usr/bin/env sh
set -e

envsubst < nginx.conf.template > nginx.conf
mv -f nginx.conf /usr/local/openresty/nginx/conf/
service openresty start

cat >> /dev/null