FROM docker/for-desktop-kernel:5.15.49-13422a825f833d125942948cf8a8688cef721ead AS ksrc

FROM ubuntu:latest

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

WORKDIR /root
CMD mount -t debugfs debugfs /sys/kernel/debug && /bin/bash
