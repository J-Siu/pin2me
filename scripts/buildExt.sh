#!bash

DIR_SCRIPT=$(dirname -- "$0")
source $DIR_SCRIPT/buildCommon.sh

APP_NAME=${PWD##*/}
BASE_HREF="/"

prepExt
flutter clean

# Build Prod
BUILD_OPTION="$RENDERER_HTML $CSP"

prepExtChrome
buildExt chrome

prepExtMoz
buildExt moz

# Build Test
BUILD_OPTION="$RENDERER_HTML $CSP $PROFILE"

prepExtChromeTest
buildExt chrome.profile

prepExtMoz
buildExt moz.profile

# switch back to web
prepWeb