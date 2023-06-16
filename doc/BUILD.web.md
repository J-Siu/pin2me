<!-- TOC -->

- [Flutter](#flutter)
- [Build Scripts](#build-scripts)
- [Build](#build)
- [Testing](#testing)

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
Go into source root(`pin2me`):

```sh
cd pin2me
```

Then:

```sh
bash scripts/switchWeb.sh
flutter clean
flutter build web
```

Target location:
- `<source root>/build/web`

PS: Do not use `buildWebDemo.sh` and `buildWebProd.sh` as they are specific for author's environment/sites only.

### Testing

Web page testing can be done in VSCode or flutter directly.

```sh
flutter run
```