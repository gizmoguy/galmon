FROM ubuntu:eoan

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8

# This allows you to use a local Ubuntu mirror
ARG APT_URL=
ENV APT_URL ${APT_URL:-http://archive.ubuntu.com/ubuntu/}
RUN sed -i "s%http://archive.ubuntu.com/ubuntu/%${APT_URL}%" /etc/apt/sources.list

# Update packages and install dependencies
RUN apt-get update && apt-get -y upgrade \
    && apt-get install -y protobuf-compiler libh2o-dev libcurl4-openssl-dev \
           libssl-dev libprotobuf-dev libh2o-evloop-dev libwslay-dev \
           libeigen3-dev libzstd-dev libfmt-dev libncurses5-dev \
	       make gcc g++ git build-essential curl autoconf automake help2man \
    && rm -rf /var/lib/apt/lists/*

# Build
ARG MAKE_FLAGS=-j2
ADD . /galmon-src/
WORKDIR /galmon-src/
RUN make $MAKE_FLAGS \
    && prefix=/galmon make install \
    && rm -rf /galmon-src
WORKDIR /galmon/bin
ENV PATH=/galmon/bin:${PATH}
