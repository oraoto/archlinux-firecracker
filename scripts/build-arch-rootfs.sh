#!/usr/bin/env bash

yes y | pacstrap -i -c arch bash filesystem systemd-sysvcompat pacman iproute2

echo "nameserver 1.1.1.1" > arch/etc/resolv.conf

tee arch/etc/systemd/system/firecracker-network.service <<-'EOF'
[Unit]
Description=Firecracker Network

[Service]
Type=oneshot
ExecStart=ip link set eth0 up
ExecStart=ip addr add 172.16.0.2/24 dev eth0
ExecStart=ip route add default via 172.16.0.1 dev eth0
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

ln -s /etc/systemd/system/firecracker-network.service arch/etc/systemd/system/multi-user.target.wants/

# Remove default (locked) root password
# See https://github.com/archlinux/svntogit-packages/commit/0320c909f3867d47576083e853543bab1705185b

sed 's/^root:.*/root::14871::::::/' -i arch/etc/shadow
