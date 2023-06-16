DIR_SCRIPT=$(dirname -- "$0")
source $DIR_SCRIPT/buildCommon.sh

prepSrc web
flutter run -d chrome --web-port 50000 --web-renderer html
