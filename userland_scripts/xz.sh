#!/bin/bash

THIS_PACKAGE=xz
. "$(dirname "$0")/validate_and_cd_into.sh"

./configure --prefix=/usr --disable-static
make -j"$PARALLEL_JOBS"
make install
