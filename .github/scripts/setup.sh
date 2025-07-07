#!/bin/bash
set -e
useradd -m builduser
echo 'builduser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
chown -R builduser:builduser .