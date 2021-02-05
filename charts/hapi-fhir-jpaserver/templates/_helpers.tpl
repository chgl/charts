{{/*
Expand the name of the chart.
*/}}
{{- define "hapi-fhir-jpaserver.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hapi-fhir-jpaserver.fullname" -}}
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
{{- define "hapi-fhir-jpaserver.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hapi-fhir-jpaserver.labels" -}}
helm.sh/chart: {{ include "hapi-fhir-jpaserver.chart" . }}
{{ include "hapi-fhir-jpaserver.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "hapi-fhir-jpaserver.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hapi-fhir-jpaserver.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the JDBC URL from the host, port and database name.
*/}}
{{- define "hapi-fhir-jpaserver.jdbcUrl" -}}
{{- if .Values.postgresql.enabled -}}
{{- $pgServiceName := ( printf "%s-%s" .Release.Name "postgresql") -}}
{{ printf "jdbc:postgresql://%s:%d/%s" $pgServiceName 5432 .Values.postgresql.postgresqlDatabase }}
{{- else -}}
{{ printf "jdbc:postgresql://%s:%d/%s" .Values.externalDatabase.host (int64 .Values.externalDatabase.port) .Values.externalDatabase.database }}
{{- end -}}
{{- end -}}

{{/*
Get the name of the secret containing the DB password
*/}}
{{- define "hapi-fhir-jpaserver.db-secretName" -}}
{{- if .Values.postgresql.enabled -}}
{{- if .Values.postgresql.existingSecret -}}
    {{ .Values.postgresql.existingSecret | quote }}
{{- else -}}
    {{ printf "%s-%s" .Release.Name "postgresql" }}
{{- end -}}
{{- else if .Values.externalDatabase.existingSecret -}}
    {{ .Values.externalDatabase.existingSecret | quote }}
{{- else -}}
    {{ printf "%s-%s" .Release.Name "externaldb" }}
{{- end -}}
{{- end -}}
