#!/usr/bin/env bash

curl --unix-socket /tmp/firecracker.socket -i \
     -X PUT 'http://localhost/boot-source'   \
     -H 'Accept: application/json'           \
     -H 'Content-Type: application/json'     \
     -d '{
          "kernel_image_path": "./output/arch-vmlinux.bin",
          "boot_args": "console=ttyS0 noapic reboot=k panic=1 pci=off nomodules 8250.nr_uarts=1 root=/dev/vda rw"
     }'

curl --unix-socket /tmp/firecracker.socket -i \
     -X PUT 'http://localhost/drives/rootfs' \
     -H 'Accept: application/json'           \
     -H 'Content-Type: application/json'     \
     -d '{
          "drive_id": "rootfs",
          "path_on_host": "./output/arch-rootfs.ext4",
          "is_root_device": true,
          "is_read_only": false
     }'

curl -X PUT \
  --unix-socket /tmp/firecracker.socket \
  http://localhost/network-interfaces/eth0 \
  -H accept:application/json \
  -H content-type:application/json \
  -d '{
      "iface_id": "eth0",
      "guest_mac": "AA:FC:00:00:00:01",
      "host_dev_name": "tap0"
    }'

curl --unix-socket /tmp/firecracker.socket -i  \
    -X PUT 'http://localhost/machine-config' \
    -H 'Accept: application/json'            \
    -H 'Content-Type: application/json'      \
    -d '{
        "vcpu_count": 1,
        "mem_size_mib": 256
    }'

curl --unix-socket /tmp/firecracker.socket -i \
     -X PUT 'http://localhost/actions'       \
     -H  'Accept: application/json'          \
     -H  'Content-Type: application/json'    \
     -d '{
         "action_type": "InstanceStart"
     }'
