<!--
Copyright (c) 2020 Dell Inc., or its subsidiaries. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0
-->
# Versioning Workflow

This versioning workflow applies to the Karavi Helm chart. This workflow is triggered either when there is a change to the Karavi Helm chart or when there is a new release of any of the child Karavi Helm charts. When either scenario occurs, a maintainer must release a new helm chart for that associated change. The steps include:

1) [Create a branch](../../CONTRIBUTING.md)
2) Update the [Chart.yaml](../karavi/Chart.yaml) file, depending on the scenario that triggered this workflow. These scenarios include:

   - **Change to the Karavi Helm Chart:**
   If any changes are made in Karavi Helm chart, for instance when the [values.yaml](./values.yaml) file is modified, the Karavi Helm chart version number must be incremented. For instance, consider the current Chart.yaml below: 

   ```yaml
      apiVersion: v2
      name: karavi
      description: A Helm chart for Kubernetes
      type: application
      version: 0.1.0
      dependencies:
      - name: karavi-topology
        version: "0.1.0"
        repository: "file://../karavi-topology"
        condition: karavi-topology.enabled
      - name: karavi-powerflex-metrics
        version: "0.1.0"
        repository: "file://../karavi-powerflex-metrics"
        condition: karavi-powerflex-metrics.enabled
   ```

   Depending on the nature of the modifications as defined by [semantic versioning](http://semver.org), for example if they meet the requirements for a minor release, the new version of the Karavi Helm chart is incremented to `0.2.0`; the Chart.yaml becomes:
  
   ```yaml
      apiVersion: v2
      name: karavi
      description: A Helm chart for Kubernetes
      type: application
      version: 0.2.0 # version updates to 0.2.0 
      dependencies:
      - name: karavi-topology
        version: "0.1.0"
        repository: "file://../karavi-topology"
        condition: karavi-topology.enabled
      - name: karavi-powerflex-metrics
        version: "1.1.0"
        repository: "file://../karavi-powerflex-metrics"
        condition: karavi-powerflex-metrics.enabled
   ```

   - **New Release of any of the child Karavi Helm Chart:**
    When there is a new release of any Karavi Helm chart dependency, the dependency version must be updated and the chart version must be incremented. Consider the case where karavi-powerflex-metrics `1.2.0` is released. Before any update, the `Chart.yaml` may look like this:

     ```yaml
      apiVersion: v2
      name: karavi
      description: A Helm chart for Kubernetes
      type: application
      version: 0.1.0
      dependencies:
      - name: karavi-topology
        version: "0.1.0"
        repository: "file://../karavi-topology"
        condition: karavi-topology.enabled
      - name: karavi-powerflex-metrics
        version: "1.1.0"
        repository: "file://../karavi-powerflex-metrics"
        condition: karavi-powerflex-metrics.enabled
     ```

     Since `karavi-powerflex-metrics-1.2.0` is a minor release, the updated `Chart.yaml` would look like this:

     ```yaml
      apiVersion: v2
      name: karavi
      description: A Helm chart for Kubernetes
      type: application
      version: 0.2.0 # version updates to 0.2.0(used a minor release change for this illustration)
      dependencies:
      - name: karavi-topology
        version: "0.1.0"
        repository: "file://../karavi-topology"
        condition: karavi-topology.enabled
      - name: karavi-powerflex-metrics
        version: "1.2.0" # version updates to 1.2.0
        repository: "file://../karavi-powerflex-metrics"
        condition: karavi-powerflex-metrics.enabled
     ```

3) Create and merge PR into main branch
4) Github action will automatically make a new release given that there is a new chart version. The action packages and publishes an artifact,  making it available for consumption. Given the example above, in either scenario, the GitHub action will produce a release called `karavi-0.2.0`.

## Consume New Release

- Given the example above, users can utilize the new release by running the following commands:

 ```bash
   helm repo add dell https://github.com/dell/helm-charts
   helm install karavi --version "0.2.0" -n karavi --create-namespace --render-subchart-notes
 ```
