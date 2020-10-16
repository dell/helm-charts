<!--
Copyright (c) 2020 Dell Inc., or its subsidiaries. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0
-->


## Dell Community Kubernetes Helm Chart for Karavi

Karavi can be deployed using Helm.

#### Installing the Chart
To install the helm chart:
```console
$ helm repo add dell github.com/dell/helm-charts
$ helm install karavi/karavi -n karavi --create-namespace --render-subchart-notes
```
After installation, the following deployments will be in Kubernetes:
- [karavi-topology](../karavi-topology/README.md)
- [karavi-powerflex-metrics](../karavi-powerflex-metrics/README.md)

#### Uninstalling the Chart
To uninstall/delete the deployment:
```console
$ helm delete karavi --namespace karavi 
```
The command removes all the Kubernetes components associated with the chart and deletes the release.

#### Configuration

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `karavi-topology.enabled`                 | Enable deployment of Karavi Topology                        | `true`                                                  |
| `karavi-powerflex-metrics.enabled`                 | Enable deployment of Karavi PowerFlex Metrics      | `true`                                                  |
| `karavi-powerflex-metrics.powerflex_endpoint`      | PowerFlex Gateway URL            | ` `                                                   |
| `karavi-powerflex-metrics.powerflex_user`                      | PowerFlex Gateway administrator username (in base64)                           | ` `                           |
| `karavi-powerflex-metrics.powerflex_password`                           | PowerFlex Gateway administrator password (in base64)                      | ` ` |

Other parameters from the subcharts can be overridden during installation of the Karavi helm chart:
- [karavi-topology](../karavi-topology/README.md)
- [karavi-powerflex-metrics](../karavi-powerflex-metrics/README.md)
