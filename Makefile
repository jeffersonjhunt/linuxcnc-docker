platforms := linux/amd64 linux/i386 linux/arm32v7 linux/arm64v8

os = $(word 1, $(subst /, ,$@))
arch = $(word 2, $(subst /, ,$@))

XSOCK := /tmp/.X11-unix/X0
DISPLAY := :0

version = v1.0.0

BUILD_NUMBER_FILE = .BUILD_NUMBER

.PHONY: build squash manifest push publish clean quick debug

%/build: $(BUILD_NUMBER_FILE)
	docker build --build-arg PLATFORM=$(arch) \
	  -t jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version).$$(cat $(BUILD_NUMBER_FILE)) .

build: 
	for p in $(platforms); do \
		$(MAKE) $$p/build; \
	done

%/squash:
	docker build --squash --build-arg PLATFORM=$(arch) \
	  -t jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version).$$(cat $(BUILD_NUMBER_FILE)) .

squash:
	for p in $(platforms); do \
		$(MAKE) $$p/squash; \
	done

%/manifest: 
	docker manifest create --amend jeffersonjhunt/linuxcnc:latest \
	  jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version).$$(cat $(BUILD_NUMBER_FILE))
	docker manifest create --amend jeffersonjhunt/linuxcnc:$(version) \
	  jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version).$$(cat $(BUILD_NUMBER_FILE))

manifest: push
	for p in $(platforms); do \
		$(MAKE) $$p/manifest; \
	done

%/push:
	docker login
	docker push jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version).$$(cat $(BUILD_NUMBER_FILE))

push: squash
	for p in $(platforms); do \
		$(MAKE) $$p/push; \
	done

publish: manifest
	docker login
	docker manifest push --purge jeffersonjhunt/linuxcnc:$(version).$$(cat $(BUILD_NUMBER_FILE))
	docker manifest push --purge jeffersonjhunt/linuxcnc:latest

%/clean:
	docker rmi jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version).$$(cat $(BUILD_NUMBER_FILE))

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
	docker run --rm -it \
	  --oom-kill-disable --cpu-rt-runtime=950000 --ulimit rtprio=99 --cap-add=sys_nice \
	  -e DISPLAY=$(DISPLAY) \
	  -v $(XSOCK):$(XSOCK) jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version).$$(cat $(BUILD_NUMBER_FILE))

quick: linux/amd64/build linux/amd64/run

%/debug: 
	docker run --rm -it --entrypoint /bin/bash \
	  jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version).$$(cat $(BUILD_NUMBER_FILE))

debug: linux/amd64/debug

include tools.mak