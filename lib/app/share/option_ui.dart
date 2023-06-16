import 'package:lazy_log/lazy_log.dart' as lazy;
import 'share.dart';

const String defaultKeyOptionUI = 'OptionUI';

class _OptionUIField {
  static const String showName = 'showName';
  static const String largeIcon = 'largeIcon';
  static const String lock = 'lock';
}

class OptionUI extends JsonPreferenceNotify {
  OptionUI({String key = defaultKeyOptionUI}) : super(key: key);
  OptionUI.load({String key = defaultKeyOptionUI}) : super(key: key) {
    load();
  }

  @override
  Future load({bool forced = false}) async {
    await super.load(forced: forced);
    lazy.log('$runtimeType.load()');
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

  bool get showName {
    String name = _OptionUIField.showName;
    return _get(name);
  }

  set showName(bool v) {
    String name = _OptionUIField.showName;
    _set(name, v);
  }

  bool get largeIcon {
    String name = _OptionUIField.largeIcon;
    return _get(name);
  }

  set largeIcon(bool v) {
    String name = _OptionUIField.largeIcon;
    _set(name, v);
  }

  bool get lock {
    String name = _OptionUIField.lock;
    return _get(name);
  }

  set lock(bool v) {
    String name = _OptionUIField.lock;
    _set(name, v);
  }
}
