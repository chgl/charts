# kubeclarity

![Version: v0.1.0](https://img.shields.io/badge/Version-v0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v2.22.0](https://img.shields.io/badge/AppVersion-v2.22.0-informational?style=flat-square)

Charts for KubeClarity deployment.

**Homepage:** <https://github.com/openclarity/kubeclarity>

## Maintainers

| Name        | Email | Url                                          |
| ----------- | ----- | -------------------------------------------- |
| KubeClarity |       | <https://github.com/openclarity/kubeclarity> |

## Source Code

- <https://github.com/openclarity/kubeclarity>

## Requirements

| Repository                                 | Name                               | Version |
| ------------------------------------------ | ---------------------------------- | ------- |
| https://aquasecurity.github.io/helm-charts | kubeclarity-trivy-server(trivy)    | 0.4.17  |
| oci://registry-1.docker.io/bitnamicharts   | kubeclarity-postgresql(postgresql) | 13.2.5  |

## Values

| Key                                                                                        | Type   | Default                                         | Description |
| ------------------------------------------------------------------------------------------ | ------ | ----------------------------------------------- | ----------- |
| curl.image.registry                                                                        | string | `"docker.io"`                                   |             |
| curl.image.repository                                                                      | string | `"curlimages/curl"`                             |             |
| curl.image.tag                                                                             | string | `"7.87.0"`                                      |             |
| global.databasePassword                                                                    | string | `"kubeclarity"`                                 |             |
| global.docker.imagePullPolicy                                                              | string | `"Always"`                                      |             |
| global.docker.registry                                                                     | string | `"ghcr.io/openclarity"`                         |             |
| global.docker.tag                                                                          | string | `"v2.22.0"`                                     |             |
| global.nodeSelector."kubernetes.io/arch"                                                   | string | `"amd64"`                                       |             |
| global.nodeSelector."kubernetes.io/os"                                                     | string | `"linux"`                                       |             |
| global.openShiftRestricted                                                                 | bool   | `false`                                         |             |
| kubeclarity-grype-server.docker.imagePullPolicy                                            | string | `"Always"`                                      |             |
| kubeclarity-grype-server.docker.imageRepo                                                  | string | `"ghcr.io/openclarity"`                         |             |
| kubeclarity-grype-server.docker.imageTag                                                   | string | `"v0.6.0"`                                      |             |
| kubeclarity-grype-server.enabled                                                           | bool   | `true`                                          |             |
| kubeclarity-grype-server.logLevel                                                          | string | `"warning"`                                     |             |
| kubeclarity-grype-server.resources.limits.cpu                                              | string | `"1000m"`                                       |             |
| kubeclarity-grype-server.resources.limits.memory                                           | string | `"1G"`                                          |             |
| kubeclarity-grype-server.resources.requests.cpu                                            | string | `"200m"`                                        |             |
| kubeclarity-grype-server.resources.requests.memory                                         | string | `"200Mi"`                                       |             |
| kubeclarity-grype-server.servicePort                                                       | int    | `9991`                                          |             |
| kubeclarity-postgresql-external.auth.database                                              | string | `"kubeclarity"`                                 |             |
| kubeclarity-postgresql-external.auth.existingSecret                                        | string | `"kubeclarity-postgresql-secret"`               |             |
| kubeclarity-postgresql-external.auth.host                                                  | string | `"pgsql.hostname"`                              |             |
| kubeclarity-postgresql-external.auth.port                                                  | int    | `5432`                                          |             |
| kubeclarity-postgresql-external.auth.sslMode                                               | string | `"disable"`                                     |             |
| kubeclarity-postgresql-external.auth.username                                              | string | `"kubeclarity"`                                 |             |
| kubeclarity-postgresql-external.enabled                                                    | bool   | `false`                                         |             |
| kubeclarity-postgresql-secret.create                                                       | bool   | `true`                                          |             |
| kubeclarity-postgresql-secret.secretKey                                                    | string | `"postgres-password"`                           |             |
| kubeclarity-postgresql.auth.database                                                       | string | `"kubeclarity"`                                 |             |
| kubeclarity-postgresql.auth.existingSecret                                                 | string | `"kubeclarity-postgresql-secret"`               |             |
| kubeclarity-postgresql.auth.sslMode                                                        | string | `"disable"`                                     |             |
| kubeclarity-postgresql.auth.username                                                       | string | `"postgres"`                                    |             |
| kubeclarity-postgresql.enabled                                                             | bool   | `true`                                          |             |
| kubeclarity-postgresql.image.registry                                                      | string | `"docker.io"`                                   |             |
| kubeclarity-postgresql.image.repository                                                    | string | `"bitnami/postgresql"`                          |             |
| kubeclarity-postgresql.image.tag                                                           | string | `"16.1.0-debian-11-r0"`                         |             |
| kubeclarity-postgresql.resources.limits.cpu                                                | string | `"1000m"`                                       |             |
| kubeclarity-postgresql.resources.limits.memory                                             | string | `"1000Mi"`                                      |             |
| kubeclarity-postgresql.resources.requests.cpu                                              | string | `"250m"`                                        |             |
| kubeclarity-postgresql.resources.requests.memory                                           | string | `"256Mi"`                                       |             |
| kubeclarity-postgresql.service.ports.postgresql                                            | int    | `5432`                                          |             |
| kubeclarity-postgresql.serviceAccount.enabled                                              | bool   | `true`                                          |             |
| kubeclarity-postgresql.shmVolume.chmod.enabled                                             | bool   | `true`                                          |             |
| kubeclarity-postgresql.volumePermissions.enabled                                           | bool   | `false`                                         |             |
| kubeclarity-postgresql.volumePermissions.securityContext.runAsUser                         | int    | `1001`                                          |             |
| kubeclarity-runtime-scan.cis-docker-benchmark-scanner.docker.imageName                     | string | `""`                                            |             |
| kubeclarity-runtime-scan.cis-docker-benchmark-scanner.logLevel                             | string | `"warning"`                                     |             |
| kubeclarity-runtime-scan.cis-docker-benchmark-scanner.resources.limits.cpu                 | string | `"1000m"`                                       |             |
| kubeclarity-runtime-scan.cis-docker-benchmark-scanner.resources.limits.memory              | string | `"1000Mi"`                                      |             |
| kubeclarity-runtime-scan.cis-docker-benchmark-scanner.resources.requests.cpu               | string | `"50m"`                                         |             |
| kubeclarity-runtime-scan.cis-docker-benchmark-scanner.resources.requests.memory            | string | `"50Mi"`                                        |             |
| kubeclarity-runtime-scan.cis-docker-benchmark-scanner.timeout                              | string | `"2m"`                                          |             |
| kubeclarity-runtime-scan.httpProxy                                                         | string | `""`                                            |             |
| kubeclarity-runtime-scan.httpsProxy                                                        | string | `""`                                            |             |
| kubeclarity-runtime-scan.labels."sidecar.istio.io/inject"                                  | string | `"false"`                                       |             |
| kubeclarity-runtime-scan.labels.app                                                        | string | `"kubeclarity-scanner"`                         |             |
| kubeclarity-runtime-scan.namespace                                                         | string | `""`                                            |             |
| kubeclarity-runtime-scan.registry.skipVerifyTlS                                            | string | `"false"`                                       |             |
| kubeclarity-runtime-scan.registry.useHTTP                                                  | string | `"false"`                                       |             |
| kubeclarity-runtime-scan.resultServicePort                                                 | int    | `8888`                                          |             |
| kubeclarity-runtime-scan.vulnerability-scanner.analyzer.analyzerList                       | string | `"syft gomod"`                                  |             |
| kubeclarity-runtime-scan.vulnerability-scanner.analyzer.analyzerScope                      | string | `"squashed"`                                    |             |
| kubeclarity-runtime-scan.vulnerability-scanner.analyzer.trivy.enabled                      | bool   | `false`                                         |             |
| kubeclarity-runtime-scan.vulnerability-scanner.analyzer.trivy.timeout                      | string | `"300"`                                         |             |
| kubeclarity-runtime-scan.vulnerability-scanner.docker.imageName                            | string | `""`                                            |             |
| kubeclarity-runtime-scan.vulnerability-scanner.logLevel                                    | string | `"warning"`                                     |             |
| kubeclarity-runtime-scan.vulnerability-scanner.resources.limits.cpu                        | string | `"1000m"`                                       |             |
| kubeclarity-runtime-scan.vulnerability-scanner.resources.limits.memory                     | string | `"1000Mi"`                                      |             |
| kubeclarity-runtime-scan.vulnerability-scanner.resources.requests.cpu                      | string | `"50m"`                                         |             |
| kubeclarity-runtime-scan.vulnerability-scanner.resources.requests.memory                   | string | `"50Mi"`                                        |             |
| kubeclarity-runtime-scan.vulnerability-scanner.scanner.dependency-track.apiKey             | string | `""`                                            |             |
| kubeclarity-runtime-scan.vulnerability-scanner.scanner.dependency-track.apiserverAddress   | string | `"dependency-track-apiserver.dependency-track"` |             |
| kubeclarity-runtime-scan.vulnerability-scanner.scanner.dependency-track.disableTls         | string | `"true"`                                        |             |
| kubeclarity-runtime-scan.vulnerability-scanner.scanner.dependency-track.enabled            | bool   | `false`                                         |             |
| kubeclarity-runtime-scan.vulnerability-scanner.scanner.dependency-track.insecureSkipVerify | string | `"true"`                                        |             |
| kubeclarity-runtime-scan.vulnerability-scanner.scanner.grype.enabled                       | bool   | `true`                                          |             |
| kubeclarity-runtime-scan.vulnerability-scanner.scanner.grype.mode                          | string | `"REMOTE"`                                      |             |
| kubeclarity-runtime-scan.vulnerability-scanner.scanner.grype.remote-grype.timeout          | string | `"2m"`                                          |             |
| kubeclarity-runtime-scan.vulnerability-scanner.scanner.scannerList                         | string | `"grype"`                                       |             |
| kubeclarity-runtime-scan.vulnerability-scanner.scanner.trivy.enabled                       | bool   | `false`                                         |             |
| kubeclarity-runtime-scan.vulnerability-scanner.scanner.trivy.timeout                       | string | `"300"`                                         |             |
| kubeclarity-sbom-db.docker.imageName                                                       | string | `""`                                            |             |
| kubeclarity-sbom-db.logLevel                                                               | string | `"warning"`                                     |             |
| kubeclarity-sbom-db.resources.limits.cpu                                                   | string | `"200m"`                                        |             |
| kubeclarity-sbom-db.resources.limits.memory                                                | string | `"1Gi"`                                         |             |
| kubeclarity-sbom-db.resources.requests.cpu                                                 | string | `"10m"`                                         |             |
| kubeclarity-sbom-db.resources.requests.memory                                              | string | `"20Mi"`                                        |             |
| kubeclarity-sbom-db.servicePort                                                            | int    | `8080`                                          |             |
| kubeclarity-trivy-server.enabled                                                           | bool   | `false`                                         |             |
| kubeclarity-trivy-server.image.pullPolicy                                                  | string | `"IfNotPresent"`                                |             |
| kubeclarity-trivy-server.image.registry                                                    | string | `"docker.io"`                                   |             |
| kubeclarity-trivy-server.image.repository                                                  | string | `"aquasec/trivy"`                               |             |
| kubeclarity-trivy-server.image.tag                                                         | string | `"0.44.1"`                                      |             |
| kubeclarity-trivy-server.persistence.enabled                                               | bool   | `false`                                         |             |
| kubeclarity-trivy-server.podSecurityContext.fsGroup                                        | int    | `1001`                                          |             |
| kubeclarity-trivy-server.podSecurityContext.runAsNonRoot                                   | bool   | `true`                                          |             |
| kubeclarity-trivy-server.podSecurityContext.runAsUser                                      | int    | `1001`                                          |             |
| kubeclarity-trivy-server.resources.limits.cpu                                              | string | `"1000m"`                                       |             |
| kubeclarity-trivy-server.resources.limits.memory                                           | string | `"1G"`                                          |             |
| kubeclarity-trivy-server.resources.requests.cpu                                            | string | `"200m"`                                        |             |
| kubeclarity-trivy-server.resources.requests.memory                                         | string | `"200Mi"`                                       |             |
| kubeclarity-trivy-server.securityContext.privileged                                        | bool   | `false`                                         |             |
| kubeclarity-trivy-server.securityContext.readOnlyRootFilesystem                            | bool   | `true`                                          |             |
| kubeclarity-trivy-server.service.port                                                      | int    | `9992`                                          |             |
| kubeclarity-trivy-server.trivy.debugMode                                                   | bool   | `false`                                         |             |
| kubeclarity.docker.imageName                                                               | string | `""`                                            |             |
| kubeclarity.enableDBInfoLog                                                                | bool   | `false`                                         |             |
| kubeclarity.ingress.annotations                                                            | object | `{}`                                            |             |
| kubeclarity.ingress.enabled                                                                | bool   | `false`                                         |             |
| kubeclarity.ingress.hosts[0].host                                                          | string | `"chart-example.local"`                         |             |
| kubeclarity.ingress.hosts[0].paths                                                         | list   | `[]`                                            |             |
| kubeclarity.ingress.ingressClassName                                                       | string | `""`                                            |             |
| kubeclarity.ingress.labels                                                                 | object | `{}`                                            |             |
| kubeclarity.ingress.tls                                                                    | list   | `[]`                                            |             |
| kubeclarity.initContainers.resources.limits.cpu                                            | string | `"200m"`                                        |             |
| kubeclarity.initContainers.resources.limits.memory                                         | string | `"200Mi"`                                       |             |
| kubeclarity.initContainers.resources.requests.cpu                                          | string | `"100m"`                                        |             |
| kubeclarity.initContainers.resources.requests.memory                                       | string | `"100Mi"`                                       |             |
| kubeclarity.logLevel                                                                       | string | `"warning"`                                     |             |
| kubeclarity.podAnnotations                                                                 | object | `{}`                                            |             |
| kubeclarity.prometheus.enabled                                                             | bool   | `false`                                         |             |
| kubeclarity.prometheus.refreshIntervalSeconds                                              | int    | `300`                                           |             |
| kubeclarity.prometheus.serviceMonitor.annotations                                          | object | `{}`                                            |             |
| kubeclarity.prometheus.serviceMonitor.enabled                                              | bool   | `false`                                         |             |
| kubeclarity.prometheus.serviceMonitor.interval                                             | string | `"30s"`                                         |             |
| kubeclarity.prometheus.serviceMonitor.labels                                               | object | `{}`                                            |             |
| kubeclarity.resources.limits.cpu                                                           | string | `"1000m"`                                       |             |
| kubeclarity.resources.limits.memory                                                        | string | `"1000Mi"`                                      |             |
| kubeclarity.resources.requests.cpu                                                         | string | `"100m"`                                        |             |
| kubeclarity.resources.requests.memory                                                      | string | `"200Mi"`                                       |             |
| kubeclarity.service.annotations                                                            | object | `{}`                                            |             |
| kubeclarity.service.port                                                                   | int    | `8080`                                          |             |
| kubeclarity.service.type                                                                   | string | `"ClusterIP"`                                   |             |

---

Autogenerated from chart metadata using [helm-docs v1.11.3](https://github.com/norwoodj/helm-docs/releases/v1.11.3)
