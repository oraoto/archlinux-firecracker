## ArchLinux on Firecracker

Build ArchLinux rootfs and kernel for [Firecracker](https://github.com/firecracker-microvm/firecracker) using Docker.

## Build

Build linux kernel and rootfs in the `output` directory:

```shell
./build.sh
```

## Network setup

The rootfs is pre-configured with network support according to [Getting Started Firecracker Network Setup](https://github.com/firecracker-microvm/firecracker/blob/master/docs/network-setup.md#on-the-host). Run these commands to setup the host:

```shell
sudo ip tuntap add tap0 mode tap
sudo ip addr add 172.16.0.1/24 dev tap0
sudo ip link set tap0 up
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo iptables -t nat -A POSTROUTING -o enp2s0 -j MASQUERADE
sudo iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i tap0 -o enp2s0 -j ACCEPT
```

## Run

Start firecracker in current directory:

```shell
firecracker --api-sock /tmp/firecracker.socket
```

And in anthor terminal:

```shell
./run.sh
```

