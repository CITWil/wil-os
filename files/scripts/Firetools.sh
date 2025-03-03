#!/bin/bash

git clone https://github.com/netblue30/firetools
cd firetools || exit

./configure --with-qmake=/usr/lib64/qt5/bin/qmake

 make
 sudo make install-strip