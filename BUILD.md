<!-- TOC -->

- [Environment](#environment)
- [Flutter](#flutter)
- [Build Script](#build-script)
- [Build](#build)
  - [Web](#web)
  - [Extension](#extension)
    - [Production](#production)
    - [Non-minify / Profile](#non-minify--profile)
      - [Chrome](#chrome)
      - [Firefox](#firefox)

<!-- /TOC -->

### Environment

Pin2Me is developed in Dart/Flutter.

Build script are written in bash and only work in Linux/MaxOS.

### Flutter

Install Flutter: https://docs.flutter.dev/get-started/install

### Build Script

- Is used due to difference between web, Chrome extension and Firefox extension.
- Switch `pubspec.yaml`, `index.html`, `manifest.json` and `api.dart` accordingly.


### Build
#### Web

On source root:

```sh
scripts/switchWeb.sh
flutter clean
flutter build web
```

Target location:
- `<source root>/build/web`

PS: Do not use `buildDemo.sh` and `buildSite.sh` as they are specific for author's environment/sites only.

#### Extension

Compiled extension are html/javascript only, no web assembly.

##### Production

On source root:

```sh
flutter clean
scripts/buildExt.sh
```

Target location:
- Chrome `~/Download/pin2me/chrome`
- Firefox `~/Download/pin2me/moz`

##### Non-minify / Profile

The only way for Dart/Flutter to build non-minify target is to use `--profile` flag.

###### Chrome
On source root
```sh
scripts/switchExtChrome
flutter clean
flutter build web --profile --web-renderer html
rm build/web/flutter.js
rm -rf build/web/canvaskit
```

###### Firefox
On source root
```sh
scripts/switchExtMoz
flutter clean
flutter build web --profile --web-renderer html
rm build/web/flutter.js
rm -rf build/web/canvaskit
```

Compiled code location:
- `<source root>/build/web`
- Extension `index.html` start `main.dart.js` directly.
- `flutter.js` and `canvaskit/` are not used and can be deleted.
