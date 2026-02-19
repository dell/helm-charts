
{{- define "csi-powermax.isStorageCapacitySupported" -}}
{{- if eq .Values.storageCapacity.enabled true -}}
  {{- if and (eq .Capabilities.KubeVersion.Major "1") (ge (trimSuffix "+" .Capabilities.KubeVersion.Minor) "24") -}}
      {{- true -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{- define "csi-powermax.isVgsnapshotEnabled" -}}
{{- if and (hasKey .Values.controller "vgsnapshot") (kindOf .Values.controller.vgsnapshot | eq "map") (hasKey .Values.controller.vgsnapshot "enabled") -}}
  {{- if .Values.controller.vgsnapshot.enabled -}}
    {{- true -}}
  {{- end -}}
{{- end -}}
{{- end -}}
