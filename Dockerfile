ARG PLATFORM=amd64
FROM ${PLATFORM}/debian:stable-20190812-slim
LABEL maintainer "Jefferson J. Hunt <jeffersonjhunt@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

# Ensure that we always use UTF-8, US English locale and UTC time
RUN apt-get update && apt-get install -y locales && \
  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
  echo "UTC" > /etc/timezone && \
  chmod 0755 /etc/timezone 
ENV LANG en_US.utf8
ENV LC_ALL=en_US.utf-8
ENV LANGUAGE=en_US:en
ENV PYTHONIOENCODING=utf-8

# Install supporting apps needed to build/run
RUN apt-get install -y \
      git \
      build-essential \
      pkg-config \
      curl \
      autogen \
      autoconf \
      python \
      python-tk \
      libudev-dev \
      libmodbus-dev \
      libusb-1.0-0-dev \
      libgtk2.0-dev \
      python-gtk2 \
      procps \
      kmod \
      intltool \
      tcl8.6-dev \
      tk8.6-dev \
      bwidget \
      libtk-img \
      tclx \
      libreadline-gplv2-dev \
      libboost-python-dev \
      libglu1-mesa-dev \
      libgl1-mesa-dev \
      libxmu-dev \
      python-yapps \
      yapps2 && \
  curl -k https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py && \
  python /tmp/get-pip.py && \
  pip install --upgrade pip

WORKDIR /opt

# Add modules/plugins

# Build and install LinuxCNC
RUN git clone https://github.com/LinuxCNC/linuxcnc.git && \
  cd linuxcnc/debian && \
  ./configure uspace && \
  cd ../src && \
  ./autogen.sh && \
  ./configure --with-realtime=uspace && \
  make

# Clean up APT when done.
RUN apt-get purge -y \
      git \
      build-essential \
      pkg-config \
      curl \
      autogen \
      autoconf \
      curl && \
  apt-get autoclean -y && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add mgmt scripts
COPY linuxcnc-entrypoint.sh /usr/local/bin/linuxcnc-entrypoint.sh
RUN chmod +x /usr/local/bin/linuxcnc-entrypoint.sh

# Fire it up!
ENTRYPOINT ["linuxcnc-entrypoint.sh"]
CMD ["start"]

# Fin
