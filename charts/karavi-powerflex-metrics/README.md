<!--
Copyright (c) 2020 Dell Inc., or its subsidiaries. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0
-->


## Dell Community Kubernetes Helm Charts for Karavi Powerflex Metrics

Karavi Powerflex Metrics can be deployed using Helm.  The chart must be configured to point to the PowerFlex system you wish to observe.

#### TL;DR;
#### Installing the Chart
To install the helm chart:
```console
$ helm repo add dell github.com/dell/helm-charts
$ helm install dell/karavi-powerflex-metrics --namespace karavi --create-namespace
```
After installation, there will be a Deployment of a PowerFlex Metrics service in Kubernetes.
The PowerFlex Metrics service will automatically start to gather PowerFlex metrics and push them to the OpenTelemetry collector.

#### Offline Chart Installation
To install the helm chart in an environment that does not have an internet connection, follow the instructions for the [Offline Karavi Helm Chart Installer](../karavi/installer/README.md). When creating the offline bundle, use `dell/karavi-powerflex-metrics` as the chart name.

#### Uninstalling the Chart
To uninstall/delete the deployment:
```console
$ helm delete karavi-powerflex-metrics --namespace karavi
```
The command removes all the Kubernetes components associated with the chart and deletes the release.

#### Configuration

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `otelCollector.cert_file`      | Required path to a valid public certificate file that will be used to deploy the OpenTelemetry Collector            | ` `                                                   |
| `otelCollector.key_file`      | Required path to the public certificate's associated private key file that will be used to deploy the OpenTelemetry Collector            | ` `|                                                   
| `powerflex_endpoint`      | PowerFlex Gateway URL            | ` `                                                   |
| `powerflex_user`                      | PowerFlex Gateway administrator username(in base64)                           | ` `                           |
| `powerflex_password`                           | PowerFlex Gateway administrator password(in base64)                      | ` ` |
| `image`                          |  PowerFlex Metrics Service image                      | `<docker-registry>:<port>/karavi-powerflex-metrics:latest`|
| `collector_addr`                         | Metrics Collector accessible from the Kubernetes cluster                    | `otel-collector:55680`  |
| `provisioner_names`                       | Provisioner Names used to filter for determining PowerFlex SDC nodes( Must be a Comma-separated list)          | ` csi-vxflexos.dellemc.com`                                                   |
| `sdc_poll_frequency_seconds`                        | The polling frequency (in seconds) to gather SDC metrics                         | `10`                                       |
| `volume_poll_frequency_seconds`                        | The polling frequency (in seconds) to gather volume metrics | `10`                         |
| `storage_class_pool_poll_frequency_seconds`                        | The polling frequency (in seconds) to gather storage class/pool metrics                         |  `10`                                       |
| `concurrent_powerflex_queries`                        | The number of simultaneous metrics queries to make to Powerflex(MUST be less than 10; otherwise, several request errors from Powerflex will ensue.)                       |  `10`                                       |
| `sdc_metrics_enabled`                        | Enable PowerFlex SDC Metrics Collection                         | `true`                                       |
| `volume_metrics_enabled`                        | Enable PowerFlex Volume Metrics Collection                         | `true`                                       |
| `storage_class_pool_metrics_enabled`                        | Enable PowerFlex  Storage Class/Pool Metrics Collection                         | `true`                                       |
| `endpoint`                        | Endpoint for pod leader election                       | `karavi-powerflex-metrics`                                       |

## Supported Kubernetes Versions

This chart repository supports the latest and previous minor versions of Kubernetes. For example, if the latest minor release of Kubernetes is 1.8 then 1.7 and 1.8 are supported. Charts may still work on previous versions of Kubernertes even though they are outside the target supported window.

To provide that support the API versions of objects should be those that work for both the latest minor release and the previous one.

## Karavi PowerFlex Metrics Helm Chart Versioning
See the Karavi PowerFlex Metrics Helm chart [versioning workflow](./VERSIONING_WORKFLOW.md)