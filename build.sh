#!/usr/bin/env bash

# Allocate rootfs disk
fallocate -l 4G output/arch-rootfs.ext4
mkfs.ext4 output/arch-rootfs.ext4

# Mount rootfs to arch
mkdir -p arch
sudo mount output/arch-rootfs.ext4 arch

# Build rootfs with pacstrap
sudo scripts/build-arch-rootfs.sh
sudo umount arch

# Build kernel
scripts/build-arch-kernel.sh

sudo chmod 777 output/*
