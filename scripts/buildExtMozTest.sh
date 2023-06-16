#!bash

DIR_SCRIPT=$(dirname -- "$0")
source $DIR_SCRIPT/buildExtCommon.sh
buildExtMozTest
