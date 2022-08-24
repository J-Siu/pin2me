#!bash

DIR_SCRIPT=$(dirname -- "$0")
source $DIR_SCRIPT/buildCommon.sh

APP_NAME=${PWD##*/}
BASE_HREF="/"
BUILD_OPTION="$RENDERER_HTML $CSP $PROFILE"

prepExt
flutter clean

prepExtChrome
buildExt chrome

prepExtChromeTest
buildExt chrome.test

prepExtMoz
buildExt moz

# chnage back to web
prepWeb