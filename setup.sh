#!/bin/bash
# Copyright 2022 Michael Smith <m@hacktheplanet.be>

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3 as published
# by the Free Software Foundation.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301, USA.

#BUILDROOT_VERSION="2020.02.3"
BUILDROOT_VERSION="2022.11"

# Install dependencies
## System packages
sudo apt-get -y install build-essential git libncurses-dev flex bison openssl \
  libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf \
  liblz4-tool bc curl gcc git libssl-dev libncurses5-dev lzop make \
  unzip exfat-utils rsync dosfstools fdisk python3 \
  python3-pip python-is-python3 musl musl-dev musl-tools \
  build-essential python-dev-is-python3 libbz2-dev libsqlite3-dev \
  libreadline-dev libgdbm-dev libdb-dev tk-dev libssl-dev libffi-dev \
  libpng-dev libjpeg-dev libgif-dev gcc-aarch64-linux-gnu \
  liblzma-dev libncursesw5-dev libtinfo-dev \
  gdb lcov pkg-config python3-setuptools \
  libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
  libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev \
  lzma lzma-dev tk-dev uuid-dev zlib1g-dev python-setuptools

## Python packages
sudo pip install --upgrade setuptools numpy matplotlib pip
sudo pip install spdx_lookup pybind11 cppy dl imageop sunaudiodev bsddb185

pushd build

## Buildroot
if [ ! -d buildroot ]
  then
    wget --quiet -c https://buildroot.org/downloads/buildroot-${BUILDROOT_VERSION}.tar.gz
    tar xf buildroot-${BUILDROOT_VERSION}.tar.gz
    mv buildroot-${BUILDROOT_VERSION} buildroot
    rm buildroot-${BUILDROOT_VERSION}.tar.gz
fi
popd

# Copy configuration files
## Buildroot configuration
cp config/buildroot-defconfig build/buildroot/configs/mrfusion_defconfig
## Kernel configuration
cp config/kernel-defconfig build/linux-socfpga/arch/arm/configs/mrfusion_defconfig
## MiSTer installation init script
mkdir -p build/buildroot/board/mrfusion/rootfs-overlay/etc/init.d
cp scripts/S99spectrogram.sh build/buildroot/board/mrfusion/rootfs-overlay/etc/init.d/
