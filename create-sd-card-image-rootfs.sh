#!/bin/bash

# set variables for file paths
zImage="./zImage"
dtb="./socfpga.dtb"
rootfs="./build/buildroot/output/images/rootfs.ext4"
image="sdcard.img"

# create the disk image
dd if=/dev/zero of=$image bs=1M count=128

# partition the disk image
parted $image --script -- mklabel msdos
parted $image --script -- mkpart primary fat32 1 64
parted $image --script -- mkpart primary ext4 65 500


# format the partitions
loopback_dev=$(sudo losetup --find --partscan --show $image)
loopback_dev_p1="${loopback_dev}p1"
loopback_dev_p2="${loopback_dev}p2"

sudo mkfs.vfat -n BOOT $loopback_dev_p1
sudo mkfs.ext4 -L rootfs $loopback_dev_p2

# mount the partitions
boot_mount_point="/mnt/boot"
rootfs_mount_point="/mnt/rootfs"

sudo mkdir -p $boot_mount_point
sudo mount $loopback_dev_p1 $boot_mount_point
sudo mkdir -p $rootfs_mount_point
sudo mount $loopback_dev_p2 $rootfs_mount_point

# copy kernel and device tree blob to boot partition
sudo cp $zImage $boot_mount_point/zImage
sudo cp $dtb $boot_mount_point/socfpga.dtb

# copy root filesystem to rootfs partition
sudo tar -xf $rootfs -C $rootfs_mount_point

# unmount the partitions and cleanup
sudo umount $boot_mount_point
sudo umount $rootfs_mount_point
sudo losetup -d $loopback_dev
sudo rmdir $boot_mount_point $rootfs_mount_point

echo "Done."
