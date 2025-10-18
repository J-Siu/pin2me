# BUILD_TYPE
EXT_CHROME="ext.chrome"
EXT_CHROME_TEST="$EXT_CHROME.test"
EXT_MOZ="ext.moz"
EXT_MOZ_TEST="$EXT_MOZ.test"

DIR_SCRIPT=$(dirname -- "$0")
source $DIR_SCRIPT/buildCommon.sh

SCRIPT_BUILD_EXT_COMMON="$DIR_SCRIPT/buildExtCommon.sh"

DIR_TARGET_BASE=~/Downloads/${APP_NAME}

# Extension base href must be /
BASE_HREF="/"
# Extension must use $RENDERER_HTML $CSP
BUILD_OPTION_BASE="web --base-href=$BASE_HREF $CSP --no-web-resources-cdn"
# BUILD_OPTION Control by buildExt and buildExtProfile
BUILD_OPTION=""

# $1 = BUILD_TYPE
function _buildExt {
	BUILD_TYPE=$1
	DIR_TARGET=$DIR_TARGET_BASE/$BUILD_TYPE

	BUILD_CMD="flutter build $BUILD_OPTION"
	echo $BUILD_CMD
	$BUILD_CMD
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

mvExt() {
	BUILD_TYPE=$1
	DIR_TARGET=$DIR_TARGET_BASE/$BUILD_TYPE
	echo $BUILD_CMD
	rm -rf ${DIR_TARGET}
	mkdir -p ${DIR_TARGET}
	cp -r build/web/* "$DIR_TARGET/"
	if [ "$BUILD_TYPE" == "$EXT_MOZ" ]; then
		mv "$DIR_TARGET/index.html" "$DIR_TARGET/your_page.html"
	fi
}

# $1
function extZip {
	BUILD_TYPE=$1
	local LOG_PREFIX="=== $SCRIPT_BUILD_EXT_COMMON: extZip $BUILD_TYPE"
	echo $LOG_PREFIX

	# DIR_CUR=$PWD
	DIR_TARGET=$DIR_TARGET_BASE/$BUILD_TYPE
	FILE_ZIP=$DIR_TARGET_BASE/$BUILD_TYPE.zip
	(
		cd $DIR_TARGET
		# clean dir
		rm -rf .DS_Store */.DS_Store */*/.DS_Store
		# clean old zip
		rm -rf $FILE_ZIP
		# create zip
		zip -r $FILE_ZIP *
		echo Zip created: $FILE_ZIP
	)
	echo $LOG_PREFIX $LOG_END
}

buildExtX() {
	BUILD_TYPE="$1"
	echo
	echo --- Build $BUILD_TYPE
	echo
	prepSrc $BUILD_TYPE
	buildExt $BUILD_TYPE
	cpExt $BUILD_TYPE
	extZip $BUILD_TYPE
}

function buildExtChrome {
	echo
	echo --- Build Chrome extension for release
	echo
	buildExtX ext.chrome
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
	buildExtX $EXT_MOZ
}

function buildExtMozTest {
	echo
	echo --- Build Firefox extension for debug/profiling
	echo
	prepSrc $EXT_MOZ
	buildExtProfile $EXT_MOZ_TEST
}
