SCRIPT_BUILD_COMMON="scripts/buildCommon.sh"

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

APP_NAME=${PWD##*/}

function checkFlutterJs {
	echo === $SCRIPT_BUILD_COMMON: checkFlutterJs
	if [ ! -f build/web/flutter.js ]; then
		echo flutter.js missing. run 'flutter clean'.
		exit 1
	fi
	echo === $SCRIPT_BUILD_COMMON: checkFlutterJs - End
}

function delCanvaskit {
	echo === $SCRIPT_BUILD_COMMON: delCanvaskit
	rm -rf build/web/canvaskit
	echo === $SCRIPT_BUILD_COMMON: delCanvaskit - End
}

function delFlutterJs {
	echo === $SCRIPT_BUILD_COMMON: delFlutterJs
	rm -rf build/web/flutter.js
	rm -rf build/web/flutter_service_worker.js
	echo === $SCRIPT_BUILD_COMMON: delFlutterJs - End
}
