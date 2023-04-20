#!bash

DIR_SCRIPT=$(dirname -- "$0")
source $DIR_SCRIPT/buildExtCommon.sh

prepExt
flutter clean

echo
echo --- Build Chrome extension for release
echo
prepExtChrome
extBuild chrome
extZip chrome

echo
echo --- Build Firefox extension for release
echo
prepExtMoz
extBuild moz
extZip moz

echo
echo --- Build Chrome extension for debug/profiling
echo
prepExtChromeTest
extBuildProfile chrome.profile

echo
echo --- Build Firefox extension for debug/profiling
echo
prepExtMoz
extBuildProfile moz.profile
