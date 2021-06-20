#!/bin/bash

if [[ ${BOOTSTRAP_STAGE} != 2 ]]; then
	echo "Sanity check failed, expected to be called at stage 2"
	exit 1
fi

THIS_PACKAGE=bash
. "$(dirname "$0")/validate_and_cd_into.sh"

./configure --prefix=/usr --without-bash-malloc
make -j"$PARALLEL_JOBS"
make install
