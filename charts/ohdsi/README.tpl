# {{ .Project.ShortName }}

[{{ .Project.Name }}]({{ .Project.URL }}) - {{ .Project.Description }}

## TL;DR;

```console
$ helm repo add {{ .Repository.Name }} {{ .Repository.URL }}
$ helm repo update
$ helm install {{ .Release.Name }} {{ .Repository.Name }}/{{ .Chart.Name }} -n {{ .Release.Namespace }}{{ with .Chart.Version }} --version={{.}}{{ end }}
```

## Breaking Changes

### 0.14

Updates all object labels to follow the Bitnami chart conventions: <https://github.com/bitnami/charts/blob/master/bitnami/common/templates/_labels.tpl>.

If you have installed a previous version and attempt to update, you will most likely receive something similar to the following message:

```console
Error: UPGRADE FAILED: cannot patch "ohdsi-atlas" with kind Deployment: Deployment.apps "ohdsi-atlas" is invalid: spec.selector:
Invalid value: v1.LabelSelector{MatchLabels:map[string]string{"app.kubernetes.io/component":"atlas", "app.kubernetes.io/instance":"ohdsi", "app.kubernetes.io/name":"ohdsi"},
MatchExpressions:[]v1.LabelSelectorRequirement(nil)}: field is immutable [...]
```

Unfortunately, the only solution is to delete and re-install the chart.
The following assumes that you have previously installed version `0.13.0`
of the chart in the `ohdsi` namespace and used the included PostgreSQL sub-chart:

```sh
$ helm ls -n ohdsi
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
ohdsi   ohdsi           3               2022-04-03 22:21:13.8195241 +0200 CEST  deployed        ohdsi-0.13.0    2.10.1

# if not saved anywhere else, first retrieve the password used by the PostgreSQL sub-chart
export POSTGRES_PASSWORD=$(kubectl get secret --namespace ohdsi ohdsi-postgresql -o jsonpath="{.data.postgres-password}" | base64 --decode)

# if you depend on the data used by the PostgreSQL sub-chart, please make sure
# uninstalling the release doesn't automatically delete the PVC before running the following
$ helm uninstall -n ohdsi ohdsi
release "ohdsi" uninstalled

$ kubectl get pvc -n ohdsi
NAME                      STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
data-ohdsi-postgresql-0   Bound    pvc-91614c49-cfe6-421a-8990-3317dfd88030   8Gi        RWO            standard       17m

# this uses the $POSTGRES_PASSWORD retrieved in the first step
# since we didn't rename the release, this will re-use the PVC `data-ohdsi-postgresql-0` used for the previous installation
helm upgrade --install -n ohdsi --render-subchart-notes --set postgresql.auth.postgresPassword="${POSTGRES_PASSWORD}" ohdsi charts/ohdsi/
```

### 0.12

Updates the included Bitnami PostgreSQL sub-chart to v11. The default Postgres version is now 14.2.

Steps to upgrade from an existing installation:

1. if you are using the sub-chart, either manually upgrade an existing postgres installation to v14.2 or set `postgresql.image.tag: 13.1.0`.
1. the default key name for the postgres secret has been renamed from `postgresql-password` to `postgres-password`. If you are using the `existingSecret` option, you may have to manually update accordingly.
1. if you are overriding any other of the sub-chart's values, please see <https://docs.bitnami.com/kubernetes/infrastructure/postgresql/administration/upgrade/> for instructions on upgrading.

### 0.4

Starting with v0.4.0, the two separate ingress resources for WebAPI and Atlas have been merged into a single one with the `/WebAPI/` and `/atlas/` paths
mapping to the WebAPI and Atlas service respectively. Set `ingress.enabled=true` and configure `ingress.hosts[]` to enabled it.

## Introduction

This chart deploys {{ .Project.App }} on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites
{{ range .Prerequisites }}
- {{ . }}
{{- end }}

## Installing the Chart

To install the chart with the release name `{{ .Release.Name }}`:

```console
$ helm install {{ .Release.Name }} {{ .Repository.Name }}/{{ .Chart.Name }} -n {{ .Release.Namespace }}{{ with .Chart.Version }} --version={{.}}{{ end }}
```

The command deploys {{ .Project.App }} on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `{{ .Release.Name }}`:

```console
$ helm delete {{ .Release.Name }} -n {{ .Release.Namespace }}
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `{{ .Chart.Name }}` chart and their default values.

{{ .Chart.Values }}

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```console
$ helm install {{ .Release.Name }} {{ .Repository.Name }}/{{ .Chart.Name }} -n {{ .Release.Namespace }}{{ with .Chart.Version }} --version={{.}}{{ end }} --set {{ .Chart.ValuesExample }}
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```console
$ helm install {{ .Release.Name }} {{ .Repository.Name }}/{{ .Chart.Name }} -n {{ .Release.Namespace }}{{ with .Chart.Version }} --version={{.}}{{ end }} --values values.yaml
```

## Initialize the CDM using a custom container

The `cdmInitJob` configuration parameter can be used to configure a custom container that is run as a Kubernetes Job
when the chart is installed. See [templates/cdm-init-job.yaml](templates/cdm-init-job.yaml) for a list of default environment
variables passed to the container.

As an example, here's one such container's `entrypoint.sh` and the associated Dockerfile below:

```sh
#!/bin/bash
set -e

OMOP_INIT_BASE_DIR="/opt/omop-init"

SOURCES_DIR="$OMOP_INIT_BASE_DIR/sources"
VOCABS_DIR="$OMOP_INIT_BASE_DIR/vocabs"
SCHEMAS_DIR="$OMOP_INIT_BASE_DIR/schemas"
POSTINIT_DIR="$OMOP_INIT_BASE_DIR/postinit"

WEBAPI_URL=${WEBAPI_URL:?"WEBAPI_URL required but not set"}
PGPASSWORD=${PGPASSWORD:?"PGPASSWORD required but not set"}
PGHOST=${PGHOST:?"PGHOST required but not set"}

export PGDATABASE=${PGDATABASE:-"ohdsi"}
export PGUSER=${PGUSER:-"postgres"}
export PGPORT=${PGPORT:-"5432"}

CDM_DIR="$VOCABS_DIR/cdm"

mkdir -p "$VOCABS_DIR"

echo "$(date): Extracting CDM vocabs"
tar -xzvf "$SOURCES_DIR/cdm.tar.gz" -C "$VOCABS_DIR/"

echo "$(date): Checking if Postgres @ $PGHOST:$PGPORT is up"
until psql -c "select 1"; do
    echo "$(date): Waiting for Postgres to be up"
    sleep 5
done
echo "$(date): Postgres is up"

echo "$(date): Creating Schema"
for SQL_FILE in init_omop/*; do
    echo "$(date): Applying $SQL_FILE"
    psql -f "$SQL_FILE"
done

echo "$(date): Copying vocabulary"

psql <<-EOSQL
    \COPY cdm.drug_strength FROM '$CDM_DIR/DRUG_STRENGTH.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b';
    \COPY cdm.concept FROM '$CDM_DIR/CONCEPT.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b';
    \COPY cdm.concept_relationship FROM '$CDM_DIR/CONCEPT_RELATIONSHIP.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b';
    \COPY cdm.concept_ancestor FROM '$CDM_DIR/CONCEPT_ANCESTOR.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b';
    \COPY cdm.concept_synonym FROM '$CDM_DIR/CONCEPT_SYNONYM.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b';
    \COPY cdm.vocabulary FROM '$CDM_DIR/VOCABULARY.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b';
    \COPY cdm.relationship FROM '$CDM_DIR/RELATIONSHIP.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b';
    \COPY cdm.concept_class FROM '$CDM_DIR/CONCEPT_CLASS.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b';
    \COPY cdm.domain FROM '$CDM_DIR/DOMAIN.csv' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b';
EOSQL

echo "$(date): Creating DB indices"
PGOPTIONS=--search_path=cdm psql -f "$POSTINIT_DIR/indexes.sql"

echo "$(date): Creating DB constraints"
PGOPTIONS=--search_path=cdm psql -f "$POSTINIT_DIR/constraints.sql"

echo "$(date): Creating CDM results tables"
PGOPTIONS=--search_path=cdm psql -f "$POSTINIT_DIR/restabs_cdm.sql"

echo "$(date): Waiting for WebAPI @ $WEBAPI_URL to be up"
until [ "$(curl -s -o /dev/null -L -w '%{http_code}' "$WEBAPI_URL/info")" == "200" ]; do
    echo "$(date): Waiting for WebAPI to be up"
    sleep 5
done


# This is better solved by invoking the WebAPI dynamically instead
echo "$(date): Updating OHDSI WebAPI CDM sources"
psql <<-EOSQL
    INSERT INTO ohdsi.source(source_id, source_name, source_key, source_connection, username, password, source_dialect)
    VALUES (1, 'CDM V5.3.1 Database', 'CDMV5', 'jdbc:postgresql://${PGHOST}:${PGPORT}/${PGDATABASE}', '$PGUSER', '$PGPASSWORD', 'postgresql');

    INSERT INTO ohdsi.source_daimon(source_daimon_id, source_id, daimon_type, table_qualifier, priority)
    VALUES (5, 1, 0, 'cdm', 2);

    INSERT INTO ohdsi.source_daimon(source_daimon_id, source_id, daimon_type, table_qualifier, priority)
    VALUES (6, 1, 1, 'cdm', 2);

    INSERT INTO ohdsi.source_daimon(source_daimon_id, source_id, daimon_type, table_qualifier, priority)
    VALUES (7, 1, 2, 'cdm_results', 2);

    INSERT INTO ohdsi.source_daimon(source_daimon_id, source_id, daimon_type, table_qualifier, priority)
    VALUES (8, 1, 3, 'cdm_results', 2);
EOSQL

echo "$(date): Refreshing sources"
curl -s -L -o /dev/null "$WEBAPI_URL/source/refresh"

echo "$(date): Completed initialization."
exit 0
```

```Dockerfile
FROM alpine:3.12
# hadolint ignore=DL3018
RUN apk --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main add \
    curl \
    bash \
    postgresql-client

WORKDIR /opt/omop-init/sources

ARG CDM_URL=https://<s3-url>/tar-gz-containing-cdm-vocabulary
RUN curl -LSs ${CDM_URL} \
    -o cdm.tar.gz

WORKDIR /opt/omop-init
RUN chown -R 10001 .

# contains the CDM schema SQLs (fetching this within the Dockerfile may be cleaner)
COPY --chown=10001:10001 init_omop init_omop/
# scripts to setup custom schema names
COPY --chown=10001:10001 init_scripts init_scripts/
# scripts to apply indexes
COPY --chown=10001:10001 postinit postinit/
# the entrypoint.sh from above
COPY --chown=10001:10001 entrypoint.sh /entrypoint.sh

USER 10001
ENTRYPOINT [ "/bin/bash" ]
CMD [ "/entrypoint.sh" ]
```

## Override config-local.js for Atlas

To use a custom config-local.js file to configure Atlas, you can use the `atlas.config.local` key:

```yaml
atlas:
  # makes sure the WEBAPI_URL env var isn't automatically set to ingress.host
  # this is needed when setting config.local
  constructWebApiUrlFromIngress: false
  config:
    local: |
      define([], function () {
        var configLocal = {};

        // clearing local storage otherwise source cache will obscure the override settings
        localStorage.clear();

        var getUrl = window.location;
        var baseUrl = getUrl.protocol + "//" + getUrl.host;

        // WebAPI
        configLocal.api = {
          name: "OHDSI",
          url: baseUrl + "/WebAPI/",
        };

        configLocal.cohortComparisonResultsEnabled = false;
        configLocal.userAuthenticationEnabled = true;
        configLocal.plpResultsEnabled = false;

        configLocal.authProviders = [
          {
            name: "OpenID",
            url: "user/login/openid",
            ajax: false,
            icon: "fa fa-openid",
          },
        ];

        return configLocal;
      });
```

## Securing Atlas using OpenID Connect

You can secure the access to the WebAPI and consequently limit what Atlas users can and cannot do.

See <https://github.com/OHDSI/WebAPI/wiki/Security-Configuration> and <https://github.com/OHDSI/WebAPI/wiki/Atlas-Security> for details.

As an example, here's a values.yaml file that enables OpenID Connect authentication (tested using Keycloak):

```yaml
ingress:
  enabled: true
  hosts:
    - host: omop.example.com
  tls:
    - secretName: omop.example.com-tls
      hosts:
        - omop.example.com
atlas:
  # makes sure the WEBAPI_URL env var isn't automatically set to ingress.host
  # this needed is when specifying config.local
  constructWebApiUrlFromIngress: false
  config:
    local: |
      define([], function () {
        var configLocal = {};

        // clearing local storage otherwise source cache will obscure the override settings
        localStorage.clear();

        var getUrl = window.location;
        var baseUrl = getUrl.protocol + "//" + getUrl.host;

        // WebAPI
        configLocal.api = {
          name: "OHDSI",
          url: baseUrl + "/WebAPI/",
        };

        configLocal.cohortComparisonResultsEnabled = false;
        configLocal.userAuthenticationEnabled = true;
        configLocal.plpResultsEnabled = false;

        configLocal.authProviders = [
          {
            name: "OpenID Connect",
            url: "user/login/openid",
            ajax: false,
            icon: "fa fa-openid",
          },
        ];

        return configLocal;
      });
webApi:
  auth:
    openid:
      enabled: true
      clientId: "ohdsi"
      clientSecret: "a5f55a03-ca7d-4a52-a352-498defb2f6fa"
      # Required. Points to the openid-configuration endpoint of the provider,
      oidUrl: "https://auth.example.com/auth/realms/OHDSI/.well-known/openid-configuration"
      # URL including the OHDSI WebAPI oauth callback, e.g. `https://example.com/WebAPI/user/oauth/callback`.
      # If unset, a URL is constructed from `ingress.hosts[0]`
      callbackApi: ""
      # URL including the callback URL referring to the ATLAS UI, e.g. `https://example.com/atlas/index.html#/welcome/`.
      # If unset, a URL is constructed from `ingress.hosts[0]`
      callbackUI: ""
      # URL to be redirected to when logging out, e.g. `https://example.com/atlas/index.html#/welcome/`.
      # If unset, a URL is constructed from `ingress.hosts[0]`
      logoutUrl: ""
      # OpenID redirect URL, e.g. `https://example.com/atlas/index.html#/welcome/null`
      # If unset, a URL is constructed from `ingress.hosts[0]`
      redirectUrl: ""
```

Make sure to give any logged-in user the appropriate permissions by following: <https://github.com/OHDSI/WebAPI/wiki/Atlas-Security#defining-an-administrator>.
