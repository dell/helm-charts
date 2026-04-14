# Installation of Dell CSI Driver for Dell LightningFS

## Description
CSI Driver for Dell LightningFS is part of the CSM (Container Storage Modules) suite of Kubernetes storage enablers for Dell products. Helm charts are used to install the CSI driver.

## Prerequisites

- Helm 3.x. If Helm is not installed run `curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash` to install Helm.
- The Dell LightningFS needs to be mounted on all the nodes in the cluster where the driver is deployed. This includes the nodes where the CSI Driver controller pods will be deployed.

## Installation Instructions

1. Add the Dell Helm Charts repository.
   ```bash
   helm repo add dell https://dell.github.io/helm-charts
   ```
2. Create a namespace for the driver or ensure that you have created a namespace where you want to install the driver. "csi-lightningfs" is just an example. You can choose any name for the namespace. Make sure to align to the same namespace during the whole installation.
   ```bash
   kubectl create namespace csi-lightningfs
   ```
3. Download and customize the values file.
   ```bash
   wget -O my-values.yaml https://raw.githubusercontent.com/dell/helm-charts/main/charts/csi-lightningfs/values.yaml
   ```
4. Edit the my-values.yaml to customize the parameters for your installation, if desired. The values.yaml file provides detailed description on all the parameters. Please take note of the below specifically:
    - `controllerCount`: Defines the number of controller pods to run. The default value is set to 1, but can be changed to any desired number.
    - `clientMountPoint`: The mount point where the Dell LightningFS is mounted on the nodes. By default, the value is set to /mnt/data. But ensure that clientMountPoint matches the actual location of where the Dell LightningFS is mounted on the nodes.
    - `volumeNamePrefix`: The prefix used for all the volumes created by the CSI driver. The default value is set to csilng, but you can change it to any value.
5. Use `helm` to install the CSI driver.
   ```bash
   helm install csi-lightningfs dell/csi-lightningfs --namespace csi-lightningfs -f my-values.yaml
   ```
6. Check the status of the driver. All pods should be in a "Running" state.
   ```bash
   kubectl get pods -n csi-lightningfs
   ```

## Uninstallation Instructions

1. Uninstall the CSI driver by running the following command:
   ```bash
   helm uninstall csi-lightningfs -n csi-lightningfs
   ```
2. Verify the driver was successfully uninstalled.
    ```bash
   kubectl get pods -n csi-lightningfs
    ```

## Provisioning

1. Create a storage class using the template provided (lightningfs.yaml) under `samples/storageclass` folder.
2. Note the following attributes in the storage class yaml file:
    - `pfs`: The name of the folder to be created by the CSI driver under the `clientMountPoint` (specified in my-values.yaml above). Default is "PFS".
    - `volumePathPermission`: The permission for the volume path. Default is 0750, but can be changed to desired value.
    - `volumeBindingMode`: The volume binding mode. One of "WaitForFirstConsumer" or "Immediate". Default is "Immediate".
3. Run the following command to create the storage class:
    ```bash
      kubectl apply -f samples/storageclass/lightningfs.yaml
    ```
4. Storage class is now ready to be used when provisioning volumes.

## License

This software contains the intellectual property of Dell Inc. or is licensed to Dell Inc. from third parties. Use of this software and the intellectual property contained therein is expressly limited to the terms and conditions of the License Agreement under which it is provided by or on behalf of Dell Inc. or its subsidiaries.

Copyright © 2026 Dell Inc. or its subsidiaries. All Rights Reserved.
