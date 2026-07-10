{{/*
Namespace for all resources to be installed into
If not defined in values file then the helm release namespace is used
By default this is not set so the helm release namespace will be used
*/}}

{{- define "custom.namespace" -}}
	{{ .Values.namespace | default .Release.Namespace }}
{{- end -}}

{{/*
Check if metrics are enabled
*/}}
{{- define "csm-authorization.isMetricsEnabled" -}}
	{{- if hasKey .Values "metrics" -}}
		{{- if hasKey .Values.metrics "enabled" -}}
			{{- printf "%t" .Values.metrics.enabled -}}
		{{- else -}}
			false
		{{- end -}}
	{{- else -}}
		false
	{{- end -}}
{{- end -}}
