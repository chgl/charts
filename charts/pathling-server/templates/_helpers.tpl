{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "pathling-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pathling-server.fullname" -}}
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
{{- define "pathling-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "pathling-server.labels" -}}
helm.sh/chart: {{ include "pathling-server.chart" . }}
{{ include "pathling-server.matchLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "pathling-server.matchLabels" -}}
app.kubernetes.io/name: {{ include "pathling-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "pathling-server.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "pathling-server.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the S3 endpoint to use
*/}}
{{- define "pathling-server.s3Endpoint" -}}
{{- if .Values.minio.enabled -}}
    {{- printf "http://%s:%d" (include "common.names.fullname" .Subcharts.minio) (int64 .Values.minio.service.ports.api) -}}
{{- else -}}
    {{- .Values.warehouse.s3.endpoint -}}
{{- end -}}
{{- end -}}

{{/*
Return the name of the secret containing the S3 access key
*/}}
{{- define "pathling-server.s3CredentialsSecretName" -}}
{{- if .Values.minio.enabled -}}
    {{- printf "%s" (include "common.names.fullname" .Subcharts.minio) -}}
{{- else -}}
    {{- if .Values.warehouse.s3.credentials.existingSecret.name -}}
        {{ .Values.warehouse.s3.credentials.existingSecret.name | quote }}
    {{- else -}}
        {{- printf "%s-s3-credentials" (include "pathling-server.fullname" .) -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the name of the key inside the secret containing the S3 access key
*/}}
{{- define "pathling-server.s3AccessKeySecretKey" -}}
{{- if .Values.minio.enabled -}}
    {{- "root-user" -}}
{{- else -}}
    {{- if .Values.warehouse.s3.credentials.existingSecret.name -}}
        {{ .Values.warehouse.s3.credentials.existingSecret.accessKeyKey | quote }}
    {{- else -}}
        {{- "access-key" -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the name of the key inside the secret containing the S3 secret key
*/}}
{{- define "pathling-server.s3SecretKeySecretKey" -}}
{{- if .Values.minio.enabled -}}
    {{- "root-password" -}}
{{- else -}}
    {{- if .Values.warehouse.s3.credentials.existingSecret.name -}}
        {{ .Values.warehouse.s3.credentials.existingSecret.secretKeyKey | quote }}
    {{- else -}}
        {{- "secret-key" -}}
    {{- end -}}
{{- end -}}
{{- end -}}
