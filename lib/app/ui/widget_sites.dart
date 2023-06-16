import 'package:lazy_log/lazy_log.dart' as lazy;
import 'ui.dart';

class WidgetSites extends ChangeNotifier {
  final List<Widget> _siteWidgets = <Widget>[];
  final Sites _sites;

  WidgetSites(this._sites) {
    for (int i = 0; i < _sites.length; i++) {
      addSite(_sites[i]);
    }
    _sites.msg.addListener(() {
      _sitesMsgHandler(_sites.msg.value);
    });
  }

  List<Widget> get list => _siteWidgets;

  void addSite(Site site) {
    Widget siteWidget = MultiProvider(
      providers: [
        ListenableProvider<Site>.value(value: site),
        ValueListenableProvider<String>.value(value: site.iconBase64Notifier)
      ],
      builder: (context, widget) => const WidgetSite(),
    );
    // Widget siteWidget = ListenableProvider<Site>.value(
    //   value: site,
    //   builder: (context, widget) => const SiteWidget(),
    // );
    _siteWidgets.add(siteWidget);
    notifyListeners();
  }

  void _sitesMsgHandler(SitesMsg msg) {
    String debugPrefix = '$runtimeType._siteHandler()';
    lazy.log('$debugPrefix:${msg.action}');
    switch (msg.action) {
      case SitesAction.clear:
        _siteWidgets.clear();
        notifyListeners();
        break;
      case SitesAction.add:
        if (msg.site != null) {
          addSite(msg.site as Site);
        }
        break;
      case SitesAction.remove:
        _siteWidgets.removeAt(msg.index);
        notifyListeners();
        break;
      case SitesAction.reorder:
        if (msg.indexNew != null && msg.indexOld != null) {
          Widget siteWidget = _siteWidgets.removeAt(msg.indexOld!);
          _siteWidgets.insert(msg.indexNew!, siteWidget);
          notifyListeners();
        }
        break;
      default:
        lazy.log('$debugPrefix:${msg.action}->default do nothing');
        break;
    }
  }

  void reorder(int indexOld, int indexNew) {
    lazy.log('$runtimeType.reorder()');
    _sites.reorder(indexOld, indexNew);
  }
}
