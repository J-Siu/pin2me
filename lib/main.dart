import 'app/app.dart';
import 'package:flutter/material.dart';
import 'package:lazy_log/lazy_log.dart' as lazy;
import 'package:pin2me/app/ui/ui.dart';

void main() async {
  String debugPrefix = 'main()';
  lazy.logEnable = true;
  lazy.log('$debugPrefix:uri.base:${Uri.base}', forced: true);
  lazy.log('$debugPrefix:uri.base.scheme:${Uri.base.scheme}', forced: true);

  globalLazyAbout.author = 'By: John Siu';
  globalLazyAbout.blog = 'JSiu.Dev';
  globalLazyAbout.blogUrl = 'https://jsiu.dev/';
  globalLazyAbout.copyright = 'Copyright © 2022';
  globalLazyAbout.license = 'MIT License';
  globalLazyAbout.privacyPolicyUrl =
      'https://johnsiu.com/privacy_policy/pin2me/';
  globalLazyAbout.project = 'Pin2Me';
  globalLazyAbout.repo = 'Github';
  globalLazyAbout.repoUrl = 'https://github.com/j-siu/pin2me/';
  globalLazyAbout.title = 'Pin2Me';
  globalLazyAbout.version = '1.0.25';

  // Pre-loading all options to prevent widget rebuild trigger by notification
  await globalOptionUI.load();
  await globalOptionService.load();
  lazy.logEnable = globalOptionService.debug;
  if (globalOptionService.gSync) {
    await globalLazySignIn.signInHandler();
    globalLazyGSync.enableLocalSaveNotifier = globalOptionService.gSync;
    globalLazyGSync.enableAutoSync = globalOptionService.gSyncAuto;
    // lazy.log(
    //     '$debugPrefix:globalLazySignIn.msg.value.status:${globalLazySignIn.msg.value.status}',
    //     forced: true);
    // lazy.log(
    //     '$debugPrefix:globalLazySignIn.msg.value.token:${globalLazySignIn.msg.value.token}',
    //     forced: true);
  }
  runApp(const MyApp());
}
