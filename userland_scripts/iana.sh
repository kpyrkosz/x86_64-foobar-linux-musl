#!/bin/bash

THIS_PACKAGE=iana
. "$(dirname "$0")/validate_and_cd_into.sh"

cp -va services protocols /etc
