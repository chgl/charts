#!/bin/bash
set -euo pipefail

SCHEMA_LOCATION="https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/"
KUBERNETES_VERSIONS="v1.16.0 v1.17.0 v1.18.0 v1.19.0"
CHARTS_DIR=${CHARTS_DIR:-"charts/*"}
SHOULD_UPDATE_DEPENDENCIES=${SHOULD_UPDATE_DEPENDENCIES:-""}

POLARIS_SCORE_THRESHOLD=${POLARIS_SCORE_THRESHOLD:-86}
SKIP_KUBE_SCORE=${SKIP_KUBE_SCORE:-"1"}
KUBE_SCORE_ARGS=""
SKIP_KUBE_LINTER=${SKIP_KUBE_LINTER:-"1"}

for CHART_PATH in $CHARTS_DIR; do
    echo "Power-linting ${CHART_PATH}:"

    if [ "$SHOULD_UPDATE_DEPENDENCIES" = true ]; then
        echo "Updating helm dependencies"
        helm dependency update ${CHART_PATH}
    fi

    HELM_TEMPLATE_ARGS=""
    TEST_VALUES_FILE="$CHART_PATH/values-test.yaml"
    if [ -f "$TEST_VALUES_FILE" ]; then
        HELM_TEMPLATE_ARGS="-f ${CHART_PATH}/values-test.yaml"
    fi

    echo "Kubeval check..."

    for KUBERNETES_VERSION in ${KUBERNETES_VERSIONS}; do
        echo "Validating against Kubernetes version $KUBERNETES_VERSION:"

        if ! helm template ${HELM_TEMPLATE_ARGS} ${CHART_PATH} |
            kubeval --strict \
                --ignore-missing-schemas \
                --kubernetes-version "${KUBERNETES_VERSION#v}" \
                --schema-location "${SCHEMA_LOCATION}"; then
            echo "kubeval validation failed"
            exit 1
        fi
    done

    echo "Polaris check..."

    POLARIS_AUDIT_ARGS=""
    POLARIS_CONFIG_FILE=".polaris.yaml"
    if [ -f "$POLARIS_CONFIG_FILE" ]; then
        POLARIS_AUDIT_ARGS="--config ${POLARIS_CONFIG_FILE}"
    fi

    if ! helm template ${HELM_TEMPLATE_ARGS} ${CHART_PATH} |
        polaris audit \
            --audit-path - \
            --format yaml \
            $POLARIS_AUDIT_ARGS \
            --set-exit-code-on-danger \
            --set-exit-code-below-score $POLARIS_SCORE_THRESHOLD; then
        echo "Polaris failed"
        exit 1
    fi

    echo "Pluto check..."

    if ! helm template ${HELM_TEMPLATE_ARGS} ${CHART_PATH} | pluto detect -; then
        echo "Pluto failed"
        exit 1
    fi

    if [ "$SKIP_KUBE_LINTER" -ne "1" ]; then
        echo "Kube-Linter check..."

        KUBE_LINTER__ARGS=""
        KUBE_LINTER_CONFIG_FILE=".kube-linter.yaml"
        if [ -f "$KUBE_LINTER_CONFIG_FILE" ]; then
            KUBE_LINTER__ARGS="--config ${KUBE_LINTER_CONFIG_FILE}"
        fi

        if ! helm template ${HELM_TEMPLATE_ARGS} ${CHART_PATH} | kube-linter lint $KUBE_LINTER__ARGS -; then
            echo "Kube-Linter failed"
            exit 1
        fi
    fi

    if [ "$SKIP_KUBE_SCORE" -ne "1" ]; then
        echo "Kube-Score check..."
        if ! helm template ${HELM_TEMPLATE_ARGS} ${CHART_PATH} |
            kube-score score $KUBE_SCORE_ARGS -; then
            echo "Kube-Score failed"
            exit 1
        fi
    fi
done
