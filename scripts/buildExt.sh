#!bash

DIR_SCRIPT=$(dirname -- "$0")
source $DIR_SCRIPT/buildCommon.sh

BASE_HREF="/"

prepExt
flutter clean

echo
echo --- Build Chrome extension for release
echo
BUILD_OPTION="$RENDERER_HTML $CSP"
prepExtChrome
extBuild chrome
extZip chrome

echo
echo --- Build Firefox extension for release
echo
BUILD_OPTION="$RENDERER_HTML $CSP"
prepExtMoz
extBuild moz
extZip moz

echo
echo --- Build Chrome extension for debug/profiling
echo
BUILD_OPTION="$RENDERER_HTML $CSP $PROFILE"
prepExtChromeTest
extBuild chrome.profile

echo
echo --- Build Firefox extension for debug/profiling
echo
BUILD_OPTION="$RENDERER_HTML $CSP $PROFILE"
prepExtMoz
extBuild moz.profile

# switch back to web
prepWeb