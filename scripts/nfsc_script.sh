#!/bin/bash

yum install nfs-utils -y

systemctl enable firewalld --now
systemctl status firewalld

echo "10.111.177.150:/srv/share/ /mnt nfs vers=3,proto=udp,noauto,x-systemd.automount 0 0" >> /etc/fstab
mount /mnt

systemctl daemon-reload
systemctl restart remote-fs.target


