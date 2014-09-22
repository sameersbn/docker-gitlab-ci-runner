all: build

build:
	@docker build --tag=${USER}/gitlab-ci-runner .
