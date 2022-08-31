{{/*
Expand the name of the chart.
*/}}
{{- define "app-mobility.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "app-mobility.fullname" -}}
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
{{- define "app-mobility.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "app-mobility.labels" -}}
helm.sh/chart: {{ include "app-mobility.chart" . }}
{{ include "app-mobility.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "app-mobility.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app-mobility.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "app-mobility.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "app-mobility.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Create the name of the velero namespace.
*/}}
{{- define "velero.namespace" -}}
{{- if not .Values.velero.enabled -}}
  {{- if .Values.veleroNamespace -}}
    {{- .Values.veleroNamespace -}}
  {{- else -}}
    {{- default "velero" -}}
  {{- end -}}
{{- else -}}
  {{ default .Release.Namespace }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the license.
*/}}
{{- define "app-mobility.licenseName" -}}
{{- if .Values.licenseName -}}
  {{- .Values.licenseName -}}
{{- else -}}
  {{- default "license" -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the secret that holds credentials to object store.
*/}}
{{- define "objectstore.secretname" -}}
{{- if not .Values.velero.enabled -}}
  {{- if .Values.objectstore.secretName -}}
    {{- .Values.objectstore.secretName -}}
  {{- else -}}
    {{- default "cloud-credentials" -}}
  {{- end -}}
{{- else -}}
  {{- if .Values.velero.credentials.existingSecret -}}
    {{ .Values.velero.credentials.existingSecret }}
  {{- else -}}
    {{ default (include "velero.fullname" .) .Values.velero.credentials.name }}  
  {{- end -}}
{{- end -}}
{{- end -}}


{{/*
Deriving the secret name that velero will use based on its template:
https://github.com/vmware-tanzu/helm-charts/blob/main/charts/velero/templates/_helpers.tpl#L45
*/}}
{{- define "velero.fullname" -}}
{{- $name := default "velero" -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
