<!--
Copyright (c) 2020 Dell Inc., or its subsidiaries. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0
-->
## Dell Community Kubernetes Helm Chart for Karavi Topology

Karavi Topology can be deployed using Helm.

#### Installing the Chart
To install the helm chart, a signed certificate file and associated private key file must be passed to the `helm install` command. The domain name used for the certificate file must be 'karavi-topology'.

```console
$ helm repo add dell github.com/dell/helm-charts
$ helm install dell/karavi-topology -n karavi --create-namespace --set-file certificateFile=<path-to-certificate-file> --set-file privateKeyFile=<path-to-private-key-file>
```
After installation, there will be a deployment of the karavi-topology service in Kubernetes.

#### Offline Chart Installation
To install the helm chart in an environment that does not have an internet connection, follow the instructions for the [Offline Karavi Helm Chart Installer](../karavi/installer/README.md).  When creating the offline bundle, use `dell/karavi-topology` as the chart name.

#### Uninstalling the Chart
To uninstall/delete the deployment:
```console
$ helm delete karavi-topology --namespace karavi 
```
The command removes all the Kubernetes components associated with the chart and deletes the release.

#### Configuration

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `image`                   | Location of the karavi-topology Docker image                                                                                                        | `<docker-registry>:<port>/karavi-topology:latest`|
| `provisioner_names`       | Provisioner Names used to filter the Persistent Volumes created on the Kubernetes cluster (must be a comma-separated list)    | ` csi-vxflexos.dellemc.com`                                                   |
| `service.type`            | Kubernetes service type	    | `ClusterIP`                                                   |
| `certificateFile`      | Required valid public certificate file that will be used to deploy the Topology service. Must use domain name 'karavi-topology'.            | ` `                                                   |
| `privateKeyFile`      | Required public certificate's associated private key file that will be used to deploy the Topology service. Must use domain name 'karavi-topology'.            | ` `|

## Supported Kubernetes Versions

This chart repository supports the latest and previous minor versions of Kubernetes. For example, if the latest minor release of Kubernetes is 1.8 then 1.7 and 1.8 are supported. Charts may still work on previous versions of Kubernertes even though they are outside the target supported window.

To provide that support the API versions of objects should be those that work for both the latest minor release and the previous one.

## Karavi Topology Helm Chart Versioning
See the Karavi Topology helm chart [versioning workflow](./VERSIONING_WORKFLOW.md)
