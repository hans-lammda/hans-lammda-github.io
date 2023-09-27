---
title: Bom Resolver
author: Hans Thorsen Lamm
---

**Bomresolver** backtracks Alpine linux distibution [**Alpine Linux distibution**](https://alpinelinux.org/). 
# Start 
```yaml
$ podman run  --rm docker.io/bomres/base_os_alpine make > Makefile
$ make config
$ vim product/build/base_os/config/packages
$ vim product/build/base_os/config/settings
$ make build
$ make resolve
$ make download_source 

```

Why not a alias ? 

```
alias bom='podman run  --rm docker.io/bomres/base_os_alpine make > Makefile'
```





# Configuration
Two textfiles controls the output of the builder
## Desired SBOM
One entry for each package, critical and important components postfixed with #S

```yaml
# 
# This is the reference image 
#
alpine-base
lighttpd #S

```

## Build Configuration
The settings file control the build 

```yaml

# Mirror of Alpine public repository 
REPO_URL=https://mirror.lammda.se/alpine

# Setting for Alpine

ALPINE_VERSION=3.16
ARCH=x86_64

BUILDER_IMAGE=alpine_builder

BASE_OS_IMAGE=alpine_sandbox_base_os
BASE_OS_VERSION=3.16.1

# Labels in Container
IMAGE_TITLE="Alpine Base OS Image"
IMAGE_CREATED="2022-12-23"
IMAGE_REVISION="A"
IMAGE_VENDOR="Lammda"
IMAGE_VERSION=1
IMAGE_AUTHOR=hans@lammda.se


```


The source code is hosted on [Github](https://github.com/Nordix/bomres).

