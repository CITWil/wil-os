#!/bin/bash

if [ ! -f /etc/arch-release ]; then
    echo "This script only works on Arch-based systems."
    exit 1
else
    echo "Welcome to Arch"
fi
paru -Sy trizen --noconfirm
trizen -Sy electron25-bin --noedit --noconfirm --noinfo
trizen -Sy prospect-mail --noedit --noconfirm --noinfo
trizen -Sy owa-desktop-bin --noedit --noconfirm --noinfo
trizen -Sy android-messages-desktop-bin --noedit --noconfirm --noinfo

#distrobox-export -a AndroidMessage
#distrobox-export -a prospect-mail
distrobox-export -a owa-desktop