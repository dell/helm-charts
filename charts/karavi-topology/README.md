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
To install the helm chart:
```console
$ helm repo add dell github.com/dell/helm-charts
$ helm install karavi-topology -n karavi --create-namespace
```
After installation, there will be a deployment of the karavi-topology service in Kubernetes.

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

## Supported Kubernetes Versions

This chart repository supports the latest and previous minor versions of Kubernetes. For example, if the latest minor release of Kubernetes is 1.8 then 1.7 and 1.8 are supported. Charts may still work on previous versions of Kubernertes even though they are outside the target supported window.

To provide that support the API versions of objects should be those that work for both the latest minor release and the previous one.

## Karavi Topology Metrics Helm Chart Versioning Workflow
See the versioning [karavi-topology workflow](../karavi-topology/VERSIONING_WORKFLOW.md)