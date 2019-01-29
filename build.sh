#!/usr/bin/env bash

docker run -it --rm --privileged \
       -v $(readlink -f scripts):/scripts \
       -v $(readlink -f config):/config  \
       -v $(readlink -f output):/output  \
       base/archlinux bash -c '/scripts/build-arch-rootfs.sh && /scripts/build-arch-kernel.sh '

sudo chmod 777 output/*
