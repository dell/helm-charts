# Copyright (c) 2026 Dell Inc., or its subsidiaries. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0

#!/bin/bash

set -euo pipefail

SUMMARY_FILE="version-summary.txt"
> "$SUMMARY_FILE"

echo "Starting Helm updater..."

strip_v() {
  echo "$1" | sed 's/^"//; s/"$//; s/^v//'
}

normalize_version() {
  echo "$1" | sed 's/^v//'
}

log_change() {
  local name=$1 old=$2 new=$3

  old_clean=$(strip_v "$old")
  new_clean=$(strip_v "$new")

  [[ "$old_clean" != "$new_clean" ]] && \
    echo "$name: $old → $new" | tee -a "$SUMMARY_FILE"
}

require_file() {
  if [[ ! -f "$1" ]]; then
    echo "Missing file: $1"
    exit 1
  fi
}

require_non_empty() {
  if [[ -z "$2" ]]; then
    echo "Missing required value: $1"
    exit 1
  fi
}

warn() {
  echo "WARN: $*" >&2
}

# Exact component extraction
# Example:
# quay.io/dell/container-storage-modules/csi-isilon:v2.17.0 → csi-isilon
extract_component() {
  basename "$1"
}

infer_version_from_component() {
  local component=$1 result=""

  case "$component" in
    csi-isilon) result="${CSI_POWERSCALE:-}" ;;
    csi-powerstore) result="${CSI_POWERSTORE:-}" ;;
    csi-powermax) result="${CSI_POWERMAX:-}" ;;
    csi-vxflexos) result="${CSI_VXFLEXOS:-}" ;;
    csi-unity) result="${CSI_UNITY:-}" ;;
    cosi) result="${COSI:-}" ;;

    csm-replication) result="${CSM_REPLICATION:-}" ;;
    karavi-resiliency) result="${KARAVI_RESILIENCY:-}" ;;
    csm-authorization) result="${CSM_AUTHORIZATION:-}" ;;
    csireverseproxy) result="${CSIREVERSEPROXY:-}" ;;
    karavi-observability) result="${KARAVI_OBSERVABILITY:-}" ;;
    karavi-metrics-powerflex) result="${KARAVI_METRICS_POWERFLEX:-}" ;;
    csm-metrics-powerstore) result="${CSM_METRICS_POWERSTORE:-}" ;;
    csm-metrics-powerscale) result="${CSM_METRICS_POWERSCALE:-}" ;;
    csm-metrics-powermax) result="${CSM_METRICS_POWERMAX:-}" ;;

    # Sidecars
    csi-resizer) result="${CSI_RESIZER:-}" ;;
    csi-provisioner) result="${CSI_PROVISIONER:-}" ;;
    csi-attacher) result="${CSI_ATTACHER:-}" ;;
    csi-snapshotter) result="${CSI_SNAPSHOTTER:-}" ;;
    csi-node-driver-registrar) result="${CSI_NODE_DRIVER_REGISTRAR:-}" ;;
    csi-external-health-monitor-controller) result="${CSI_EXTERNAL_HEALTH_MONITOR_CONTROLLER:-}" ;;
    csi-metadata-retriever) result="${CSI_METADATA_RETRIEVER:-}" ;;

    # Third-party
    opentelemetry-collector) result="${OPENTELEMETRY_COLLECTOR:-}" ;;
    nginx-unprivileged) result="${NGINX_UNPRIVILEGED:-}" ;;
    grafana) result="${GRAFANA:-}" ;;
    prometheus) result="${PROMETHEUS:-}" ;;
    openpolicyagent-opa) result="${OPENPOLICYAGENT_OPA:-}" ;;
    openpolicyagent-kube-mgmt) result="${OPENPOLICYAGENT_KUBE_MGMT:-}" ;;
    redis) result="${REDIS:-}" ;;

    *)
      result=""
      ;;
  esac

  if [[ -z "$result" ]]; then
    case "$component" in
      csi-isilon) echo "ERROR: Missing required env var CSI_POWERSCALE for component '$component'" >&2; exit 1 ;;
      csi-powerstore) echo "ERROR: Missing required env var CSI_POWERSTORE for component '$component'" >&2; exit 1 ;;
      csi-powermax) echo "ERROR: Missing required env var CSI_POWERMAX for component '$component'" >&2; exit 1 ;;
      csi-vxflexos) echo "ERROR: Missing required env var CSI_VXFLEXOS for component '$component'" >&2; exit 1 ;;
      csi-unity) echo "ERROR: Missing required env var CSI_UNITY for component '$component'" >&2; exit 1 ;;
      cosi) echo "ERROR: Missing required env var COSI for component '$component'" >&2; exit 1 ;;
      csm-replication) echo "ERROR: Missing required env var CSM_REPLICATION for component '$component'" >&2; exit 1 ;;
      karavi-resiliency) echo "ERROR: Missing required env var KARAVI_RESILIENCY for component '$component'" >&2; exit 1 ;;
      csm-authorization) echo "ERROR: Missing required env var CSM_AUTHORIZATION for component '$component'" >&2; exit 1 ;;
      csireverseproxy) echo "ERROR: Missing required env var CSIREVERSEPROXY for component '$component'" >&2; exit 1 ;;
      karavi-observability) echo "ERROR: Missing required env var KARAVI_OBSERVABILITY for component '$component'" >&2; exit 1 ;;
      karavi-metrics-powerflex) echo "ERROR: Missing required env var KARAVI_METRICS_POWERFLEX for component '$component'" >&2; exit 1 ;;
      csm-metrics-powerstore) echo "ERROR: Missing required env var CSM_METRICS_POWERSTORE for component '$component'" >&2; exit 1 ;;
      csm-metrics-powerscale) echo "ERROR: Missing required env var CSM_METRICS_POWERSCALE for component '$component'" >&2; exit 1 ;;
      csm-metrics-powermax) echo "ERROR: Missing required env var CSM_METRICS_POWERMAX for component '$component'" >&2; exit 1 ;;
      csi-resizer) echo "ERROR: Missing required env var CSI_RESIZER for component '$component'" >&2; exit 1 ;;
      csi-provisioner) echo "ERROR: Missing required env var CSI_PROVISIONER for component '$component'" >&2; exit 1 ;;
      csi-attacher) echo "ERROR: Missing required env var CSI_ATTACHER for component '$component'" >&2; exit 1 ;;
      csi-snapshotter) echo "ERROR: Missing required env var CSI_SNAPSHOTTER for component '$component'" >&2; exit 1 ;;
      csi-node-driver-registrar) echo "ERROR: Missing required env var CSI_NODE_DRIVER_REGISTRAR for component '$component'" >&2; exit 1 ;;
      csi-external-health-monitor-controller) echo "ERROR: Missing required env var CSI_EXTERNAL_HEALTH_MONITOR_CONTROLLER for component '$component'" >&2; exit 1 ;;
      csi-metadata-retriever) echo "ERROR: Missing required env var CSI_METADATA_RETRIEVER for component '$component'" >&2; exit 1 ;;
      opentelemetry-collector) echo "ERROR: Missing required env var OPENTELEMETRY_COLLECTOR for component '$component'" >&2; exit 1 ;;
      nginx-unprivileged) echo "ERROR: Missing required env var NGINX_UNPRIVILEGED for component '$component'" >&2; exit 1 ;;
      grafana) echo "ERROR: Missing required env var GRAFANA for component '$component'" >&2; exit 1 ;;
      prometheus) echo "ERROR: Missing required env var PROMETHEUS for component '$component'" >&2; exit 1 ;;
      openpolicyagent-opa) echo "ERROR: Missing required env var OPENPOLICYAGENT_OPA for component '$component'" >&2; exit 1 ;;
      openpolicyagent-kube-mgmt) echo "ERROR: Missing required env var OPENPOLICYAGENT_KUBE_MGMT for component '$component'" >&2; exit 1 ;;
      redis) echo "ERROR: Missing required env var REDIS for component '$component'" >&2; exit 1 ;;
      *)
        echo ""
        return 0
        ;;
    esac
  fi

  echo "$result"
}

# Detect images
detect_flat_images() {
  local file=$1

  yq e -o=json '
    paths(.. | select(tag == "!!str")) as $p
    | select(getpath($p) | test("^[^[:space:]]+:[^[:space:]]+$"))
    | {
        path: ($p | join(".")),
        value: getpath($p)
      }
  ' "$file" 2>/dev/null | jq -c '.'
}

# Parse image string
parse_image_string() {
  repo=$(echo "$1" | sed 's/:.*//')
  tag=$(echo "$1" | sed 's/.*://')
  echo "$repo|$tag"
}

# Update YAML
update_field() {
  local file=$1 path=$2 value=$3 label=$4

  old=$(yq e ".$path" "$file")

  yq e ".$path" "$file" >/dev/null 2>&1 || {
    echo "Path not found: $path in $file"
    exit 1
  }

  yq e -i ".$path = \"$value\"" "$file" || {
    echo "Failed update: $path"
    exit 1
  }


  log_change "$label ($path)" "$old" "$value"
}

# Detect version from Chart.yaml (fallback)
detect_chart_version() {
  yq e '.appVersion // .version // ""' "$1"
}

# Dependency-aware mapping
update_dependencies() {
  local chart_file=$1 chart_dir=$2 default_version=$3

  DEP_COUNT=$(yq e '.dependencies | length' "$chart_file" 2>/dev/null || echo 0)

  for ((i=0; i<DEP_COUNT; i++)); do
    name=$(yq e ".dependencies[$i].name" "$chart_file")

    require_non_empty "dependency name" "$name"

    inferred=$(infer_version_from_component "$name")
    if [[ -z "$inferred" ]]; then
      warn "$chart_dir: unknown dependency '$name' in $chart_file; using chart version '$default_version'"
      inferred="$default_version"
    fi
    version=$(normalize_version "$inferred")

    update_field "$chart_file" "dependencies[$i].version" "$version" "$chart_dir dependency"
  done
}

# --------------------------------------------------
# MAIN LOOP
# --------------------------------------------------

mapfile -t CHARTS < <(find charts -mindepth 1 -maxdepth 1 -type d | sort)

for chart_dir in "${CHARTS[@]}"; do
  echo ""
  echo "Processing $chart_dir"

  chart_file="$chart_dir/Chart.yaml"
  values_file="$chart_dir/values.yaml"

  require_file "$chart_file"

  chart_version=""

  # ---- Infer from flat images
  if [[ -f "$values_file" ]]; then
    while IFS= read -r entry; do
      [[ -z "$entry" ]] && continue
      value=$(echo "$entry" | jq -r '.value')

      parsed=$(parse_image_string "$value")
      repo=${parsed%|*}
      component=$(extract_component "$repo")

      inferred_version=$(infer_version_from_component "$component")
      if [[ -n "$inferred_version" ]]; then
        chart_version="$inferred_version"
        break
      fi
      warn "$chart_dir: unknown image component '$component' in $values_file; skipping for chart version inference"
    done < <(detect_flat_images "$values_file")
  fi

  # ---- fallback Chart.yaml
  if [[ -z "$chart_version" ]]; then
    raw=$(detect_chart_version "$chart_file")
    [[ -n "$raw" ]] && chart_version=$(strip_v "$raw")
  fi

  # ---- fallback global
  [[ -z "$chart_version" ]] && chart_version="${CSM_VERSION:-}"

  require_non_empty "chart version ($chart_dir)" "$chart_version"

  chart_version=$(normalize_version "$chart_version")

  # Update Chart.yaml
  update_field "$chart_file" "version" "$chart_version" "$chart_dir"
  update_field "$chart_file" "appVersion" "$chart_version" "$chart_dir"

  # Dependencies
  update_dependencies "$chart_file" "$chart_dir" "$chart_version"

  # Flat images
  if [[ -f "$values_file" ]]; then
    while IFS= read -r entry; do
      [[ -z "$entry" ]] && continue
      path=$(echo "$entry" | jq -r '.path')
      value=$(echo "$entry" | jq -r '.value')

      parsed=$(parse_image_string "$value")
      repo=${parsed%|*}
      component=$(extract_component "$repo")

      inferred=$(infer_version_from_component "$component")
      if [[ -z "$inferred" ]]; then
        warn "$chart_dir: unknown image component '$component' at $values_file:$path; leaving as-is"
        continue
      fi
      new_value="${repo}:$(normalize_version "$inferred")"

      update_field "$values_file" "$path" "$new_value" "$chart_dir image"

    done < <(detect_flat_images "$values_file")
  fi
done

echo ""
echo "Update complete"
echo ""
echo "Summary:"
cat "$SUMMARY_FILE"
