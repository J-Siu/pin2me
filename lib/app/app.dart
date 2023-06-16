import 'package:lazy_ui_utils/lazy_ui_utils.dart' as lazy;
import 'ui/ui.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget home = MultiProvider(
      providers: [
        ValueListenableProvider.value(value: globalLazySignIn.isSignedIn),
        ListenableProvider.value(value: globalOptionService),
        ListenableProvider.value(value: globalOptionUI),
        ListenableProvider.value(value: globalSites),
        ListenableProvider.value(value: globalWidgetSites),
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
