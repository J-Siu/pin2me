#!bash

DIR_SCRIPT=$(dirname -- "$0")
source $DIR_SCRIPT/buildCommon.sh

APP_NAME=${PWD##*/}
BASE_HREF="/"

prepExt
flutter clean

# Build Chrome extension
BUILD_OPTION="$RENDERER_HTML $CSP"
prepExtChrome
buildExt chrome

BUILD_OPTION="$RENDERER_HTML $CSP $PROFILE"
prepExtChromeTest
buildExt chrome.profile

# Build Firefox extension
BUILD_OPTION="$RENDERER_HTML $CSP"
prepExtMoz
buildExt moz

BUILD_OPTION="$RENDERER_HTML $CSP $PROFILE"
prepExtMoz
buildExt moz.profile

# switch back to web
prepWeb