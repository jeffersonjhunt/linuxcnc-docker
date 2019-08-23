# Supported tags and respective Dockerfile links

* [latest](https://github.com/jeffersonjhunt/linuxcnc-docker/blob/master/Dockerfile "Dockerfile")
* [v1.1.0](https://github.com/jeffersonjhunt/linuxcnc-docker/blob/v1.1.0/Dockerfile "Dockerfile")

# Quick reference

* __Where to file issues:__

   https://github.com/jeffersonjhunt/linuxcnc-docker/issues

* __Maintained by:__

   [jeffersonjhunt](https://hub.docker.com/u/jeffersonjhunt "Profile of Jefferson J Hunt")

* __Supported architectures: [(more info)](https://github.com/docker-library/official-images#architectures-other-than-amd64 "Docker alt architectures")__

   amd64 (x86_64), i386, arm32v7 (armhf), arm64v8

* __Supported Single Board Computers (SBC): [(more info)](https://github.com/jeffersonjhunt/linuxcnc-docker/blob/master/guides "Guides")__

   Raspberry Pi 3 Model B, Raspberry Pi 3 Model B+, NVIDIA Jetson Nano

* __Source of this description:__

   On the GitHub repo at [README.Docker.md](https://github.com/jeffersonjhunt/linuxcnc-docker/blob/master/README.Docker.md "README.Docker.md")

* __Supported Docker versions:__

   the latest CE release (down to 17-ce on a best-effort basis)

# What is LinuxCNC?

*from the [LinuxCNC GitHub Repo](https://github.com/LinuxCNC/linuxcnc "GitHub LinuxCNC"):* 

>LinuxCNC controls CNC machines. It can drive milling machines, lathes, 3d printers, laser cutters, plasma cutters, robot arms, hexapods, and more. [LinuxCNC Homepage](http://linuxcnc.org/ "LinuxCNC Homepage")

# How to use this image

### Run LinuxCNC
```bash
$ xhost +
$ docker run --rm -it -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0 -e DISPLAY=:0 jeffersonjhunt/linuxcnc start
```

This will run LinuxCNC without Realtime OS support and should only be used for testing. For Realtime OS support, see the
[README.md](https://github.com/jeffersonjhunt/linuxcnc-docker/blob/master/README.md "README.md")

# Building the Dockerfile

For more information about the build, versions used and how to modify it see the
[README.md](https://github.com/jeffersonjhunt/linuxcnc-docker/blob/master/README.md "README.md")

# License
View license information for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
