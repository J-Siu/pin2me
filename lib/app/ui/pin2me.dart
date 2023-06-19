import 'package:lazy_log/lazy_log.dart' as lazy;
import 'package:lazy_ui_utils/lazy_ui_utils.dart' as lazy;
import 'package:reorderables/reorderables.dart';
import 'ui.dart';
import 'dart:async';

class Pin2Me extends StatefulWidget {
  final String? title;
  const Pin2Me({Key? key, required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Pin2Me();
}

class _Pin2Me extends State<Pin2Me> {
  ScrollController scrollController = ScrollController();
  Timer? _tokenRefreshTimer;
  bool __tokenRefresh = false;
  bool _menuOpen = false;
  bool debugLog = false;
  final int _tokenRefreshInterval = 30;
  final int minSyncSpinningSeconds = 10;

  @override
  void initState() {
    super.initState();
    _tokenRefreshTimer?.cancel();
    globalLazyGSync.error.addListener(_syncErrorHandler);
    globalLazySignIn.isSignedIn.addListener(_signInHandler);
    globalLazySignIn.token.addListener(_tokenHandler);
  }

  @override
  void dispose() {
    _tokenRefreshTimer?.cancel();
    globalLazyGSync.error.removeListener(_syncErrorHandler);
    globalLazySignIn.isSignedIn.removeListener(_signInHandler);
    globalLazySignIn.token.removeListener(_tokenHandler);
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

    Widget buttonSync = Consumer<bool>(
      builder: (context, isSignedIn, child) {
        List<Widget> children = [];
        if (isSignedIn) {
          children.add(const WidgetSync());
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        );
      },
    );

    Widget widgetAvatar = Consumer<bool>(
      builder: (context, isSignedIn, child) {
        List<Widget> children = [];
        if (isSignedIn) {
          children.add(const WidgetAvatar());
        }
        return Row(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        );
      },
    );

    List<Widget> actions = [];
    if (_menuOpen) {
      actions = [
        buttonAdd,
        buttonHelp,
        buttonSetting,
      ];
    }

    actions
      ..add(buttonSync)
      ..add(buttonMenu)
      ..add(widgetAvatar);

    var appBarTextColor = Theme.of(context).textTheme.bodyLarge?.color;
    AppBar appBar = AppBar(
      actions: actions,
      backgroundColor:
          Theme.of(context).colorScheme.background.withOpacity(0.3),
      foregroundColor: appBarTextColor,
      elevation: 0,
      leading: buttonAbout,
      // title: Text(title),
    );

    Widget spacer = const SizedBox(height: 58, child: Row());

    Widget sitesWrapReorderable() => ReorderableWrap(
          alignment: WrapAlignment.center,
          buildDraggableFeedback: _reorderableWarpFeedback,
          footer: spacer,
          header: [spacer],
          onReorder: Provider.of<WidgetSites>(context).reorder,
          runAlignment: WrapAlignment.start,
          controller: scrollController,
          children: Provider.of<WidgetSites>(context).list,
        );

    Widget sitesWrap() {
      var children = [spacer];
      children.addAll(Provider.of<WidgetSites>(context).list);
      children.add(spacer);
      return SingleChildScrollView(
        controller: scrollController,
        child: Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.start,
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
        controller: scrollController,
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

  void _signInHandler() {
    String debugPrefix = '$runtimeType._signInHandler()';
    lazy.log(debugPrefix);
    if (globalLazySignIn.isSignedIn.value) {
      globalLazySignIn.authorize();
    }
  }

  void _syncErrorHandler() {
    String debugPrefix = '$runtimeType._syncErrorHandler()';
    if (globalLazyGSync.error.value) {
      // Assume token error, clear token
      lazy.log('$debugPrefix: clear token.');
      globalLazySignIn.token.value = '';
    }
  }

  void _tokenHandler() {
    String debugPrefix = '$runtimeType._tokenHandler()';
    lazy.log(debugPrefix);
    if (globalLazySignIn.token.value.isNotEmpty) {
      _tokenRefresh = true;
      // reset GSync error
      turnOnGSync();
    } else {
      _tokenRefresh = false;
      turnOffGSync();
    }
  }

  // Set token refresh timer in minute
  // bool get _tokenRefresh => __tokenRefresh;
  set _tokenRefresh(bool v) {
    String debugPrefix = '$runtimeType._tokenRefresh($v)';
    lazy.log(debugPrefix);
    if (__tokenRefresh != v) {
      __tokenRefresh = v;
      if (v) {
        _tokenRefreshTimer?.cancel();
        _tokenRefreshTimer =
            Timer.periodic(Duration(minutes: _tokenRefreshInterval), (timer) {
          lazy.log('$debugPrefix:authorize()');
          globalLazySignIn.authorize();
        });
      } else {
        // remove listener
        _tokenRefreshTimer?.cancel();
      }
    }
  }
}
