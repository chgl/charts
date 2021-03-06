# fhir-server

[Microsoft FHIR Server](https://github.com/OHDSI) - Helm chart for deploying the Microsoft FHIR Server for Azure.

## TL;DR;

```console
$ helm repo add chgl https://chgl.github.io/charts
$ helm repo update
$ helm install fhir-server chgl/fhir-server -n fhir
```

## Introduction

This chart deploys the Microsoft FHIR Server for Azure. on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes v1.16+
- Helm v3

## Installing the Chart

To install the chart with the release name `fhir-server`:

```console
$ helm install fhir-server chgl/fhir-server -n fhir
```

The command deploys the Microsoft FHIR Server for Azure. on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `fhir-server`:

```console
$ helm delete fhir-server -n fhir
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `fhir-server` chart and their default values.

| Parameter                                                      | Description                                                                                                                                                                                                                               | Default                                          |
| -------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------ |
| replicaCount                                                   |                                                                                                                                                                                                                                           | `1`                                              |
| nameOverride                                                   |                                                                                                                                                                                                                                           | `""`                                             |
| fullnameOverride                                               |                                                                                                                                                                                                                                           | `""`                                             |
| podIdentity.enabled                                            |                                                                                                                                                                                                                                           | `false`                                          |
| export.enabled                                                 |                                                                                                                                                                                                                                           | `false`                                          |
| export.blobStorageUri                                          |                                                                                                                                                                                                                                           | `https://mystorageaccount.blob.core.windows.net` |
| service.type                                                   |                                                                                                                                                                                                                                           | `ClusterIP`                                      |
| service.port                                                   |                                                                                                                                                                                                                                           | `80`                                             |
| database.dataStore                                             | options: ExistingSqlServer, SqlServer, SqlContainer, CosmosDb                                                                                                                                                                             | `"SqlServer"`                                    |
| database.resourceGroup                                         |                                                                                                                                                                                                                                           | `""`                                             |
| database.location                                              |                                                                                                                                                                                                                                           | `""`                                             |
| database.sql.edition                                           | 0: Basic 1: Business 2: BusinessCritical 3: DataWarehouse 4: Free 5: GeneralPurpose 6: Hyperscale 7: Premium More at https://godoc.org/github.com/Azure/azure-sdk-for-go/services/preview/sql/mgmt/2015-05-01-preview/sql#DatabaseEdition | `5`                                              |
| database.sql.maxPoolSize                                       |                                                                                                                                                                                                                                           | `100`                                            |
| database.sql.schema.automaticUpdatesEnabled                    |                                                                                                                                                                                                                                           | `true`                                           |
| database.cosmosDb.initialCollectionThroughput                  |                                                                                                                                                                                                                                           | `"400"`                                          |
| database.sqlContainer.acceptEula                               | Accept EULA when deploying with --set database.sqlContainer.acceptEula="Y"                                                                                                                                                                | `"n"`                                            |
| database.sqlContainer.edition                                  |                                                                                                                                                                                                                                           | `"Developer"`                                    |
| database.sqlContainer.image.registry                           |                                                                                                                                                                                                                                           | `mcr.microsoft.com`                              |
| database.sqlContainer.image.repository                         |                                                                                                                                                                                                                                           | `mssql/server`                                   |
| database.sqlContainer.image.tag                                |                                                                                                                                                                                                                                           | `2019-latest`                                    |
| database.sqlContainer.image.pullPolicy                         |                                                                                                                                                                                                                                           | `IfNotPresent`                                   |
| database.sqlContainer.replicaCount                             |                                                                                                                                                                                                                                           | `1`                                              |
| database.sqlContainer.port                                     |                                                                                                                                                                                                                                           | `1433`                                           |
| database.sqlContainer.databaseName                             |                                                                                                                                                                                                                                           | `FHIR`                                           |
| database.sqlContainer.userName                                 |                                                                                                                                                                                                                                           | `sa`                                             |
| database.sqlContainer.persistence.storageClass                 |                                                                                                                                                                                                                                           | `""`                                             |
| database.sqlContainer.persistence.size                         |                                                                                                                                                                                                                                           | `8Gi`                                            |
| database.sqlContainer.securityContext.allowPrivilegeEscalation |                                                                                                                                                                                                                                           | `false`                                          |
| database.sqlContainer.podSecurityContext.runAsUser             | mssql container has user mssql defined with id 10001                                                                                                                                                                                      | `10001`                                          |
| database.sqlContainer.podSecurityContext.runAsGroup            |                                                                                                                                                                                                                                           | `10001`                                          |
| database.sqlContainer.podSecurityContext.fsGroup               |                                                                                                                                                                                                                                           | `10001`                                          |
| database.existingSqlServer.userName                            |                                                                                                                                                                                                                                           | `sa`                                             |
| database.existingSqlServer.databaseName                        |                                                                                                                                                                                                                                           | `FHIR`                                           |
| database.existingSqlServer.serverName                          |                                                                                                                                                                                                                                           | `mymssql-mssql-linux.default`                    |
| database.existingSqlServer.password                            |                                                                                                                                                                                                                                           | `fhir`                                           |
| database.existingSqlServer.existingSecret                      | name of a pre-created secret to retrieve the SQL Server's password. the secret must have a key named `DATABASEPASSWORD` with the password as its value.                                                                                   | `""`                                             |
| database.existingSqlServer.port                                |                                                                                                                                                                                                                                           | `1433`                                           |
| database.connectionTimeoutSeconds                              | sets the connection timeout (`Connection Timeout` parameter of the connection string)                                                                                                                                                     | `30`                                             |
| appInsights.secretKey                                          |                                                                                                                                                                                                                                           | `"instrumentationKey"`                           |
| serviceMonitor.enabled                                         |                                                                                                                                                                                                                                           | `false`                                          |
| serviceMonitor.port                                            |                                                                                                                                                                                                                                           | `1234`                                           |
| serviceMonitor.interval                                        | prometheus: monitor                                                                                                                                                                                                                       | `30s`                                            |
| serviceMonitor.dotnetRuntimeMetrics                            |                                                                                                                                                                                                                                           | `true`                                           |
| serviceMonitor.httpMetrics                                     |                                                                                                                                                                                                                                           | `true`                                           |
| serviceMonitor.systemMetrics                                   |                                                                                                                                                                                                                                           | `true`                                           |
| security.enabled                                               |                                                                                                                                                                                                                                           | `false`                                          |
| security.enableAadSmartOnFhirProxy                             |                                                                                                                                                                                                                                           | `false`                                          |
| security.authority                                             |                                                                                                                                                                                                                                           | `null`                                           |
| security.audience                                              |                                                                                                                                                                                                                                           | `null`                                           |
| ingress.enabled                                                |                                                                                                                                                                                                                                           | `false`                                          |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```console
$ helm install fhir-server chgl/fhir-server -n fhir --set replicaCount=1
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```console
$ helm install fhir-server chgl/fhir-server -n fhir --values values.yaml
```
