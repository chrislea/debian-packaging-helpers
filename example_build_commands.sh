#!/bin/bash

# Ubuntu Xenial amd64
sbuild \
    --arch=amd64 \
    --dist=xenial \
    --apt-update \
    --apt-upgrade \
    -j$(nproc)

# Ubuntu Precise amd64 using clang-3.4
CC=/usr/bin/clang CXX=/usr/bin/clang++ sbuild \
  --arch=amd64 \
  --dist=precise \
  --apt-update \
  --apt-upgrade \
  --chroot-setup-commands="apt-get -y install clang-3.4" \
  -j$(nproc)

# Debian Wheezy amd64 using clang-3.4
# from the NodeSource repository
CC=/usr/bin/clang CXX=/usr/bin/clang++ sbuild \
  --arch=amd64 \
  --dist=wheezy \
  --apt-update \
  --apt-upgrade \
  --chroot-setup-commands="apt-get -y install curl apt-transport-https ca-certificates" \
  --chroot-setup-commands="echo 'deb https://deb.nodesource.com/clang-3.4 wheezy main' >> /etc/apt/sources.list" \
  --chroot-setup-commands="curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -" \
  --chroot-setup-commands="apt-get update" \
  --chroot-setup-commands="apt-get -y install clang-3.4" \
  -j$(nproc)

# Debian Sid armhf
sbuild \
    --arch=armhf \
    --dist=sid \
    --apt-update \
    --apt-upgrade \
    -j$(nproc)

# Debian Jessie i386
sbuild \
    --arch=i386 \
    --dist=jessie \
    --apt-update \
    --apt-upgrade \
    -j$(nproc)
