#!/bin/sh
REGISTRY=registry.jrbhome.net
APP_NAME=bg3-tools
VERSION=`git rev-parse --short=8 HEAD`
FULL_BUILD="${REGISTRY}/${APP_NAME}:${VERSION}"
docker buildx build -t ${FULL_BUILD} .
docker push $FULL_BUILD
