#!/bin/bash

# via https://github.com/argoproj/argo-helm/blob/main/scripts/renovate-bump-version.sh

depName="${1}"
if [ -z "${depName}" ]; then
    echo "Missing argument 'depName'" >&2
    exit 1
fi

echo "Changed dep name is: $depName"
echo "----------------------------------------"

git --no-pager diff

docker version

ct list-changed || true

docker run --rm -it -v "${PWD}:/root/workspace" ghcr.io/chgl/kube-powertools:v2.3.25@sha256:99b5cc7a49cd443fb953ca4ab52dc45245a5c43ad03e3503be06d0d0f512b67d git config --global --add safe.directory /root/workspace && ct list-changed --config=.github/ct/ct.yaml
