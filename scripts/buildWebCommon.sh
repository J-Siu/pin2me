DIR_SCRIPT=$(dirname -- "$0")
source $DIR_SCRIPT/buildCommon.sh

SCRIPT_BUILD_SITE_COMMON="$DIR_SCRIPT/buildWebCommon.sh"

DIR_TARGET_BASE=~/Downloads/${APP_NAME}

# $1 = BASE_HREF
_buildWebCanvas() {
	BASE_HREF="$1"
	local LOG_PREFIX="=== $SCRIPT_BUILD_SITE_COMMON: _buildWebCanvas $BASE_HREF"
	echo $LOG_PREFIX

	BUILD_OPTION="web --base-href=$BASE_HREF"
	BUILD_CMD="flutter build $BUILD_OPTION"
	echo $BUILD_CMD
	$BUILD_CMD

	echo $LOG_PREFIX $LOG_END
}

# $1 = BASE_HREF
_buildWebHtml() {
	BASE_HREF="$1"
	local LOG_PREFIX="=== $SCRIPT_BUILD_SITE_COMMON: _buildWebHtml $BASE_HREF"
	echo $LOG_PREFIX

	BUILD_OPTION="web --base-href=$BASE_HREF $RENDERER_HTML"
	BUILD_CMD="flutter build $BUILD_OPTION"
	echo $BUILD_CMD
	$BUILD_CMD
	delCanvaskit

	echo $LOG_PREFIX $LOG_END
}

# $1 = BASE_HREF
buildWeb() {
	BASE_HREF="$1"
	local LOG_PREFIX="=== $SCRIPT_BUILD_SITE_COMMON: buildWeb $BASE_HREF"
	echo $LOG_PREFIX

	# _buildWebCanvas $BASE_HREF
	_buildWebHtml $BASE_HREF

	# Occationally flutter.js is missing from build/web
	checkFlutterJs

	echo $LOG_PREFIX $LOG_END
}
