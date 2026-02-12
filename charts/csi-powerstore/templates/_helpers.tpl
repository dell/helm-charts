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
Return true if vgsnapshot is enabled and properly configured
*/}}
{{- define "csi-powerstore.isVgsnapshotEnabled" -}}
{{- if and (hasKey .Values.controller "vgsnapshot") (kindOf .Values.controller.vgsnapshot | eq "map") (hasKey .Values.controller.vgsnapshot "enabled") }}
  {{- if .Values.controller.vgsnapshot.enabled }}
    {{- true -}}
  {{- end -}}
{{- end -}}
{{- end -}}
