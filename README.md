# Table of Contents
- [Introduction](#introduction)
    - [Version](#version)
    - [Changelog](Changelog.md)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
    - [Data Store](#data-store)
- [Maintenance](#maintenance)
    - [SSH Login](#ssh-login)
- [Upgrading](#upgrading)
- [References](#references)

# Introduction
Dockerfile to build a GitLab CI Runner container image.

## Version
Current Version: 4.0.0

# Installation

Pull the latest version of the image from the docker index. This is the recommended method of installation as it is easier to update image in the future. These builds are performed by the **Docker Trusted Build** service.

```bash
docker pull sameersbn/gitlab-ci-runner
```

Starting from GitLab CI Runner version 4.0.0, You can pull a particular version of GitLab CI Runner by specifying the version number. For example,

```bash
docker pull sameersbn/gitlab-ci-runner:4.0.0
```

Alternately you can build the image yourself.

```bash
git clone https://github.com/sameersbn/docker-gitlab-ci-runner.git
cd docker-gitlab-ci-runner
docker build -t="$USER/gitlab-ci-runner" .
```

# Quick Start
Before you can start the GitLab CI Runner image you need to make sure you have a [GitLab CI](https://www.gitlab.com/gitlab-ci/) server running. Checkout the [docker-gitlab-ci](https://github.com/sameersbn/docker-gitlab-ci) project for getting a GitLab CI server up and running.

Before the image can be started, the runner should be registered on the GitLab CI server. This can be done by running the image with the **app:setup** command.

```bash
docker run -name gitlab-ci-runner -i -t \
  sameersbn/gitlab-ci-runner app:setup
```

The command will prompt you to specify the location of the GitLab CI server and provide the registration token to access the server. After configuring the runner, the image can now be started.

```bash
docker run -name gitlab-ci-runner -d sameersbn/gitlab-ci-runner
```

You should now have GitLab CI Runner up and running. Please read [Data Store](#data-store) section for deployment in production environments.

# Configuration

## Data Store
GitLab CI Runner saves the configuration for connection and access to the GitLab CI server. In addition, SSH keys are generated as well. To make sure this configuration is not lost when when the container is stopped/deleted, we should mount a data store volume at

* /home/gitlab_ci_runner/data

Volumes can be mounted in docker by specifying the **'-v'** option in the docker run command.

```bash
mkdir /opt/gitlab-ci-runner/data
docker run -name gitlab-ci-runner -d -h gitlab-ci-runner.local.host \
  -v /opt/gitlab-ci-runner/data:/home/gitlab_ci_runner/data \
  sameersbn/gitlab-ci-runner
```

# Maintenance

## SSH Login
There are two methods to gain root login to the container, the first method is to add your public rsa key to the authorized_keys file and build the image.

The second method is use the dynamically generated password. Every time the container is started a random password is generated using the pwgen tool and assigned to the root user. This password can be fetched from the docker logs.

```bash
docker logs gitlab-ci 2>&1 | grep '^User: ' | tail -n1
```

This password is not persistent and changes every time the image is executed.

## Upgrading

To upgrade to newer GitLab CI Runner releases, simply follow this 4 step upgrade procedure.

- **Step 1**: Stop the currently running image

```bash
docker stop gitlab-ci-runner
```

- **Step 2**: Update the docker image.

```bash
docker pull sameersbn/gitlab-ci-runner
```

- **Step 4**: Start the image

```bash
docker run -name gitlab-ci-runner -d [OPTIONS] sameersbn/gitlab-ci-runner
```


## References
  * https://gitlab.com/gitlab-org/gitlab-ci-runner/blob/master/README.md
