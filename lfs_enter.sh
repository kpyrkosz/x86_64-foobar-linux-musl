#!/bin/bash

if [[ $# != 2 ]]; then
	echo "Usage: $0 <chroot dir> <program to execute>"
	exit 1
fi

mount -v --bind /dev ${1}/dev
mount -v --bind /dev/pts ${1}/dev/pts
mount -v --bind /proc  ${1}/proc
mount -v --bind /sys  ${1}/sys
mount -v --bind /run  ${1}/run

chroot "$1" /usr/bin/env -i HOME=/root TERM="$TERM" PS1='(lfs chroot) \u:\w\$ ' PATH=/bin:/usr/bin:/sbin:/usr/sbin "$2" --login +h

umount -v ${1}/run
umount -v ${1}/sys
umount -v ${1}/proc
umount -v ${1}/dev/pts
umount -v ${1}/dev
