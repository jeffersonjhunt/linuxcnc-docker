platforms := linux/amd64 linux/i386 linux/arm32v7 linux/arm64v8

os = $(word 1, $(subst /, ,$@))
arch = $(word 2, $(subst /, ,$@))

XSOCK := /tmp/.X11-unix/X0
DISPLAY := :0

version = v1.0.0

.PHONY: build squash manifest push publish clean quick debug

%/build:
	docker build --build-arg PLATFORM=$(arch) \
	  -t jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version) .

build:
	for p in $(platforms); do \
		$(MAKE) $$p/build; \
	done

%/squash:
	docker build --squash --build-arg PLATFORM=$(arch) \
	  -t jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version) .

squash:
	for p in $(platforms); do \
		$(MAKE) $$p/squash; \
	done

%/manifest: 
	docker manifest create --amend jeffersonjhunt/linuxcnc:latest \
	  jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version)
	docker manifest create --amend jeffersonjhunt/linuxcnc:$(version) \
	  jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version)

manifest: push
	for p in $(platforms); do \
		$(MAKE) $$p/manifest; \
	done

%/push:
	docker push jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version)

push: squash
	for p in $(platforms); do \
		$(MAKE) $$p/push; \
	done

publish: manifest
	docker manifest push --purge jeffersonjhunt/linuxcnc:$(version)
	docker manifest push --purge jeffersonjhunt/linuxcnc:latest

%/clean:
	docker rmi jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version)

clean:
	for p in $(platforms); do \
		$(MAKE) $$p/clean; \
	done

%/run:
	xhost +
	docker run --rm -it -v $(XSOCK):$(XSOCK) \
	  -e DISPLAY=$(DISPLAY) \
	  jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version)

%/realtime:
	xhost +
	docker run --rm -it \
	  --oom-kill-disable --cpu-rt-runtime=950000 --ulimit rtprio=99 --cap-add=sys_nice \
	  -e DISPLAY=$(DISPLAY) \
	  -v $(XSOCK):$(XSOCK) jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version)

quick: linux/amd64/build linux/amd64/run

%/debug: 
	docker run --rm -it --entrypoint /bin/bash \
	  jeffersonjhunt/linuxcnc:$(os)-$(arch)-$(version)

debug: linux/amd64/debug
