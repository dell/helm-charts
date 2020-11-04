# Workflow
This versioning workflow applies to the Karavi PowerFlex Metrics Helm Chart. This workflow is triggered when there is a new release of [karavi-powerflex-metrics](https://github.com/dell/karavi-powerflex-metrics) or when there is a change made to the Karavi PowerFlex Metrics Helm Chart. When either scenario occurs, a maintainer must release a new helm chart for that associated change. The steps include:
## Create New Version
* Create a branch
* Update the [Chart.yaml](../karavi-powerflex-metrics/Chart.yaml) file with the new version number and also with the app version aligning with the service release number. For example, if the new release number was version 2.0.0, a maintainer must release an updated version  using appVersion: 2.0.0. NOTE that if this workflow is triggered by the changes made in the Karavi PowerFlex Metrics Helm Chart, the appVersion does not change. Moreover, a maintanier can decide on use any version as described in [versioning](../VERSIONING.md) notes. For this illustration, we will assume a maintainer uses: 1.10.0
* Create and merge PR into main branch
* Github action will automatically make a new release given that there is a new chart version. The action packages and publishes an artifact,  making it available for consumption. Given the example above, the GitHub action will produce a release called `karavi-powerflex-metrics-1.10.0`.

## Consume New Release
Given the example above, users can utilize the new release by running the following commands:

```bash
   helm repo add dell https://github.com/dell/helm-charts
   helm install dell/karavi-powerflex-metrics --version "1.10.0" -n karavi-powerflex-metrics

   ```