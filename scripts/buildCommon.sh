SCRIPT_BUILD_COMMON="scripts/buildCommon.sh"
DIR_SCRIPT_SRC=$DIR_SCRIPT/src
APP_NAME=${PWD##*/}
LOG_END="- End"
# Use local flutter_lazy library if LOCAL=".local"
# LOCAL=".local"

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
# generate source map
SRC_MAP="--source-maps"
# --- fluttter build option - end

function checkFlutterJs {
	local LOG_PREFIX="=== $SCRIPT_BUILD_COMMON:checkFlutterJs"
	echo $LOG_PREFIX
	if [ ! -f build/web/flutter.js ]; then
		echo flutter.js missing. run 'flutter clean'.
		exit 1
	fi
	echo $LOG_PREFIX $LOG_END
}

function delCanvaskit {
	local LOG_PREFIX="=== $SCRIPT_BUILD_COMMON:delCanvaskit"
	echo $LOG_PREFIX
	rm -rf build/web/canvaskit
	echo $LOG_PREFIX $LOG_END
}

function delFlutterJs {
	local LOG_PREFIX="=== $SCRIPT_BUILD_COMMON:delFlutterJs"
	echo $LOG_PREFIX
	rm -rf build/web/flutter.js
	rm -rf build/web/flutter_service_worker.js
	echo $LOG_PREFIX $LOG_END
}

# Prepare source tree base on build type
# $1 = BUILD_TYPE:
#		ext.chrome      = Chrome extension
#		ext.chrome.test = Chrome extension for test
#		ext.moz         = Firefox extension
#		web             = webapp
function prepSrc {
	BUILD_TYPE=$1
	local LOG_PREFIX="=== $SCRIPT_BUILD_COMMON:prepSrc $BUILD_TYPE $LOCAL"
	echo $LOG_PREFIX
	FILE_API="$BUILD_TYPE.api"
	FILE_INDEX="$BUILD_TYPE.index.html"
	FILE_MANIFEST="$BUILD_TYPE.manifest.json"
	FILE_PUBSPEC="$BUILD_TYPE.pubspec$LOCAL.yaml"
	cp $DIR_SCRIPT_SRC/$FILE_API lib/app/ui/api.dart
	cp $DIR_SCRIPT_SRC/$FILE_INDEX web/index.html
	cp $DIR_SCRIPT_SRC/$FILE_MANIFEST web/manifest.json
	cp $DIR_SCRIPT_SRC/$FILE_PUBSPEC pubspec.yaml
	rm $DIR_SCRIPT/.current.*
	touch $DIR_SCRIPT/$FILE_LOCK
	flutter pub get
	echo $LOG_PREFIX $LOG_END
}
