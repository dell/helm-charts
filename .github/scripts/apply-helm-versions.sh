# Copyright (c) 2026 Dell Inc., or its subsidiaries. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0

#!/bin/bash

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

# Exact component extraction
# Example:
# quay.io/dell/container-storage-modules/csi-isilon:v2.17.0 → csi-isilon
extract_component() {
  basename "$1"
}

infer_version_from_component() {
  local component=$1 result=""

  case "$component" in
    csi-isilon) echo "${CSI_POWERSCALE:-}" ;;
    csi-powerstore) echo "${CSI_POWERSTORE:-}" ;;
    csi-powermax) echo "${CSI_POWERMAX:-}" ;;
    csi-vxflexos) echo "${CSI_VXFLEXOS:-}" ;;
    csi-unity) echo "${CSI_UNITY:-}" ;;
    cosi) echo "${COSI:-}" ;;

    csm-replication) echo "${CSM_REPLICATION:-}" ;;
    karavi-resiliency) echo "${KARAVI_RESILIENCY:-}" ;;
    csm-authorization) echo "${CSM_AUTHORIZATION:-}" ;;
    csireverseproxy) echo "${CSIREVERSEPROXY:-}" ;;
    karavi-observability) echo "${KARAVI_OBSERVABILITY:-}" ;;

    # Sidecars
    csi-resizer) echo "${CSI_RESIZER:-}" ;;
    csi-provisioner) echo "${CSI_PROVISIONER:-}" ;;
    csi-attacher) echo "${CSI_ATTACHER:-}" ;;
    csi-snapshotter) echo "${CSI_SNAPSHOTTER:-}" ;;
    csi-node-driver-registrar) echo "${CSI_NODE_DRIVER_REGISTRAR:-}" ;;
    csi-external-health-monitor-controller) echo "${CSI_EXTERNAL_HEALTH_MONITOR_CONTROLLER:-}" ;;
    csi-metadata-retriever) echo "${CSI_METADATA_RETRIEVER:-}" ;;

    # Third-party
    opentelemetry-collector) echo "${OPENTELEMETRY_COLLECTOR:-}" ;;
    nginx-unprivileged) echo "${NGINX_UNPRIVILEGED:-}" ;;
    grafana) echo "${GRAFANA:-}" ;;
    prometheus) echo "${PROMETHEUS:-}" ;;
    openpolicyagent-opa) echo "${OPENPOLICYAGENT_OPA:-}" ;;
    redis) echo "${REDIS:-}" ;;

    *) 
      echo "Unknown component: $component"
      exit 1
      ;;
  esac
  
  require_non_empty "$component env var" "$result"
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
  local chart_file=$1 chart_dir=$2

  DEP_COUNT=$(yq e '.dependencies | length' "$chart_file" 2>/dev/null || echo 0)

  for ((i=0; i<DEP_COUNT; i++)); do
    name=$(yq e ".dependencies[$i].name" "$chart_file")

    require_non_empty "dependency name" "$name"

    inferred=$(infer_version_from_component "$name")
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
    while read -r entry; do
      value=$(echo "$entry" | jq -r '.value')

      parsed=$(parse_image_string "$value")
      repo=${parsed%|*}
      component=$(extract_component "$repo")

      chart_version=$(infer_version_from_component "$component")
      break
    done <<< "$(detect_flat_images "$values_file")"
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
  update_dependencies "$chart_file" "$chart_dir"

  # Flat images
  if [[ -f "$values_file" ]]; then
    while read -r entry; do
      path=$(echo "$entry" | jq -r '.path')
      value=$(echo "$entry" | jq -r '.value')

      parsed=$(parse_image_string "$value")
      repo=${parsed%|*}
      component=$(extract_component "$repo")

      inferred=$(infer_version_from_component "$component")
      new_value="${repo}:$(normalize_version "$inferred")"

      update_field "$values_file" "$path" "$new_value" "$chart_dir image"

    done <<< "$(detect_flat_images "$values_file")"
  fi
done

echo ""
echo "Update complete"
echo ""
echo "Summary:"
cat "$SUMMARY_FILE"
