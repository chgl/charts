{{- define "ohdsi.auth.secretName" -}}
{{- if .Values.webApi.auth.openid.existingSecret -}}
    {{ .Values.webApi.auth.openid.existingSecret }}
{{- else -}}
    {{- $fullname := ( include "ohdsi.fullname" . ) -}}
    {{ printf "%s-%s" $fullname "webapi-auth" }}
{{- end -}}
{{- end }}

{{- define "ohdsi.auth.secretKey" -}}
{{- if .Values.webApi.auth.openid.existingSecret -}}
    {{ .Values.webApi.auth.openid.existingSecretKey }}
{{- else -}}
    {{ printf "%s" "webapi-openid-client-secret" }}
{{- end -}}
{{- end }}

{{- define "ohdsi.auth.jwt.secretName" -}}
{{- if .Values.webApi.auth.jwt.existingSecret -}}
    {{ .Values.webApi.auth.jwt.existingSecret }}
{{- else -}}
    {{- $fullname := ( include "ohdsi.fullname" . ) -}}
    {{ printf "%s-%s" $fullname "webapi-auth" }}
{{- end -}}
{{- end }}

{{- define "ohdsi.auth.jwt.secretKey" -}}
{{- if .Values.webApi.auth.jwt.existingSecret -}}
    {{ .Values.webApi.auth.jwt.existingSecretKey }}
{{- else -}}
    {{ printf "%s" "webapi-jwt-secret" }}
{{- end -}}
{{- end }}

{{/*
Whether any WebAPI authentication provider is enabled
*/}}
{{- define "ohdsi.auth.enabled" -}}
{{- if (or .Values.webApi.auth.openid.enabled .Values.webApi.auth.basic.enabled) -}}
true
{{- end -}}
{{- end }}

{{- define "ohdsi.ingress.protocol" -}}
    {{- if .Values.ingress.tls -}}
    {{ "https" }}
    {{- else -}}
    {{ "http" }}
    {{- end -}}
{{- end -}}

{{/*
The origin (scheme://host) of the first ingress host
*/}}
{{- define "ohdsi.ingress.origin" -}}
    {{- $protocol := include "ohdsi.ingress.protocol" . }}
    {{- $host := (index .Values.ingress.hosts 0).host }}
    {{- printf "%s://%s" $protocol $host }}
{{- end -}}

{{/*
SECURITY_AUTH_OAUTH_CALLBACK_UI
*/}}
{{- define "ohdsi.oauth.callback.ui" -}}
{{- if .Values.webApi.auth.openid.callbackUI -}}
    {{ .Values.webApi.auth.openid.callbackUI }}
{{- else if not .Values.ingress.enabled -}}
    {{- fail "webApi.auth.openid.callbackUI must be set if webApi.auth.openid.enabled=true and ingress.enabled=false" -}}
{{- else -}}
    {{- printf "%s/%s" (include "ohdsi.ingress.origin" .) "atlas/#/oauth/callback" }}
{{- end -}}
{{- end }}
