DIR_SCRIPT=$(dirname -- "$0")
source $DIR_SCRIPT/buildCommon.sh

prepSrc $WEB
flutter run -d chrome --web-port 50000 html
