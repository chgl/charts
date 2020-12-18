#!/bin/bash
set -euo pipefail

echo "Running chart-doc-gen..."

for chart in charts/*; do
    echo "Chart $chart:"

    if test -f "${chart}/README.tpl"; then
        echo "${chart}/README.tpl exists"
        chart-doc-gen -d="${chart}/doc.yaml" -v="${chart}/values.yaml" -t="${chart}/README.tpl" > "${chart}/README.md"
    else
        chart-doc-gen -d="${chart}/doc.yaml" -v="${chart}/values.yaml" > "${chart}/README.md"
    fi
done

echo "Running prettier..."

prettier --write charts/**/README.md
