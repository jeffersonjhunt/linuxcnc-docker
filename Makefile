platforms := linux/amd64 linux/i386 linux/arm32v7 linux/arm64v8

os = $(word 1, $(subst /, ,$@))
arch = $(word 2, $(subst /, ,$@))

XSOCK := /tmp/.X11-unix/X0
DISPLAY := :0

version = v1.1.0

# to run under WSL use: make DOCKER=/mnt/c/Progra~1/Docker/Docker/resources/bin/docker.exe <TARGET>
DOCKER = $(shell which docker)
BUILD_NUMBER_FILE = .BUILD_NUMBER

.PHONY: build squash manifest push publish clean quick debug

%/build: $(BUILD_NUMBER_FILE)
	$(DOCKER) build --build-arg PLATFORM=$(arch) \
	  -t jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version).$$(cat $(BUILD_NUMBER_FILE)) .

%/squash:
	$(DOCKER) build --squash --build-arg PLATFORM=$(arch) \
	  -t jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version).$$(cat $(BUILD_NUMBER_FILE)) .

%/manifest: 
	$(DOCKER) manifest create --amend jeffersonjhunt/linuxcnc:latest \
	  jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version).$$(cat $(BUILD_NUMBER_FILE))
	$(DOCKER) manifest create --amend jeffersonjhunt/linuxcnc:$(version) \
	  jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version).$$(cat $(BUILD_NUMBER_FILE))

%/push:
	$(DOCKER) login
	$(DOCKER) push jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version).$$(cat $(BUILD_NUMBER_FILE))

publish: manifest
	$(DOCKER) login
	$(DOCKER) manifest push --purge jeffersonjhunt/linuxcnc:$(version)
	$(DOCKER) manifest push --purge jeffersonjhunt/linuxcnc:latest

%/clean:
	do$(DOCKER)cker rmi jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version).$$(cat $(BUILD_NUMBER_FILE))

clean:
	for p in $(platforms); do \
		$(MAKE) $$p/clean; \
	done

%/run:
	xhost +
	docker run --rm -it -v $(XSOCK):$(XSOCK) \
	  -e DISPLAY=$(DISPLAY) \
	  jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version).$$(cat $(BUILD_NUMBER_FILE))

%/realtime:
	xhost +
	$(DOCKER) run --rm -it \
	  --oom-kill-disable --cpu-rt-runtime=950000 --ulimit rtprio=99 --cap-add=sys_nice \
	  -e DISPLAY=$(DISPLAY) \
	  -v $(XSOCK):$(XSOCK) jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version).$$(cat $(BUILD_NUMBER_FILE))

%/debug: 
	$(DOCKER) run --rm -it --entrypoint /bin/bash \
	  jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version).$$(cat $(BUILD_NUMBER_FILE))

include tools.mak
