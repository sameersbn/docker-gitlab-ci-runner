FROM sameersbn/ubuntu:12.04.20140812
MAINTAINER sameer@damagehead.com

RUN add-apt-repository -y ppa:git-core/ppa && \
		add-apt-repository -y ppa:brightbox/ruby-ng && \
		apt-get update && \
		apt-get install -y build-essential checkinstall \
			git-core zlib1g-dev libyaml-dev libssl-dev \
			libgdbm-dev libreadline-dev libncurses5-dev libffi-dev \
			libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev \
			ruby2.1 ruby2.1-dev && \
		gem install --no-ri --no-rdoc bundler && \
		apt-get clean # 20140519

ADD assets/setup/ /app/setup/
RUN chmod 755 /app/setup/install
RUN /app/setup/install

ADD assets/init /app/init
RUN chmod 755 /app/init

VOLUME ["/home/gitlab_ci_runner/data"]

ENTRYPOINT ["/app/init"]
CMD ["app:start"]
