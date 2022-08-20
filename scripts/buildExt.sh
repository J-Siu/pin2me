#!bash

DIR_SCRIPT=$(dirname -- "$0")
source $DIR_SCRIPT/buildCommon.sh

APP_NAME=${PWD##*/}
BASE_HREF="/"
BUILD_OPTION="$RENDERER_HTML"

prepExt

rm -rf build

prepExtChrome
buildExt chrome

prepExtMoz
buildExt moz

# chnage back to web
prepWeb
