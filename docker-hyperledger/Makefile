TARGETS		= composer-playground
STACKS		= composer

.PHONY: default
default: build

.PHONY: build
build: $(TARGETS)

tag = my/$(lastword $(subst /, ,$1))

.PHONY: $(TARGETS)
$(TARGETS): %:
	-docker build -t $(call tag,$*) $*

.PHONY: run
run: $(TARGETS:=.run)

.PHONY: $(TARGETS:=.run)
$(TARGETS:=.run): %.run: %
	-docker run -d --rm $(call tag,$*)

.PHONY: deploy
deploy: $(STACKS:=.deploy)

.PHONY: $(STACKS:=.deploy)
$(STACKS:=.deploy): %.deploy:
	-docker stack deploy --prune -c $*/docker-compose.yaml $*

.PHONY: composer.deploy
composer.deploy: composer-playground

.PHONY: clean
clean: rm-containers rm-untagged

.PHONY: clobber
clobber: clean rm-images

.PHONY: pristine
pristine: clobber rm-volumes

.PHONY: rm-stack
rm-stack:
	-docker stack ls | tail -n +2 | awk '{print $$1}' | xargs --no-run-if-empty docker stack rm

.PHONY: rm-containers
rm-containers: rm-stack
	-docker ps -a -q | xargs --no-run-if-empty docker stop
	-docker ps -a -q | xargs --no-run-if-empty docker rm

.PHONY: rm-untagged
rm-untagged:
	-docker images | tail -n +2 | awk '$$1 == "<none>" {print $$3}' | xargs --no-run-if-empty docker rmi

.PHONY: rm-images
rm-images: rm-containers
	-docker images | tail -n +2 | awk '{print $$3}' | xargs --no-run-if-empty docker rmi -f

.PHONY: rm-volumes
rm-volumes: rm-containers
	-docker volume ls | tail -n +2 | awk '{print $$2}' | xargs --no-run-if-empty docker volume rm -f

.PHONY: help
help:
	@echo "default:       build"
	@echo "build:         build all images"
	@echo "run:           run all container (<name>.run for a single container)"
	@echo "deploy:        deploy all stacks (<name>.deploy for a single stack"
	@echo "clean:         stop stack, containers and remove untagged images"
	@echo "clobber:       clean and also remove all images"
	@echo "pristine:      clobber and also remove all volumes"
	@echo "rm-stack:      stop all stacks"
	@echo "rm-containers: stop and remove all containers"
	@echo "rm-untagged:   remove untagged images"
	@echo "rm-images:     remove all containers and images"
	@echo "rm-volumes:    remove all containers and volumes"
