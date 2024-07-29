# fhir-server-exporter

[FHIR® Server Exporter](https://github.com/chgl/fhir-server-exporter) - Helm chart for deploying the Prometheus FHIR® server exporter

## TL;DR;

```sh
helm install fhir-server-exporter oci://ghcr.io/chgl/charts/fhir-server-exporter --create-namespace -n fhir
```

## Introduction

This chart deploys the FHIR® server exporter. on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes v1.18+
- Helm v3

## Installing the Chart

To install the chart with the release name `fhir-server-exporter`:

```sh
helm install fhir-server-exporter oci://ghcr.io/chgl/charts/fhir-server-exporter -n fhir
```

The command deploys the FHIR® server exporter. on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `fhir-server-exporter`:

```sh
helm uninstall fhir-server-exporter -n fhir
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `fhir-server-exporter` chart and their default values.

| Parameter                                   | Description                                                                                                                                                                                                                                                                                                                                   | Default                |
| ------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------- |
| fhirServerUrl                               | the URL of the FHIR server whose metrics should be scraped. Interpreted as a template.                                                                                                                                                                                                                                                        | <code>""</code>        |
| fhirServerName                              | the name of the FHIR server (included in the metrics as `server_name`). Interpreted as a template.                                                                                                                                                                                                                                            | <code>""</code>        |
| fetchIntervalSeconds                        | FHIR server exporter fetch interval in seconds                                                                                                                                                                                                                                                                                                | <code>300</code>       |
| serviceMonitor.enabled                      | if enabled, creates a ServiceMonitor instance for Prometheus Operator-based monitoring                                                                                                                                                                                                                                                        | <code>false</code>     |
| replicaCount                                | number of replicas                                                                                                                                                                                                                                                                                                                            | <code>1</code>         |
| nameOverride                                |                                                                                                                                                                                                                                                                                                                                               | <code>""</code>        |
| fullnameOverride                            |                                                                                                                                                                                                                                                                                                                                               | <code>""</code>        |
| service.type                                |                                                                                                                                                                                                                                                                                                                                               | <code>ClusterIP</code> |
| service.port                                |                                                                                                                                                                                                                                                                                                                                               | <code>8080</code>      |
| serviceAccount.create                       | Specifies whether a service account should be created.                                                                                                                                                                                                                                                                                        | <code>true</code>      |
| serviceAccount.name                         | The name of the service account to use. If not set and create is true, a name is generated using the fullname template                                                                                                                                                                                                                        | <code>""</code>        |
| serviceAccount.automountServiceAccountToken | whether to automount the SA token                                                                                                                                                                                                                                                                                                             | <code>false</code>     |
| resourcesPreset                             | set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if primary.resources is set (primary.resources is recommended for production). More information: <https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15> | <code>"micro"</code>   |
| podDisruptionBudget.enabled                 | create a PodDisruptionBudget resource for the pods                                                                                                                                                                                                                                                                                            | <code>false</code>     |
| podDisruptionBudget.minAvailable            | Minimum available instances; ignored if there is no PodDisruptionBudget                                                                                                                                                                                                                                                                       | <code>1</code>         |
| podDisruptionBudget.maxUnavailable          | Maximum unavailable instances; ignored if there is no PodDisruptionBudget                                                                                                                                                                                                                                                                     | <code>""</code>        |
| tests.automountServiceAccountToken          |                                                                                                                                                                                                                                                                                                                                               | <code>false</code>     |
| tests.resourcesPreset                       | set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if primary.resources is set (primary.resources is recommended for production). More information: <https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15> | <code>"nano"</code>    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```sh
helm install fhir-server-exporter oci://ghcr.io/chgl/charts/fhir-server-exporter -n fhir --set fetchIntervalSeconds=300
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```sh
helm install fhir-server-exporter oci://ghcr.io/chgl/charts/fhir-server-exporter -n fhir --values values.yaml
```
