#!bash

DIR_SCRIPT=$(dirname -- "$0")
source $DIR_SCRIPT/buildSiteCommon.sh

# Build web

APP="app"
buildWeb "/${APP}/${APP_NAME}/"

# Update https://j-siu.github.io/app/pin2me/

DIR_SITE=~/code/public/J-Siu.github.io
DIR_APP=${DIR_SITE}/${APP}
DIR_DES=${DIR_APP}/${APP_NAME}
DIR_SRC=$(pwd)/build/web

cd ${DIR_SITE}

# Pull from github.io
git pull gh main

# clean target location
rm -rf ${DIR_DES}
# mkdir target location
mkdir -p ${DIR_DES}
# copy to target location
CMD_COPY="cp -r ${DIR_SRC}/* ${DIR_DES}/"
echo $CMD_COPY
$CMD_COPY
# clean .DS_Store
rm -rf .DS_Store */.DS_Store */*/.DS_Store

git add .
git commit -m "update ${APP_NAME}"
go-mygit p
