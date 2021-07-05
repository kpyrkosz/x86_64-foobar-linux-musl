#!/bin/bash

THIS_PACKAGE=bzip
. "$(dirname "$0")/validate_and_cd_into.sh"

make -f -e Makefile-libbz2_so
make -e clean
make -e -j"$PARALLEL_JOBS"
make -e PREFIX=/usr install
