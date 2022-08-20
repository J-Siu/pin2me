#!bash

DIR_SCRIPT=$(dirname -- "$0")
source $DIR_SCRIPT/buildCommon.sh
BUILD_OPTION=""

prepWeb

BASE_HREF="/"

echo "BUILD OPTION: web --base-href=$BASE_HREF $BUILD_OPTION"

flutter build web --base-href=$BASE_HREF $BUILD_OPTION

delCanvaskit

checkFlutterJs

echo ssh
ssh js.admin 'rm -rf ~/data/pin2me/web'
echo scp
scp -r build/web js.admin:~/data/pin2me/web
