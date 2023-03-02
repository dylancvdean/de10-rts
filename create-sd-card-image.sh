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

# Create the sd card image container.
sudo dd if=/dev/zero of=images/mr-fusion.img bs=12M count=12

# Partition the sd card image.
sudo sfdisk --force images/mr-fusion.img << EOF
start=20240, type=0b
start=2048, size=8192, type=a2
EOF

# Attach the sd card image to a loopback device.
sudo losetup -fP images/mr-fusion.img

# Install the bootloader.
sudo dd if="vendor/bootloader.img" of="/dev/loop0p2" bs=64k
sync

# Create the data partition.
sudo mkfs.vfat -n "RTS" /dev/loop0p1
sudo mkdir -p /mnt/data
sudo mount /dev/loop0p1 /mnt/data

# Copy support files.
sudo cp -r vendor/support/* /mnt/data/

# Copy kernel and initramfs.
sudo cp zImage /mnt/data

# Clean up.
sudo umount /mnt/data
sudo losetup -d /dev/loop0
