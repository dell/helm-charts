<!--
Copyright (c) 2020 Dell Inc., or its subsidiaries. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0
-->

# Dell Community Helm Chart for Karavi Observability

Karavi Observability can be deployed using Helm.

# Installing the Chart

To install the helm chart:

```console
$ helm repo add dell https://dell.github.io/helm-charts
$ helm install karavi-observability dell/karavi-observability -n karavi --create-namespace \
    --set-file karaviTopology.certificateFile=<location-of-karavi-topology-certificate-file> \
    --set-file karaviTopology.privateKeyFile=<location-of-karavi-topology-private-key-file> \
    --set-file otelCollector.certificateFile=<location-of-otel-collector-certificate-file> \
    --set-file otelCollector.privateKeyFile=<location-of-otel-collector-private-key-file> \
    --set karaviMetricsPowerflex.powerflexPassword=<base64-encoded-password> \
    --set karaviMetricsPowerflex.powerflexUser=<base64-encoded-username> \
    --set karaviMetricsPowerflex.powerflexEndpoint=https://<powerflex-endpoint>
```

# Uninstalling the Chart

To uninstall/delete the deployment:

```console
$ helm delete karavi-observability --namespace karavi
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

# Configuration

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `karaviTopology.image`                   | Location of the karavi-topology Docker image                                                                                                        | `dellemc/karavi-topology:0.1.0-pre-release`|
| `karaviTopology.provisionerNames`       | Provisioner Names used to filter the Persistent Volumes created on the Kubernetes cluster (must be a comma-separated list)    | ` csi-vxflexos.dellemc.com`                                                   |
| `karaviTopology.service.type`            | Kubernetes service type	    | `ClusterIP`                                                   |
| `karaviTopology.certificateFile`      | Required valid public certificate file that will be used to deploy the Topology service. Must use domain name 'karavi-topology'.            | ` `                                                   |
| `karaviTopology.privateKeyFile`      | Required public certificate's associated private key file that will be used to deploy the Topology service. Must use domain name 'karavi-topology'.            | ` `|
| `otelCollector.certificateFile`      | Required valid public certificate file that will be used to deploy the OpenTelemetry Collector. Must use domain name 'otel-collector'.            | ` `                                                   |
| `otelCollector.privateKeyFile`      | Required public certificate's associated private key file that will be used to deploy the OpenTelemetry Collector. Must use domain name 'otel-collector'.            | ` `|                                                   
| `karaviMetricsPowerflex.powerflexEndpoint`      | PowerFlex Gateway URL            | ` `                                                   |
| `karaviMetricsPowerflex.powerflexUser`                      | PowerFlex Gateway administrator username(in base64)                           | ` `                           |
| `karaviMetricsPowerflex.powerflexPassword`                           | PowerFlex Gateway administrator password(in base64)                      | ` ` |
| `karaviMetricsPowerflex.image`                          |  Karavi Metrics for PowerFlex Service image                      | `dellemc/karavi-metrics-powerflex:0.1.0-pre-release`|
| `karaviMetricsPowerflex.collectorAddr`                         | Metrics Collector accessible from the Kubernetes cluster                    | `otel-collector:55680`  |
| `karaviMetricsPowerflex.provisionerNames`                       | Provisioner Names used to filter for determining PowerFlex SDC nodes( Must be a Comma-separated list)          | ` csi-vxflexos.dellemc.com`                                                   |
| `karaviMetricsPowerflex.sdcPollFrequencySeconds`                        | The polling frequency (in seconds) to gather SDC metrics                         | `10`                                       |
| `karaviMetricsPowerflex.volumePollFrequencySeconds`                        | The polling frequency (in seconds) to gather volume metrics | `10`                         |
| `karaviMetricsPowerflex.storageClassPoolPollFrequencySeconds`                        | The polling frequency (in seconds) to gather storage class/pool metrics                         |  `10`                                       |
| `karaviMetricsPowerflex.concurrentPowerflexQueries`                        | The number of simultaneous metrics queries to make to Powerflex(MUST be less than 10; otherwise, several request errors from Powerflex will ensue.)                       |  `10`                                       |
| `karaviMetricsPowerflex.sdcMetricsEnabled`                        | Enable PowerFlex SDC Metrics Collection                         | `true`                                       |
| `karaviMetricsPowerflex.volumeMetricsEnabled`                        | Enable PowerFlex Volume Metrics Collection                         | `true`                                       |
| `karaviMetricsPowerflex.storageClassPoolMetricsEnabled`                        | Enable PowerFlex  Storage Class/Pool Metrics Collection                         | `true`                                       |
| `karaviMetricsPowerflex.endpoint`                        | Endpoint for pod leader election                       | `karavi-metrics-powerflex`                                       |


## Supported Kubernetes Versions

This chart repository supports the latest and previous minor versions of Kubernetes. For example, if the latest minor release of Kubernetes is 1.8 then 1.7 and 1.8 are supported. Charts may still work on previous versions of Kubernetes even though they are outside the target supported window.

To provide that support the API versions of objects should be those that work for both the latest minor release and the previous one.

## Helm Chart Versioning

See the Helm chart [versioning workflow](./VERSIONING_WORKFLOW.md).
