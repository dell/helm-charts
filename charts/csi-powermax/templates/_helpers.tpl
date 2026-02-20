
{{- define "csi-powermax.isStorageCapacitySupported" -}}
{{- if eq .Values.storageCapacity.enabled true -}}
  {{- if and (eq .Capabilities.KubeVersion.Major "1") (ge (trimSuffix "+" .Capabilities.KubeVersion.Minor) "24") -}}
      {{- true -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{- define "csi-powermax.isVgsnapshotEnabled" -}}
{{- if and (hasKey .Values.controller "snapshot") -}}
  {{- if and (hasKey .Values.controller.snapshot "volumeGroupSnapshot") (eq .Values.controller.snapshot.volumeGroupSnapshot.enabled true) -}}
      {{- true -}}
  {{- end -}}
{{- end -}}
{{- end -}}
