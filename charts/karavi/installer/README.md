<!--
Copyright (c) 2020 Dell Inc., or its subsidiaries. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0
-->

# Offline Karavi Helm Chart Installer

The following instructions can be followed when a Helm chart will be installed in an environment that does not have an internet connection and will be unable to download the Helm chart and related Docker images.

## Dependencies

Multiple Linux based systems may be required to create and process an offline bundle for use.
* One Linux based system, with internet access, will be used to create the bundle. This involves the user invoking a script that utilizes `docker` to pull and save container images to file.
* One Linux based system, with access to an image registry, to invoke a script that uses `docker` to restore container images from file and push them to a registry

If one Linux system has both internet access and access to an internal registry, that system can be used for both steps.

Preparing an offline bundle requires the following utilities:

| Dependency            | Usage |
| --------------------- | ----- |
| `docker`   | `docker` will be used to pull images from public image registries, tag them, and push them to a private registry.<br>Required on both the system building the offline bundle as well as the system preparing for installation. <br>Tested version is `docker` 18.09+

## Workflow

To perform an offline installation of a helm chart, the following steps should be performed:
1. Build an offline bundle
2. Unpack the offline bundle and prepare for installation
3. Perform a Helm installation

### Build the Offline Bundle
1. Copy the `offline-installer.sh` script to a local Linux system using `curl` or `wget`:
```
[user@anothersystem /home/user]# curl https://raw.githubusercontent.com/dell/helm-charts/main/charts/karavi/installer/offline-installer.sh --output offline-installer.sh
```
or
```
[user@anothersystem /home/user]# wget -O offline-installer.sh https://raw.githubusercontent.com/dell/helm-charts/main/charts/karavi/installer/offline-installer.sh
```

2. Set the file as executable.
```
[user@anothersystem /home/user]# chmod +x offline-installer.sh
```

3. Build the bundle by providing the Helm chart name as the argument:
```
[user@anothersystem /home/user]# ./offline-installer.sh -c dell/karavi

*
* Adding Helm repository https://github.com/dell/helm-charts


*
* Downloading Helm chart dell/karavi to directory /home/user/offline-karavi-bundle/helm-original


*
* Downloading and saving Docker images

   dellemc/karavi-powerflex-metrics:0.1.0
   dellemc/karavi-topology:0.1.0

*
* Compressing offline-karavi-bundle.tar.gz
```

### Unpack the Offline Bundle

1. Copy the bundle file to another Linux system that has access to the internal Docker registry and that can install the Helm chart. From that Linux system, unpack the bundle.

```
[user@anothersystem /home/user]# tar -xzf offline-karavi-bundle.tar.gz
```

2. Change directory into the new directory created from unpacking the bundle:

```
[user@anothersystem /home/user]# cd offline-karavi-bundle
```

3. Prepare the bundle by providing the internal Docker registry URL.

```
[user@anothersystem /home/user/offline-karavi-bundle]# ./offline-installer.sh -p my-registry:5000

*
* Loading, tagging, and pushing Docker images to registry my-registry:5000/

   dellemc/karavi-powerflex-metrics:0.1.0 -> my-registry:5000/karavi-powerflex-metrics:0.1.0
   dellemc/karavi-topology:0.1.0 -> my-registry:5000/karavi-topology:0.1.0
```

### Perform Helm installation

1. Change directory to `helm` which contains the updated Helm chart directory:
```
[user@anothersystem /home/user/offline-karavi-bundle]# cd helm
```

2. Now that the required images have been made available and the Helm Charts configuration updated with references to the internal registry location, installation can proceed by following the instructions that are documented within the Helm charts repository.

```
[user@anothersystem /home/user/offline-karavi-bundle/helm]# helm install -n install-namespace app-name karavi

NAME: app-name
LAST DEPLOYED: Fri Nov  6 08:48:13 2020
NAMESPACE: install-namespace
STATUS: deployed
REVISION: 1
TEST SUITE: None

```
