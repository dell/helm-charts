# How to Contribute

Become one of the contributors to this project! We thrive to build a welcoming and open community for anyone who wants to use the project or contribute to it. There are just a few small guidelines you need to follow. To help us create a safe and positive community experience for all, we require all participants to adhere to the [Code of Conduct](CODE_OF_CONDUCT.md).

# Table of Contents:
* [Become a contributor](#Become-a-contributor)
* [Report bugs](#Report-bugs)
* [Feature request](#Feature-request)
* [Answering questions](#Answering-questions)
* [Triage issues](#Triage-issues)
* [Your first contribution](#Your-first-contribution)
* [Pull requests](#Pull-requests)
* [Commit message format](#Commit-message-format)
* [Branching Strategy](#Branching-strategy)
* [Code reviews](#Code-reviews)
* [Signing your commits](#Signing-your-commits)
* [TODOs in the code](#TODOs-in-the-code)

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

Report a bug by submitting a [bug report](https://github.com/dell/helm-charts/issues/new?template=bug_report.md). Make sure that you provide as much information as possible on how to reproduce the bug.

When opening a Bug please include the following information to help with debugging:

1. Version of relevant software: this software, Kubernetes, Dell Storage Platform, Helm, etc.
2. Details of the issue explaining the problem: what, when, where
3. The expected outcome that was not met (if any)
4. Supporting troubleshooting information. __Note: Do not provide private company information that could compromise your company's security.__

An Issue __must__ be created before submitting any pull request. Any pull request that is created should be linked to an Issue.

## Feature request

If you have an idea of how to improve Dell Community Kubernetes Helm Charts, submit a [feature request](https://github.com/dell/helm-charts/issues/new?template=feature_request.md).

## Answering questions

If you have a question and you can't find the answer in the documentation or issues, the next step is to submit a [question](https://github.com/dell/helm-charts/issues/new?template=ask-a-question.md)

We'd love your help answering questions being asked by other Dell Community Kubernetes Helm Charts users.

## Triage issues

Triage helps ensure that issues resolve quickly by:

- Ensuring the issue's intent and purpose is conveyed precisely. This is necessary because it can be difficult for an issue to explain how an end user experiences a problem and what actions they took.
- Giving a contributor the information they need before they commit to resolving an issue.
- Lowering the issue count by preventing duplicate issues.
- Streamlining the development process by preventing duplicate discussions.

If you don't have the knowledge or time to code, consider helping with _issue triage_. The community will thank you for saving them time by spending some of yours.

Read more about the ways you can [Triage issues](ISSUE_TRIAGE.md).

## Your first contribution

Unsure where to begin contributing to Dell Community Kubernetes Helm Charts? Start by browsing issues labeled `beginner friendly` or `help wanted`.

- [Beginner-friendly](https://github.com/dell/helm-charts/issues?q=is%3Aopen+is%3Aissue+label%3A%22beginner+friendly%22) issues are generally straightforward to complete.
- [Help wanted](https://github.com/dell/helm-charts/issues?q=is%3Aopen+is%3Aissue+label%3A%22help+wanted%22) issues are problems we would like the community to help us with regardless of complexity.

When you're ready to contribute, it's time to create a pull request.

## Pull requests

If this is your first time contributing to an open-source project on GitHub, make sure you read about [Creating a pull request](https://help.github.com/en/articles/creating-a-pull-request).

A pull request must always link to at least one GitHub issue. If that is not the case, create a GitHub issue and link it.

To increase the chance of having your pull request accepted, make sure your pull request follows these guidelines:

- Title and description matches the implementation.
- Commits within the pull request follow the formatting guidelines.
- The pull request closes one related issue.
- The pull request contains necessary tests that verify the intended behavior.
- If your pull request has conflicts, rebase your branch onto the master branch.

If the pull request fixes a bug:

- The pull request description must include `Fixes #<issue number>`.

The Dell Community Kubernetes Helm Charts team _squashes_ all commits into one when we accept a pull request. The title of the pull request becomes the subject line of the squashed commit message. We still encourage contributors to write informative commit messages, as they becomes a part of the Git commit body.

We use the pull request title when we generate change logs for releases. As such, we strive to make the title as informative as possible.

Make sure that the title for your pull request uses the same format as the subject line in the commit message.

## Commit message format

Dell Community Kubernetes Helm Charts uses the guidelines for commit messages outlined in [How to Write a Git Commit Message](https://chris.beams.io/posts/git-commit/)

## Branching Strategy
We are following a scaled trunk branching strategy where short-lived branches are created off of the main branch. When coding is complete, the branch is merged back into main after being approved in a pull request code review.

Steps to create a branch for a bug fix or feature:
1. Fork the repository.
2. Create a branch off of the main branch. The branch name should be descriptive and include the chart name, the bug fix it contains or the release # associated with the version update being made to the chart.
3. Update the chart and commit to your branch.  Note: The chart version must be updated if any change is made to the chart.  See [Versioning](./charts/VERSIONING.md) 
4. If other code changes have merged into the upstream main branch, perform a rebase of those changes into your branch.
5. Open a pull request between your branch and the upstream main branch.  This will trigger a GitHub action to lint the chart in question.
6. Once your pull request has merged, GitHub actions will take care of creating a chart release, packaging the chart, and making the new version available in the Helm repo.

## Branch Naming Convention

|  Branch Type |  Example                          |  Comment                                  |
|--------------|-----------------------------------|-------------------------------------------|
|  main        |  main                             |                                           |
|  Feature     |  feature-9-olp-support            |  "9" referring to GitHub issue ID         |
|  Bug Fix     |  bugfix-110-remove-docker-compose |  "110" referring to GitHub issue ID       |

## Code Reviews

All submissions, including submissions by project members, require review. We use GitHub pull requests for this purpose. Consult [GitHub Help](https://help.github.com/articles/about-pull-requests/) for more information on using pull requests.

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

## TODOs in the code
We don't like TODOs in the code. It is really best if you sort out all issues you can see with the changes before we check the changes in.
