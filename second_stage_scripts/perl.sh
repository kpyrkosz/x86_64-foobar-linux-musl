#!/bin/bash

if [[ ${BOOTSTRAP_STAGE} != 2 ]]; then
	echo "Sanity check failed, expected to be called at stage 2"
	exit 1
fi

THIS_PACKAGE=perl
. "$(dirname "$0")/validate_and_cd_into.sh"

sh Configure -des                                        \
             -Dprefix=/usr                               \
             -Dvendorprefix=/usr                         \
             -Dprivlib=/usr/lib/perl5/5.32/core_perl     \
             -Darchlib=/usr/lib/perl5/5.32/core_perl     \
             -Dsitelib=/usr/lib/perl5/5.32/site_perl     \
             -Dsitearch=/usr/lib/perl5/5.32/site_perl    \
             -Dvendorlib=/usr/lib/perl5/5.32/vendor_perl \
             -Dvendorarch=/usr/lib/perl5/5.32/vendor_perl
make -j"$PARALLEL_JOBS"
make install
