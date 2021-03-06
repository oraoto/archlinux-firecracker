## ArchLinux on Firecracker

Build ArchLinux rootfs and kernel for [Firecracker](https://github.com/firecracker-microvm/firecracker).

## Build

Build linux kernel and rootfs in the `output` directory:

```shell
scripts/build-arch-kernel.sh
scripts/build-arch-rootfs.sh
```

## Network setup

The rootfs is pre-configured with network support according to [Getting Started Firecracker Network Setup](https://github.com/firecracker-microvm/firecracker/blob/master/docs/network-setup.md#on-the-host). Run these commands to setup the host:

```shell
# change IF to your actual NIC
IF=enp4s0
sudo ip tuntap add tap0 mode tap
sudo ip addr add 172.16.0.1/24 dev tap0
sudo ip link set tap0 up
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo iptables -t nat -A POSTROUTING -o $IF -j MASQUERADE
sudo iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i tap0 -o $IF -j ACCEPT
```

## Run

Start firecracker in current directory:

```shell
firecracker --api-sock /tmp/firecracker.socket --config-file vm-config.json
```

Then you can login as root in the terminal.
