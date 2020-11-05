# How to Contribute

Become one of the contributors to this project! We thrive to build a welcoming and open
community for anyone who wants to use the project or contribute to it. There are
just a few small guidelines you need to follow. 

# Table of Content:
- [How to Contribute](#how-to-contribute)
- [Table of Content:](#table-of-content)
  - [Introduction](#introduction)
  - [Issues](#issues)
  - [Branching Strategy](#branching-strategy)
  - [Branch Naming Convention](#branch-naming-convention)
  - [Code Reviews](#code-reviews)
  - [Signing your commits](#signing-your-commits)
    - [Signing a commit](#signing-a-commit)

## Introduction

Please contribute! 
Read the below documentation to understand the coding standards and expected practices of this project.

## Issues

We greatly value your feedback! If you have any questions, wish to report a bug, or request a new feature, use our project GitHub Issues page.

We aim to track and document everything related to this repo via the Issues page. The code and documentation are released with no warranties or SLAs and are intended to be supported through a community driven process.

When opening a Bug please include the following information to help with debugging:

1. Version of relevant software: this software, Kubernetes, Dell Storage Platform, Helm, etc.
2. Details of the issue explaining the problem: what, when, where
3. The expected outcome that was not met (if any)
4. Supporting troubleshooting information. __Note: Do not provide private company information that could compromise your company's security.__

An Issue __must__ be created before submitting any pull request. Any pull request that is created should be linked to an Issue.

## Branching Strategy
We are following a scaled trunk branching strategy where short-lived branches are created off of the main branch. When coding is complete, the branch is merged back into main after being approved in a pull request code review.

Steps to create a branch for a bug fix or feature:
1. Fork the repository.
2. Create a branch off of the main branch. The branch name should be descriptive and include the chart name, the bug fix it contains or the release # associated with the version update being made to the chart.
3. Update the chart and commit to your branch.  Note: The chart version must be updated if any change is made to the chart.  See the `Versioning.md` file in the chart you wanted to update.
4. If other code changes have merged into the upstream main branch, perform a rebase of those changes into your branch.
5. Open a pull request between your branch and the upstream main branch.  This will trigger a GitHub action to lint the chart in question.
6. Once your pull request has merged, GitHub actions will take care of creating a chart release, packaging the chart, and making the new version available in the Helm repo.

Release branches will be created from the main branch near the time of a planned release when all features are completed. Only critical bug fixes will be merged into the feature branch at this time. All other bug fixes and features can continue to be merged into the main branch. When a feature branch is stable, the branch will be tagged for release and the release branch will be deleted.

## Branch Naming Convention

|  Branch Type |  Example                          |  Comment                                  |
|--------------|-----------------------------------|-------------------------------------------|
|  main        |  main                             |                                           |
|  Release     |  release-1.0                      |  hotfix: release-1.1 patch: release-1.0.1 |
|  Feature     |  feature-9-olp-support            |  "9" referring to GitHub issue ID         |
|  Bug Fix     |  bugfix-110-remove-docker-compose |  "110" referring to GitHub issue ID       |

## Code Reviews

All submissions, including submissions by project members, require review. We
use GitHub pull requests for this purpose. Consult
[GitHub Help](https://help.github.com/articles/about-pull-requests/) for more
information on using pull requests.

## Signing your commits

We require that developers sign off their commits to certify that they have permission to contribute the code in a pull request. This way of certifying is commonly known as the [Developer Certificate of Origin (DCO)](https://developercertificate.org/). We encourage all contributors to read the DCO text before signing a commit and making contributions.

GitHub will prevent a pull request from being merged if there are any unsigned commits.

### Signing a commit

GPG (GNU Privacy Guard) will be used to sign commits.  Follow the instructions [here](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/signing-commits) to create a GPG key and configure your GitHub account to use that key.

Make sure you have your user name and e-mail set.  This will be required for your signed commit to be properly verified.  Check the following references:

* Setting up your github user name [reference](https://help.github.com/articles/setting-your-username-in-git/)
* Setting up your e-mail address [reference](https://help.github.com/articles/setting-your-commit-email-address-in-git/)

Once Git and your GitHub account have been properly configured, you can add the -S flag to the git commits:
```console
$ git commit -S -m your commit message
# Creates a signed commit
```

