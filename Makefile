.PHONY: default build

default: build

build:
	@docker build -t jeckel/docker-taskd .

