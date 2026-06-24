<!--
Copyright (c) 2021-2023 Dell Inc., or its subsidiaries. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0
-->

# Container Storage Modules (CSM) for Observability Dell Community Helm Chart

CSM for Observability can be deployed using Helm.

For complete deployment instructions, refer to the [Container Storage Modules documentation](https://dell.github.io/csm-docs/docs/deployment/helm/modules/installation/observability/).

## Helm Chart Versioning

For an explanation and examples on versioning/releasing the CSM for Observability Helm chart, please see the [contributing guide](../../docs/CONTRIBUTING.md#helm-chart-release-strategy).

## About Helm v4

Helm v4 has some changes that affect how it handles Custom Resource Definitions (CRDs). Specifically, Helm v4 requires CRDs to include version labels to avoid Server-Side Apply (SSA) conflicts. This is because Helm v4 uses SSA by default, which requires all resources to have version labels.

### Cert Manager CRD Requirements for Helm v4

When installing this chart with Helm v4, special consideration is required for cert-manager CRDs:

- **Manual CRD Deletion Required**: This chart does not include an explicit installer to patch cert-manager CRDs for Helm v4. You must manually delete any existing cert-manager CRDs (versions 1.10.0 or 1.11.0) from the cluster before installing with Helm v4 to avoid kubectl-client-side-apply conflicts.

- **Helm v3 Compatibility**: For Helm v3 installations, cert-manager CRDs can remain on the cluster without conflicts. Installing or upgrading with Helm v3 will not throw kubectl-client-side-apply errors even if cert-manager CRDs are present.

- **Helm Version Upgrade**: If your cluster has existing cert-manager CRDs installed with Helm v3 and you upgrade the Helm version to v4, the Observability pods will upgrade without issues. However, new installations with Helm v4 require manual CRD deletion.

- **Readiness Check**: The chart includes a post-install/upgrade hook (`cert-manager-readiness-check`) that waits for cert-manager deployments to become available and for the webhook caBundle to be populated before proceeding with the installation. This ensures cert-manager is fully operational.

- **Cleanup Hook**: A pre-delete hook (`cert-manager-cleanup`) automatically removes cert-manager resources (certificates and issuers) created by this chart during uninstallation to prevent orphaned resources.

**Important**: Before installing with Helm v4 on a fresh cluster, ensure no cert-manager CRDs are present. Delete any existing cert-manager CRDs manually to avoid conflicts during installation.
