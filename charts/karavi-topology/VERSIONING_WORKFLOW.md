<!--
Copyright (c) 2020 Dell Inc., or its subsidiaries. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0
-->

# Versioning Workflow

This workflow is triggered when there is a new release of [karavi-topology](https://github.com/dell/karavi-topology) or when there is a change made to the helm chart. When either scenario occurs, a maintainer must release a new Helm chart for that associated change. The steps include:

1) [Create a branch](../../CONTRIBUTING.md).
2) Update the [Chart.yaml](../karavi-topology/Chart.yaml) file, depending on the scenario that triggered this workflow. These scenarios include:

   - **Change to the Helm Chart:**
    If any changes are made in Karavi Topology Helm chart, for instance when the [values.yaml](./values.yaml) file is modified, the Karavi Topology Helm chart version number must be incremented. For instance, consider the current Chart.yaml below:  

    ```yaml
        apiVersion: v1
        appVersion: "1.0"
        description: The open-source solution that provides Kubernetes administrators insight into storage usage and performance for containerized applications using Dell products.
        name: karavi-topology
        version: 0.1.0
     ```

    Depending on the nature of the modifications as defined by [semantic versioning](http://semver.org), for example if they meet the requirements for a minor release, the new version of the Helm chart is incremented to `0.2.0`; the Chart.yaml becomes:

    ```yaml
        apiVersion: v1
        appVersion: "1.0"
        description: The open-source solution that provides Kubernetes administrators insight into storage usage and performance for containerized applications using Dell products.
        name: karavi-topology
        version: 0.2.0 # updated to 0.2.0
     ```

   - **New Release of [Karavi Topology](https://github.com/dell/karavi-topology) Service:**
    When there is a new release of Karavi Topology service, the `appVersion` must be updated and the chart version must be incremented. Consider the case where karavi-topology `1.2.0` is released. Before any update, the `Chart.yaml` may look like this:

    ```yaml
        apiVersion: v1
        appVersion: "1.0"
        description: The open-source solution that provides Kubernetes administrators insight into storage usage and performance for containerized applications using Dell products.
        name: karavi-topology
        version: 0.1.0
     ```

     Since `karavi-topology-1.2.0` is a minor release, the updated `Chart.yaml` will look like this:

    ```yaml
        apiVersion: v1
        appVersion: "1.2.0" # updated to 1.2.0 to match the new Karavi Topology service release
        description: The open-source solution that provides Kubernetes administrators insight into storage usage and performance for containerized applications using Dell products.
        name: karavi-topology
        version: 0.2.0 # updated to 0.2.0(used a minor release change for this illustration)
    ```

3) Create and merge PR into main branch.
4) Github action will automatically make a new release given that there is a new chart version. The action packages and publishes an artifact,  making it available for consumption. Given the example above, in either scenario, the GitHub action will produce a release called `karavi-topology-0.2.0`.

## Consume New Release

- Given the example above, users can utilize the new release by running the following commands:

```bash
   helm repo add dell https://dell.github.io/helm-charts
   helm install karavi-topology --version "0.2.0" -n karavi --create-namespace

```
