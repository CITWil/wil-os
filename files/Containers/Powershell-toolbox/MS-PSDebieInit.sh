#!/bin/bash
#Mcfly test then install
if [ ! -e "$/usr/local/bin/mcfly" ]; then
    curl -LSfs https://raw.githubusercontent.com/cantino/mcfly/master/ci/install.sh | sh -s -- --git cantino/mcfly
fi
#Powershel Profile setup
cp /home/wmaxwell/VMs/Containers/Powershell-toolbox/profile.ps1 /opt/microsoft/powershell/7/

edge=false
msrepo=false
while test $# -gt 0; do
    case $1 in
        --msrepo | -m)
            msrepo=true
            shift
            ;;
        --edge | -e)
            edge=true
            ;;
        *)
            ;;
    esac
    shift
done

if [ $msrepo = true ]; then
#Microsoft Linux Repo
    curl -sSL -O https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb
fi

if [ $edge = true ]; then
#Microsoft Edge Repo
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo cp /home/wmaxwell/VMs/Containers/Powershell-toolbox/microsoft-edge-dev.list /etc/apt/sources.list.d/
sudo apt-get update
sudo apt-get -y install microsoft-edge-beta #Edge does not Sync on Debian
#distrobox-export -a microsoft-edge-beta
fi

