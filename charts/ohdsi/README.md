# ohdsi

[OHDSI](https://github.com/OHDSI) - Helm chart for deploying the OHDSI ATLAS web tool.

## TL;DR;

```console
$ helm repo add chgl https://chgl.github.io/charts
$ helm repo update
$ helm install ohdsi chgl/ohdsi -n ohdsi
```

There isn't (yet) a Keycloak sub-chart included.

## Introduction

This chart deploys the OHDSI WebAPI and ATLAS app. on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes v1.16+
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

| Parameter                                    | Description                                                                                                            | Default             |
| -------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ------------------- |
| imagePullSecrets                             |                                                                                                                        | `[]`                |
| nameOverride                                 |                                                                                                                        | `""`                |
| fullnameOverride                             |                                                                                                                        | `""`                |
| global.postgresql.existingSecret             |                                                                                                                        | `""`                |
| global.postgresql.database                   |                                                                                                                        | `"ohdsi"`           |
| postgresqlha.enabled                         |                                                                                                                        | `true`              |
| postgresqlha.postgresqlImage.tag             |                                                                                                                        | `13.1.0`            |
| webapi.enabled                               |                                                                                                                        | `true`              |
| webapi.replicaCount                          |                                                                                                                        | `1`                 |
| webapi.image.registry                        |                                                                                                                        | `ghcr.io`           |
| webapi.image.repository                      |                                                                                                                        | `chgl/ohdsi/webapi` |
| webapi.image.tag                             |                                                                                                                        | `2.8.0-snapshot`    |
| webapi.image.pullPolicy                      |                                                                                                                        | `Always`            |
| webapi.db.host                               |                                                                                                                        | `"db"`              |
| webapi.db.port                               |                                                                                                                        | `5432`              |
| webapi.db.database                           |                                                                                                                        | `"ohdsi"`           |
| webapi.db.username                           |                                                                                                                        | `"postgres"`        |
| webapi.db.password                           |                                                                                                                        | `"postgres"`        |
| webapi.db.existingSecret                     | name of an existing secret containing the password to the DB. The key for the password has to be `postgresql-password` | `""`                |
| webapi.podAnnotations                        |                                                                                                                        | `{}`                |
| webapi.podSecurityContext                    |                                                                                                                        | `{}`                |
| webapi.securityContext.runAsNonRoot          | readOnlyRootFilesystem: true                                                                                           | `true`              |
| webapi.securityContext.runAsUser             |                                                                                                                        | `101`               |
| webapi.service.type                          |                                                                                                                        | `ClusterIP`         |
| webapi.service.port                          |                                                                                                                        | `8080`              |
| webapi.ingress.enabled                       |                                                                                                                        | `false`             |
| webapi.ingress.annotations                   |                                                                                                                        | `{}`                |
| webapi.ingress.tls                           |                                                                                                                        | `[]`                |
| webapi.resources                             |                                                                                                                        | `{}`                |
| webapi.readinessProbe.failureThreshold       |                                                                                                                        | `5`                 |
| webapi.readinessProbe.initialDelaySeconds    |                                                                                                                        | `45`                |
| webapi.readinessProbe.periodSeconds          |                                                                                                                        | `15`                |
| webapi.readinessProbe.successThreshold       |                                                                                                                        | `1`                 |
| webapi.readinessProbe.timeoutSeconds         |                                                                                                                        | `15`                |
| webapi.nodeSelector                          |                                                                                                                        | `{}`                |
| webapi.tolerations                           |                                                                                                                        | `[]`                |
| webapi.affinity                              |                                                                                                                        | `{}`                |
| webapi.extraEnv                              | extra environment variables                                                                                            | `[]`                |
| atlas.enabled                                |                                                                                                                        | `true`              |
| atlas.replicaCount                           |                                                                                                                        | `1`                 |
| atlas.image.registry                         |                                                                                                                        | `ghcr.io`           |
| atlas.image.repository                       |                                                                                                                        | `chgl/ohdsi/atlas`  |
| atlas.image.tag                              |                                                                                                                        | `2.8.0-dev`         |
| atlas.image.pullPolicy                       |                                                                                                                        | `Always`            |
| atlas.podAnnotations                         |                                                                                                                        | `{}`                |
| atlas.podSecurityContext                     |                                                                                                                        | `{}`                |
| atlas.securityContext.readOnlyRootFilesystem |                                                                                                                        | `false`             |
| atlas.securityContext.runAsNonRoot           |                                                                                                                        | `true`              |
| atlas.securityContext.runAsUser              |                                                                                                                        | `101`               |
| atlas.service.type                           |                                                                                                                        | `ClusterIP`         |
| atlas.service.port                           |                                                                                                                        | `8080`              |
| atlas.ingress.enabled                        |                                                                                                                        | `false`             |
| atlas.ingress.annotations                    |                                                                                                                        | `{}`                |
| atlas.ingress.tls                            |                                                                                                                        | `[]`                |
| atlas.resources                              |                                                                                                                        | `{}`                |
| atlas.readinessProbe.failureThreshold        |                                                                                                                        | `5`                 |
| atlas.readinessProbe.initialDelaySeconds     |                                                                                                                        | `30`                |
| atlas.readinessProbe.periodSeconds           |                                                                                                                        | `15`                |
| atlas.readinessProbe.successThreshold        |                                                                                                                        | `1`                 |
| atlas.readinessProbe.timeoutSeconds          |                                                                                                                        | `15`                |
| atlas.livenessProbe.failureThreshold         |                                                                                                                        | `5`                 |
| atlas.livenessProbe.initialDelaySeconds      |                                                                                                                        | `30`                |
| atlas.livenessProbe.periodSeconds            |                                                                                                                        | `15`                |
| atlas.livenessProbe.successThreshold         |                                                                                                                        | `1`                 |
| atlas.livenessProbe.timeoutSeconds           |                                                                                                                        | `15`                |
| atlas.nodeSelector                           |                                                                                                                        | `{}`                |
| atlas.tolerations                            |                                                                                                                        | `[]`                |
| atlas.affinity                               |                                                                                                                        | `{}`                |
| atlas.extraEnv                               | extra environment variables                                                                                            | `[]`                |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```console
$ helm install ohdsi chgl/ohdsi -n ohdsi --set global.postgresql.database="ohdsi"
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```console
$ helm install ohdsi chgl/ohdsi -n ohdsi --values values.yaml
```

## Use an existing secret with DB connection parameters

```yaml
kind: Secret
apiVersion: v1
metadata:
  name: test
  namespace: ohdsi
type: Opaque
data:
  repmgr-password: cmVwbWdyLXBhc3N3b3JkMQ==
  postgresql-password: cG9zdGdyZXNxbC1wYXNzd29yZDE=
  admin-password: YWRtaW4tcGFzc3dvcmQx
```
