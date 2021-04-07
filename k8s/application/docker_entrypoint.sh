#!/usr/bin/env bash
set -e -o pipefail

if [ $# -gt 0 ]; then
  export SERVER_PORT=$1
fi

envsubst '$SERVER_PORT' < /etc/nginx/template/nginx.conf > /etc/nginx/nginx.conf

nginx -g 'daemon off;'
