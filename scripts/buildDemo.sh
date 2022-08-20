#!bash

DIR_SCRIPT=$(dirname -- "$0")
source $DIR_SCRIPT/buildCommon.sh
BUILD_OPTION=""

APP_NAME=${PWD##*/}
BASE_HREF="/app/${APP_NAME}/"
DIR_DEMO=~/code/public/J-Siu.github.io
DIR_TARGET=${DIR_DEMO}/app

echo "BUILD OPTION: web --base-href=$BASE_HREF $BUILD_OPTION"

prepWeb

flutter build web --base-href=$BASE_HREF $BUILD_OPTION

checkFlutterJs

# clean target location
rm -rf ${DIR_TARGET}/${APP_NAME}
# mkdir target location
mkdir -p ${DIR_TARGET}/${APP_NAME}
# cp to target location
cp -r build/web/* ${DIR_TARGET}/${APP_NAME}/

# Push to github.io
cd ${DIR_DEMO}
git pull gh main
git add .
git commit -m "update ${APP_NAME}"
go-mygit p
