# Table of Contents
- [Introduction](#introduction)
	- [Version](#version)
	- [Changelog](Changelog.md)
- [Contributing](#contributing)
- [Reporting Issues](#reporting-issues)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
	- [Data Store](#data-store)
	- [Installing Trusted SSL Server Certificates](#installing-trusted-ssl-server-certificates)
- [Deploy Keys](#deploy-keys)
- [Configuration Parameters](#configuration-parameters)
- [Shell Access](#shell-access)
- [Upgrading](#upgrading)
- [References](#references)

# Introduction

Dockerfile to build a GitLab CI Runner base image. You can use this as the base image to build your own runner images. The [sameersbn/runner-gitlab](https://github.com/sameersbn/docker-runner-gitlab) project demonstrates its use to build a CI image for GitLab CE.

## Version

Current Version: **5.2.1**

# Contributing

If you find this image useful here's how you can help:

- Send a Pull Request with your awesome new features and bug fixes
- Help new users with [Issues](https://github.com/sameersbn/docker-gitlab-ci-runner/issues) they may encounter
- Send me a tip via [Bitcoin](https://www.coinbase.com/sameersbn) or using [Gratipay](https://gratipay.com/sameersbn/)

# Reporting Issues

Docker is a relatively new project and is active being developed and tested by a thriving community of developers and testers and every release of docker features many enhancements and bugfixes.

Given the nature of the development and release cycle it is very important that you have the latest version of docker installed because any issue that you encounter might have already been fixed with a newer docker release.

For ubuntu users I suggest [installing docker](https://docs.docker.com/installation/ubuntulinux/) using docker's own package repository since the version of docker packaged in the ubuntu repositories are a little dated.

Here is the shortform of the installation of an updated version of docker on ubuntu.

```bash
sudo apt-get purge docker.io
curl -s https://get.docker.io/ubuntu/ | sudo sh
sudo apt-get update
sudo apt-get install lxc-docker
```

Fedora and RHEL/CentOS users should try disabling selinux with `setenforce 0` and check if resolves the issue. If it does than there is not much that I can help you with. You can either stick with selinux disabled (not recommended by redhat) or switch to using ubuntu.

If using the latest docker version and/or disabling selinux does not fix the issue then please file a issue request on the [issues](https://github.com/sameersbn/docker-gitlab-ci-runner/issues) page.

In your issue report please make sure you provide the following information:

- The host ditribution and release version.
- Output of the `docker version` command
- Output of the `docker info` command
- The `docker run` command you used to run the image (mask out the sensitive bits).

# Installation

Pull the latest version of the image from the docker index. This is the recommended method of installation as it is easier to update image in the future. These builds are performed by the **Docker Trusted Build** service.

```bash
docker pull sameersbn/gitlab-ci-runner:latest
```

Starting from GitLab CI Runner version `5.2.1`, You can pull a particular version of GitLab CI Runner by specifying the version number. For example,

```bash
docker pull sameersbn/gitlab-ci-runner:5.2.1
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
  sameersbn/gitlab-ci-runner:5.2.1 app:setup
```

The command will prompt you to specify the location of the GitLab CI server and provide the registration token to access the server. With this out of the way the image is ready, lets get is started.

```bash
docker run --name gitlab-ci-runner -it --rm \
	-v /opt/gitlab-ci-runner:/home/gitlab_ci_runner/data \
	sameersbn/gitlab-ci-runner:5.2.1
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
  sameersbn/gitlab-ci-runner:5.2.1
```

## Installing Trusted SSL Server Certificates

If your GitLab server is using self-signed SSL certificates then you should make sure the GitLab server certificate is trusted on the runner for the git clone operations to work.

The default path the runner is configured to look for the trusted SSL certificates is at `/home/gitlab_ci_runner/data/certs/ca.crt`, this can however be changed using the `CA_CERTIFICATES_PATH` configuration option.

If you remember from above, the `/home/gitlab_ci_runner/data` is the path of the [data store](#data-store), which means that we have to create a folder named `certs` inside `/opt/gitlab-ci-runner/data/` and copy the `ca.crt` file into it.

The `ca.crt` file should contain the root certificates of all the servers you want to trust. With respect to GitLab, this will be the contents of the `gitlab.crt` file as described in the [README](https://github.com/sameersbn/docker-gitlab/blob/master/README.md#ssl) of the [docker-gitlab](https://github.com/sameersbn/docker-gitlab) container.

# Deploy Keys

The image automatically generates a deploy keys for the `gitlab_ci_runner` user and these keys are available at the data volume at `/home/gitlab_ci_runner/data/.ssh`. You can overwrite these keys if you wish to do so.

If the runner needs to access a private git repo then add the generated public key to your projects deploy keys so that the runner can clone the required repos.

*NOTE: The deploy keys are generated without a passphrase.*

# Configuration Parameters

*Please refer the docker run command options for the `--env-file` flag where you can specify all required environment variables in a single file. This will save you from writing a potentially long docker run command.*

Below is the list of available options that you can use to configure your runner.

- **CI_SERVER_URL**: The hostname of the GitLab CI server. No defaults
- **REGISTRATION_TOKEN**: The token to use to register on the CI server
*The above two options are only applicable if you want to skip the `app:setup` step and want to instead provide these parameters at launch. Additionally, they are effective only the first time you launch the container*

# Shell Access

For debugging and maintenance purposes you may want access the containers shell. If you are using docker version `1.3.0` or higher you can access a running containers shell using `docker exec` command.

```bash
docker exec -it gitlab-ci-runner bash
```

If you are using an older version of docker, you can use the [nsenter](http://man7.org/linux/man-pages/man1/nsenter.1.html) linux tool (part of the util-linux package) to access the container shell.

Some linux distros (e.g. ubuntu) use older versions of the util-linux which do not include the `nsenter` tool. To get around this @jpetazzo has created a nice docker image that allows you to install the `nsenter` utility and a helper script named `docker-enter` on these distros.

To install `nsenter` execute the following command on your host,

```bash
docker run --rm -v /usr/local/bin:/target jpetazzo/nsenter
```

Now you can access the container shell using the command

```bash
sudo docker-enter gitlab-ci-runner
```

For more information refer https://github.com/jpetazzo/nsenter

# Upgrading

To update the runner, simply stop the image and pull the latest version from the docker index.

```bash
docker pull sameersbn/gitlab-ci-runner:5.2.1
docker stop gitlab-ci-runner
docker rm gitlab-ci-runner
docker run --name gitlab-ci-runner -d [OPTIONS] sameersbn/gitlab-ci-runner:5.2.1
```

# References
  * https://gitlab.com/gitlab-org/gitlab-ci-runner/blob/master/README.md
