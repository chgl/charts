# fhir-server-exporter

[FHIR® Server Exporter](https://github.com/chgl/fhir-server-exporter) - Helm chart for deploying the Prometheus FHIR® server exporter

## TL;DR;

```bash
$ helm repo add chgl https://chgl.github.io/charts
$ helm repo update
$ helm search repo chgl/fhir-server-exporter --version=1.0.20
$ helm upgrade -i fhir-server-exporter chgl/fhir-server-exporter -n fhir --create-namespace --version=1.0.20
```

## Introduction

This chart deploys the FHIR® server exporter. on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes v1.18+
- Helm v3

## Installing the Chart

To install/upgrade the chart with the release name `fhir-server-exporter`:

```bash
$ helm upgrade -i fhir-server-exporter chgl/fhir-server-exporter -n fhir --create-namespace --version=1.0.20
```

The command deploys the FHIR® server exporter. on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `fhir-server-exporter`:

```bash
$ helm uninstall fhir-server-exporter -n fhir
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `fhir-server-exporter` chart and their default values.

| Parameter                          | Description                                                                                                                                                   | Default                |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------- |
| fhirServerUrl                      | the URL of the FHIR server whose metrics should be scraped. Interpreted as a template.                                                                        | <code>""</code>        |
| fhirServerName                     | the name of the FHIR server (included in the metrics as `server_name`). Interpreted as a template.                                                            | <code>""</code>        |
| fetchIntervalSeconds               | FHIR server exporter fetch interval in seconds                                                                                                                | <code>300</code>       |
| serviceMonitor.enabled             | if enabled, creates a ServiceMonitor instance for Prometheus Operator-based monitoring                                                                        | <code>false</code>     |
| serviceMonitor.additionalLabels    | additional labels to apply to the ServiceMonitor object, e.g. `release: prometheus`                                                                           | <code>{}</code>        |
| replicaCount                       | number of replicas                                                                                                                                            | <code>1</code>         |
| imagePullSecrets                   |                                                                                                                                                               | <code>[]</code>        |
| nameOverride                       |                                                                                                                                                               | <code>""</code>        |
| fullnameOverride                   |                                                                                                                                                               | <code>""</code>        |
| deploymentAnnotations              | annotations applied to the server deployment                                                                                                                  | <code>{}</code>        |
| podAnnotations                     | annotations applied to the server pod                                                                                                                         | <code>{}</code>        |
| podSecurityContext                 |                                                                                                                                                               | <code>{}</code>        |
| service.type                       |                                                                                                                                                               | <code>ClusterIP</code> |
| service.port                       |                                                                                                                                                               | <code>8080</code>      |
| resources                          |                                                                                                                                                               | <code>{}</code>        |
| nodeSelector                       |                                                                                                                                                               | <code>{}</code>        |
| tolerations                        |                                                                                                                                                               | <code>[]</code>        |
| affinity                           |                                                                                                                                                               | <code>{}</code>        |
| extraEnv                           | extra env vars to set on the fhir-server-exporter container                                                                                                   | <code>[]</code>        |
| customQueries                      | specify custom queries as a list of `name`, `query` and `description` objects. see <https://github.com/chgl/fhir-server-exporter#custom-queries> for details. | <code>[]</code>        |
| podDisruptionBudget.enabled        | create a PodDisruptionBudget resource for the pods                                                                                                            | <code>false</code>     |
| podDisruptionBudget.minAvailable   | Minimum available instances; ignored if there is no PodDisruptionBudget                                                                                       | <code>1</code>         |
| podDisruptionBudget.maxUnavailable | Maximum unavailable instances; ignored if there is no PodDisruptionBudget                                                                                     | <code>""</code>        |
| topologySpreadConstraints          | pod topology spread configuration see: <https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/#api>                              | <code>[]</code>        |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i fhir-server-exporter chgl/fhir-server-exporter -n fhir --create-namespace --version=1.0.20 --set fetchIntervalSeconds=300
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i fhir-server-exporter chgl/fhir-server-exporter -n fhir --create-namespace --version=1.0.20 --values values.yaml
```
