# Copyright (c) 2026 Dell Inc., or its subsidiaries. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0

#!/bin/bash

set -euo pipefail

trap 'echo "ERROR: ${BASH_SOURCE[0]} failed at line ${LINENO}: ${BASH_COMMAND}" >&2' ERR

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

  if [[ "$old_clean" != "$new_clean" ]]; then
    echo "$name: $old → $new" | tee -a "$SUMMARY_FILE"
  fi
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
  basename -- "$1"
}

infer_version_from_component() {
  local component=$1 result="" known=true

  case "$component" in
    csi-isilon) result="${CSI_POWERSCALE:-}" ;;
    csi-lightningfs) result="${CSI_LIGHTNINGFS:-}" ;;
    csi-powerstore) result="${CSI_POWERSTORE:-}" ;;
    csi-powermax) result="${CSI_POWERMAX:-}" ;;
    csi-vxflexos) result="${CSI_VXFLEXOS:-}" ;;
    csi-unity) result="${CSI_UNITY:-}" ;;
    cosi) result="${COSI:-}" ;;

    csm-replication) result="${CSM_REPLICATION:-}" ;;
    dell-replication-controller) result="${CSM_REPLICATION:-}" ;;
    dell-csi-replicator) result="${CSM_REPLICATION:-}" ;;
    karavi-resiliency) result="${KARAVI_RESILIENCY:-}" ;;
    podmon) result="${KARAVI_RESILIENCY:-}" ;;
    csm-authorization) result="${CSM_AUTHORIZATION:-}" ;;
    csm-authorization-sidecar)    result="${CSM_AUTHORIZATION:-}" ;;
    csm-authorization-proxy)      result="${CSM_AUTHORIZATION:-}" ;;
    csm-authorization-tenant)     result="${CSM_AUTHORIZATION:-}" ;;
    csm-authorization-role)       result="${CSM_AUTHORIZATION:-}" ;;
    csm-authorization-storage)    result="${CSM_AUTHORIZATION:-}" ;;
    csm-authorization-controller) result="${CSM_AUTHORIZATION:-}" ;;
    csireverseproxy) result="${CSIREVERSEPROXY:-}" ;;
    csipowermax-reverseproxy) result="${CSIREVERSEPROXY:-}" ;;
    karavi-observability) result="${KARAVI_OBSERVABILITY:-}" ;;
    karavi-metrics-powerflex) result="${KARAVI_METRICS_POWERFLEX:-}" ;;
    csm-metrics-powerflex) result="${KARAVI_METRICS_POWERFLEX:-}" ;;
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
    opa) result="${OPENPOLICYAGENT_OPA:-}" ;;
    openpolicyagent-opa) result="${OPENPOLICYAGENT_OPA:-}" ;;
    kube-mgmt) result="${OPENPOLICYAGENT_KUBE_MGMT:-}" ;;
    openpolicyagent-kube-mgmt) result="${OPENPOLICYAGENT_KUBE_MGMT:-}" ;;
    redis) result="${REDIS:-}" ;;

    *)
      known=false
      ;;
  esac

  if [[ "$known" == true ]] && [[ -z "$result" ]]; then
    echo "ERROR: Missing required env var for known component '$component'" >&2
    exit 1
  fi

  echo "$result"
}

# Map chart directory name to its version env var
infer_chart_version_from_name() {
  local name=$1 result=""
  case "$name" in
    cosi)                  result="${COSI:-}" ;;
    csi-isilon)            result="${CSI_POWERSCALE:-}" ;;
    csi-lightningfs)       result="${CSI_LIGHTNINGFS:-}" ;;
    csi-powerstore)        result="${CSI_POWERSTORE:-}" ;;
    csi-powermax)          result="${CSI_POWERMAX:-}" ;;
    csi-vxflexos)          result="${CSI_VXFLEXOS:-}" ;;
    csi-unity)             result="${CSI_UNITY:-}" ;;
    csm-authorization*)    result="${CSM_AUTHORIZATION:-}" ;;
    csm-disaster-recovery) result="${CSM_VERSION:-}" ;;
    csm-replication)       result="${CSM_REPLICATION:-}" ;;
    karavi-observability)  result="${KARAVI_OBSERVABILITY:-}" ;;
  esac
  echo "$result"
}

# Detect images
detect_flat_images() {
  local file=$1
  yq e -o=json '.' "$file" 2>/dev/null \
    | jq -c 'paths(strings) as $p | select(getpath($p) | (test("^[a-zA-Z0-9][^[:space:]]*:[^[:space:]]+$") and (test("://") | not))) | {path: ($p | map(tostring) | join(".")), value: getpath($p)}'
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

  local tmp
  tmp=$(mktemp)
  yq e ".$path = \"$value\"" "$file" > "$tmp" || {
    echo "Failed update: $path"
    rm -f "$tmp"
    exit 1
  }
  mv "$tmp" "$file"

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

  # ---- Primary: infer from chart name
  chart_name=$(basename "$chart_dir")
  raw=$(infer_chart_version_from_name "$chart_name")
  [[ -n "$raw" ]] && chart_version=$(normalize_version "$raw")

  # ---- Fallback: existing version from Chart.yaml (keeps unknown charts stable)
  if [[ -z "$chart_version" ]]; then
    raw=$(detect_chart_version "$chart_file")
    if [[ -n "$raw" ]]; then
      chart_version=$(strip_v "$raw")
      warn "$chart_dir: no version mapping for chart '$chart_name'; keeping existing version $chart_version"
    fi
  fi

  require_non_empty "chart version ($chart_dir)" "$chart_version"

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
