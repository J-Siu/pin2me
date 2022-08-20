import 'app/app.dart';
import 'package:flutter/material.dart';
import 'package:lazy_log/lazy_log.dart' as lazy;
import 'package:pin2me/app/ui/ui.dart';

void main() async {
  lazy.log('uri.base:${Uri.base}', forced: true);
  lazy.log('uri.base.scheme:${Uri.base.scheme}', forced: true);
  // Pre-loading all options to prevent widget rebuild trigger by notification
  await globalOptionUI.load();
  await globalOptionService.load();
  lazy.logEnable = globalOptionService.debug;
  if (globalOptionService.gSync) {
    await globalLazySignIn.signInHandler();
    globalLazyGSync.enableLocalSaveNotifier = globalOptionService.gSync;
    globalLazyGSync.enableAutoSync = globalOptionService.gSyncAuto;
  }
  runApp(const MyApp());
}
