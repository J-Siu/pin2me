DIR_SCRIPT=$(dirname -- "$0")
source $DIR_SCRIPT/buildCommon.sh

SCRIPT_BUILD_EXT_COMMON="$DIR_SCRIPT/buildExtCommon.sh"

DIR_TARGET_BASE=~/Downloads/${APP_NAME}

# Extension base href must be /
BASE_HREF="/"
# Extension must use $RENDERER_HTML $CSP
BUILD_OPTION_BASE="web --base-href=$BASE_HREF $CSP --no-web-resources-cdn"
# BUILD_OPTION Control by buildExt and buildExtProfile
BUILD_OPTION="$BUILD_OPTION_BASE"

# Copy extension from build/web to target location
extCopy() {
	BUILD_TYPE=$1
	local LOG_PREFIX="=== $SCRIPT_BUILD_EXT_COMMON: extCopy $BUILD_TYPE"
	echo $LOG_PREFIX

	DIR_TARGET=$DIR_TARGET_BASE/$BUILD_TYPE
	echo $BUILD_CMD
	rm -rf ${DIR_TARGET}
	mkdir -p ${DIR_TARGET}
	cp -r build/web/* "$DIR_TARGET/"
	if [ "$BUILD_TYPE" == "$EXT_MOZ" ]; then
		mv "$DIR_TARGET/index.html" "$DIR_TARGET/your_page.html"
	fi

	echo $LOG_PREFIX $LOG_END
}

# $1
extZip() {
	BUILD_TYPE=$1
	local LOG_PREFIX="=== $SCRIPT_BUILD_EXT_COMMON: extZip $BUILD_TYPE"
	echo $LOG_PREFIX

	# DIR_CUR=$PWD
	DIR_TARGET=$DIR_TARGET_BASE/$BUILD_TYPE
	FILE_ZIP=$DIR_TARGET_BASE/$BUILD_TYPE.zip
	(
		cd $DIR_TARGET
		pwd
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

# $1 = BUILD_TYPE
extBuild() {
	BUILD_TYPE=$1
	local LOG_PREFIX="=== $SCRIPT_BUILD_EXT_COMMON: buildExt $BUILD_TYPE"
	echo $LOG_PREFIX

	DIR_TARGET=$DIR_TARGET_BASE/$BUILD_TYPE
	BUILD_CMD="flutter build $BUILD_OPTION"
	echo $BUILD_CMD
	$BUILD_CMD

	echo $LOG_PREFIX $LOG_END
}

# $1 = BUILD_TYPE
buildExt() {
	BUILD_TYPE="$1"
	local LOG_PREFIX="=== $SCRIPT_BUILD_EXT_COMMON: buildExt $BUILD_TYPE"
	echo $LOG_PREFIX

	prepSrc $BUILD_TYPE
	extBuild $BUILD_TYPE
	extCopy $BUILD_TYPE
	extZip $BUILD_TYPE

	echo $LOG_PREFIX $LOG_END
}

buildExtChrome() {
	echo
	echo --- Build Chrome extension for release
	echo
	buildExt $EXT_CHROME
}

buildExtChromeTest() {
	echo
	echo --- Build Chrome extension for debug/profiling
	echo
	BUILD_OPTION="$BUILD_OPTION $PROFILE"
	buildExt $EXT_CHROME
}

buildExtMoz() {
	echo
	echo --- Build Firefox extension for release
	echo
	buildExt $EXT_MOZ
}

buildExtMozTest() {
	echo
	echo --- Build Firefox extension for debug/profiling
	echo
	BUILD_OPTION="$BUILD_OPTION $PROFILE"
	buildExt $EXT_MOZ_TEST
}
