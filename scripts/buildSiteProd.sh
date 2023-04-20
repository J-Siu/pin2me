#!bash

DIR_SCRIPT=$(dirname -- "$0")
source $DIR_SCRIPT/buildSiteCommon.sh

# build web
buildWeb /

# Update https://pin2me.dev

DIR_LOCAL=build/web
DIR_REMOTE='~/data/pin2me/web'
SSH_HOST=jsiu.dev

# clean local
echo "clean .DS_Store: $DIR_LOCAL"
rm -rf $DIR_LOCAL/.DS_Store $DIR_LOCAL/*/.DS_Store $DIR_LOCAL/*/*/.DS_Store

# clean remote
echo "clean: $SSH_HOST:$DIR_REMOTE"
ssh $SSH_HOST "rm -rf $DIR_REMOTE"

# upload
SCP_CMD="scp -r $DIR_LOCAL $SSH_HOST:$DIR_REMOTE"
echo "$SCP_CMD"
$SCP_CMD