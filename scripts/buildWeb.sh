#!bash

DIR_SCRIPT=$(dirname -- "$0")
source $DIR_SCRIPT/buildWebCommon.sh

prepSrc $WEB
buildWeb /
