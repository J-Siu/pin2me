import 'package:flutter/material.dart';
import 'package:lazy_collection/lazy_collection.dart' as lazy;
// import 'package:lazy_sign_in/lazy_sign_in.dart' as lazy;
import 'ui/ui.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget home = MultiProvider(
      providers: [
        ListenableProvider.value(value: globalOptionService),
        ListenableProvider.value(value: globalOptionUI),
        ListenableProvider.value(value: globalWidgetSites),
        ListenableProvider.value(value: globalSites),
        // ValueListenableProvider<lazy.SignInMsg>.value(
        //     value: globalLazySignIn.msg),
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
