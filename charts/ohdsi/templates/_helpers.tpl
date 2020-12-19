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
{{- $fullname := ( include "ohdsi.fullname" . ) -}}
{{- if .Values.postgresqlha.enabled -}}
{{- if .Values.global.postgresql.existingSecret -}}
{{ .Values.global.postgresql.existingSecret | quote }}
{{- else -}}
{{ printf "%s-%s" $fullname "postgresqlha-postgresql" }}
{{- end -}}
{{- else if .Values.webapi.db.existingSecret -}}
{{ .Values.webapi.db.existingSecret | quote }}
{{- else -}}
{{ printf "%s-%s" $fullname "webapi-db-secret" }}
{{- end -}}
{{- end -}}

{{/*
Create the JDBC URL from the host, port and database name.
*/}}
{{- define "ohdsi.webapi.jdbcUrl" -}}
{{- if .Values.postgresqlha.enabled -}}
{{- $fullname := ( include "ohdsi.fullname" . ) -}}
{{- $pgpoolServiceName := ( printf "%s-%s" $fullname "postgresqlha-pgpool") -}}
{{ printf "jdbc:postgresql://%s:%d/%s" $pgpoolServiceName 5432 .Values.global.postgresql.database }}
{{- else -}}
{{ printf "jdbc:postgresql://%s:%d/%s" .Values.webapi.db.host (int64 .Values.webapi.db.port) .Values.webapi.db.database }}
{{- end -}}
{{- end -}}
