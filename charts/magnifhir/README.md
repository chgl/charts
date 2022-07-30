# magniFHIR

[magniFHIR](https://github.com/chgl/magniFHIR) - Helm chart for deploying the magniFHIR app

## TL;DR;

```bash
$ helm repo add chgl https://chgl.github.io/charts
$ helm repo update
$ helm search repo chgl/magnifhir --version=1.0.0
$ helm upgrade -i magnifhir chgl/magnifhir -n magnifhir --create-namespace --version=1.0.0
```

## Introduction

This chart deploys the magniFHIR app. on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes v1.18+
- Helm v3

## Installing the Chart

To install/upgrade the chart with the release name `magnifhir`:

```bash
$ helm upgrade -i magnifhir chgl/magnifhir -n magnifhir --create-namespace --version=1.0.0
```

The command deploys the magniFHIR app. on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall the `magnifhir`:

```bash
$ helm uninstall magnifhir -n magnifhir
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `magnifhir` chart and their default values.

| Parameter                       | Description                                                                                                                                                   | Default                |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------- |
| serviceMonitor.enabled          | if enabled, creates a ServiceMonitor instance for Prometheus Operator-based monitoring                                                                        | <code>false</code>     |
| serviceMonitor.additionalLabels | additional labels to apply to the ServiceMonitor object, e.g. `release: prometheus`                                                                           | <code>{}</code>        |
| replicaCount                    | number of replicas                                                                                                                                            | <code>1</code>         |
| imagePullSecrets                | image pull secrets used by all pods                                                                                                                           | <code>[]</code>        |
| nameOverride                    | partially override the release name                                                                                                                           | <code>""</code>        |
| fullnameOverride                | fully override the release name                                                                                                                               | <code>""</code>        |
| deploymentAnnotations           | annotations applied to the server deployment                                                                                                                  | <code>{}</code>        |
| podAnnotations                  | annotations applied to the server pod                                                                                                                         | <code>{}</code>        |
| podSecurityContext              | security context applied at the Pod level                                                                                                                     | <code>{}</code>        |
| service.type                    | type of service                                                                                                                                               | <code>ClusterIP</code> |
| service.port                    | port for the web interface                                                                                                                                    | <code>8080</code>      |
| service.metrics.port            | port for the metrics endpoint                                                                                                                                 | <code>8081</code>      |
| resources                       | specify resource requests and limits                                                                                                                          | <code>{}</code>        |
| nodeSelector                    | node labels for pods assignment see: <https://kubernetes.io/docs/user-guide/node-selection/>                                                                  | <code>{}</code>        |
| tolerations                     | tolerations for pods assignment see: <https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/>                                                | <code>[]</code>        |
| affinity                        | affinity for pods assignment see: <https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity>                             | <code>{}</code>        |
| topologySpreadConstraints       | pod topology spread configuration see: <https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/#api>                              | <code>[]</code>        |
| extraEnv                        | extra env vars to set on the magnifhir container                                                                                                              | <code>[]</code>        |
| appsettings                     | provide an `appsettings` object to configure the `FhirServers` and other settings via JSON see <https://github.com/chgl/magniFHIR#configuration> for details. | <code>""</code>        |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm upgrade -i`. For example:

```bash
$ helm upgrade -i magnifhir chgl/magnifhir -n magnifhir --create-namespace --version=1.0.0 --set replicaCount=1
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm upgrade -i magnifhir chgl/magnifhir -n magnifhir --create-namespace --version=1.0.0 --values values.yaml
```
