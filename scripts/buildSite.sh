#!bash

DIR_SCRIPT=$(dirname -- "$0")
source $DIR_SCRIPT/buildCommon.sh
BUILD_OPTION="$RENDERER_HTML"

prepWeb

BASE_HREF="/"

echo "BUILD OPTION: web --base-href=$BASE_HREF $BUILD_OPTION"

flutter build web --base-href=$BASE_HREF $BUILD_OPTION

delCanvaskit

checkFlutterJs

DIR_LOCAL=build/web
DIR_REMOTE='~/data/pin2me/web'
SSH_HOST=js.admin
SCP_CMD="scp -r $DIR_LOCAL $SSH_HOST:$DIR_REMOTE"
echo "clean: $DIR_LOCAL"
rm -rf $DIR_LOCAL/.DS_Store $DIR_LOCAL/*/.DS_Store $DIR_LOCAL/*/*/.DS_Store
echo "clean: $DIR_REMOTE"
ssh $SSH_HOST "rm -rf $DIR_REMOTE"
echo "$SCP_CMD"
$SCP_CMD