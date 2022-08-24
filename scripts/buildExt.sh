#!bash

DIR_SCRIPT=$(dirname -- "$0")
source $DIR_SCRIPT/buildCommon.sh

APP_NAME=${PWD##*/}
BASE_HREF="/"

prepExt
flutter clean

BUILD_OPTION="$RENDERER_HTML $CSP"
prepExtMoz
buildExt moz

prepExtChrome
buildExt chrome

BUILD_OPTION="$RENDERER_HTML $CSP $PROFILE"
prepExtChromeTest
buildExt chrome.test

# chnage back to web
prepWeb