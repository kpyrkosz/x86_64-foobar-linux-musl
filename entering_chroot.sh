#!/bin/bash

# Hm, I think this should be merged with the previous step because accidentally
# mounting the same target twice breaks up the system
# It would be better to do it "C++ RAII style", mount on enter, umount on exit

# I suspect, if the build were to continue automatically, I should not invoke
# /bin/bash but a script that would run without human interaction inside the chroot
# TODO

. vars.sh

chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /usr/bin/bash --login +h
