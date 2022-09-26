{{/*
Expand the name of the chart.
*/}}
{{- define "vfps.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "vfps.fullname" -}}
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
{{- define "vfps.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "vfps.labels" -}}
helm.sh/chart: {{ include "vfps.chart" . }}
{{ include "vfps.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "vfps.selectorLabels" -}}
app.kubernetes.io/name: {{ include "vfps.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "vfps.serviceAccountName" -}}
{{- if (or .Values.serviceAccount.create .Values.migrationsJob.enabled) }}
{{- default (include "vfps.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Get the container image for the wait-for-db init container
*/}}
{{- define "vfps.waitForDatabaseInitContainerImage" -}}
{{- $registry := .Values.waitForDatabaseInitContainer.image.registry -}}
{{- $repository := .Values.waitForDatabaseInitContainer.image.repository -}}
{{- $tag := .Values.waitForDatabaseInitContainer.image.tag -}}
{{ printf "%s/%s:%s" $registry $repository $tag}}
{{- end -}}

{{/*
Create a default fully qualified postgresql name. TODO: could we use SubChart template rendering to render this?
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "vfps.postgresql.fullname" -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "vfps.database.host" -}}
{{- ternary (include "vfps.postgresql.fullname" .) .Values.database.host .Values.postgresql.enabled -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "vfps.database.user" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if .Values.postgresql.auth.username -}}
        {{ .Values.postgresql.auth.username | quote }}
    {{- else -}}
        {{ "postgres" }}
    {{- end -}}
{{- else -}}
    {{ .Values.database.username}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "vfps.database.name" -}}
{{- ternary .Values.postgresql.auth.database .Values.database.database .Values.postgresql.enabled -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "vfps.database.port" -}}
{{- ternary "5432" .Values.database.port .Values.postgresql.enabled -}}
{{- end -}}

{{/*
Get the name of the secret containing the DB password
*/}}
{{- define "vfps.database.db-secret-name" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if .Values.postgresql.auth.existingSecret -}}
        {{ .Values.postgresql.auth.existingSecret | quote }}
    {{- else -}}
        {{ ( include "vfps.postgresql.fullname" . ) }}
    {{- end -}}
{{- else if .Values.database.existingSecret -}}
    {{ .Values.database.existingSecret | quote }}
{{- else -}}
    {{- $fullname := ( include "vfps.fullname" . ) -}}
    {{ printf "%s-%s" $fullname "db-secret" }}
{{- end -}}
{{- end -}}

{{/*
Get the key inside the secret containing the DB user's password
*/}}
{{- define "vfps.database.db-secret-key" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if (or .Values.postgresql.auth.username .Values.postgresql.auth.existingSecret ) -}}
        {{ "password" }}
    {{- else -}}
        {{ "postgres-password" }}
    {{- end -}}
{{- else if .Values.database.existingSecret -}}
    {{ .Values.database.existingSecretKey | quote }}
{{- else -}}
    {{ "postgres-password" }}
{{- end -}}
{{- end -}}

{{/*
Create the connection string from the host, port and database name.
*/}}
{{- define "vfps.database.connection-string" -}}
{{- $host := (include "vfps.database.host" .) -}}
{{- $port := (include "vfps.database.port" .) -}}
{{- $databaseName := (include "vfps.database.name" .) -}}
{{- $releaseName := (include "vfps.fullname" .) -}}
{{- $appName := printf "%s" $releaseName -}}
{{- $additionalConnectionStringParameters := printf "%s" .Values.database.additionalConnectionStringParameters -}}
{{ (printf "Host=%s:%d;Database=%s;Application Name=%s;%s" $host (int $port) $databaseName $appName $additionalConnectionStringParameters) | quote }}
{{- end -}}

{{/*
get the version of the image tag to use as an identifier. Default to .Chart.Version to handle things like tags used for testing.
*/}}
{{- define "vfps.migrationsJob.versionIdentifier" -}}
{{- $imageTagVersion := (default .Chart.Version (first (splitList "@" .Values.migrationsJob.image.tag))) -}}
{{- $imageTagVersion }}
{{- end -}}

{{/*
get the name of the migrations Job resource
*/}}
{{- define "vfps.migrationsJob.resourceName" -}}
{{ include "vfps.fullname" . }}-migrations-{{ include "vfps.migrationsJob.versionIdentifier" . }}
{{- end -}}
