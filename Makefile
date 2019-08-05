BUILD:
	docker build -t jeffersonjhunt/linuxcnc .

RUN:
	xhost +
	XSOCK=/tmp/.X11-unix/X0
	docker run --rm -it \
	--oom-kill-disable \
	--cpu-rt-runtime=950000 \
    --ulimit rtprio=99 \
    --cap-add=sys_nice \
	--entrypoint /bin/bash -v $XSOCK:$XSOCK \
	jeffersonjhunt/linuxcnc