# SonarQube

I use SonarQube to analyze the quality of the code that is being pushed to the `main` branch.

## Why I use Docker instead of SonarCloud?

The content of this sub-project is heavily based on [this repo I did for running SonarQube locally](https://github.com/raulwwq0/sonarqube-docker). Normally, I would recommend using this only for local development purposes and using [SonarCloud](https://docs.sonarcloud.io) for CI. However, since I have hosted the whole project in an [Oracle Cloud Infrastructure](https://www.oracle.com/cloud/) VPS I decide to also self-host SonarQube there behind the [Nginx reverse proxy](../nginx_reverse_proxy/README.md).

## How is implemented in CI/CD?

In the [Deploy to VPS](../../.github/workflows/deploy.yml), before deploying the code there is a SonarQube job that:

1. Scan the code of the whole project
2. Check that the code pass the [Quality Gate](https://docs.sonarqube.org/9.8/user-guide/quality-gates/)

Once those steps are completed, the code is considered as **Production Ready** and the deploy job can begin.
