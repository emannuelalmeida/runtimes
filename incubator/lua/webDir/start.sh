#!/usr/bin/env sh
set -e

envsubst < nginx.conf.template > /kubeless/nginx.conf

openresty -c /kubeless/nginx.conf

cat /usr/local/openresty/nginx/logs/error.log