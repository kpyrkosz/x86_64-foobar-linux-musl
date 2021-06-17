#!/bin/bash

# Determining sysroot
while [[ -z $LFS_SYSROOT ]]; do
echo "Enter the root directory where YOYO Linux is about to be installed"
	read -r LFS_SYSROOT
	mkdir -pv "${LFS_SYSROOT}"
	if (( $? != 0 )); then
		echo "Unable to create directory \"${LFS_SYSROOT}\""
		unset LFS_SYSROOT
		continue
	fi
	touch "${LFS_SYSROOT}/writetest.$$"
	if (( $? != 0 )); then
		echo "Directory \"${LFS_SYSROOT}\" is not writable for the current user"
		unset LFS_SYSROOT
		continue
	fi
	rm "${LFS_SYSROOT}/writetest.$$"
done
echo "Installing in ${LFS_SYSROOT}"

# Creating basic dirs
dev  etc  home  lib  lib32  lib64  lost+found  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
mkdir -pv "${LFS_SYSROOT}/"{usr/{bin/,lib/,include/,src/,local/},boot/,dev/,etc/,home/,mnt/,opt/,proc/,root/,run/,sbin/,srv/,sys/,tmp/,var/}
ln -sv usr/bin ${LFS_SYSROOT}/bin
ln -sv usr/lib ${LFS_SYSROOT}/lib

echo "Created basic dirs"
