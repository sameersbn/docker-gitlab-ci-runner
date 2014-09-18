FROM sameersbn/debian:jessie.20140918
MAINTAINER sameer@damagehead.com

RUN apt-get update \
 && apt-get install -y gcc g++ patch make \
      git-core libc6-dev zlib1g-dev libyaml-dev libssl-dev \
      libgdbm-dev libreadline-dev libncurses5-dev libffi-dev \
      libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev \
      ruby2.1 ruby2.1-dev rubygems openssh-client \
&& gem install --no-ri --no-rdoc bundler \
&& rm -rf /var/lib/apt/lists/* # 20140918

ADD assets/setup/ /app/setup/
RUN chmod 755 /app/setup/install
RUN /app/setup/install

ADD assets/init /app/init
RUN chmod 755 /app/init

VOLUME ["/home/gitlab_ci_runner/data"]

ENTRYPOINT ["/app/init"]
CMD ["app:start"]
