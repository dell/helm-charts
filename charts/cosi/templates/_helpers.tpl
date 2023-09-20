{{/*
Expand the name of the chart.
*/}}
{{- define "cosi.name" }}
  {{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cosi.fullname" }}
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
{{- define "cosi.chart" }}
  {{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
# COSI driver log level
# Values are set to the integer value, higher value means more verbose logging
# Possible values: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
# Default value: 4
*/}}
{{- define "cosi.logLevel" }}
  {{- if (kindIs "int64" .Values.provisioner.logLevel) }}
    {{- if (or (ge .Values.provisioner.logLevel 0) (le .Values.provisioner.logLevel 10)) }}
      {{- .Values.provisioner.logLevel }}
    {{- else }}
      {{- 4 }}
    {{- end }}
  {{- else }}
    {{- 4 }}
  {{- end }}
{{- end }}

{{/*
# COSI driver sidecar log level
# Values are set to the integer value, higher value means more verbose logging
# Possible values: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
# Default value: 4
*/}}
{{- define "cosi.provisionerSidecarVerbosity" }}
  {{- if (kindIs "int64" .Values.sidecar.verbosity) }}
    {{- if (or (ge .Values.sidecar.verbosity 0) (le .Values.sidecar.verbosity 10)) }}
      {{- .Values.sidecar.verbosity }}
    {{- else }}
      {{- 4 }}
    {{- end }}
  {{- else }}
    {{- 4 }}
  {{- end }}
{{- end }}

{{/*
# COSI driver log format
# Possible values: "json" "text"
# Default value: "json"
*/}}
{{- define "cosi.logFormat" }}
  {{- $logFormatValues := list "json" "text" }}
  {{- if (has .Values.provisioner.logFormat $logFormatValues) }}
    {{- .Values.provisioner.logFormat }}
  {{- else }}
    {{- "text" }}
  {{- end }}
{{- end }}

{{/*
# COSI driver OTEL endpoint
# Default value is left empty on purpose, to not start any tracing if no argument was provided.
# Default value: ""
*/}}
{{- define "cosi.otelEndpoint" }}
  {{- if .Values.provisioner.otelEndpoint }}
    {{- .Values.provisioner.otelEndpoint }}
  {{- else }}
    {{- "" }}
  {{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cosi.labels" }}
helm.sh/chart: {{ include "cosi.chart" . }}
{{- include "cosi.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cosi.selectorLabels" }}
app.kubernetes.io/name: {{ include "cosi.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the role to use
*/}}
{{- define "cosi.roleName" }}
  {{- if and .Values.rbac.create }}
      {{- default (printf "%s" (include "cosi.fullname" .)) .Values.rbac.role.name }}
  {{- else }}
    {{- .Values.rbac.role.name }}
  {{- end }}
{{- end }}

{{/*
Create the name of the role binding to use
*/}}
{{- define "cosi.roleBindingName" }}
  {{- if and .Values.rbac.create }}
    {{- default (printf "%s" (include "cosi.fullname" .)) .Values.rbac.roleBinding.name }}
  {{- else }}
    {{- .Values.rbac.roleBinding.name }}
  {{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cosi.serviceAccountName" -}}
  {{- if .Values.serviceAccount.create -}}
      {{ default (include "cosi.fullname" .) .Values.serviceAccount.name }}
  {{- else -}}
      {{ default "default" .Values.serviceAccount.name }}
  {{- end -}}
{{- end -}}

{{/*
Create the name of provisioner container
*/}}
{{- define "cosi.provisionerContainerName" }}
  {{- default "objectstorage-provisioner" .Values.provisioner.name }}
{{- end }}

{{/*
Create the name of provisioner sidecar container
*/}}
{{- define "cosi.provisionerSidecarContainerName" }}
  {{- default "objectstorage-provisioner-sidecar" .Values.sidecar.name }}
{{- end }}

{{/*
Create the full name of provisioner image from repository and tag
*/}}
{{- define "cosi.provisionerImageName" }}
  {{- .Values.provisioner.image.repository }}:{{ .Values.provisioner.image.tag | default .Chart.AppVersion }}
{{- end }}

{{/*
Create the full name of provisioner sidecar image from repository and tag
*/}}
{{- define "cosi.provisionerSidecarImageName" }}
  {{- .Values.sidecar.image.repository }}:{{ .Values.sidecar.image.tag }}
{{- end }}

{{/*
Create the secret name
*/}}
{{- define "cosi.secretName" }}
  {{- if .Values.configuration.create }}
    {{- default (printf "%s-config" (include "cosi.name" . )) .Values.configuration.secretName }}
  {{- else }}
    {{- .Values.configuration.secretName }}
  {{- end }}
{{- end }}

{{/*
Create the name for secret volume
*/}}
{{- define "cosi.secretVolumeName" }}
  {{- printf "%s-config" (include "cosi.name" . ) }}
{{- end }}
