{{/*
Return the appropriate sidecar images based on k8s version
*/}}
{{- define "csi-powerstore.attacherImage" -}}
  {{- if eq .Capabilities.KubeVersion.Major "1" }}
    {{- if and (ge (trimSuffix "+" .Capabilities.KubeVersion.Minor) "22") (le (trimSuffix "+" .Capabilities.KubeVersion.Minor) "26") -}}
      {{- print "k8s.gcr.io/sig-storage/csi-attacher:v4.2.0" -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "csi-powerstore.provisionerImage" -}}
  {{- if eq .Capabilities.KubeVersion.Major "1" }}
    {{- if and (ge (trimSuffix "+" .Capabilities.KubeVersion.Minor) "22") (le (trimSuffix "+" .Capabilities.KubeVersion.Minor) "26") -}}
      {{- print "k8s.gcr.io/sig-storage/csi-provisioner:v3.4.0" -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "csi-powerstore.snapshotterImage" -}}
  {{- if eq .Capabilities.KubeVersion.Major "1" }}
    {{- if and (ge (trimSuffix "+" .Capabilities.KubeVersion.Minor) "22") (le (trimSuffix "+" .Capabilities.KubeVersion.Minor) "26") -}}
      {{- print "k8s.gcr.io/sig-storage/csi-snapshotter:v6.2.1" -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "csi-powerstore.resizerImage" -}}
  {{- if eq .Capabilities.KubeVersion.Major "1" }}
    {{- if and (ge (trimSuffix "+" .Capabilities.KubeVersion.Minor) "22") (le (trimSuffix "+" .Capabilities.KubeVersion.Minor) "26") -}}
      {{- print "k8s.gcr.io/sig-storage/csi-resizer:v1.7.0" -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "csi-powerstore.registrarImage" -}}
  {{- if eq .Capabilities.KubeVersion.Major "1" }}
    {{- if and (ge (trimSuffix "+" .Capabilities.KubeVersion.Minor) "22") (le (trimSuffix "+" .Capabilities.KubeVersion.Minor) "26") -}}
      {{- print "k8s.gcr.io/sig-storage/csi-node-driver-registrar:v2.6.3" -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "csi-powerstore.healthmonitorImage" -}}
  {{- if eq .Capabilities.KubeVersion.Major "1" }}
    {{- if and (ge (trimSuffix "+" .Capabilities.KubeVersion.Minor) "22") (le (trimSuffix "+" .Capabilities.KubeVersion.Minor) "26") -}}
      {{- print "gcr.io/k8s-staging-sig-storage/csi-external-health-monitor-controller:v0.8.0" -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
 
{{/*
Return true if storage capacity tracking is enabled and is supported based on k8s version
*/}}
{{- define "csi-powerstore.isStorageCapacitySupported" -}}
{{- if eq .Values.storageCapacity.enabled true -}}
  {{- if and (eq .Capabilities.KubeVersion.Major "1") (ge (trimSuffix "+" .Capabilities.KubeVersion.Minor) "24") -}}
      {{- true -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Namespace for all resources to be installed into
If not defined in values file then the helm release namespace is used
By default this is not set so the helm release namespace will be used
*/}}

{{- define "custom.namespace" -}}
	{{ .Values.namespace | default .Release.Namespace }}
{{- end -}}