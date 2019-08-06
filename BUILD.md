# Readme

This document covers the building of the Docker multi-platform images.

## Simplified Makefile system

There is a `Makefile` to ease creating the multi-platform images, bundle them in a release and push them to DockerHub.

__NOTES:__ 

* Don't forget to update the version in the `Makefile`
* Login to DockerHub before publishing a release or pushing a new image

### Build All

```bash
$ make
```

### Build just for linux on amd64

```bash
$ make linux/amd64/build
```

### Build linux on amd64 and run (useful for debugging)

```bash
$ make quick
```

### Release a new build to DockerHub

```bash
$ make publish
```

## Docker image

__squish__ requires that the Docker experimental settings be enabled. Add the following to `/etc/docker/daemon.json`

```json
{ 
    "experimental": true 
} 
```

The build can be completed without __squish__ but it will result in much larger image. The default will build amd64 based images.

```bash
$ docker build --squash -t jeffersonjhunt/linuxcnc .
```

## Patches

None

## Alternate architectures

The following instructions are for building platform specific images. The currently supported images (PLATFORM) types are:

  `amd64`, `i386`, `arm32v7`, `arm64v8`

In theory any platform supported by [Docker](https://github.com/docker-library/official-images#architectures-other-than-amd64 "Alternate Architectures") and [Debian](https://hub.docker.com/_/debian "Debian Platforms") would work, but only the aforementioned ones have been tested.

### 32 bit support (i386)

To build the image requires the additional `--build-arg` to be passed set to `i386`.

```bash
$ docker build --squash --build-arg PLATFORM=i386 -t jeffersonjhunt/linuxcnc .
```

### Raspberry PI (arm32v7)

In order to build `arm32v7` based containers the build will need to be performed on an Raspberry PI or using Qemu on a Linux machine with [`binfmt-support`](https://en.wikipedia.org/wiki/Binfmt_misc "binfmt").

This page [Debian Wiki](https://wiki.debian.org/RaspberryPi/qemu-user-static "Debian Qemu Raspberry") used for creating an Raspbian image for local building/testing goes further than necessary, but provides excellent background information. The minimum supporting packages can be installed with:

```bash
$ sudo apt-get update
$ sudo apt-get install qemu-user
$ sudo apt-get install qemu-user-static
```

To build the image requires the additional `--build-arg` to be passed set to `arm32v7`. *__NOTE:__ on an i7-6600 this process takes hours to complete.*

```bash
$ docker build --squash --build-arg PLATFORM=arm32v7 -t jeffersonjhunt/linuxcnc .
```

### NVIDIA Jetson Nano (arm64v8)

*__NOTE:__ Raspberry PI and PINE64 official support will be added in the near future. PINE64 should work out of the box, but 64 Bit Raspbian is not trivial and requires sourcing a new base distro to test.*

To cross-compile use the same procedure as the __Raspberry PI (arm32v7)__ setting the `--build-arg` to `arm64v8`. *__NOTE:__ on an i7-6600 this process takes several hours to complete.*

__Instead of cross-compiling building on a `NVIDIA Jetson Nano` is strongly suggested as it is much quicker.__

```bash
$ docker build --squash --build-arg PLATFORM=arm64v8 -t jeffersonjhunt/linuxcnc .
```
