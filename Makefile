CURRENT_DIRECTORY := $(shell pwd)
NAME = adriagalin/web
VERSION ?= latest

.PHONY: all build build-no-cache tag-latest run stop

hugo-build:
	docker build -t hugo-compiler -f Dockerfile.hugo .
	rm -rf web/public
	#docker run -e SITE_URL="http://adriagalin.com" -v $(CURRENT_DIRECTORY)/web:/web --rm hugo-compiler

run:
	docker run -p 80:80 -p 443:443 -d $(NAME)

stop:
	docker stop `docker ps | grep $(NAME) | head -n1 | awk '{ print $1 }'`

remove-exited-containers:
	docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs sudo docker rm

remove-untagged-images:
	docker rmi $(docker images | grep '^<none>' | awk '{print $3}')
