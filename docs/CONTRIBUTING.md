<!--
Copyright (c) 2021 Dell Inc., or its subsidiaries. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0
-->

# How to Contribute

Become one of the contributors to this project! We thrive to build a welcoming and open community for anyone who wants to use the project or contribute to it. There are just a few small guidelines you need to follow. To help us create a safe and positive community experience for all, we require all participants to adhere to the [Code of Conduct](docs/CODE_OF_CONDUCT.md).

## Table of Contents

- [How to Contribute](#how-to-contribute)
  - [Table of Contents](#table-of-contents)
  - [Become a contributor](#become-a-contributor)
  - [Report bugs](#report-bugs)
  - [Feature request](#feature-request)
  - [Answering questions](#answering-questions)
  - [Triage issues](#triage-issues)
  - [Your first contribution](#your-first-contribution)
  - [Branching Strategy](#branching-strategy)
    - [Branch Naming Convention](#branch-naming-convention)
    - [Branch Types](#branch-types)
    - [Steps to create a branch for a bug fix or feature](#steps-to-create-a-branch-for-a-bug-fix-or-feature)
  - [Signing your commits](#signing-your-commits)
    - [Signing a commit](#signing-a-commit)
    - [Commit message format](#commit-message-format)
  - [Pull requests](#pull-requests)
  - [Code Reviews](#code-reviews)
  - [Code Quality](#code-quality)
  - [Helm chart release strategy](#helm-chart-release-strategy)

## Become a contributor

You can contribute to Dell Community Kubernetes Helm Charts in several ways. Here are some examples:

- Contribute to the Dell Community Kubernetes Helm Charts codebase.
- Report and triage bugs.
- Feature requests
- Write technical documentation and blog posts, for users and contributors.
- Help others by answering questions about Dell Community Kubernetes Helm Charts.

## Report bugs

We aim to track and document everything related to this repo via the Issues page. The code and documentation are released with no warranties or SLAs and are intended to be supported through a community driven process.

Before submitting a new issue, try to make sure someone hasn't already reported the problem. Look through the [existing issues](https://github.com/dell/helm-charts/issues) for similar issues.

Report a bug by submitting a [bug report](https://github.com/dell/helm-charts/issues/new?labels=type%2Fbug%2C+needs-triage&template=bug_report.md&title=%5BBUG%5D%3A+%5Bchart+name+%28if+applicable%29%5D%3A+bug+title). Make sure that you provide as much information as possible on how to reproduce the bug.

When opening a Bug please include the following information to help with debugging:

1. Version of relevant software: this software, Kubernetes, Dell Storage Platform, Helm, etc.
2. Details of the issue explaining the problem: what, when, where
3. The expected outcome that was not met (if any)
4. Supporting troubleshooting information. **Note: Do not provide private company information that could compromise your company's security.**

An Issue **must** be created before submitting any pull request. Any pull request that is created should be linked to an Issue.

## Feature request

If you have an idea of how to improve Dell Community Kubernetes Helm Charts, submit a [feature request](https://github.com/dell/helm-charts/issues/new?labels=type%2Ffeature-request%2C+needs-triage&template=feature_request.md&title=%5BFEATURE%5D%3A+%5Bchart+name+%28if+applicable%29%5D%3A+feature+title).

## Answering questions

If you have a question and you can't find the answer in the documentation or issues, the next step is to submit a [question](https://github.com/dell/helm-charts/issues/new?labels=type%2Fquestion&template=ask-a-question.md&title=%5BQUESTION%5D%3A+%5Bchart+name+%28if+applicable%29%5D%3A+question+title).

We'd love your help answering questions being asked by other Dell Community Kubernetes Helm Charts users.

## Triage issues

Triage helps ensure that issues resolve quickly by:

- Ensuring the issue's intent and purpose is conveyed precisely. This is necessary because it can be difficult for an issue to explain how an end user experiences a problem and what actions they took.
- Giving a contributor the information they need before they commit to resolving an issue.
- Lowering the issue count by preventing duplicate issues.
- Streamlining the development process by preventing duplicate discussions.

If you don't have the knowledge or time to code, consider helping with _issue triage_. The community will thank you for saving them time by spending some of yours.

Read more about the ways you can [Triage issues](docs/ISSUE_TRIAGE.md).

## Your first contribution

Unsure where to begin contributing to Dell Community Kubernetes Helm Charts? Start by browsing issues labeled `beginner friendly` or `help wanted`.

- [Beginner-friendly](https://github.com/dell/helm-charts/issues?q=is%3Aopen+is%3Aissue+label%3A%22beginner+friendly%22) issues are generally straightforward to complete.
- [Help wanted](https://github.com/dell/helm-charts/issues?q=is%3Aopen+is%3Aissue+label%3A%22help+wanted%22) issues are problems we would like the community to help us with regardless of complexity.

When you're ready to contribute, it's time to create a pull request.

## Branching Strategy

Updating a Helm chart will require a new branch. When updates are complete, the branch is merged back into the main branch after being approved in a pull request review. The frequency in which you merge branches into the main branch depends on how often you wish to release the Helm chart. Please see [Helm chart branching strategy](#helm-chart-release-strategy) for information on how merging a branch to the main branch will automatically release a Helm chart.

### Branch Naming Convention

Branch naming should be descriptive and align with a feature or bug fix. In order to align a branch with the feature or bug fix, use the GitHub issue ID whenever possible.

| Branch Type | Example                          | Comment                                  |
| ----------- | -------------------------------- | ---------------------------------------- |
| Feature     | feature-9-olp-support            | "9" referring to GitHub issue ID         |
| Bug Fix     | bugfix-110-remove-docker-compose | "110" referring to GitHub issue ID       |

### Branch Types

- Bug Fix branch is a branch which is created for the purpose of fixing the given defect/issue.
- Feature branch is created for feature development

### Steps to create a branch for a bug fix or feature

1. Fork the repository.
2. Create a branch off of the main branch. The branch name should follow [branch naming convention](#branch-naming-convention).
3. Write code, add tests, and commit to your branch. Optionally, add feature flags to disable any new features that are not yet ready for the release.
4. If other code changes have merged into the upstream main branch, perform a rebase of those changes into your branch.
5. Open a [pull request](#pull-requests) between your branch and the upstream main branch.
6. Once your pull request has merged, your branch can be deleted.

## Signing your commits

We require that developers sign off their commits to certify that they have permission to contribute the code in a pull request. This way of certifying is commonly known as the [Developer Certificate of Origin (DCO)](https://developercertificate.org/). We encourage all contributors to read the DCO text before signing a commit and making contributions.

GitHub will prevent a pull request from being merged if there are any unsigned commits.

### Signing a commit

GPG (GNU Privacy Guard) will be used to sign commits. Follow the instructions [here](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/signing-commits) to create a GPG key and configure your GitHub account to use that key.

Make sure you have your user name and e-mail set. This will be required for your signed commit to be properly verified. Check the following references:

- Setting up your github user name [reference](https://help.github.com/articles/setting-your-username-in-git/)
- Setting up your e-mail address [reference](https://help.github.com/articles/setting-your-commit-email-address-in-git/)

Once Git and your GitHub account have been properly configured, you can add the -S flag to the git commits:

```console
$ git commit -S -m your commit message
# Creates a signed commit
```

### Commit message format

Dell Community Kubernetes Helm Charts uses the guidelines for commit messages outlined in [How to Write a Git Commit Message](https://chris.beams.io/posts/git-commit/)

## Pull requests

If this is your first time contributing to an open-source project on GitHub, make sure you read about [Creating a pull request](https://help.github.com/en/articles/creating-a-pull-request).

A pull request must always link to at least one GitHub issue. If that is not the case, create a GitHub issue and link it.

To increase the chance of having your pull request accepted, make sure your pull request follows these guidelines:

- Title and description matches the implementation.
- Commits within the pull request follow the formatting guidelines.
- The pull request closes one related issue.
- The pull request contains necessary tests that verify the intended behavior.
- If your pull request has conflicts, rebase your branch onto the master branch.
- Code validation checks must pass.

If the pull request fixes a bug:

- The pull request description must include `Fixes #<issue number>`.

The Dell Community Kubernetes Helm Charts team _squashes_ all commits into one when we accept a pull request. The title of the pull request becomes the subject line of the squashed commit message. We still encourage contributors to write informative commit messages, as they becomes a part of the Git commit body.

We use the pull request title when we generate change logs for releases. As such, we strive to make the title as informative as possible.

Make sure that the title for your pull request uses the same format as the subject line in the commit message.

## Code Reviews

All submissions, including submissions by project members, require review. We use GitHub pull requests for this purpose. Consult [GitHub Help](https://help.github.com/articles/about-pull-requests/) for more information on using pull requests.

## Code Quality

In order to maintain code quality, we have defined quality gates that are automatically checked in every Pull Request. Any failed checks will block merging the Pull Request changes to the main branch. The contributor will need to update the code to address the failed checks. When the changes are committed to the Pull Request, the checks will rerun automatically. After all the checks have passed, merging to the main branch will be enabled based on maintainer approval. The following checks are used for the helm-charts repository:

- Validate linting using [helm-lint](https://helm.sh/docs/helm/helm_lint/) on updated charts.
- Check for version increment on updated charts.
- Validate [dependency](https://helm.sh/docs/helm/helm_dependency/) versions on parent charts.

A pull request must satisfy following for it to be merged:

- A pull request will require at least 2 maintainer approvals.
- Maintainer must perform a code review and ensure there is no malicious code.
- Maintainer must run a suite of tests that verify the quality of the code being submitted, and update the contributor if there are any failures.
- If any commits are made after the PR has been approved, the PR approval will automatically be removed and the above process must happen again.

## Helm chart release strategy

It is important to understand that when a branch is merged into the main branch, a GitHub action will generate a new helm chart release if the helm chart version in the chart.yaml file has been incremented. Consider the following example where a change to the Helm chart has been made and the contributor wants a new version to be released:

The original Chart.yaml file:

   ```yaml
   apiVersion: v2
   name: karavi-observability
   description: A Helm chart for Kubernetes
   type: application
   version: 0.1.0
   ```

If a modification to the Helm chart is made (an update to the values.yaml file for instance) the version in Chart.yaml is incremented to `0.2.0`:

   ```yaml
   apiVersion: v2
   name: karavi-observability
   description: A Helm chart for Kubernetes
   type: application
   version: 0.2.0 # version updates to 0.2.0
   ```

Once the associated branch is merged into the main branch, the GitHub action packages and publishes an artifact, making it available for consumption. The release name is based off the 'name' field and the 'version' field in the Chart.yaml file. Given the example above, GitHub action will produce a release called `karavi-observability-0.2.0`.
