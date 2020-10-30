# Workflow
This versioning workflow applies to Karavi PowerFlex Metrics Helm Chart. This workflow is triggered when there is a new release of [karavi-powerflex-metrics](https://github.com/dell/karavi-powerflex-metrics) or when there is a change made to the Karavi PowerFlex Metrics Helm Chart. When either scenario occurs, a maintainer needs to release a new helm chart for that associated change. The steps include:
## Create New Version
* Create A PR
* Update the Chart.yaml file with the new version number and also with the app version aligning with the service release number. For example, if the new release number  was version 2.0.0, a maintainer must release an updated version using version: 1.10.0  and appVersion: 2.0.0. NOTE: if the change is due to changes in the Karavi PowerFlex Metrics Helm Chart, the appVersion does not change.
* Merge PR into main branch
* Github action will automatically make a new release given that there is a new chart version. The action packages and publishes an artifact,  making it available for consumption. This artifact will be `karavi-powerflex-metrics-1.10.0`.

## Update Karavi PowerFlex Metrics Helm Chart
* Ensure the `karavi-powerflex-metrics` helm chart version aligns with the new release.

## Consume New Release
Maintainers can use the new release by running the following commands:

```bash
   helm repo add dell https://github.com/dell/helm-charts
   helm install dell/karavi-powerflex-metrics –-version “1.10.0” –n karavi-powerflex-metrics

   ```