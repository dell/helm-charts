<!--
Copyright (c) 2022-2026 Dell Inc., or its subsidiaries. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0
-->

# Container Storage Modules (CSM) for Authorization Dell Community Helm Chart

CSM for Authorization V2 can be deployed using Helm.

For complete deployment instructions, refer to the [Container Storage Modules documentation](https://dell.github.io/csm-docs/docs/authorization/deployment/helm).

## IPv4 and IPv6 installation

Set the NGINX Gateway Fabric and Redis Commander IP-family values to the same
value. The Redis value enables the IPv6 DNS initialization workaround used by
the Operator installation for `ipv6` and `dual` deployments.

```bash
helm upgrade --install csm-authorization dell/csm-authorization \
  --namespace csm-authorization --create-namespace \
  --set nginx-gateway-fabric.nginx.config.ipFamily=ipv6 \
  --set redis.ipFamily=ipv6
```

Use `ipv4` instead of `ipv6` for an IPv4-only cluster. The chart supports
`dual` for the NGINX and Redis Commander configuration, although the chart's
standard single-family installation should be used for IPv4-only or IPv6-only
clusters.

## Helm Chart Versioning

For an explanation and examples on versioning/releasing the CSM for Authorization Helm chart, please see the [contributing guide](../../docs/CONTRIBUTING.md#helm-chart-release-strategy).

## Authentication upgrade order

This release enables admin JWT authentication for service-to-service gRPC calls to the storage-service. During a rolling upgrade, older proxy-server and controller instances may send tenant-only tokens or admin tokens without the `admin` role, which the updated services reject.

To avoid mixed-version authentication failures, upgrade the components in this order and wait for each deployment to become ready before continuing:

1. `proxy-server`
2. `controller`
3. `role-service`
4. `storage-service`

Keep all components on the same release while the rollout is in progress. Do not scale down the old version before the replacement component is ready. If the release is managed by the operator, apply the corresponding operator/release configuration update together with this chart upgrade so image versions remain aligned.

After the upgrade, regenerate admin tokens with `GenerateAdminToken`; refreshing an admin token created before this change does not add the new `admin` role claim.
