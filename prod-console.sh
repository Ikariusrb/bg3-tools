#!/bin/sh
kubectl exec -it deploy/bg3-tools-production -n apps-production -- bin/rails console
