#!/bin/bash
ipsec initnss
systemctl enable ipsec --now
firewall-cmd --add-service="ipsec"
firewall-cmd --runtime-to-permanent