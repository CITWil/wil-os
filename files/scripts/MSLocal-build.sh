#!/bin/bash

set -ouex pipefail

### Install packages
curl -L -o /etc/yum.repos.d/microsoft-rhel9.0-prod.repo https://packages.microsoft.com/yumrepos/microsoft-rhel9.0-prod/config.repo
curl -o /etc/yum.repos.d/microsoft-edge.repo https://packages.microsoft.com/yumrepos/edge/config.repo

# Undo the work of good open source maintainers https://github.com/ublue-os/bluefin-lts/pull/425
# Required because the Microsoft packages are an absolute joke
rm /opt && mkdir /opt #&& mkdir /var/opt
dnf install -y microsoft-edge-beta
mv /opt/microsoft /usr/lib/opt/microsoft
ln -s /usr/lib/opt/microsoft /var/opt/microsoft
ls -l /var/opt
ls -l /usr/lib/opt
rm -rf /opt && ln -s /var/opt /opt
ls -l /var/opt