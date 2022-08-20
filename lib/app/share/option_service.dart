import 'share.dart';

const String defaultKeyOptionService = 'OptionService';

class _OptionServiceField {
  static const String debug = 'debug';
  static const String gSync = 'gSync';
  static const String gSyncAuto = 'gSyncAuto';
}

class OptionService extends JsonPreferenceNotify {
  OptionService({String key = defaultKeyOptionService}) : super(key: key);
  OptionService.load({String key = defaultKeyOptionService}) : super(key: key) {
    load();
  }

  bool debugLog = false;

  bool get debug {
    String name = _OptionServiceField.debug;
    if (obj[name] == null) {
      debug = false;
    }
    return obj[name];
  }

  set debug(bool v) {
    String name = _OptionServiceField.debug;
    if (obj[name] == null || obj[name] != v) {
      obj[name] = v;
      save(debugMsg: '$runtimeType.$name:$v');
      notifyListeners();
    }
  }

  bool get gSync {
    String name = _OptionServiceField.gSync;
    if (obj[name] == null) {
      gSync = false;
    }
    return obj[name];
  }

  set gSync(bool v) {
    String name = _OptionServiceField.gSync;
    if (obj[name] == null || obj[name] != v) {
      obj[name] = v;
      save(debugMsg: '$runtimeType.$name:$v');
      if (!v) gSyncAuto = false;
      notifyListeners();
    }
  }

  /// [gSyncAuto] can only be `true` while [gSync] is `true`
  bool get gSyncAuto {
    String name = _OptionServiceField.gSyncAuto;
    if (obj[name] == null) {
      gSyncAuto = false;
    }
    return obj[name];
  }

  set gSyncAuto(bool v) {
    String name = _OptionServiceField.gSyncAuto;
    bool value = v && gSync;
    if (obj[name] == null || obj[name] != value) {
      obj[name] = value;
      save(debugMsg: '$runtimeType.$name:$value');
      notifyListeners();
    }
  }
}
