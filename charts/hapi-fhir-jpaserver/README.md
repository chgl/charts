# hapi-fhir-jpaserver

[HAPI FHIR JPA Server](https://github.com/hapifhir/hapi-fhir-jpaserver-starter) - Helm chart for deploying the HAPI FHIR JPA starter server

## TL;DR;

```console
$ helm repo add chgl https://chgl.github.io/charts
$ helm repo update
$ helm install hapi-fhir-jpaserver chgl/hapi-fhir-jpaserver -n fhir
```

## Introduction

This chart deploys the HAPI FHIR JPA starter server. on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes v1.18+
- Helm v3

## Installing the Chart

To install the chart with the release name `hapi-fhir-jpaserver`:

```console
$ helm install hapi-fhir-jpaserver chgl/hapi-fhir-jpaserver -n fhir
```

The command deploys the HAPI FHIR JPA starter server. on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `hapi-fhir-jpaserver`:

```console
$ helm delete hapi-fhir-jpaserver -n fhir
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `hapi-fhir-jpaserver` chart and their default values.

| Parameter                                     | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                | Default            |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------ |
| replicaCount                                  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | `1`                |
| nameOverride                                  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | `""`               |
| fullnameOverride                              |                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | `""`               |
| service.type                                  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | `ClusterIP`        |
| service.port                                  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | `8080`             |
| ingress.enabled                               | whether to create an Ingress to expose the FHIR server web interface                                                                                                                                                                                                                                                                                                                                                                                                       | `false`            |
| postgresql.enabled                            | enable an included PostgreSQL DB. if set to `false`, the values under `webApi.db` are used                                                                                                                                                                                                                                                                                                                                                                                 | `true`             |
| postgresql.image                              | update the default Postgres version to 13.3                                                                                                                                                                                                                                                                                                                                                                                                                                | `{"tag":"13.3.0"}` |
| postgresql.postgresqlDatabase                 | name of the database to create see: <https://github.com/bitnami/bitnami-docker-postgresql/blob/master/README.md#creating-a-database-on-first-run>                                                                                                                                                                                                                                                                                                                          | `"fhir"`           |
| postgresql.existingSecret                     | Name of existing secret to use for PostgreSQL passwords. The secret has to contain the keys `postgresql-password` which is the password for `postgresqlUsername` when it is different of `postgres`, `postgresql-postgres-password` which will override `postgresqlPassword`, `postgresql-replication-password` which will override `replication.password` and `postgresql-ldap-password` which will be sed to authenticate on LDAP. The value is evaluated as a template. | `""`               |
| postgresql.replication.enabled                | should be true for production use                                                                                                                                                                                                                                                                                                                                                                                                                                          | `false`            |
| postgresql.replication.readReplicas           | number of read replicas                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `1`                |
| postgresql.replication.synchronousCommit      | set synchronous commit mode: on, off, remote_apply, remote_write and local                                                                                                                                                                                                                                                                                                                                                                                                 | `"on"`             |
| postgresql.replication.numSynchronousReplicas | from the number of `readReplicas` defined above, set the number of those that will have synchronous replication                                                                                                                                                                                                                                                                                                                                                            | `1`                |
| postgresql.metrics.enabled                    | should also be true for production use                                                                                                                                                                                                                                                                                                                                                                                                                                     | `false`            |
| postgresql.metrics.serviceMonitor.enabled     | create a Prometheus Operator ServiceMonitor resource                                                                                                                                                                                                                                                                                                                                                                                                                       | `false`            |
| externalDatabase.host                         | Database host                                                                                                                                                                                                                                                                                                                                                                                                                                                              | `localhost`        |
| externalDatabase.user                         | non-root Username for FHIR Database                                                                                                                                                                                                                                                                                                                                                                                                                                        | `fhir`             |
| externalDatabase.password                     | Database password                                                                                                                                                                                                                                                                                                                                                                                                                                                          | `""`               |
| externalDatabase.existingSecret               | Name of an existing secret resource containing the DB password in a 'postgresql-password' key                                                                                                                                                                                                                                                                                                                                                                              | `""`               |
| externalDatabase.database                     | Database name                                                                                                                                                                                                                                                                                                                                                                                                                                                              | `fhir`             |
| externalDatabase.port                         | Database port number                                                                                                                                                                                                                                                                                                                                                                                                                                                       | `5432`             |
| networkPolicy.enabled                         | Enable NetworkPolicy                                                                                                                                                                                                                                                                                                                                                                                                                                                       | `false`            |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```console
$ helm install hapi-fhir-jpaserver chgl/hapi-fhir-jpaserver -n fhir --set replicaCount=1
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```console
$ helm install hapi-fhir-jpaserver chgl/hapi-fhir-jpaserver -n fhir --values values.yaml
```
