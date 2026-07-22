{{/*
Namespace for all resources to be installed into
If not defined in values file then the helm release namespace is used
By default this is not set so the helm release namespace will be used
*/}}

{{- define "custom.namespace" -}}
	{{ .Values.namespace | default .Release.Namespace }}
{{- end -}}

{{/*
Return true if proxy-server metrics is enabled
*/}}
{{- define "csm-authorization.isMetricsEnabled" -}}
{{- if hasKey .Values.authorization "metrics" -}}
  {{- if (eq .Values.authorization.metrics.enabled true) -}}
      {{- true -}}
  {{- else -}}
      {{- false -}}
  {{- end -}}
{{- else -}}
  {{- false -}}
{{- end -}}
{{- end -}}
