#!bash

DIR_SCRIPT=$(dirname -- "$0")
source $DIR_SCRIPT/buildWebCommon.sh

prepSrc web
buildWeb /

# Update https://pin2me.dev

DIR_LOCAL=build/web
DIR_REMOTE='~/data/pin2me/web'
SSH_HOST=jsiu.dev

# clean local
CMD="rm -rf $DIR_LOCAL/.DS_Store $DIR_LOCAL/*/.DS_Store $DIR_LOCAL/*/*/.DS_Store"
echo "$CMD"
$CMD

# clean remote
CMD="ssh $SSH_HOST rm -rf $DIR_REMOTE"
echo "$CMD"
$CMD

# upload
CMD="scp -r $DIR_LOCAL $SSH_HOST:$DIR_REMOTE"
echo "$CMD"
$CMD
