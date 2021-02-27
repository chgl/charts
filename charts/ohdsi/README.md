# ohdsi

[OHDSI](https://github.com/OHDSI) - Helm chart for deploying OHDSI ATLAS and WebAPI.

## TL;DR;

```console
$ helm repo add chgl https://chgl.github.io/charts
$ helm repo update
$ helm install ohdsi chgl/ohdsi -n ohdsi
```

## Breaking Changes

### 0.4

Starting with v0.4.0, the two seperate ingress resources for WebAPI and Atlas have been merged into a single one with the `/WebAPI/` and `/atlas/` paths
mapping to the WebAPI and Atlas service respectively. Set `ingress.enabled=true` and configure `ingress.hosts[]` to enabled it.

## Introduction

This chart deploys the OHDSI WebAPI and ATLAS app. on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes v1.18+
- Helm v3

## Installing the Chart

To install the chart with the release name `ohdsi`:

```console
$ helm install ohdsi chgl/ohdsi -n ohdsi
```

The command deploys the OHDSI WebAPI and ATLAS app. on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `ohdsi`:

```console
$ helm delete ohdsi -n ohdsi
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `ohdsi` chart and their default values.

| Parameter                                                    | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                | Default                                                                                                                                 |
| ------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| imagePullSecrets                                             | image pull secrets used by all pods                                                                                                                                                                                                                                                                                                                                                                                                                                        | `[]`                                                                                                                                    |
| nameOverride                                                 | partially override the release name                                                                                                                                                                                                                                                                                                                                                                                                                                        | `""`                                                                                                                                    |
| fullnameOverride                                             | fully override the release name                                                                                                                                                                                                                                                                                                                                                                                                                                            | `""`                                                                                                                                    |
| commonAnnotations                                            | annotations applied to all deployments and jobs                                                                                                                                                                                                                                                                                                                                                                                                                            | `[]`                                                                                                                                    |
| postgresql.enabled                                           | enable an included PostgreSQL DB. if set to `false`, the values under `webApi.db` are used                                                                                                                                                                                                                                                                                                                                                                                 | `true`                                                                                                                                  |
| postgresql.image                                             | update the default Postgres version to 13.1                                                                                                                                                                                                                                                                                                                                                                                                                                | `{"pullPolicy":"Always","tag":"13.1.0"}`                                                                                                |
| postgresql.postgresqlDatabase                                | name of the database to create see: <https://github.com/bitnami/bitnami-docker-postgresql/blob/master/README.md#creating-a-database-on-first-run>                                                                                                                                                                                                                                                                                                                          | `"ohdsi"`                                                                                                                               |
| postgresql.existingSecret                                    | Name of existing secret to use for PostgreSQL passwords. The secret has to contain the keys `postgresql-password` which is the password for `postgresqlUsername` when it is different of `postgres`, `postgresql-postgres-password` which will override `postgresqlPassword`, `postgresql-replication-password` which will override `replication.password` and `postgresql-ldap-password` which will be sed to authenticate on LDAP. The value is evaluated as a template. | `""`                                                                                                                                    |
| postgresql.replication.enabled                               | should be true for production use                                                                                                                                                                                                                                                                                                                                                                                                                                          | `false`                                                                                                                                 |
| postgresql.replication.readReplicas                          | number of read replicas                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `2`                                                                                                                                     |
| postgresql.replication.synchronousCommit                     | set synchronous commit mode: on, off, remote_apply, remote_write and local                                                                                                                                                                                                                                                                                                                                                                                                 | `"on"`                                                                                                                                  |
| postgresql.replication.numSynchronousReplicas                | from the number of `readReplicas` defined above, set the number of those that will have synchronous replication                                                                                                                                                                                                                                                                                                                                                            | `1`                                                                                                                                     |
| postgresql.metrics.enabled                                   | should also be true for production use                                                                                                                                                                                                                                                                                                                                                                                                                                     | `false`                                                                                                                                 |
| postgresql.containerSecurityContext.allowPrivilegeEscalation |                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | `false`                                                                                                                                 |
| webApi.enabled                                               | enable the OHDSI WebAPI deployment                                                                                                                                                                                                                                                                                                                                                                                                                                         | `true`                                                                                                                                  |
| webApi.replicaCount                                          | number of pod replicas for the WebAPI                                                                                                                                                                                                                                                                                                                                                                                                                                      | `1`                                                                                                                                     |
| webApi.image                                                 | the WebAPI image                                                                                                                                                                                                                                                                                                                                                                                                                                                           | `{"pullPolicy":"Always","registry":"ghcr.io","repository":"chgl/ohdsi/webapi","tag":"2.8.0"}`                                           |
| webApi.db.host                                               | database hostname                                                                                                                                                                                                                                                                                                                                                                                                                                                          | `"host.example.com"`                                                                                                                    |
| webApi.db.port                                               | port used to connect to the postgres DB                                                                                                                                                                                                                                                                                                                                                                                                                                    | `5432`                                                                                                                                  |
| webApi.db.database                                           | name of the database inside. If postgresql.enabled=true, then postgresql.postgresqlDatabase is used                                                                                                                                                                                                                                                                                                                                                                        | `"ohdsi"`                                                                                                                               |
| webApi.db.username                                           | username used to connect to the DB. Note that this name is currently used even if postgresql.enabled=true                                                                                                                                                                                                                                                                                                                                                                  | `"postgres"`                                                                                                                            |
| webApi.db.password                                           | the database password. Only used if postgresql.enabled=false, otherwise the secret created by the postgresql chart is used                                                                                                                                                                                                                                                                                                                                                 | `"postgres"`                                                                                                                            |
| webApi.db.existingSecret                                     | name of an existing secret containing the password to the DB.                                                                                                                                                                                                                                                                                                                                                                                                              | `""`                                                                                                                                    |
| webApi.db.existingSecretKey                                  | name of the key in `webApi.db.existingSecret` to use as the password to the DB.                                                                                                                                                                                                                                                                                                                                                                                            | `"postgresql-postgres-password"`                                                                                                        |
| webApi.db.schema                                             | schema used for the WebAPI's tables. Also referred to as the "OHDSI schema"                                                                                                                                                                                                                                                                                                                                                                                                | `"ohdsi"`                                                                                                                               |
| webApi.podAnnotations                                        | annotations applied to the pod                                                                                                                                                                                                                                                                                                                                                                                                                                             | `{}`                                                                                                                                    |
| webApi.podSecurityContext                                    | security context for the pod                                                                                                                                                                                                                                                                                                                                                                                                                                               | `{}`                                                                                                                                    |
| webApi.securityContext                                       | security context for the WebAPI container                                                                                                                                                                                                                                                                                                                                                                                                                                  | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":101}`  |
| webApi.service                                               | the service used to expose the WebAPI web port                                                                                                                                                                                                                                                                                                                                                                                                                             | `{"port":8080,"type":"ClusterIP"}`                                                                                                      |
| webApi.resources                                             | resource requests and limits for the container                                                                                                                                                                                                                                                                                                                                                                                                                             | `{}`                                                                                                                                    |
| webApi.readinessProbe                                        | readiness probe                                                                                                                                                                                                                                                                                                                                                                                                                                                            | `{"failureThreshold":5,"initialDelaySeconds":10,"periodSeconds":15,"successThreshold":1,"timeoutSeconds":15}`                           |
| webApi.startupProbe                                          | startup probe                                                                                                                                                                                                                                                                                                                                                                                                                                                              | `{"failureThreshold":10,"initialDelaySeconds":60,"periodSeconds":20,"successThreshold":1,"timeoutSeconds":30}`                          |
| webApi.livenessProbe                                         | liveness probe                                                                                                                                                                                                                                                                                                                                                                                                                                                             | `{"failureThreshold":5,"initialDelaySeconds":10,"periodSeconds":15,"successThreshold":1,"timeoutSeconds":15}`                           |
| webApi.nodeSelector                                          | node labels for pods assignment see: <https://kubernetes.io/docs/user-guide/node-selection/>                                                                                                                                                                                                                                                                                                                                                                               | `{}`                                                                                                                                    |
| webApi.tolerations                                           | tolerations for pods assignment see: <https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/>                                                                                                                                                                                                                                                                                                                                                             | `[]`                                                                                                                                    |
| webApi.affinity                                              | affinity for pods assignment see: <https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity>                                                                                                                                                                                                                                                                                                                                          | `{}`                                                                                                                                    |
| webApi.extraEnv                                              | extra environment variables                                                                                                                                                                                                                                                                                                                                                                                                                                                | `[]`                                                                                                                                    |
| atlas.enabled                                                | enable the OHDSI Atlas deployment                                                                                                                                                                                                                                                                                                                                                                                                                                          | `true`                                                                                                                                  |
| atlas.replicaCount                                           | number of replicas                                                                                                                                                                                                                                                                                                                                                                                                                                                         | `1`                                                                                                                                     |
| atlas.image                                                  | the Atlas image                                                                                                                                                                                                                                                                                                                                                                                                                                                            | `{"pullPolicy":"Always","registry":"ghcr.io","repository":"chgl/ohdsi/atlas","tag":"2.8.0"}`                                            |
| atlas.webApiUrl                                              | the base URL of the OHDSI WebAPI, e.g. https://example.com/WebAPI if this value is not set but `webapi.ingress.enabled=true`, then this URL is constructed from `webapi.ingress`                                                                                                                                                                                                                                                                                           | `""`                                                                                                                                    |
| atlas.podAnnotations                                         | annotations for the pod                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `{}`                                                                                                                                    |
| atlas.podSecurityContext                                     | security context for the pod                                                                                                                                                                                                                                                                                                                                                                                                                                               | `{}`                                                                                                                                    |
| atlas.securityContext                                        | ContainerSecurityContext for the Atlas container                                                                                                                                                                                                                                                                                                                                                                                                                           | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":false,"runAsNonRoot":true,"runAsUser":101}` |
| atlas.service                                                | the service used to expose the Atlas web port                                                                                                                                                                                                                                                                                                                                                                                                                              | `{"port":8080,"type":"ClusterIP"}`                                                                                                      |
| atlas.resources                                              | resource requests and limits for the container                                                                                                                                                                                                                                                                                                                                                                                                                             | `{}`                                                                                                                                    |
| atlas.readinessProbe                                         | readiness probe                                                                                                                                                                                                                                                                                                                                                                                                                                                            | `{"failureThreshold":5,"initialDelaySeconds":30,"periodSeconds":15,"successThreshold":1,"timeoutSeconds":15}`                           |
| atlas.livenessProbe                                          | liveness probe                                                                                                                                                                                                                                                                                                                                                                                                                                                             | `{"failureThreshold":5,"initialDelaySeconds":30,"periodSeconds":15,"successThreshold":1,"timeoutSeconds":15}`                           |
| atlas.nodeSelector                                           | node labels for pods assignment see: <https://kubernetes.io/docs/user-guide/node-selection/>                                                                                                                                                                                                                                                                                                                                                                               | `{}`                                                                                                                                    |
| atlas.tolerations                                            | tolerations for pods assignment see: <https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/>                                                                                                                                                                                                                                                                                                                                                             | `[]`                                                                                                                                    |
| atlas.affinity                                               | affinity for pods assignment see: <https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity>                                                                                                                                                                                                                                                                                                                                          | `{}`                                                                                                                                    |
| atlas.extraEnv                                               | extra environment variables                                                                                                                                                                                                                                                                                                                                                                                                                                                | `[]`                                                                                                                                    |
| cdmInitJob.enabled                                           | if enabled, create a Kubernetes Job running the specified container see [cdm-init-job.yaml](templates/cdm-init-job.yaml) for the env vars that are passed by default                                                                                                                                                                                                                                                                                                       | `false`                                                                                                                                 |
| cdmInitJob.image                                             | the container image used to create the CDM initialization job                                                                                                                                                                                                                                                                                                                                                                                                              | `{"pullPolicy":"Always","registry":"docker.io","repository":"docker/whalesay","tag":"latest"}`                                          |
| cdmInitJob.podAnnotations                                    | annotations set on the cdm-init pod                                                                                                                                                                                                                                                                                                                                                                                                                                        | `{}`                                                                                                                                    |
| cdmInitJob.podSecurityContext                                | PodSecurityContext for the cdm-init pod                                                                                                                                                                                                                                                                                                                                                                                                                                    | `{}`                                                                                                                                    |
| cdmInitJob.securityContext                                   | ContainerSecurityContext for the cdm-init container                                                                                                                                                                                                                                                                                                                                                                                                                        | `{}`                                                                                                                                    |
| cdmInitJob.extraEnv                                          | extra environment variables to set                                                                                                                                                                                                                                                                                                                                                                                                                                         | `[]`                                                                                                                                    |
| achilles.enabled                                             | whether or not to enable the Achilles cron job                                                                                                                                                                                                                                                                                                                                                                                                                             | `true`                                                                                                                                  |
| achilles.schedule                                            | when to run the Achilles job. See <https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#cron-schedule-syntax>                                                                                                                                                                                                                                                                                                                                              | `"@daily"`                                                                                                                              |
| achilles.image                                               | the Achilles image                                                                                                                                                                                                                                                                                                                                                                                                                                                         | `{"pullPolicy":"Always","registry":"ghcr.io","repository":"chgl/ohdsi/achilles","tag":"master"}`                                        |
| achilles.schemas.cdm                                         | name of the schema containing the OMOP CDM. Equivalent to the Achilles `ACHILLES_CDM_SCHEMA` env var.                                                                                                                                                                                                                                                                                                                                                                      | `"synpuf_cdm"`                                                                                                                          |
| achilles.schemas.vocab                                       | name of the schema containing the vocabulary. Equivalent to the Achilles `ACHILLES_VOCAB_SCHEMA` env var.                                                                                                                                                                                                                                                                                                                                                                  | `"synpuf_vocab"`                                                                                                                        |
| achilles.schemas.res                                         | name of the schema containing the cohort generation results. Equivalent to the Achilles `ACHILLES_RES_SCHEMA` env var.                                                                                                                                                                                                                                                                                                                                                     | `"synpuf_results"`                                                                                                                      |
| achilles.cdmVersion                                          | version of the CDM. Equivalent to the Achilles `ACHILLES_CDM_VERSION` env var.                                                                                                                                                                                                                                                                                                                                                                                             | `"5.3.1"`                                                                                                                               |
| achilles.securityContext                                     | ContainerSecurityContext for the Achilles container                                                                                                                                                                                                                                                                                                                                                                                                                        | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true,"runAsUser":10001}`                              |
| ingress.enabled                                              | whether to create an Ingress to expose the Atlas web interface                                                                                                                                                                                                                                                                                                                                                                                                             | `false`                                                                                                                                 |
| ingress.annotations                                          | provide any additional annotations which may be required. Evaluated as a template.                                                                                                                                                                                                                                                                                                                                                                                         | `{}`                                                                                                                                    |
| ingress.tls                                                  | ingress TLS config                                                                                                                                                                                                                                                                                                                                                                                                                                                         | `[]`                                                                                                                                    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```console
$ helm install ohdsi chgl/ohdsi -n ohdsi --set postgresql.image={"pullPolicy":"Always","tag":"13.1.0"}
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```console
$ helm install ohdsi chgl/ohdsi -n ohdsi --values values.yaml
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
# scripts to apply indizes
COPY --chown=10001:10001 postinit postinit/
# the entrypoint.sh from above
COPY --chown=10001:10001 entrypoint.sh /entrypoint.sh

USER 10001
ENTRYPOINT [ "/bin/bash" ]
CMD [ "/entrypoint.sh" ]
```
