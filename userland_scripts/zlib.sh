#!/bin/bash

THIS_PACKAGE=zlib
. "$(dirname "$0")/validate_and_cd_into.sh"

./configure --prefix=/usr
make -j"$PARALLEL_JOBS"
make install
