import 'app/app.dart';
import 'package:lazy_log/lazy_log.dart' as lazy;
import 'package:pin2me/app/ui/ui.dart';

void main() async {
  String debugPrefix = 'main()';
  lazy.log('$debugPrefix:uri.base:${Uri.base}', forced: true);
  lazy.log('$debugPrefix:uri.base.scheme:${Uri.base.scheme}', forced: true);

  globalLazyAbout
    ..author = 'By: John Siu'
    ..blog = 'JSiu.Dev'
    ..blogUrl = 'https://jsiu.dev/'
    ..copyright = 'Copyright © 2023'
    ..license = 'MIT License'
    ..privacyPolicyUrl = 'https://johnsiu.com/privacy_policy/pin2me/'
    ..project = 'Pin2Me'
    ..repo = 'Github'
    ..repoUrl = 'https://github.com/j-siu/pin2me/'
    ..title = 'Pin2Me'
    ..version = '2.0.0';

  // Pre-loading all options to prevent widget rebuild trigger by notification
  await globalOptionUI.load();
  await globalOptionService.load();
  lazy.logEnable = globalOptionService.debug;
  if (globalOptionService.gSignIn) {
    globalLazySignIn.signIn().catchError((e) {
      lazy.log('$debugPrefix:$e', forced: true);
    });
  }
  runApp(const MyApp());
}
