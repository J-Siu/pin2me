<!-- TOC -->

- [Environment](#environment)
- [Flutter](#flutter)
- [Build Script](#build-script)
- [Build](#build)
  - [Web](#web)
  - [Extension](#extension)

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

From zip:

```sh
unzip pin2me.zip
```

From Github

```sh
git clone https://github.com/J-Siu/pin2me
```

#### Web

Go into source root(`pin2me`):

```sh
cd pin2me
```

Then:

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

Go into source root(`pin2me`):

```sh
cd pin2me
```

Then:

```sh
flutter clean
scripts/buildExt.sh
```

Target location:

Platform|Mode|Path|Javascript Minified
---|---|---|---
Chrome|Release|`~/Download/pin2me/chrome`|yes
Chrome|Profile|`~/Download/pin2me/chrome.profile`|no
Firefox|Release|`~/Download/pin2me/moz`|yes
Firefox|Profile|`~/Download/pin2me/moz.profile`|no