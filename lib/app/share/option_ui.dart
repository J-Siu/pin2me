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
    lazy.log('$runtimeType.load()', forced: debugLog);
  }

  bool debugLog = false;

  bool get showName {
    String name = _OptionUIField.showName;
    if (obj[name] == null) {
      obj[name] = true;
    }
    return obj[name];
  }

  set showName(bool v) {
    String name = _OptionUIField.showName;
    if (obj[name] == null || obj[name] != v) {
      obj[name] = v;
      save(debugMsg: '$runtimeType.$name:$v');
      notifyListeners();
    }
  }

  bool get largeIcon {
    String name = _OptionUIField.largeIcon;
    if (obj[name] == null) {
      obj[name] = false;
    }
    return obj[name];
  }

  set largeIcon(bool v) {
    String name = _OptionUIField.largeIcon;
    if (obj[name] == null || obj[name] != v) {
      obj[name] = v;
      save(debugMsg: '$runtimeType.$name:$v');
      notifyListeners();
    }
  }

  bool get lock {
    String name = _OptionUIField.lock;
    if (obj[name] == null) {
      obj[name] = false;
    }
    return obj[name];
  }

  set lock(bool v) {
    String name = _OptionUIField.lock;
    if (obj[name] == null || obj[name] != v) {
      obj[name] = v;
      save(debugMsg: '$runtimeType.$name:$v');
      notifyListeners();
    }
  }
}
