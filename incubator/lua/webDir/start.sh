#!/usr/bin/env sh
set -e

envsubst < nginx.conf.template > /kubeless/nginx.conf
#mv -f /kubeless/nginx.conf /usr/local/openresty/nginx/conf/
#service openresty start
#service openresty -c /kubeless/nginx.conf start

openresty -c /kubeless/nginx.conf

cat /usr/local/openresty/nginx/logs/error.log