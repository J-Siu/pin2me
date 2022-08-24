# --- flutter build option - start
# Bundle canvaskit
BUNDLE_CANVASKIT='--dart-define=FLUTTER_WEB_CANVASKIT_URL=/canvaskit/'
# Build for manifest.json content security policy
CSP="--csp"
# dart build don't send analytics data
NO_ANALYTICS="--suppress-analytics"
# dart build don't run pub get before build
NO_PUB="--no-pub"
# Profile
PROFILE="--profile"
# flutter renderer option
RENDERER_CANVAS='--web-renderer canvaskit'
RENDERER_HTML='--web-renderer html'
# generate source map
SRC_MAP="--source-maps"
# --- fluttter build option - end

DIR_SCRIPT=$(dirname -- "$0")
DIR_SCRIPT_EXT=$DIR_SCRIPT/ext
DIR_SCRIPT_WEB=$DIR_SCRIPT/web

function checkFlutterJs {
	if [ ! -f build/web/flutter.js ]; then
		echo flutter.js missing. run 'flutter clean'.
		exit 1
	fi
}

function delCanvaskit {
	rm -rf build/web/canvaskit
}

function prepExtChrome {
	echo prepExtChrome
	cp $DIR_SCRIPT_EXT/chrome/chrome.manifest.json web/manifest.json
}

function prepExtChromeTest {
	echo prepExtChromeTest
	cp $DIR_SCRIPT_EXT/chrome/chrome.test.manifest.json web/manifest.json
}

function prepExtMoz {
	echo prepExtMoz
	echo DIR_SCRIPT: $DIR_SCRIPT
	cp $DIR_SCRIPT_EXT/moz/moz.manifest.json web/manifest.json
}

function prepExt {
	echo prepExt
	echo DIR_SCRIPT: $DIR_SCRIPT
	if [ ! -f $DIR_SCRIPT/.current.ext ]; then
		rm $DIR_SCRIPT/.current.*
		cp $DIR_SCRIPT_EXT/api.dart.ext lib/app/ui/api.dart
		cp $DIR_SCRIPT_EXT/ext.index.html web/index.html
		cp $DIR_SCRIPT_EXT/ext.pubspec.yaml pubspec.yaml
		touch $DIR_SCRIPT/.current.ext
	fi
}

function prepWeb {
	echo prepWeb
	echo DIR_SCRIPT: $DIR_SCRIPT
	if [ ! -f $DIR_SCRIPT/.current.web ]; then
		rm $DIR_SCRIPT/.current.*
		cp $DIR_SCRIPT_WEB/api.dart.webapp lib/app/ui/api.dart
		cp $DIR_SCRIPT_WEB/web.index.html web/index.html
		cp $DIR_SCRIPT_WEB/web.manifest.json web/manifest.json
		cp $DIR_SCRIPT_WEB/web.pubspec.yaml pubspec.yaml
		touch $DIR_SCRIPT/.current.web
	fi
}

function buildExt {
	DIR_TARGET=~/Downloads/${APP_NAME}/$1

	echo "BUILD OPTION: web --base-href=$BASE_HREF $BUILD_OPTION"
	echo "DIR_TARGET: $DIR_TARGET"

	flutter build web --base-href=$BASE_HREF $BUILD_OPTION

	# mkdir target location
	mkdir -p ${DIR_TARGET}
	# cp to target location
	cp -r build/web/* ${DIR_TARGET}/

	# Not use in extension
	rm ${DIR_TARGET}/flutter.js
	rm -rf ${DIR_TARGET}/canvaskit
}
