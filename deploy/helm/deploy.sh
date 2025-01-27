#!/bin/sh
VERSION=`git rev-parse --short=8 HEAD`;  helm upgrade bg3-tools . --install --set version=${VERSION} --set appName=bg3-tools --set environment=production --namespace apps-production --values=values.yaml --values=secrets-values.yaml
