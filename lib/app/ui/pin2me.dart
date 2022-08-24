// import 'package:lazy_sign_in/lazy_sign_in.dart' as lazy;
import 'package:flutter/material.dart';
import 'package:lazy_collection/lazy_collection.dart' as lazy;
import 'package:lazy_log/lazy_log.dart' as lazy;
import 'package:reorderables/reorderables.dart';
import 'ui.dart';

class Pin2Me extends StatefulWidget {
  final String? title;
  const Pin2Me({Key? key, required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Pin2Me();
}

class _Pin2Me extends State<Pin2Me> {
  bool _menuOpen = false;
  bool debugLog = false;
  final int minSyncSpinningSeconds = 10;

  @override
  void initState() {
    super.initState();
    globalLazyGSync.syncError.addListener(_syncErrorHandler);
  }

  @override
  void dispose() {
    globalLazyGSync.syncError.removeListener(_syncErrorHandler);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // String debugPrefix = '$runtimeType.build';
    String themeId = ThemeProvider.controllerOf(context).currentThemeId;
    double appbarIconSize = lazy.textStyleHeadlineM(context)!.fontSize!;

    Widget logo = SizedBox(
      height: appbarIconSize,
      width: appbarIconSize,
      child: Logo.roundCorner(themeId),
    );
    globalLazyAbout.logo = logo;
    Widget buttonAbout = TextButton(
      onPressed: () => globalLazyAbout.popup(context),
      child: logo,
    );
    Widget buttonAdd = IconButton(
      onPressed: () =>
          dialogSite(context, add: true, title: 'Add', site: Site()),
      icon: const Icon(Icons.add_circle_outlined),
    );
    Widget buttonHelp = IconButton(
      onPressed: () => dialogHelp(context),
      icon: const Icon(Icons.help),
    );
    Widget buttonMenu = IconButton(
      onPressed: () => setState(() => _menuOpen = !_menuOpen),
      icon: Icon((_menuOpen) ? Icons.more_horiz : Icons.more_vert),
    );
    Widget buttonSetting = IconButton(
      onPressed: () => dialogSetting(context),
      icon: const Icon(Icons.settings),
    );
    Widget buttonSync = lazy.SpinningWidget(
      minSyncSpinningSeconds: 10,
      spin: globalLazyGSync.syncing,
      child: IconButton(
        icon: Icon(
          Icons.sync,
          color: (globalLazyGSync.syncError.value) ? Colors.red : null,
        ),
        onPressed: () => globalLazyGSync.sync(),
      ),
    );

    // Display sync button if GDrive sync enabled
    Widget buttonSyncWidget = Consumer<OptionService>(
      builder: (context, option, child) {
        List<Widget> children = [];
        if (option.gSync) {
          children.add(buttonSync);
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        );
      },
    );

    // // Display user avatar if sign-in and available
    // Widget widgetAvatar = Consumer2<OptionService, lazy.SignInMsg>(
    //   builder: (context, option, msg, child) {
    //     List<Widget> children = [];
    //     if (option.gSync &&
    //         // msg.status &&
    //         globalLazySignIn.photoUrl.isNotEmpty) {
    //       children.add(SizedBox(
    //         height: appbarIconSize,
    //         width: appbarIconSize,
    //         child: imageAvatar(Image.network(globalLazySignIn.photoUrl)),
    //       ));
    //     }
    //     return Row(
    //       // mainAxisSize: MainAxisSize.min,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: children,
    //     );
    //   },
    // );
    Widget widgetAvatar = const WidgetAvatar();

    List<Widget> actions = [];
    if (_menuOpen) {
      actions = [
        buttonAdd,
        buttonHelp,
        buttonSetting,
      ];
    }

    actions.add(buttonSyncWidget);
    actions.add(buttonMenu);
    actions.add(widgetAvatar);

    var appBarTextColor = Theme.of(context).textTheme.bodyLarge?.color;
    AppBar appBar = AppBar(
      actions: actions,
      backgroundColor: Theme.of(context).backgroundColor.withOpacity(0.3),
      foregroundColor: appBarTextColor,
      elevation: 0,
      leading: buttonAbout,
      // title: Text(title),
    );

    Widget spacer = SizedBox(height: 58, child: Row());
    // Widget reorderableWarp = Consumer<SiteWidgets>(builder: (
    //   context,
    //   siteWidgets,
    //   child,
    // ) {
    //   return ReorderableWrap(
    //     alignment: WrapAlignment.center,
    //     buildDraggableFeedback: _reorderableWarpFeedback,
    //     footer: spacer,
    //     header: [spacer],
    //     onReorder: siteWidgets.reorder,
    //     runAlignment: WrapAlignment.start,
    //     children: siteWidgets.list,
    //   );
    // });
    Widget sitesWrapReorderable() => ReorderableWrap(
          alignment: WrapAlignment.center,
          buildDraggableFeedback: _reorderableWarpFeedback,
          footer: spacer,
          header: [spacer],
          onReorder: Provider.of<WidgetSites>(context).reorder,
          runAlignment: WrapAlignment.start,
          children: Provider.of<WidgetSites>(context).list,
        );

    Widget sitesWrap() {
      var children = [spacer];
      children.addAll(Provider.of<WidgetSites>(context).list);
      children.add(spacer);
      return SingleChildScrollView(
        child: Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.start,
          // children: Provider.of<WidgetSites>(context).list,
          children: children,
        ),
      );
    }

    Widget sitesList() =>
        Consumer<OptionUI>(builder: (context, optionUI, child) {
          if (optionUI.lock) {
            return sitesWrap();
          } else {
            return sitesWrapReorderable();
          }
        });

    return Scaffold(
      appBar: appBar,
      extendBodyBehindAppBar: true,
      body: Scrollbar(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            physics: const ClampingScrollPhysics(),
            scrollbars: false,
          ),
          // child: Align(
          // child: reorderableWarp,
          child: sitesList(),
          // ),
        ),
      ),
    );
  }

  Widget _reorderableWarpFeedback(
    BuildContext context,
    BoxConstraints constraints,
    Widget child,
  ) {
    // The feedback widget must be material
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: lazy.borderRadius(10),
        child: child,
      ),
    );
  }

  void _syncErrorHandler() async {
    // Trigger setState to change color of the sync icon
    String debugPrefix = '$runtimeType._syncErrorHandler()';
    lazy.log(debugPrefix);
    setState(() {});
  }
}
