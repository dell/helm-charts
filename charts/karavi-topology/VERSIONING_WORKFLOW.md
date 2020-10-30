# Workflow
This versioning workflow applies to Karavi Helm Charts. When there is an new release of  a Major release, maintainers can initiate a new releases by following the steps below:
1) A maintainers  request for a [Minor releases](#Minor-releases) or [Patch releases](#Patch-releases) by specifying the project and version.   
2) The release is automatically created. For instance, if in step 1 the projects was `karavi` and version was `1.10.0`, the following artifact will be created:  `karavi-1.10.0`
3) This artifact is added to the GitHub page site and the index.yml is updated. You will see this artifact in the page as:  `karavi-1.10.0.tgz`

This whole process is automated with the steps below:
```bash
   helm repo add dell https://github.com/dell/helm-charts
   helm install dell/karavi –-version “1.10.0” –n karavi

   ```
