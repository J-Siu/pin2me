import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lazy_cache/lazy_cache.dart' as lazy;
import 'package:lazy_log/lazy_log.dart' as lazy;
import 'share.dart';

/// For debug purpose. There should be no individual site saved.
const String defaultKeySite = 'Site';

final lazy.Cache _localCache = lazy.Cache(keyPrefix: 'icon');

class SiteFields {
  static const String noIcon = 'noIcon';
}

// Site Structure
class Site extends SiteBase {
  // String _iconBase64 = '';
  Site({
    String name = '',
    String url = '',
    String key = defaultKeySite,
  }) : super(key: key) {
    this.name = name;
    this.url = url;
  }

  Site.fromJson(Map<String, dynamic> json, {String key = defaultKeySite})
      : super(key: key) {
    fromJson(json);
  }

  ValueNotifier<String> iconBase64Notifier = ValueNotifier('');
  String get iconBase64 => iconBase64Notifier.value;
  set iconBase64(String v) {
    if (iconBase64Notifier.value.isEmpty || iconBase64Notifier.value != v) {
      iconBase64Notifier.value = v;
      lazy.log(
          '$runtimeType.iconBase64.length:${iconBase64Notifier.value.length}');
    }
  }

  // String get iconBase64 => _iconBase64;
  // set iconBase64(String v) {
  //   if (_iconBase64.isEmpty || _iconBase64 != v) {
  //     _iconBase64 = v;
  //     lazy.log('$runtimeType.iconBase64.length:${_iconBase64.length}');
  //     // updated();
  //     iconBase64Notifier.value++;
  //   }
  // }

  @override
  set iconUrl(String v) {
    String name = SiteBaseFields.iconUrl;
    if (obj[name] == null || obj[name] != v) {
      obj[name] = v;
      updated();
    }
  }

  @override
  set name(String v) {
    String name = SiteBaseFields.name;
    if (obj[name] == null || obj[name] != v) {
      obj[name] = v;
      updated();
    }
  }

  @override
  set url(String v) {
    String name = SiteBaseFields.url;
    if (obj[name] == null || obj[name] != v) {
      obj[name] = v;
      getIcon();
      updated();
    }
  }

  @override
  void fromJson(Map<String, dynamic> jsonObj, {bool debug = false}) {
    // Site should not trigger save, it is Sites job
    noSave(() => super.fromJson(jsonObj, debug: debug));
    getIcon();
  }

  /// [noIcon]: `true` if not getting for this site
  bool get noIcon {
    String name = SiteFields.noIcon;
    if (obj[name] == null) obj[name] = false;
    return obj[name];
  }

  set noIcon(bool v) {
    String name = SiteFields.noIcon;
    if (obj[name] == null || obj[name] != v) {
      obj[name] = v;
    }
  }

  // Get icon
  //  refresh: force get icon
  void getIcon({bool refresh = false}) async {
    String? host = Uri.tryParse(url)?.host;
    String iconUrlNew = "https://icon.horse/icon/$host";

    if ((host != null && host.isNotEmpty) &&
        (refresh || !noIcon) &&
        (refresh || iconBase64.isEmpty || iconUrl != iconUrlNew)) {
      iconUrl = iconUrlNew;

      // Try [lazy.LocalCache] first
      if (refresh) {
        iconBase64 = '';
        await _localCache.set(host, '');
      } else {
        iconBase64 = await _localCache.get(host);
      }
      // Try http if not in [lazy.LocalCache]
      if (iconBase64.isNotEmpty) {
        lazy.log('$runtimeType.getIcon():using _localCache');
      } else {
        // Then http
        http.get(Uri.parse(iconUrl)).then(
          (value) {
            lazy.log('$runtimeType.getIcon($host):using http.get()');
            var body = value.bodyBytes;
            iconBase64 = base64Encode(body);
            // Save to localCache
            _localCache.set(host, iconBase64);
          },
          onError: (e) {
            noIcon = true;
            iconBase64 = '';
            iconUrl = '';
            lazy.log('$runtimeType.getIcon:error:${e.toString()}');
          },
        );
      }
    } else {
      lazy.log('$runtimeType.getIcon():false');
    }
  }

  void updated() {
    notifyListeners();
  }
}
