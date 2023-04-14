FROM docker/for-desktop-kernel:5.15.49-13422a825f833d125942948cf8a8688cef721ead AS ksrc

FROM ubuntu:latest

FROM golang:latest

WORKDIR /
COPY --from=ksrc /kernel-dev.tar /
RUN tar xf kernel-dev.tar && rm kernel-dev.tar

RUN apt-get update
RUN apt install -y kmod python3-bpfcc

COPY hello_world.py /root

RUN mkdir -p /site/ebpf
# Use Alibaba Cloud mirror for ubuntu
#RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list
# Install LLVM 10.0.1
#RUN apt-get update && apt install -y wget lsb-release software-properties-common && wget https://apt.llvm.org/llvm.sh && chmod +x llvm.sh && ./llvm.sh 10
#ENV PATH "$PATH:/usr/lib/llvm-10/bin"

# Build/Install bpftrace
RUN apt-get install -y bpftrace

# Build/Install bcc

#Build/Install golang

RUN apt-get update && apt-get -y install wget vim gcc
#RUN wget https://studygolang.com/dl/golang/go1.17.1.linux-amd64.tar.gz && \
#    tar -C /usr/local -xvzf go1.17.1.linux-amd64.tar.gz && \
#    rm go1.17.1.linux-amd64.tar.gz
#ENV PATH=$PATH:/usr/local/go/bin

#RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list

#RUN apt-get -y install golang

#FROM golang:latest@sha256:729f2ed830b2e1b8df4d6110eaea96acd48650e994522199b4a807d201f16325 as builder

WORKDIR /site/ebpf
CMD mount -t debugfs debugfs /sys/kernel/debug && /bin/bash
