{{/* Copyright © 2026 Dell Inc. or its subsidiaries. All Rights Reserved. */}}
{{/*
Namespace for all resources to be installed into
If not defined in values file then the helm release namespace is used
By default this is not set so the helm release namespace will be used
*/}}

{{- define "custom.namespace" -}}
	{{ .Values.namespace | default .Release.Namespace }}
{{- end -}}

{{/*
Generate PrometheusRule for a specific driver
Args:
  .driverName: The driver name (e.g., "powerflex", "powerstore", "powerscale", "powermax")
  .jobPattern: The Prometheus job pattern (e.g., "karavi-metrics-powerflex.*")
  .root: The root context (pass $ from the template)
*/}}
{{- define "karavi.prometheusRule" -}}
{{- $driverName := .driverName -}}
{{- $moduleLabel := .moduleLabel -}}
{{- $platformLabel := .platformLabel -}}
{{- $platformLabelRef := printf "{{ $labels.%s }}" $platformLabel -}}
{{- $jobPattern := .jobPattern -}}
{{- $root := .root -}}
---
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: {{ $root.Release.Name }}-{{ $driverName }}-alerts
  namespace: {{ include "custom.namespace" $root }}
  labels:
    app.kubernetes.io/name: karavi-observability
    app.kubernetes.io/instance: {{ $root.Release.Name }}
    app.kubernetes.io/component: observability-alerts
    app.kubernetes.io/driver: {{ $driverName }}
    release: prometheus
spec:
  groups:
    - name: csm-observability-alerts-{{ $driverName }}
      interval: 30s
      rules:
        - alert: CSMObservabilityMetricsCollectionFailure
          expr: absent(dell_csm_obs_collection_rate{module="{{ $moduleLabel }}"}) or dell_csm_obs_collection_rate{module="{{ $moduleLabel }}"} == 0
          for: 3m
          labels:
            severity: warning
            platform: observability
            component: csm-module
            driver: {{ $driverName }}
            alert_id: OBS-01
          annotations:
            summary: "CSM observability metrics collection failed for {{ $driverName }} on {{ $platformLabelRef }}"
            description: "No observability collection data has been produced for driver {{ $driverName }} and module {{ $moduleLabel }} on platform {{ $platformLabelRef }} for 3 minutes. Check the observability collector and upstream driver connectivity."
            runbook_url: "https://dell.github.io/csm-docs/docs/observability/alerts/csm-observability/"

        - alert: CSMObservabilityMetricsExportFailure
          expr: increase(dell_csm_obs_export_success_total{module="{{ $moduleLabel }}",status=~"failure|error"}[5m]) > 0
          for: 3m
          labels:
            severity: warning
            platform: observability
            component: csm-module
            driver: {{ $driverName }}
            alert_id: OBS-02
          annotations:
            summary: "CSM observability metrics export failure for {{ $driverName }} on {{ $platformLabelRef }}"
            description: "Observability export failures were detected for driver {{ $driverName }} and module {{ $moduleLabel }} on platform {{ $platformLabelRef }}. Investigate the export backend and the observability pipeline."
            runbook_url: "https://dell.github.io/csm-docs/docs/observability/alerts/csm-observability/"

        - alert: CSMObservabilityArrayConnectivityLost
          expr: dell_csm_obs_array_connectivity{module="{{ $moduleLabel }}"} == 0
          for: 2m
          labels:
            severity: critical
            platform: observability
            component: csm-module
            driver: {{ $driverName }}
            alert_id: OBS-03
          annotations:
            summary: "CSM observability lost array connectivity for {{ $driverName }} on {{ $platformLabelRef }}"
            description: "The observability module has reported lost array connectivity for driver {{ $driverName }} and module {{ $moduleLabel }} on platform {{ $platformLabelRef }}. Check storage array reachability, credentials, and network connectivity."
            runbook_url: "https://dell.github.io/csm-docs/docs/observability/alerts/csm-observability/"

        - alert: CSMObservabilityScrapeEndpointUnavailable
          expr: absent(up{job=~"{{ $jobPattern }}"}) or up{job=~"{{ $jobPattern }}"} == 0
          for: 2m
          labels:
            severity: critical
            platform: observability
            component: csm-module
            driver: {{ $driverName }}
            alert_id: OBS-04
          annotations:
            summary: "CSM observability scrape endpoint unavailable for {{ $driverName }}"
            description: "The Prometheus scrape endpoint for the {{ $driverName }} observability metrics exporter is unavailable. Check the observability metrics service, ServiceMonitor, and pod health."
            runbook_url: "https://dell.github.io/csm-docs/docs/observability/alerts/csm-observability/"
{{- end -}}
