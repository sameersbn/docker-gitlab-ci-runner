# Changelog

**latest**
- added CI_RUNNERS_COUNT option to allow launching multiple runners
- start runner as gitlab_ci_runner user
- purge development packages after install. shaves off ~150MB from the image.
- rebase image on sameersbn/debian:jessie.20140918 base image

**5.0.0-1**
- Create deploy keys for root user
- update to sameersbn/ubuntu:14.04.20140628 image
- update to the sameersbn/ubuntu:12.04.20140818 baseimage
- update to the sameersbn/ubuntu:12.04.20140812 baseimage
- shallow clone gitlab-ci-runner
- update to sameersbn/ubuntu:14.04.20140628 base image
- removed sshd start, use nsenter instead

**5.0.0**
- upgrade to gitlab-ci-runner 5.0.0
- upgrade to sameersbn/ubuntu:14.04.20140505 base image
- added CA_CERTIFICATES_PATH configuration option
- use sameersbn/ubuntu as the base docker image
- install ruby2.0 via ppa

**4.0.0**
 - initial creation, adapted from https://github.com/sameersbn/docker-gitlab-ci
