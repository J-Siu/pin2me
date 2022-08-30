<!-- TOC -->

- [Flutter](#flutter)
- [Build Scripts](#build-scripts)
- [Build](#build)
- [Testing](#testing)
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

Compiled extension are html/javascript only, no web assembly(removed by build script).

Go into source root(`pin2me`):

```sh
cd pin2me
```

Then:

```sh
bash scripts/buildExt.sh
```

Target location:

Platform|Mode|Path|Javascript Minified
---|---|---|---|---
Chrome|Release|`~/Downloads/pin2me/ext/chrome`|yes
Chrome|Profile|`~/Downloads/pin2me/ext/chrome.profile`|no

PS: `buildExt.sh` builds both Chrome and Firefox release and profile targets.

### Testing

In Chrome, enable develope mode in `Extensions` window, then use `Load unpacked`.

- Load `~/Downloads/pin2me/ext/chrome.profile` for local testing.

### Zip Files for Submission

`buildExt.sh` creates zip file for submission from release target.

Zip File Path|Zip File Source
---|---
`~/Downloads/pin2me/ext/chrome.ext.zip`|`~/Downloads/pin2me/ext/chrome`

Create zip manually:
```sh
cd ~/Downloads/pin2me/ext/chrome
zip -r ../chrome.ext.zip *
cd ..
```
