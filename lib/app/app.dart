import 'package:flutter/material.dart';
import 'package:lazy_collection/lazy_collection.dart' as lazy;
import 'package:lazy_sign_in/lazy_sign_in.dart' as lazy;
import 'ui/ui.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    globalLazyAbout.author = 'By: John Siu';
    globalLazyAbout.blog = 'JSiu.Dev';
    globalLazyAbout.blogUrl = 'https://jsiu.dev/';
    globalLazyAbout.copyright = 'Copyright © 2022';
    globalLazyAbout.license = 'MIT License';
    globalLazyAbout.privacyPolicyUrl =
        'https://johnsiu.com/privacy_policy/pin2me/';
    globalLazyAbout.project = 'Pin2Me';
    // globalLazyAbout.repo = 'Github';
    // globalLazyAbout.repoUrl = 'https://github.com/j-siu/pin2me/';
    globalLazyAbout.title = 'Pin2Me';
    globalLazyAbout.version = '1.0.22';

    Widget home = MultiProvider(
      providers: [
        ListenableProvider.value(value: globalOptionService),
        ListenableProvider.value(value: globalOptionUI),
        ListenableProvider.value(value: globalSiteWidgets),
        ListenableProvider.value(value: globalSites),
        ValueListenableProvider<lazy.SignInMsg>.value(
            value: globalLazySignIn.msg),
        Provider(
            create: (_) => [TextEditingController(), TextEditingController()]),
      ],
      child: lazy.themeProvider(
        debugShowCheckedModeBanner: false,
        context: context,
        child: Pin2Me(title: globalLazyAbout.title),
      ),
    );

    return home;
  }
}
