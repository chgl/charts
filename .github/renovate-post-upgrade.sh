#!/bin/bash

# via https://github.com/argoproj/argo-helm/blob/main/scripts/renovate-bump-version.sh

depName="${1}"
if [ -z "${depName}" ]; then
  echo "Missing argument 'depName'" >&2
  exit 1
fi

newVersion="${2}"
if [ -z "${newVersion}" ]; then
  echo "Missing argument 'newVersion'" >&2
  exit 1
fi

echo "Changed dep name is: $depName to $newVersion"

depType="${4:-}"
currentVersion="${5:-}"

# The kind test matrix in ci.yaml contains the three latest Kubernetes minor versions. Renovate only updates
# the patch versions of the older two. If the newest version receives a minor update, rotate the list:
# the previous middle version becomes the oldest and the previous newest one becomes the middle version.
if [ "${depName}" = "kindest/node" ]; then
  workflow=".github/workflows/ci.yaml"

  if [ "${depType}" = "k8s-newest" ] && [ -n "${currentVersion}" ] && [ "${currentVersion%.*}" != "${newVersion%.*}" ]; then
    middleVersion=$(grep -A1 "renovate: k8s-version=k8s-middle" "${workflow}" | grep -oE "[0-9]+\.[0-9]+\.[0-9]+")

    echo "Rotating the kind test matrix to: ${middleVersion}, ${currentVersion}, ${newVersion}"

    sed -i -E "/renovate: k8s-version=k8s-oldest/{n;s/[0-9]+\.[0-9]+\.[0-9]+/${middleVersion}/}" "${workflow}"
    sed -i -E "/renovate: k8s-version=k8s-middle/{n;s/[0-9]+\.[0-9]+\.[0-9]+/${currentVersion}/}" "${workflow}"
  fi

  # the workflow isn't part of any chart, so there's no chart version to bump
  exit 0
fi

docker run --rm -v "${PWD}:/root/workspace" ghcr.io/chgl/kube-powertools:v2.3.30@sha256:b7e588f30df97635c271e49ebd15e84c3d2845a67f0eaf20e9c273ad269b2964 /root/workspace/.github/renovate-bump-version.sh "${depName}" "${newVersion}"
