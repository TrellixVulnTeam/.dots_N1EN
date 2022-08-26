#!/bin/bash

set -euo pipefail

emacs_dir=~/src/emacs
if [[ ! -d $emacs_dir ]]; then
  git clone https://git.savannah.gnu.org/git/emacs.git $emacs_dir
fi

cd $emacs_dir

sudo apt install libxpm-dev libgif-dev libjpeg-dev libpng-dev libtiff-dev libx11-dev libncurses5-dev automake autoconf texinfo libgtk2.0-dev autoconf make checkinstall texinfo libxpm-dev libjpeg-dev libgif-dev libtiff-dev libpng-dev libgnutls28-dev libncurses5-dev libjansson-dev libharfbuzz-dev libgccjit-10-dev gcc-10 g++-10
sudo add-apt-repository ppa:ubuntu-toolchain-r/ppa
sudo apt install gcc-10 g++-10 libgccjit0 libgccjit-10-dev libjansson4 libjansson-dev libxml2-dev

export CC=/usr/bin/gcc-10 CXX=/usr/bin/gcc-10
./autogen.sh 
./configure --with-native-compilation --with-xml2
make -j8
sudo make install
