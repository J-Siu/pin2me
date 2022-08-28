#!bash

DIR_SCRIPT=$(dirname -- "$0")
source $DIR_SCRIPT/buildCommon.sh

APP_NAME=${PWD##*/}
BASE_HREF="/"

prepExt
flutter clean

# Build extension for release
BUILD_OPTION="$RENDERER_HTML $CSP"
prepExtChrome
extBuild chrome
extZip chrome

BUILD_OPTION="$RENDERER_HTML $CSP"
prepExtMoz
extBuild moz
extZip moz

# Build extension for debug/profiling
BUILD_OPTION="$RENDERER_HTML $CSP $PROFILE"
prepExtChromeTest
extBuild chrome.profile

BUILD_OPTION="$RENDERER_HTML $CSP $PROFILE"
prepExtMoz
extBuild moz.profile

# switch back to web
prepWeb