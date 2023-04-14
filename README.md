# eBPF for Docker Desktop on macOS

#copy from https://github.com/singe/ebpf-docker-for-mac
eBPF and its compiler bcc need access to some parts of the kernel and its headers to work. This image shows how you can do that with Docker Desktop for mac's linuxkit host VM.

## Build the image

Done quite simply with:

`docker build -t ebpf-for-mac .`

## Run the image

It needs to run as privileged, and depending on what you want to do, having access to the host's PID namespace is pretty useful too.

```
docker run -it --rm \ 
  --privileged \ 
  -v /lib/modules:/lib/modules:ro \ 
  -v /etc/localtime:/etc/localtime:ro \ 
  --pid=host \ 
  ebpf-for-mac
```

```
docker run -it --rm \
  --name ebpf-for-mac \
  --privileged \
  -v /lib/modules:/lib/modules:ro \
  -v /etc/localtime:/etc/localtime:ro \
-v /Users/laraveljun/tools/ebpf-docker/src:/site/ebpf \ 
  --pid=host \
  ebpf-for-mac
```

#/Users/laraveljun/tools/ebpf-docker/src:/site/ebpf 把开发目录渲染到docker目录去

Note: /lib/modules probably doesn't exist on your mac host, so Docker will map the volume in from the linuxkit host VM.

## Maintenance

Docker published their for-desktop kernel's [on Docker hub](https://hub.docker.com/r/docker/for-desktop-kernel/tags?page=1&ordering=last_updated) you may need to update the Dockerfile for the latest kernel that matches your linuxkit host VM.
