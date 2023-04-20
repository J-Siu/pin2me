DIR_SCRIPT=$(dirname -- "$0")
source $DIR_SCRIPT/buildCommon.sh

SCRIPT_BUILD_SITE_COMMON="scripts/buildSiteCommon.sh"

DIR_SCRIPT_WEB=$DIR_SCRIPT/web

function prepWeb {
	echo === $SCRIPT_BUILD_SITE_COMMON: prepWeb
	if [ ! -f $DIR_SCRIPT/.current.web ]; then
		flutter clean
		rm $DIR_SCRIPT/.current.*
		cp $DIR_SCRIPT_WEB/api.dart.webapp lib/app/ui/api.dart
		cp $DIR_SCRIPT_WEB/web.index.html web/index.html
		cp $DIR_SCRIPT_WEB/web.manifest.json web/manifest.json
		cp $DIR_SCRIPT_WEB/web.pubspec.yaml pubspec.yaml
		touch $DIR_SCRIPT/.current.web
	fi
	echo === $SCRIPT_BUILD_SITE_COMMON: prepWeb - End
}

function _buildSiteCanvas {
	echo === $SCRIPT_BUILD_SITE_COMMON: _buildSiteCanvas $1

	BASE_HREF="$1"
	BUILD_OPTION="web --base-href=$BASE_HREF $RENDERER_CANVAS"
	BUILD_CMD="flutter build $BUILD_OPTION"
	echo $BUILD_CMD
	$BUILD_CMD

	echo === $SCRIPT_BUILD_SITE_COMMON: _buildSiteCanvas $1 - End
}

function _buildSiteHtml {
	echo === $SCRIPT_BUILD_SITE_COMMON: _buildSiteHtml $1

	BASE_HREF="$1"
	BUILD_OPTION="web --base-href=$BASE_HREF $RENDERER_HTML"
	BUILD_CMD="flutter build $BUILD_OPTION"
	echo $BUILD_CMD
	$BUILD_CMD
	delCanvaskit

	echo === $SCRIPT_BUILD_SITE_COMMON: _buildSiteHtml $1 - End
}

function buildWeb {
	echo === $SCRIPT_BUILD_SITE_COMMON: buildWeb $1

	prepWeb

	# _buildSiteCanvas $1
	_buildSiteHtml $1

	# Occationally flutter.js is missing from build/web
	checkFlutterJs

	echo === $SCRIPT_BUILD_SITE_COMMON: buildWeb $1 - End
}
