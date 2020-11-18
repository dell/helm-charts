<!--
Copyright (c) 2020 Dell Inc., or its subsidiaries. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0
-->

# Dell Community Kubernetes Helm Chart for Karavi Observability

Karavi Observability can be deployed using Helm.

# Installing the Chart

<<<<<<< HEAD:charts/karavi-observability/README.md
=======
#### Installing the Chart
The Karavi chart contains dependencies on the following charts which will be deployed during installation. Read the documentation for these helm charts to make sure the correct certificates have been created or an error may occur during deployment.

- [karavi-topology](../karavi-topology/README.md)
- [karavi-powerflex-metrics](../karavi-powerflex-metrics/README.md)

>>>>>>> main:charts/karavi/README.md
To install the helm chart:

```console
$ helm repo add dell github.com/dell/helm-charts
<<<<<<< HEAD:charts/karavi-observability/README.md
$ helm install dell/karavi-observability -n karavi --create-namespace --render-subchart-notes
```

After installation, the following deployments will be in Kubernetes:

- [karavi-topology](../karavi-topology/README.md)
- [karavi-metrics-powerflex](../karavi-metrics-powerflex/README.md)

# Offline Chart Installation

To install the helm chart in an environment that does not have an internet connection, follow the instructions for the [Offline Karavi Observability Helm Chart Installer](./installer/README.md). When creating the offline bundle, use `dell/karavi-observability` as the chart name.
=======
$ helm install dell/karavi -n karavi --create-namespace --render-subchart-notes --set-file karavi-topology.certificateFile=<path-to-certificate-file> (other --set-file parameters as documented in the dependency helm charts)
```
>>>>>>> main:charts/karavi/README.md

# Uninstalling the Chart

To uninstall/delete the deployment:

```console
$ helm delete karavi-observability --namespace karavi
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

# Configuration

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `karavi-topology.enabled`                 | Enable deployment of Karavi Topology                        | `true`                                                  |
<<<<<<< HEAD:charts/karavi-observability/README.md
| `karavi-topology.certificateFile`         | Location of the signed certificate file    |  |
| `karavi-topology.privateKeyFile`          | Location of the signed certificate private key file |  |
| `karavi-powerflex-metrics.enabled`                 | Enable deployment of Karavi Metrics for PowerFlex      | `true`                                                  |
=======
| `karavi-topology.certificateFile`      | Required valid public certificate file that will be used to deploy the Topology service. Must use domain name 'karavi-topology'.            | ` `                                                   |
| `karavi-topology.privateKeyFile`      | Required public certificate's associated private key file that will be used to deploy the Topology service. Must use domain name 'karavi-topology'.            | ` `|

| `karavi-powerflex-metrics.enabled`                 | Enable deployment of Karavi PowerFlex Metrics      | `true`                                                  |
>>>>>>> main:charts/karavi/README.md
| `karavi-powerflex-metrics.powerflex_endpoint`      | PowerFlex Gateway URL            | ` `                                                   |
| `karavi-powerflex-metrics.powerflex_user`                      | PowerFlex Gateway administrator username (in base64)                           | ` `                           |
| `karavi-powerflex-metrics.otelCollector.certificateFile`      | Required valid public certificate file that will be used to deploy the OpenTelemetry Collector. Must use domain name 'otel-collector'.            | ` `                                                   |
| `karavi-powerflex-metrics.otelCollector.privateKeyFile`      | Required public certificate's associated private key file that will be used to deploy the OpenTelemetry Collector. Must use domain name 'otel-collector'.            | ` `|

Other parameters from the subcharts can be overridden during installation of the Karavi Observability helm chart:

- [karavi-topology](../karavi-topology/README.md)
- [karavi-metrics-powerflex](../karavi-metrics-powerflex/README.md)

## Supported Kubernetes Versions

This chart repository supports the latest and previous minor versions of Kubernetes. For example, if the latest minor release of Kubernetes is 1.8 then 1.7 and 1.8 are supported. Charts may still work on previous versions of Kubernetes even though they are outside the target supported window.

To provide that support the API versions of objects should be those that work for both the latest minor release and the previous one.

<<<<<<< HEAD:charts/karavi-observability/README.md
## Karavi Observability Helm Chart Versioning Workflow

See the Karavi Observability Helm chart [versioning workflow](./VERSIONING_WORKFLOW.md).
=======
## Karavi Helm Chart Versioning Workflow
See the Karavi Helm chart [versioning workflow](./VERSIONING_WORKFLOW.md)
>>>>>>> main:charts/karavi/README.md
