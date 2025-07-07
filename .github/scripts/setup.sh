#!/bin/bash
set -e
pacman -Syu --noconfirm
pacman -S --noconfirm base-devel
useradd -m builduser
echo 'builduser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
chown -R builduser:builduser .