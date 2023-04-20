DIR_SCRIPT=$(dirname -- "$0")
source $DIR_SCRIPT/buildCommon.sh

SCRIPT_BUILD_EXT_COMMON="scripts/buildExtCommon.sh"

DIR_SCRIPT_EXT=$DIR_SCRIPT/ext
DIR_TARGET_BASE=~/Downloads
DIR_TARGET_EXT=$DIR_TARGET_BASE/${APP_NAME}/ext

# Extension base href must be /
BASE_HREF="/"
# Extension must use $RENDERER_HTML $CSP
BUILD_OPTION_BASE="web --base-href=$BASE_HREF $RENDERER_HTML $CSP"
# BUILD_OPTION Control by extBuild and extBuildProfile
BUILD_OPTION=""

function prepExt {
	echo === $SCRIPT_BUILD_EXT_COMMON: prepExt
	if [ ! -f $DIR_SCRIPT/.current.ext ]; then
		flutter clean
		rm $DIR_SCRIPT/.current.*
		cp $DIR_SCRIPT_EXT/api.dart.ext lib/app/ui/api.dart
		cp $DIR_SCRIPT_EXT/ext.index.html web/index.html
		cp $DIR_SCRIPT_EXT/ext.pubspec.yaml pubspec.yaml
		touch $DIR_SCRIPT/.current.ext
	fi
	echo === $SCRIPT_BUILD_EXT_COMMON: prepExt - End
}

function prepExtChrome {
	echo === $SCRIPT_BUILD_EXT_COMMON: prepExtChrome
	cp $DIR_SCRIPT_EXT/chrome/chrome.manifest.json web/manifest.json
	echo === $SCRIPT_BUILD_EXT_COMMON: prepExtChrome - End
}

function prepExtChromeTest {
	echo === $SCRIPT_BUILD_EXT_COMMON: prepExtChromeTest
	cp $DIR_SCRIPT_EXT/chrome/chrome.test.manifest.json web/manifest.json
	echo === $SCRIPT_BUILD_EXT_COMMON: prepExtChromeTest - End
}

function prepExtMoz {
	echo === $SCRIPT_BUILD_EXT_COMMON: prepExtMoz
	cp $DIR_SCRIPT_EXT/moz/moz.manifest.json web/manifest.json
	echo === $SCRIPT_BUILD_EXT_COMMON: prepExtMoz - End
}

function extBuild {
	echo === $SCRIPT_BUILD_EXT_COMMON: extBuild $1
	BUILD_OPTION="$BUILD_OPTION_BASE"
	_extBuild $1
	echo === $SCRIPT_BUILD_EXT_COMMON: extBuild $1 - End
}

function extBuildProfile {
	echo === $SCRIPT_BUILD_EXT_COMMON: extBuildProfile $1
	BUILD_OPTION="$BUILD_OPTION_BASE $PROFILE"
	_extBuild $1
	echo === $SCRIPT_BUILD_EXT_COMMON: extBuildProfile $1 - End
}

function _extBuild {
	DIR_TARGET=$DIR_TARGET_EXT/$1

	BUILD_CMD="flutter build $BUILD_OPTION"
	echo $BUILD_CMD
	$BUILD_CMD
	delCanvaskit
	delFlutterJs

	# mkdir target location
	mkdir -p ${DIR_TARGET}
	# cp to target location
	cp -r build/web/* ${DIR_TARGET}/
}

function extZip {
	echo === $SCRIPT_BUILD_EXT_COMMON: extZip $1
	DIR_CUR=$PWD

	DIR_TARGET=$DIR_TARGET_EXT/$1
	FILE_ZIP=$DIR_TARGET_EXT/$1.ext.zip
	cd $DIR_TARGET
	# clean dir
	rm -rf .DS_Store */.DS_Store */*/.DS_Store
	# clean old zip
	rm -rf $FILE_ZIP
	# create zip
	zip -r $FILE_ZIP *

	cd $DIR_CUR
	echo Zip created: $FILE_ZIP

	echo === $SCRIPT_BUILD_EXT_COMMON: extZip $1 - End
}
