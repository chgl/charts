# fhir-server-exporter

[FHIR© Server Exporter](https://github.com/chgl/fhir-server-exporter) - Helm chart for deploying the Prometheus FHIR© server exporter

## TL;DR;

```console
$ helm repo add chgl https://chgl.github.io/charts
$ helm repo update
$ helm install fhir-server-exporter chgl/fhir-server-exporter -n fhir
```

## Introduction

This chart deploys the FHIR© server exporter. on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes v1.18+
- Helm v3

## Installing the Chart

To install the chart with the release name `fhir-server-exporter`:

```console
$ helm install fhir-server-exporter chgl/fhir-server-exporter -n fhir
```

The command deploys the FHIR© server exporter. on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `fhir-server-exporter`:

```console
$ helm delete fhir-server-exporter -n fhir
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `fhir-server-exporter` chart and their default values.

| Parameter                                | Description                                                                            | Default                                                                                                       |
| ---------------------------------------- | -------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| fhirServerUrl                            | the URL of the FHIR server whose metrics should be scraped                             | `""`                                                                                                          |
| fetchIntervalSeconds                     | FHIR server exporter fetch interval in seconds                                         | `300`                                                                                                         |
| serviceMonitor.enabled                   | if enabled, creates a ServiceMonitor instance for Prometheus Operator-based monitoring | `false`                                                                                                       |
| serviceMonitor.additionalLabels          | additional labels to apply to the ServiceMonitor object, e.g. `release: prometheus`    | `{}`                                                                                                          |
| replicaCount                             | number of replicas                                                                     | `1`                                                                                                           |
| image                                    | the exporter image                                                                     | `{"pullPolicy":"IfNotPresent","registry":"ghcr.io","repository":"chgl/fhir-server-exporter","tag":"v1.1.16"}` |
| imagePullSecrets                         |                                                                                        | `[]`                                                                                                          |
| nameOverride                             |                                                                                        | `""`                                                                                                          |
| fullnameOverride                         |                                                                                        | `""`                                                                                                          |
| deploymentAnnotations                    | annotations applied to the server deployment                                           | `{}`                                                                                                          |
| podAnnotations                           | annotations applied to the server pod                                                  | `{}`                                                                                                          |
| podSecurityContext                       |                                                                                        | `{}`                                                                                                          |
| securityContext.allowPrivilegeEscalation |                                                                                        | `false`                                                                                                       |
| securityContext.readOnlyRootFilesystem   |                                                                                        | `true`                                                                                                        |
| securityContext.runAsNonRoot             |                                                                                        | `true`                                                                                                        |
| securityContext.runAsUser                |                                                                                        | `65532`                                                                                                       |
| service.type                             |                                                                                        | `ClusterIP`                                                                                                   |
| service.port                             |                                                                                        | `8080`                                                                                                        |
| resources                                |                                                                                        | `{}`                                                                                                          |
| nodeSelector                             |                                                                                        | `{}`                                                                                                          |
| tolerations                              |                                                                                        | `[]`                                                                                                          |
| affinity                                 |                                                                                        | `{}`                                                                                                          |
| readinessProbe                           | readiness probe                                                                        | `{"failureThreshold":5,"initialDelaySeconds":30,"periodSeconds":20,"successThreshold":1,"timeoutSeconds":20}` |
| livenessProbe                            | readiness probe                                                                        | `{"failureThreshold":5,"initialDelaySeconds":30,"periodSeconds":20,"successThreshold":1,"timeoutSeconds":20}` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```console
$ helm install fhir-server-exporter chgl/fhir-server-exporter -n fhir --set fetchIntervalSeconds=300
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```console
$ helm install fhir-server-exporter chgl/fhir-server-exporter -n fhir --values values.yaml
```
