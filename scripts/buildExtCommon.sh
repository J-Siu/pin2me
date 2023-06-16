DIR_SCRIPT=$(dirname -- "$0")
source $DIR_SCRIPT/buildCommon.sh

SCRIPT_BUILD_EXT_COMMON="$DIR_SCRIPT/buildExtCommon.sh"

DIR_TARGET_BASE=~/Downloads/${APP_NAME}

# Extension base href must be /
BASE_HREF="/"
# Extension must use $RENDERER_HTML $CSP
BUILD_OPTION_BASE="web --base-href=$BASE_HREF $RENDERER_HTML $CSP"
# BUILD_OPTION Control by buildExt and buildExtProfile
BUILD_OPTION=""

# $1 = BUILD_TYPE
function _buildExt {
	BUILD_TYPE=$1
	DIR_TARGET=$DIR_TARGET_BASE/$BUILD_TYPE

	BUILD_CMD="flutter build $BUILD_OPTION"
	echo $BUILD_CMD
	$BUILD_CMD
	delCanvaskit
	delFlutterJs
	# mkdir target location
	rm -rf ${DIR_TARGET}
	mkdir -p ${DIR_TARGET}
	# cp to target location
	cp -r build/web/* ${DIR_TARGET}/
}

# $1
function buildExt {
	BUILD_TYPE=$1
	local LOG_PREFIX="=== $SCRIPT_BUILD_EXT_COMMON: buildExt $BUILD_TYPE"
	echo $LOG_PREFIX

	BUILD_OPTION="$BUILD_OPTION_BASE"
	_buildExt $BUILD_TYPE

	echo $LOG_PREFIX $LOG_END
}

# $1
function buildExtProfile {
	BUILD_TYPE=$1
	local LOG_PREFIX="=== $SCRIPT_BUILD_EXT_COMMON: buildExtProfile $BUILD_TYPE"
	echo $LOG_PREFIX

	BUILD_OPTION="$BUILD_OPTION_BASE $PROFILE"
	_buildExt $BUILD_TYPE

	echo $LOG_PREFIX $LOG_END
}

# $1
function extZip {
	BUILD_TYPE=$1
	local LOG_PREFIX="=== $SCRIPT_BUILD_EXT_COMMON: extZip $BUILD_TYPE"
	echo $LOG_PREFIX

	DIR_CUR=$PWD
	DIR_TARGET=$DIR_TARGET_BASE/$BUILD_TYPE
	FILE_ZIP=$DIR_TARGET_BASE/$BUILD_TYPE.zip
	cd $DIR_TARGET
	# clean dir
	rm -rf .DS_Store */.DS_Store */*/.DS_Store
	# clean old zip
	rm -rf $FILE_ZIP
	# create zip
	zip -r $FILE_ZIP *
	echo Zip created: $FILE_ZIP
	cd $DIR_CUR

	echo $LOG_PREFIX $LOG_END
}

function buildExtChrome {
	echo
	echo --- Build Chrome extension for release
	echo
	BUILD_TYPE=ext.chrome
	prepSrc $BUILD_TYPE
	buildExt $BUILD_TYPE
	extZip $BUILD_TYPE
}

function buildExtChromeTest {
	echo
	echo --- Build Chrome extension for debug/profiling
	echo
	BUILD_TYPE=ext.chrome.test
	prepSrc $BUILD_TYPE
	buildExtProfile $BUILD_TYPE
}

function buildExtMoz {
	echo
	echo --- Build Firefox extension for release
	echo
	BUILD_TYPE=ext.moz
	prepSrc $BUILD_TYPE
	buildExt $BUILD_TYPE
	extZip $BUILD_TYPE
}

function buildExtMozTest {
	echo
	echo --- Build Firefox extension for debug/profiling
	echo
	BUILD_TYPE=ext.moz
	prepSrc $BUILD_TYPE
	buildExtProfile $BUILD_TYPE.test
}
