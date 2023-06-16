import 'share.dart';

const String defaultKeyOptionService = 'OptionService';

class _OptionServiceField {
  static const String autoSync = 'autoSync';
  static const String debug = 'debug';
  static const String gSignIn = 'gSignIn';
}

class OptionService extends JsonPreferenceNotify {
  OptionService({String key = defaultKeyOptionService}) : super(key: key);
  OptionService.load({String key = defaultKeyOptionService}) : super(key: key) {
    load();
  }

  bool _get(String name) {
    if (obj[name] == null) {
      obj[name] = false;
    }
    return obj[name];
  }

  _set(String name, bool v) {
    if (obj[name] == null || obj[name] != v) {
      obj[name] = v;
      save(debugMsg: '$runtimeType.$name:$v');
      notifyListeners();
    }
  }

  bool get debug {
    String name = _OptionServiceField.debug;
    return _get(name);
  }

  bool get gSignIn {
    String name = _OptionServiceField.gSignIn;
    return _get(name);
  }

  bool get autoSync {
    String name = _OptionServiceField.autoSync;
    return _get(name);
  }

  set debug(bool v) {
    String name = _OptionServiceField.debug;
    _set(name, v);
  }

  set gSignIn(bool v) {
    String name = _OptionServiceField.gSignIn;
    _set(name, v);
  }

  /// [autoSync] can only be `true` while [gSync] is `true`
  set autoSync(bool v) {
    String name = _OptionServiceField.autoSync;
    _set(name, v);
  }
}
