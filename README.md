# Table of Contents
- [Introduction](#introduction)
	- [Version](#version)
	- [Changelog](Changelog.md)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
	- [Data Store](#data-store)
	- [Installing Trusted SSL Server Certificates](#installing-trusted-ssl-server-certificates)
- [Deploy Keys](#deploy-keys)
- [Upgrading](#upgrading)
- [References](#references)

# Introduction

Dockerfile to build a GitLab CI Runner base image. You can use this as the base image to build your own runner images. The [sameersbn/runner-gitlab](https://github.com/sameersbn/docker-runner-gitlab) project demonstrates its use to build a CI image for GitLab CE.

## Version

Current Version: **5.0.0-1**

# Installation

Pull the latest version of the image from the docker index. This is the recommended method of installation as it is easier to update image in the future. These builds are performed by the **Docker Trusted Build** service.

```bash
docker pull sameersbn/gitlab-ci-runner:latest
```

Starting from GitLab CI Runner version `5.0.0-1`, You can pull a particular version of GitLab CI Runner by specifying the version number. For example,

```bash
docker pull sameersbn/gitlab-ci-runner:5.0.0-1
```

Alternately you can build the image yourself.

```bash
git clone https://github.com/sameersbn/docker-gitlab-ci-runner.git
cd docker-gitlab-ci-runner
docker build --tag="$USER/gitlab-ci-runner" .
```

# Quick Start

For a runner to do its trick, it has to first be registered/authorized on the GitLab CI server. This can be done by running the image with the `app:setup` command.

```bash
mkdir -p /opt/gitlab-ci-runner
docker run --name gitlab-ci-runner -it --rm \
	-v /opt/gitlab-ci-runner:/home/gitlab_ci_runner/data \
  sameersbn/gitlab-ci-runner:5.0.0-1 app:setup
```

The command will prompt you to specify the location of the GitLab CI server and provide the registration token to access the server. With this out of the way the image is ready, lets get is started.

```bash
docker run --name gitlab-ci-runner -it --rm \
	-v /opt/gitlab-ci-runner:/home/gitlab_ci_runner/data \
	sameersbn/gitlab-ci-runner:5.0.0-1
```

You now have a basic runner up and running. But in this form its more or less useless. See [sameersbn/runner-gitlab](https://github.com/sameersbn/docker-runner-gitlab) to understand how you can use this base image to build a runner for your own projects.

# Configuration

## Data Store

GitLab CI Runner saves the configuration for connection and access to the GitLab CI server. In addition, SSH keys are generated as well. To make sure this configuration is not lost when when the container is stopped/deleted, we should mount a data store volume at

* `/home/gitlab_ci_runner/data`

Volumes can be mounted in docker by specifying the **'-v'** option in the docker run command.

```bash
mkdir /opt/gitlab-ci-runner
docker run --name gitlab-ci-runner -it --rm -h gitlab-ci-runner.local.host \
  -v /opt/gitlab-ci-runner:/home/gitlab_ci_runner/data \
  sameersbn/gitlab-ci-runner:5.0.0-1
```

## Installing Trusted SSL Server Certificates

If your GitLab server is using self-signed SSL certificates then you should make sure the GitLab server certificate is trusted on the runner for the git clone operations to work.

The default path the runner is configured to look for the trusted SSL certificates is at `/home/gitlab_ci_runner/data/certs/ca.crt`, this can however be changed using the `CA_CERTIFICATES_PATH` configuration option.

If you remember from above, the `/home/gitlab_ci_runner/data` is the path of the [data store](#data-store), which means that we have to create a folder named `certs` inside `/opt/gitlab-ci-runner/data/` and copy the `ca.crt` file into it.

The `ca.crt` file should contain the root certificates of all the servers you want to trust. With respect to GitLab, this will be the contents of the `gitlab.crt` file as described in the [README](https://github.com/sameersbn/docker-gitlab/blob/master/README.md#ssl) of the [docker-gitlab](https://github.com/sameersbn/docker-gitlab) container.

# Deploy Keys

The image automatically generates a deploy keys for the `root` user and these keys are available at the data volume at `/home/gitlab_ci_runner/data/.ssh`. You can overwrite these keys if you wish to do so.

If the runner needs to access a private git repo then add the generated public key to your projects deploy keys so that the runner can clone the required repos.

*NOTE: The deploy keys are generated without a passphrase.*

# Upgrading

To update the runner, simply stop the image and pull the latest version from the docker index.

```bash
docker pull sameersbn/gitlab-ci-runner:5.0.0-1
docker stop gitlab-ci-runner
docker rm gitlab-ci-runner
docker run --name gitlab-ci-runner -d [OPTIONS] sameersbn/gitlab-ci-runner:5.0.0-1
```

# References
  * https://gitlab.com/gitlab-org/gitlab-ci-runner/blob/master/README.md
