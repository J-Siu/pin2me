import 'api.dart';
import 'dart:convert';
import 'package:lazy_g_sync/lazy_g_sync.dart' as lazy;
import 'package:lazy_log/lazy_log.dart' as lazy;
import 'package:lazy_ui_utils/lazy_ui_utils.dart' as lazy;
import 'ui.dart';

// import 'package:lazy_sign_in/lazy_sign_in.dart' as lazy;
// import 'package:lazy_sign_in_google/lazy_sign_in_google.dart' as lazy;

bool globalDefaultDebug = false;

const int tokenInterval = 50;

final globalLazySignIn = Api(
  clientId: apiClientId,
  scopes: apiScopes,
);
final globalOptionService = OptionService();
final globalOptionUI = OptionUI();
final globalSites = Sites.init(
  preset: sitesPreset,
  filenamePrefix: apiClientId,
);
final globalLazyAbout = lazy.About();
final globalLazyGSync = lazy.GSync(
  getFilename: () => globalSites.keyFilename,
  getLocalContent: () => globalSites.toString(),
  getLocalSaveTime: () => globalSites.lastSaveTime,
  setLocalContent: (content, dateTime) {
    globalSites.noSave(() {
      globalSites
        ..clear()
        ..fromJson(jsonDecode(content));
    });
    globalSites.save(dateTime: dateTime, saveNotify: false);
  },
  localSaveNotifier: globalSites.saveNotifier,
);

final globalWidgetSites = WidgetSites(globalSites);

class Logo {
  static final _logo = {
    'dark': {
      'large': 'img/pin2me-512.png',
      'small': 'img/pin2me-128.png',
    },
    'light': {
      'large': 'img/pin2me-512.png',
      'small': 'img/pin2me-128.png',
    },
  };
  static String get(String themeId, String size) =>
      _logo[themeId]![size] ?? 'img/pin2me-512.png';

  static Widget roundCorner(String themeId) {
    String themeLogo = Logo.get(themeId, 'large');
    return ClipRRect(
      borderRadius: lazy.borderRadius(10),
      child: Image.asset(themeLogo),
    );
  }

  static Widget image(String themeId) {
    String themeLogo = Logo.get(themeId, 'large');
    return Image.asset(themeLogo);
  }

  static Widget icon(String themeId) {
    String themeLogo = Logo.get(themeId, 'large');
    return ImageIcon(Image.asset(themeLogo).image);
  }
}

Widget imageAvatar(Image image) => ClipOval(child: image);

// logic for dialog_setting to turn on sync
void turnOnGSync() {
  lazy.log('settingTurnOnGSync():token:${globalLazySignIn.token}');
  globalLazyGSync
    ..auto = globalOptionService.autoSync
    ..token = globalLazySignIn.token.value
    // enable must be set last, as this may trigger sync
    ..enable = true;
}

// logic for dialog_setting to turn off sync
void turnOffGSync() {
  lazy.log('settingTurnOffGSync()');
  globalLazyGSync
    ..enable = false
    ..token = '';
}
