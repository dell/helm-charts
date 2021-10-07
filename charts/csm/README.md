# Create application yaml files using ytt templates

## Usage

### Helm Package

Can be packaged by using the command below and then shipped
```console
$~ helm package .
Successfully packaged chart and saved it to: /root/external/helm-charts/charts/csm/csm-1.0.0.tgz
```

### Helm Install

From this directory, configure the `values.yaml` and run the command below:

```console
$~ helm template <release-name> . --post-renderer ./csm-ytt-post-renderer --disable-openapi-validation
```
helm template poc-powerflex . --post-renderer ./csm-ytt-post-renderer --disable-openapi-validation --debug
