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

{{- define "ohdsi.ingress.protocol" -}}
    {{- if .Values.ingress.tls -}}
    {{ "https" }}
    {{- else -}}
    {{ "http" }}
    {{- end -}}
{{- end -}}

{{/*
SECURITY_OAUTH_CALLBACK_API
*/}}
{{- define "ohdsi.oauth.callback.api" -}}
{{- if .Values.webApi.auth.openid.callbackApi -}}
    {{ .Values.webApi.auth.openid.callbackApi }}
{{- else -}}
    {{- $protocol := include "ohdsi.ingress.protocol" . }}
    {{- $host := (index .Values.ingress.hosts 0).host }}
    {{- printf "%s://%s/%s" $protocol $host "WebAPI/user/oauth/callback" }}
{{- end -}}
{{- end }}

{{/*
SECURITY_OAUTH_CALLBACK_UI
*/}}
{{- define "ohdsi.oauth.callback.ui" -}}
{{- if .Values.webApi.auth.openid.callbackUI -}}
    {{ .Values.webApi.auth.openid.callbackUI }}
{{- else -}}
    {{- $protocol := include "ohdsi.ingress.protocol" . }}
    {{- $host := (index .Values.ingress.hosts 0).host }}
    {{- printf "%s://%s/%s" $protocol $host "atlas/index.html#/welcome/" }}
{{- end -}}
{{- end }}

{{/*
SECURITY_OID_LOGOUTURL
*/}}
{{- define "ohdsi.oid.logoutUrl" -}}
{{- if .Values.webApi.auth.openid.logoutUrl -}}
    {{ .Values.webApi.auth.openid.logoutUrl }}
{{- else -}}
    {{- printf "%s" (include "ohdsi.oauth.callback.ui" .) }}
{{- end -}}
{{- end }}

{{/*
SECURITY_OID_REDIRECTURL
*/}}
{{- define "ohdsi.oid.redirectUrl" -}}
{{- if .Values.webApi.auth.openid.redirectUrl -}}
    {{ .Values.webApi.auth.openid.redirectUrl }}
{{- else -}}
    {{- $protocol := include "ohdsi.ingress.protocol" . }}
    {{- $host := (index .Values.ingress.hosts 0).host }}
    {{- printf "%s://%s/%s" $protocol $host "atlas/index.html#/welcome/null" }}
{{- end -}}
{{- end }}
