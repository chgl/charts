{{/*
Expand the name of the chart.
*/}}
{{- define "ohdsi.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ohdsi.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ohdsi.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ohdsi.labels" -}}
helm.sh/chart: {{ include "ohdsi.chart" . }}
app.kubernetes.io/name: {{ include "ohdsi.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Labels to use on deploy.spec.selector.matchLabels and svc.spec.selector
*/}}
{{- define "ohdsi.matchLabels" -}}
app.kubernetes.io/name: {{ include "ohdsi.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "ohdsi.postgresql.fullname" -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Get the name of the secret containing the DB password
*/}}
{{- define "ohdsi.webapi.db-secret-name" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if .Values.postgresql.auth.existingSecret -}}
        {{ .Values.postgresql.auth.existingSecret | quote }}
    {{- else -}}
        {{ ( include "ohdsi.postgresql.fullname" . ) }}
    {{- end -}}
{{- else if .Values.webApi.db.existingSecret -}}
    {{ .Values.webApi.db.existingSecret | quote }}
{{- else -}}
    {{- $fullname := ( include "ohdsi.fullname" . ) -}}
    {{ printf "%s-%s" $fullname "webapi-db-secret" }}
{{- end -}}
{{- end -}}

{{/*
Get the key inside the secret containing the DB user's password
*/}}
{{- define "ohdsi.webapi.db-secret-key" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if (or .Values.postgresql.auth.username .Values.postgresql.auth.existingSecret ) -}}
        {{ "password" }}
    {{- else -}}
        {{ "postgres-password" }}
    {{- end -}}
{{- else if .Values.webApi.db.existingSecret -}}
    {{ .Values.webApi.db.existingSecretKey | quote }}
{{- else -}}
    {{ "postgres-password" }}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "ohdsi.database.host" -}}
{{- ternary (include "ohdsi.postgresql.fullname" .) .Values.webApi.db.host .Values.postgresql.enabled -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "ohdsi.database.user" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if .Values.postgresql.auth.username -}}
        {{ .Values.postgresql.auth.username | quote }}
    {{- else -}}
        {{ "postgres" }}
    {{- end -}}
{{- else -}}
    {{ .Values.webApi.db.username}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "ohdsi.database.name" -}}
{{- ternary .Values.postgresql.auth.database .Values.webApi.db.database .Values.postgresql.enabled -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "ohdsi.database.port" -}}
{{- ternary "5432" .Values.webApi.db.port .Values.postgresql.enabled -}}
{{- end -}}

{{/*
Create the JDBC URL from the host, port and database name.
*/}}
{{- define "ohdsi.webapi.jdbcUrl" -}}
{{- $host := (include "ohdsi.database.host" .) -}}
{{- $port := (include "ohdsi.database.port" .) -}}
{{- $name := (include "ohdsi.database.name" .) -}}
{{- $releaseName := (include "ohdsi.fullname" .) -}}
{{- $appName := printf "%s-webapi" $releaseName -}}
{{ printf "jdbc:postgresql://%s:%d/%s?ApplicationName=%s" $host (int $port) $name $appName}}
{{- end -}}

{{/*
Get the container image for the wait-for-db init container used by the WebAPI component
*/}}
{{- define "ohdsi.webapi.waitForDatabaseInitContainerImage" -}}
{{- $registry := .Values.webApi.waitForDatabaseInitContainer.image.registry -}}
{{- $repository := .Values.webApi.waitForDatabaseInitContainer.image.repository -}}
{{- $tag := .Values.webApi.waitForDatabaseInitContainer.image.tag -}}
{{ printf "%s/%s:%s" $registry $repository $tag}}
{{- end -}}

{{/*
Create the Achilles DB URL from the host, port and database name.
*/}}
{{- define "ohdsi.achilles.dbUrl" -}}
{{- $host := (include "ohdsi.database.host" .) -}}
{{- $port := (include "ohdsi.database.port" .) -}}
{{- $name := (include "ohdsi.database.name" .) -}}
{{- $releaseName := (include "ohdsi.fullname" .) -}}
{{- $appName := printf "%s-achilles" $releaseName -}}
{{ printf "postgresql://%s:%d/%s?ApplicationName=%s" $host (int $port) $name $appName}}
{{- end -}}

{{/*
Return the appropriate apiVersion for Ingress
*/}}
{{- define "ohdsi.ingress.apiVersion" -}}
{{- if semverCompare "<1.14-0" .Capabilities.KubeVersion.Version -}}
{{- print "extensions/v1beta1" -}}
{{- else if semverCompare "<1.19-0" .Capabilities.KubeVersion.Version -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- else -}}
{{- print "networking.k8s.io/v1" -}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for CronJob
*/}}
{{- define "ohdsi.cronJob.apiVersion" -}}
{{- if semverCompare ">=1.21-0" .Capabilities.KubeVersion.Version -}}
{{- print "batch/v1" -}}
{{- else -}}
{{- print "batch/v1beta1" -}}
{{- end -}}
{{- end -}}

{{/*
Return the URL to access the WebAPI service at. This is the cluster-internal service URL,
not the one used by ATLAS which needs to be accessible from the user's browser.
*/}}
{{- define "ohdsi.webApi.url" -}}
{{- if .Values.atlas.webApiUrl }}
    {{ .Values.atlas.webApiUrl }}
{{- else }}
    {{- $webApiServiceName := printf "%s-webapi" (include "ohdsi.fullname" .) -}}
    {{ printf "http://%s:%d/WebAPI" $webApiServiceName (int .Values.webApi.service.port) }}
{{- end }}
{{- end -}}

{{/*
env vars set on the webapi container for otel tracing and metrics
*/}}
{{- define "ohdsi.webApi.otel.envVars" -}}
{{- if (or .Values.webApi.metrics.serviceMonitor.enabled .Values.webApi.tracing.enabled) }}
{{- $webApiServiceName := printf "%s-webapi" (include "ohdsi.fullname" .) -}}
{{- $metricsExporter := (ternary "prometheus" "none" .Values.webApi.metrics.serviceMonitor.enabled) -}}
{{- $tracesExporter := (ternary "jaeger" "none" .Values.webApi.tracing.enabled) -}}
- name: JAVA_OPTS
  value: "-javaagent:/var/lib/ohdsi/webapi/opentelemetry-javaagent.jar"
- name: OTEL_LOGS_EXPORTER
  value: "none"
- name: OTEL_METRICS_EXPORTER
  value: "{{ $metricsExporter }}"
- name: OTEL_TRACES_EXPORTER
  value: "{{ $tracesExporter }}"
{{- if .Values.webApi.tracing.enabled }}
- name: OTEL_SERVICE_NAME
  value: "{{ $webApiServiceName }}"
- name: OTEL_EXPORTER_JAEGER_ENDPOINT
  value: "{{ .Values.webApi.tracing.jaeger.endpoint }}"
- name: OTEL_EXPORTER_JAEGER_PROTOCOL
  value: "{{ .Values.webApi.tracing.jaeger.protocol }}"
- name: OTEL_EXPORTER_JAEGER_AGENT_HOST
  value: "{{ .Values.webApi.tracing.jaeger.agentHost }}"
- name: OTEL_EXPORTER_JAEGER_AGENT_PORT
  value: "{{ .Values.webApi.tracing.jaeger.agentPort }}"
{{- end }}
{{- end }}
{{- end -}}


{{/*
TODO: refactor to pass the module name (webapi, atlas, achilles) and the `.serviceAccount` context as 2 parameters
*/}}

{{/*
Create the name of the webapi service account to use
*/}}
{{- define "ohdsi.webApi.serviceAccountName" -}}
{{- if .Values.webApi.serviceAccount.create -}}
    {{ default (printf "%s-webapi" (include "ohdsi.fullname" .)) .Values.webApi.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.webApi.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the atlas service account to use
*/}}
{{- define "ohdsi.atlas.serviceAccountName" -}}
{{- if .Values.atlas.serviceAccount.create -}}
    {{ default (printf "%s-atlas" (include "ohdsi.fullname" .)) .Values.atlas.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.atlas.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the atlas service account to use
*/}}
{{- define "ohdsi.achilles.serviceAccountName" -}}
{{- if .Values.achilles.serviceAccount.create -}}
    {{ default (printf "%s-achilles" (include "ohdsi.fullname" .)) .Values.achilles.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.achilles.serviceAccount.name }}
{{- end -}}
{{- end -}}
