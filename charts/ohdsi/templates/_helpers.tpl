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
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Get the name of the secret containing the DB password
*/}}
{{- define "ohdsi.webapi.db-secret-name" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if .Values.postgresql.existingSecret -}}
        {{ .Values.postgresql.existingSecret | quote }}
    {{- else -}}
        {{ ( include "postgresql.primary.fullname" .Subcharts.postgresql ) }}
    {{- end -}}
{{- else if .Values.webApi.db.existingSecret -}}
    {{ .Values.webApi.db.existingSecret | quote }}
{{- else -}}
    {{- $fullname := ( include "ohdsi.fullname" . ) -}}
    {{ printf "%s-%s" $fullname "webapi-db-secret" }}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "ohdsi.database.host" -}}
{{- ternary ( include "postgresql.primary.fullname" .Subcharts.postgresql ) .Values.webApi.db.host .Values.postgresql.enabled -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "ohdsi.database.user" -}}
{{- ternary .Values.postgresql.postgresqlUsername .Values.webApi.db.username .Values.postgresql.enabled -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "ohdsi.database.name" -}}
{{- ternary .Values.postgresql.postgresqlDatabase .Values.webApi.db.database .Values.postgresql.enabled -}}
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
{{- $appName := printf "%s-webapi" .Release.Name -}}
{{ printf "jdbc:postgresql://%s:%d/%s?ApplicationName=%s" $host (int $port) $name $appName}}
{{- end -}}

{{/*
Create the Achilles DB URL from the host, port and database name.
*/}}
{{- define "ohdsi.achilles.dbUrl" -}}
{{- $host := (include "ohdsi.database.host" .) -}}
{{- $port := (include "ohdsi.database.port" .) -}}
{{- $name := (include "ohdsi.database.name" .) -}}
{{- $appName := printf "%s-achilles" .Release.Name -}}
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
