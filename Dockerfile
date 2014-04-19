FROM sameersbn/ubuntu:12.04.20140418
MAINTAINER sameer@damagehead.com

RUN apt-get install -y python-software-properties && \
		add-apt-repository -y ppa:git-core/ppa && apt-get update

RUN apt-get install -y build-essential checkinstall \
			git-core zlib1g-dev libyaml-dev libssl-dev \
			libgdbm-dev libreadline-dev libncurses5-dev libffi-dev \
			libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev && \
		apt-get clean

RUN add-apt-repository -y ppa:brightbox/ruby-ng && apt-get update && \
		apt-get install -y ruby2.0 ruby-switch ruby2.0-dev && apt-get clean && \
		ruby-switch --set ruby2.0 && gem install --no-ri --no-rdoc bundler

ADD assets/ /app/
RUN chmod 755 /app/init /app/setup/install
RUN /app/setup/install

ADD authorized_keys /root/.ssh/

VOLUME ["/home/gitlab_ci_runner/data"]

ENTRYPOINT ["/app/init"]
CMD ["app:start"]
