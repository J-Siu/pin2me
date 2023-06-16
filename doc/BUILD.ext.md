<!-- TOC -->

- [Flutter](#flutter)
- [Build Scripts](#build-scripts)
- [Build](#build)
- [Testing Chrome Extension](#testing-chrome-extension)
- [Testing Firefox Extension](#testing-firefox-extension)
- [Zip Files for Submission](#zip-files-for-submission)

<!-- /TOC -->

### Flutter

Pin2Me is developed in Dart/Flutter.

Install Flutter: https://docs.flutter.dev/get-started/install

### Build Scripts

Build scripts are written in bash and only work in Linux/MaxOS.

Why?
- Due to difference between web, Chrome extension and Firefox extension.
- Switch `pubspec.yaml`, `index.html`, `manifest.json` and `api.dart` according to target.
- Put compiled target into separate directories

### Build

> Compiled extension are html/javascript only, no web assembly(removed by build script).

Go into source root(`pin2me`):

```sh
cd pin2me
```

To compile Chrome extension:

```sh
bash scripts/buildExtChrome.sh
bash scripts/buildExtChromeTest.sh
```

> `buildExtChrome.sh` also creates zip file for submission from release target.

To compile Firefox extension:

```sh
bash scripts/buildExtMoz.sh
bash scripts/buildExtMozTest.sh
```

> `buildExtMoz.sh` also creates zip file for submission from release target.

Target location:

Platform|Mode|Path|Javascript Minified
---|---|---|---
Chrome|Release|`~/Downloads/pin2me/ext.chrome`|yes
Chrome|Profile/Test|`~/Downloads/pin2me/ext.chrome.test`|no
Firefox|Release|`~/Downloads/pin2me/ext.moz`|yes
Firefox|Profile/Test|`~/Downloads/pin2me/ext.moz.test`|no

### Testing Chrome Extension

In Chrome, enable develope mode in `Extensions` window, then use `Load unpacked`.

### Testing Firefox Extension

PS: First tab will be empty or Firefox default page. Open 2nd tab to activate addon. It is known issue on Firefox for this addon.

Testing release version:
```sh
cd ~/Downloads/pin2me/ext.moz
web-ext run
```

Testing profile/test version:
```sh
cd ~/Downloads/pin2me/ext.moz.test
web-ext run
```

### Zip Files for Submission

Zip File Source|Zip File Path
---|---
`~/Downloads/pin2me/ext.chrome`|`~/Downloads/pin2me/ext.chrome.zip`
`~/Downloads/pin2me/ext.moz`|`~/Downloads/pin2me/ext.moz.zip`

Create Chrome extension zip manually:

```sh
cd ~/Downloads/pin2me/ext.chrome
zip -r ../ext.chrome.zip *
cd ..
```

Create Firefox extension zip manually:

```sh
cd ~/Downloads/pin2me/ext.moz
zip -r ../ext.moz.zip *
cd ..
```
