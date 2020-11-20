<!--
Copyright (c) 2020 Dell Inc., or its subsidiaries. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0
-->

# Versioning Workflow

This workflow is triggered either when there is a change to the helm chart or when there is a new release of any of the child charts. When either scenario occurs, a maintainer must release a new helm chart for that associated change. The steps include:

1) [Create a branch](../../CONTRIBUTING.md).
2) Update the [Chart.yaml](./Chart.yaml) file, depending on the scenario that triggered this workflow. These scenarios include:

   - **Change to the Helm Chart:**
   If any changes are made in Karavi Observability Helm chart, for instance when the [values.yaml](./values.yaml) file is modified, the chart version number must also be incremented. For instance, consider the current Chart.yaml below:

   ```yaml
      apiVersion: v2
      name: karavi-observability
      description: A Helm chart for Kubernetes
      type: application
      version: 0.1.0
      dependencies:
      - name: karavi-topology
        version: "0.1.0"
        repository: "file://../karavi-topology"
        condition: karavi-topology.enabled
      - name: karavi-metrics-powerflex
        version: "0.1.0"
        repository: "file://../karavi-metrics-powerflex"
        condition: karavi-metrics-powerflex.enabled
   ```

   Depending on the nature of the modifications as defined by [semantic versioning](http://semver.org), for example if they meet the requirements for a minor release, the new version of the Helm chart is incremented to `0.2.0`; the Chart.yaml becomes:
  
   ```yaml
      apiVersion: v2
      name: karavi-observability
      description: A Helm chart for Kubernetes
      type: application
      version: 0.2.0 # version updates to 0.2.0 
      dependencies:
      - name: karavi-topology
        version: "0.1.0"
        repository: "file://../karavi-topology"
        condition: karavi-topology.enabled
      - name: karavi-metrics-powerflex
        version: "1.1.0"
        repository: "file://../karavi-metrics-powerflex"
        condition: karavi-metrics-powerflex.enabled
   ```

   - **New Release of any of the child helm Charts:**
    When there is a new release of any of the dependency charts, the dependency version must be updated and the chart version must be incremented. Consider the case where karavi-metrics-powerflex `1.2.0` is released. Before any update, the `Chart.yaml` may look like this:

     ```yaml
      apiVersion: v2
      name: karavi-observability
      description: A Helm chart for Kubernetes
      type: application
      version: 0.1.0
      dependencies:
      - name: karavi-topology
        version: "0.1.0"
        repository: "file://../karavi-topology"
        condition: karavi-topology.enabled
      - name: karavi-metrics-powerflex
        version: "1.1.0"
        repository: "file://../karavi-metrics-powerflex"
        condition: karavi-metrics-powerflex.enabled
     ```

     Since `karavi-metrics-powerflex-1.2.0` is a minor release, the updated `Chart.yaml` would look like this:

     ```yaml
      apiVersion: v2
      name: karavi-observability
      description: A Helm chart for Kubernetes
      type: application
      version: 0.2.0 # version updates to 0.2.0(used a minor release change for this illustration)
      dependencies:
      - name: karavi-topology
        version: "0.1.0"
        repository: "file://../karavi-topology"
        condition: karavi-topology.enabled
      - name: karavi-metrics-powerflex
        version: "1.2.0" # version updates to 1.2.0
        repository: "file://../karavi-metrics-powerflex"
        condition: karavi-metrics-powerflex.enabled
     ```

3) Create and merge PR into main branch.
4) Github action will automatically make a new release given that there is a new chart version. The action packages and publishes an artifact, making it available for consumption. Given the example above, in either scenario, the GitHub action will produce a release called `karavi-observability-0.2.0`.

## Consume New Release

- Given the example above, users can utilize the new release by running the following commands:

 ```bash
   helm repo add dell https://dell.github.io/helm-charts
   helm install karavi-observability --version "0.2.0" -n karavi --create-namespace --render-subchart-notes
 ```
