FROM docker/for-desktop-kernel:5.15.49-pr-704f10d9d090a85069f63d0cad4dc557a64e8cc7 AS ksrc

FROM ubuntu:20.04 AS bpftrace

FROM golang:latest

WORKDIR /
COPY --from=ksrc /kernel-dev.tar /
RUN tar xf kernel-dev.tar && rm kernel-dev.tar

RUN apt-get update
RUN apt install -y kmod python3-bpfcc

#COPY src/hello_world.py /root

RUN mkdir -p /site/ebpf
# Use Alibaba Cloud mirror for ubuntu
#RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list
# Install LLVM 10.0.1
#RUN apt-get update && apt install -y wget lsb-release software-properties-common && wget https://apt.llvm.org/llvm.sh && chmod +x llvm.sh && ./llvm.sh 10
#ENV PATH "$PATH:/usr/lib/llvm-10/bin"

# Build/Install bpftrace
RUN apt-get install -y bpftrace bcc

# Build/Install bcc

#Build/Install golang

RUN apt-get update && apt-get -y install lsb-release software-properties-common wget vim gcc clang llvm

#RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list

RUN apt-get install -y libbpf-dev apt-file && apt-file update && apt-file list libbpf-dev
#RUN apt-get install -y apt-file
#RUN apt-file update
#RUN apt-file list libbpf-dev


#RUN apt-get -y install golang

RUN go env
# go env环境变量设置
RUN go env -w GOPROXY=https://goproxy.io,direct
RUN go env -w GOSUMDB=sum.golang.google.cn
RUN go env -w GO111MODULE=on #有""不用设置

RUN apt-get install -y libelf-dev bpftool
#RUN git clone https://github.com/libbpf/libbpf.git \
#    && cd libbpf/src && mkdir build root && BUILD_STATIC_ONLY=y OBJDIR=build DESTDIR=root make install
RUN mv /usr/src/linux-headers-5.15.49-linuxkit-pr /usr/src/linux-headers-5.15.49-linuxkit

WORKDIR /site/ebpf
CMD mount -t debugfs debugfs /sys/kernel/debug && /bin/bash
