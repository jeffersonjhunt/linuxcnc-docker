# Readme

This document covers the current state of the Docker built image. It enumerates the known issues, todo lists, etc...

## Releases

See [RELEASE.md](https://github.com/jeffersonjhunt/linuxcnc-docker/blob/master/RELEASE.md "RELEASE.md") for more details.

* v1.0.0 - 
    * [Dockerfile](https://github.com/jeffersonjhunt/linuxcnc-docker/blob/v1.0.0/Dockerfile "Dockerfile")
    * [Docker Image](https://hub.docker.com/r/jeffersonjhunt/linuxcnc "Docker Image")

## Basics

See the [README.Docker.md](https://github.com/jeffersonjhunt/linuxcnc-docker/blob/master/README.Docker.md "README.Docker.md") for more information on basic operation using Docker.

Single Board Computers (SBC) like the *Raspberry Pi* and *NVIDIA Jetson Nano* are supported via Docker with specific guides located [here](https://github.com/jeffersonjhunt/linuxcnc-docker/blob/master/guides "Guides").

### Run

```bash
$ xhost +
$ docker run --rm -it -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0 -e DISPLAY=:0 jeffersonjhunt/linuxcnc start
```

### Realtime OS Run

```bash
$ xhost +
$ docker run --rm -it --oom-kill-disable --cpu-rt-runtime=950000 --ulimit rtprio=99 --cap-add=sys_nice \
  -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0 -e DISPLAY=:0 jeffersonjhunt/linuxcnc start
```

## Config & Control

### Entrypoint script

The `linuxcnc-entrypoint.sh` is used to simplify the interaction of Docker with LinuxCNC. Docker passes in any additional arguments to the run command to the entrypoint.

## Build Notes

### Dockerfile 
#### Structure

The `Dockerfile` is broken into several __RUN__ sections to allow for quicker builds while adding and refining modules, plugins, supporting apps and new versions of LinuxCNC.

#### Build

See: `BUILD.md` for complete details on building, debugging and packaging.
