#!/bin/sh
set -ea

_stopStrapi() {
  echo "Stopping strapi"
  kill -SIGINT "$strapiPID"
  wait "$strapiPID"
}

trap _stopStrapi SIGTERM SIGINT

echo Container running strapi with version: $STRAPI_BUILD_VERSION

cd $APP_NAME
strapi start &

strapiPID=$!
wait "$strapiPID"
