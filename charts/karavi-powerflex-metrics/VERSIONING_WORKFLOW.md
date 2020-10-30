# Workflow
This versioning workflow applies to Karavi Helm Charts. This workflow is triggered either when there is either a new release in karavi service in DockerHub or when there is an internal bug fix in any of the child services that Karavi depends on. When either scenario occurs, a maintainer needs to release a new helm chart for that associated change. The steps include:
## Create New Version
* Create A PR
* Update the Chart.yaml file with the new version number and also with the app version aligning with the service release number. For example, if the new release number  was version 2.0.0, a maintainer can decide to release an updated version using version: 1.10.0  and appVersion: 2.0.0. NOTE: if the change is due to bug fix, the appVersion does not change.
* Merge PR into main branch
* Github action will automatically make a new release given that there is a new chart version. The action packages and publishes an artifact,  making it available for consumption. This artifact will be `karavi-powerflex-metrics-1.10.0`.

## Update Associated Helm Chart

* Ensure the associated helm chart version aligns with the new release 

## New Release of Parent Karavi-powerflex-metrics helm chart
Update the main chat so that the dependency on any service is going to change to be the latest one.
* Create A PR
* Ensure that the dependency on the `karavi-powerflex-metrics-1.10.0.tgz` file will become the new release.
* Update the main Karavi-powerflex-metrics helm chat to `1.10.0`
* Merge PR into main branch

## Consume New Release
Maintainers can use the new release by running the following commands:

```bash
   helm repo add dell https://github.com/dell/helm-charts
   helm install dell/karavi-powerflex-metrics –-version “1.10.0” –n karavi-powerflex-metrics

   ```