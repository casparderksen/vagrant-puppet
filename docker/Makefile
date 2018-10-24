TARGETS			= jenkins nginx oradb weblogic
STACKS			= devbox

TAG_jenkins		= my/jenkins
TAG_nginx		= my/nginx
TAG_oradb		= my/oradb
TAG_weblogic	= my/weblogic

DIR_jenkins		= jenkins
DIR_nginx		= nginx
DIR_oradb		= oracle/oradb
DIR_weblogic	= oracle/weblogic

DIR_devbox		= stack/devbox

.PHONY: default
default: build

.PHONY: build
build: $(TARGETS:=.build)

.PHONY: $(TARGETS:=.build)
$(TARGETS:=.build): %.build: $(DIR_$*)
	-docker build -t $(TAG_$*) $(DIR_$*)

.PHONY: run
run: $(TARGETS:=.run)

.PHONY: $(TARGETS:=.run)
$(TARGETS:=.run): %.run: %.build
	-docker run -d --rm $(TAG_$*)

.PHONY: deploy
deploy: $(STACKS:=.deploy)

.PHONY: $(STACKS:=.deploy)
$(STACKS:=.deploy): %.deploy: build
	-docker stack deploy --prune -c $(DIR_$*)/docker-compose.yaml $*

.PHONY: clean
clean: rm-containers rm-untagged rm-targets

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

.PHONY: rm-targets
rm-targets: rm-containers
	-docker rmi -f $(foreach tag,$(TARGETS),$(TAG_$(tag)))

.PHONY: rm-images
rm-images: rm-containers
	-docker images | tail -n +2 | awk '{print $$3}' | xargs --no-run-if-empty docker rmi -f

.PHONY: rm-volumes
rm-volumes: rm-containers
	-docker volume ls | tail -n +2 | awk '{print $$2}' | xargs --no-run-if-empty docker volume rm -f

.PHONY: help
help:
	@echo "default:       build"
	@echo "build:         build all images (<target>.build for a single image)"
	@echo "run:           run all container (<target>.run for a single container)"
	@echo "deploy:        deploy all stacks (<target>.deploy for a single stack)"
	@echo "clean:         stop stack, containers and remove untagged images"
	@echo "clobber:       clean and also remove all images"
	@echo "pristine:      clobber and also remove all volumes"
	@echo "rm-stack:      stop all stacks"
	@echo "rm-containers: stop and remove all containers"
	@echo "rm-untagged:   remove untagged images"
	@echo "rm-targets:    remove all containers and target images"
	@echo "rm-images:     remove all containers and all images"
	@echo "rm-volumes:    remove all containers and volumes"