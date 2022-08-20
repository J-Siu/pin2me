import 'package:lazy_log/lazy_log.dart' as lazy;
import 'share.dart';

/// For debug purpose. There should be no individual site saved.
const String defaultPrefKeySiteBase = 'SiteBase';

class SiteBaseFields {
  static const String bmp = 'bmp';
  static const String iconUrl = 'iconUrl';
  static const String name = 'name';
  static const String isPreset = 'isPreset';
  static const String url = 'url';
}

// Site Structure
class SiteBase extends JsonPreferenceNotify {
  SiteBase({
    String key = defaultPrefKeySiteBase,
    String name = '',
    String url = '',
    bool isPreset = false,
  }) : super(key: key) {
    this.name = name;
    this.url = url;
    if (isPreset) this.isPreset = isPreset;
  }

  SiteBase.fromJson(Map<String, dynamic> json,
      {String key = defaultPrefKeySiteBase})
      : super(key: key) {
    fromJson(json);
  }

  SiteBase.clone(Site site, {String key = defaultPrefKeySiteBase})
      : super(key: key) {
    lazy.log('$runtimeType.clone()');
    fromJson(site.toJson());
  }

  String get name {
    String name = SiteBaseFields.name;
    if (obj[name] == null) obj[name] = '';
    return obj[name];
  }

  set name(String v) {
    String name = SiteBaseFields.name;
    if (obj[name] == null || obj[name] != v) {
      obj[name] = v;
    }
  }

  bool get isPreset {
    String name = SiteBaseFields.isPreset;
    if (obj[name] == null) obj[name] = false;
    return obj[name];
  }

  set isPreset(bool v) {
    String name = SiteBaseFields.isPreset;
    if (obj[name] == null || obj[name] != v) {
      obj[name] = v;
    }
  }

  bool get bmp {
    String name = SiteBaseFields.bmp;
    if (obj[name] == null) obj[name] = false;
    return obj[name];
  }

  set bmp(bool v) {
    String name = SiteBaseFields.bmp;
    if (obj[name] == null || obj[name] != v) {
      obj[name] = v;
    }
  }

  String get url {
    String name = SiteBaseFields.url;
    if (obj[name] == null) obj[name] = '';
    return obj[name];
  }

  set url(String v) {
    String name = SiteBaseFields.url;
    if (obj[name] == null || obj[name] != v) {
      obj[name] = v;
    }
  }

  String get iconUrl {
    String name = SiteBaseFields.iconUrl;
    if (obj[name] == null) obj[name] = '';
    return obj[name];
  }

  set iconUrl(String v) {
    String name = SiteBaseFields.iconUrl;
    if (obj[name] == null || obj[name] != v) {
      obj[name] = v;
    }
  }

  /// export() - export name and url only
  Map<String, dynamic> export() {
    return {
      SiteBaseFields.name: name,
      SiteBaseFields.url: url,
      // SiteBaseFields.isPreset: isPreset,
    };
  }
}
