import 'api.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lazy_collection/lazy_collection.dart' as lazy;
import 'package:lazy_g_drive/lazy_g_drive.dart' as lazy;
import 'package:lazy_g_sync/lazy_g_sync.dart' as lazy;
import 'ui.dart';

const String clientId =
    '455194234164-rultqj0bto8jd3dfaopepg1cnguor335.apps.googleusercontent.com';

final globalLazySignIn = Api(
  clientId: clientId,
  scopes: [
    'email',
    'https://www.googleapis.com/auth/drive.appdata',
  ],
);
final globalOptionService = OptionService();
final globalOptionUI = OptionUI();
final globalSites = Sites.init(preset: sitesPreset, filenamePrefix: clientId);
final globalLazyAbout = lazy.About();
final globalLazyGDrive = lazy.GDrive();
final globalLazyGSync = lazy.GSync(
  getFilename: () => globalSites.keyFilename,
  getLocalContent: () => globalSites.toString(),
  getLocalSaveTime: () => globalSites.lastSaveTime,
  lazyGSignIn: globalLazySignIn,
  localSaveNotifier: globalSites.saveNotifier,
  setContent: (content, dateTime) {
    globalSites.noSave(() {
      globalSites
        ..clear()
        ..fromJson(jsonDecode(content));
    });
    globalSites.save(dateTime: dateTime, saveNotify: false);
  },
);

final globalSiteWidgets = SiteWidgets(globalSites);

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
void settingTurnOnGSync() {
  // Set GSync auto sync according to option
  globalLazyGSync.enableAutoSync = globalOptionService.gSyncAuto;
  globalLazyGSync.enableLocalSaveNotifier = true;
  globalOptionService.gSync = true;
}

// logic for dialog_setting to turn off sync
void settingTurnOffGSync() {
  // Turn off GSync auto sync
  globalLazyGSync.enableAutoSync = false;
  globalLazyGSync.enableLocalSaveNotifier = false;
  globalOptionService.gSync = false;
  globalOptionService.gSyncAuto = false;
}
