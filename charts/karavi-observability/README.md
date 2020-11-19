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

The Karavi Observability chart contains dependencies on the following charts which will be deployed during installation. Read the documentation for these helm charts to make sure the correct certificates have been created or an error may occur during deployment.

- [karavi-topology](../karavi-topology/README.md)
- [karavi-metrics-powerflex](../karavi-metrics-powerflex/README.md)

To install the helm chart:

```console
$ helm repo add dell github.com/dell/helm-charts
$ helm install dell/karavi-observability -n karavi --create-namespace --render-subchart-notes --set-file karavi-topology.certificateFile=<path-to-certificate-file> (other --set-file parameters as documented in the dependency helm charts)
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
| `karavi-topology.enabled`                 | Enable deployment of Karavi Topology                        | `true`                                                  |
| `karavi-topology.certificateFile`      | Required valid public certificate file that will be used to deploy the Topology service. Must use domain name 'karavi-topology'.            | ` `                                                   |
| `karavi-topology.privateKeyFile`      | Required public certificate's associated private key file that will be used to deploy the Topology service. Must use domain name 'karavi-topology'.            | ` `|
| `karavi-metrics-powerflex.enabled`                 | Enable deployment of Karavi PowerFlex Metrics      | `true`                                                  |
| `karavi-metrics-powerflex.powerflex_endpoint`      | PowerFlex Gateway URL            | ` `                                                   |
| `karavi-metrics-powerflex.powerflex_user`                      | PowerFlex Gateway administrator username (in base64)                           | ` `                           |
| `karavi-metrics-powerflex.otelCollector.certificateFile`      | Required valid public certificate file that will be used to deploy the OpenTelemetry Collector. Must use domain name 'otel-collector'.            | ` `                                                   |
| `karavi-metrics-powerflex.otelCollector.privateKeyFile`      | Required public certificate's associated private key file that will be used to deploy the OpenTelemetry Collector. Must use domain name 'otel-collector'.            | ` `|

Other parameters from the subcharts can be overridden during installation of the Karavi Observability helm chart:

- [karavi-topology](../karavi-topology/README.md)
- [karavi-metrics-powerflex](../karavi-metrics-powerflex/README.md)

## Supported Kubernetes Versions

This chart repository supports the latest and previous minor versions of Kubernetes. For example, if the latest minor release of Kubernetes is 1.8 then 1.7 and 1.8 are supported. Charts may still work on previous versions of Kubernetes even though they are outside the target supported window.

To provide that support the API versions of objects should be those that work for both the latest minor release and the previous one.

## Helm Chart Versioning

See the Helm chart [versioning workflow](./VERSIONING_WORKFLOW.md).
