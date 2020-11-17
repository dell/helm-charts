<!--
Copyright (c) 2020 Dell Inc., or its subsidiaries. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0
-->
# Versioning Workflow

This versioning workflow applies to the Karavi PowerFlex Metrics Helm Chart. This workflow is triggered when there is a new release of [karavi-powerflex-metrics](https://github.com/dell/karavi-powerflex-metrics) or when there is a change made to the Karavi PowerFlex Metrics Helm Chart. When either scenario occurs, a maintainer must release a new helm chart for that associated change. The steps include:

1) [Create a branch](../../CONTRIBUTING.md).
2) Update the [Chart.yaml](../karavi-powerflex-metrics/Chart.yaml) file, depending on the scenario that triggered this workflow. These scenarios include:
   - **Change to the Karavi PowerFlex Metrics Helm Chart:**
    If any changes are made in Karavi PowerFlex Metrics Helm chart, for instance when the [values.yaml](./values.yaml) file is modified, the Karavi PowerFlex Metrics Helm chart version number must be incremented. For instance, consider the current Chart.yaml below:

    ```yaml
        apiVersion: v1
        appVersion: "1.0"
        description: The open-source solution that provides Kubernetes administrators insight into storage usage and performance for containerized applications using Dell products.
        name: karavi-powerflex-metrics
        version: 0.1.0
     ```

    Depending on the nature of the modifications as defined by [semantic versioning](http://semver.org), for example if they meets the requirements for a minor release, the new version of the Karavi PowerFlex Metrics Helm chart is incremented to `0.2.0`; the Chart.yaml becomes:

     ```yaml
        apiVersion: v1
        appVersion: "1.0"
        description: The open-source solution that provides Kubernetes administrators insight into storage usage and performance for containerized applications using Dell products.
        name: karavi-powerflex-metrics
        version: 0.2.0 # updated to 0.2.0
     ```

   - **New Release of [Karavi Powerflex Metrics](https://github.com/dell/karavi-powerflex-metrics) Service:**
    When there is a new release of Karavi Powerflex Metrics service, the `appVersion` must be updated and the chart version must be incremented. Consider the case where karavi-powerflex-metrics `1.2.0` is released. Before any update, the `Chart.yaml` may look like this:

     ```yaml
        apiVersion: v1
        appVersion: "1.0"
        description: The open-source solution that provides Kubernetes administrators insight into storage usage and performance for containerized applications using Dell products.
        name: karavi-powerflex-metrics
        version: 0.1.0
     ```

    Since `karavi-powerflex-metrics-1.2.0` is a minor release, the updated `Chart.yaml` will look like this:

     ```yaml
        apiVersion: v1
        appVersion: "1.2.0" # updated to 1.2.0 to match the new Karavi Powerflex Metrics service release
        description: The open-source solution that provides Kubernetes administrators insight into storage usage and performance for containerized applications using Dell products.
        name: karavi-powerflex-metrics
        version: 0.2.0 # updated to 0.2.0
     ```

3) Create and merge PR into main branch.
4) Github action will automatically make a new release given that there is a new chart version. The action packages and publishes an artifact,  making it available for consumption. Given the example above, in either scenario, the GitHub action will produce a release called `karavi-powerflex-metrics-0.2.0`.

## Consume New Release

- Given the example above, users can utilize the new release by running the following commands:
  
```bash
   helm repo add dell https://github.com/dell/helm-charts
   helm install karavi-powerflex-metrics --version "0.2.0" -n karavi --create-namespace
```
