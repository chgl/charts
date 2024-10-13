#!/bin/bash

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

git config --global --add safe.directory /root/workspace

CHANGELOG_ENTRY=$(
    cat <<EOF
# When using the list of objects option the valid supported kinds are
# added, changed, deprecated, removed, fixed and security.
- kind: changed
  description: "Updated ${depName} to ${newVersion}"
EOF
)

export CHANGELOG_ENTRY

CHANGED_CHARTS=$(ct list-changed --config=.github/ct/ct.yaml)

for CHART in $CHANGED_CHARTS; do
    echo "$CHART: bumping Chart.yaml version"
    # Bump the chart version by one patch version
    # via <https://github.com/argoproj/argo-helm/blob/main/scripts/renovate-bump-version.sh>
    version=$(grep '^version:' "${CHART}/Chart.yaml" | awk '{print $2}')
    echo "$CHART: current: ${version}"
    major=$(echo "${version}" | cut -d. -f1)
    minor=$(echo "${version}" | cut -d. -f2)
    patch=$(echo "${version}" | cut -d. -f3)
    patch=$((patch + 1))
    echo "$CHART: next: ${version}"
    sed -i "s/^version:.*/version: ${major}.${minor}.${patch}/g" "${CHART}/Chart.yaml"

    echo "$CHART: updating Chart.yaml with auto-generated changelog annotation: Updated ${depName} to ${newVersion}"
    yq -i '.annotations."artifacthub.io/changes" = strenv(CHANGELOG_ENTRY)' "$CHART/Chart.yaml"
done
