import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lazy_extensions/lazy_extensions.dart' as lazy;
import 'package:lazy_log/lazy_log.dart' as lazy;
import 'share.dart';

const String defaultKeySites = 'Sites';
const int defaultSitesSaveWaitSeconds = 3;
const int defaultSitesSaveWaitAgainSeconds = 2;

enum SitesAction {
  add,
  clear,
  insert,
  remove,
  removeAt,
  reorder,
  noAction,
}

class SitesField {
  static const String sites = 'sites';
}

class Sites extends JsonPreferenceNotify {
  final ValueNotifier<SitesMsg> msg = ValueNotifier<SitesMsg>(SitesMsg());

  Sites({
    String filenamePrefix = '',
    String key = defaultKeySites,
    int saveWaitAgainSeconds = defaultSitesSaveWaitAgainSeconds,
    int saveWaitSeconds = defaultSitesSaveWaitSeconds,
  }) : super(
          filenamePrefix: filenamePrefix,
          key: key,
          saveWaitAgainSeconds: saveWaitAgainSeconds,
          saveWaitSeconds: saveWaitSeconds,
        );
  Sites.fromJson({
    String filenamePrefix = '',
    String key = defaultKeySites,
    int saveWaitAgainSeconds = defaultSitesSaveWaitAgainSeconds,
    int saveWaitSeconds = defaultSitesSaveWaitSeconds,
    required Map<String, dynamic> json,
  }) : super(
          filenamePrefix: filenamePrefix,
          key: key,
          saveWaitAgainSeconds: saveWaitAgainSeconds,
          saveWaitSeconds: saveWaitSeconds,
        ) {
    fromJson(json);
  }
  Sites.init({
    List<SiteBase> preset = const [],
    String filenamePrefix = '',
    String key = defaultKeySites,
    int saveWaitAgainSeconds = defaultSitesSaveWaitAgainSeconds,
    int saveWaitSeconds = defaultSitesSaveWaitSeconds,
  }) : super(
          filenamePrefix: filenamePrefix,
          key: key,
          saveWaitAgainSeconds: saveWaitAgainSeconds,
          saveWaitSeconds: saveWaitSeconds,
        ) {
    init(preset: preset);
  }

  List<Site> get _sites {
    String name = SitesField.sites;
    if (obj[name] == null) {
      obj[name] = <Site>[];
    }
    return obj[name];
  }

// - List methods
  Site operator [](int i) => _sites[i];
  bool get isEmpty => _sites.isEmpty;
  int get length => _sites.length;
  void forEach(void Function(Site) action) {
    for (var site in _sites) {
      action(site);
    }
  }

  void add(Site site) {
    String debugPrefix = '$runtimeType.add()';
    lazy.log('$debugPrefix:isPreset:${site.isPreset}');
    _sites.add(site);
    // Dialog box don't allow default site edit. Only getIcon() will trigger save.
    // Following is to prevent site.getIcon() from updating lastSaveTime.
    site.addListener(() =>
        save(debugMsg: '$runtimeType listener', noSaveTime: site.isPreset));
    save(debugMsg: debugPrefix);
    msg.value = SitesMsg(action: SitesAction.add, site: site);
  }

  void addByNameUrl(String name, String url) {
    String debugPrefix = '$runtimeType.addByNameUrl()';
    Site site = Site(name: name, url: url);
    lazy.log('$debugPrefix:isPreset:${site.isPreset}');
    _sites.add(site);
    site.addListener(() => save(debugMsg: '$runtimeType listener'));
    save(debugMsg: debugPrefix);
    msg.value = SitesMsg(action: SitesAction.add, site: site);
  }

  void clear() {
    String debugPrefix = '$runtimeType.clear()';
    lazy.log(debugPrefix);
    noSave(() {
      // Cannot use _sites.forEach() as it break down completely
      while (length > 0) {
        removeAt(0);
      }
    });
    save(debugMsg: debugPrefix);
    msg.value = SitesMsg(action: SitesAction.clear);
  }

  void insert(int index, Site site) {
    String debugPrefix = '$runtimeType.insert()';
    lazy.log(debugPrefix);
    _sites.insert(index, site);
    site.addListener(() => save(debugMsg: '$runtimeType listener'));
    save(debugMsg: debugPrefix);
    msg.value = SitesMsg(action: SitesAction.insert, site: site, index: index);
  }

  bool remove(Site site) {
    String debugPrefix = '$runtimeType.remove()';
    lazy.log(debugPrefix);
    int index = _sites.indexOf(site);
    bool isRemoved = _sites.remove(site);
    if (isRemoved) {
      site.removeListener(() => save(debugMsg: '$runtimeType listener'));
      save(debugMsg: debugPrefix);
      msg.value =
          SitesMsg(action: SitesAction.remove, site: site, index: index);
    }
    return isRemoved;
  }

  Site removeAt(int index) {
    String debugPrefix = '$runtimeType.removeAt()';
    lazy.log(debugPrefix);
    Site site = _sites.removeAt(index);
    site.removeListener(() => save(debugMsg: '$runtimeType listener'));
    save(debugMsg: debugPrefix);
    msg.value =
        SitesMsg(action: SitesAction.removeAt, site: site, index: index);
    return site;
  }

  @override
  void fromJson(Map<String, dynamic> jsonObj, {bool debug = false}) {
    String debugPrefix = '$runtimeType.fromJson()';
    lazy.log(debugPrefix);
    noSave(() {
      try {
        for (var jsonSite in jsonObj['sites']) {
          add(Site.fromJson(jsonSite));
        }
      } catch (e) {
        lazy.log('$debugPrefix:$e');
      }
    });
    save(debugMsg: debugPrefix);
  }

// - Custom methods
  void defaultsAdd(
      {List<SiteBase> defaultSites = const [],
      int num = 1,
      DateTime? dateTime}) {
    String debugPrefix = '$runtimeType.defaultsAdd()';

    lazy.log(debugPrefix);
    noSave(() {
      for (int i = 0; i < num; i++) {
        for (var site in defaultSites) {
          add(Site.fromJson(jsonDecode(jsonEncode(site))));
        }
      }
    });
    save(debugMsg: debugPrefix, dateTime: dateTime);
  }

  void defaultsDel() {
    String debugPrefix = '$runtimeType.defaultsDel()';

    lazy.log(debugPrefix);
    noSave(() {
      List<Site> delList = [];
      for (var site in _sites) {
        if (site.isPreset) delList.add(site);
      }
      for (var site in delList) {
        remove(site);
      }
    });
    save(debugMsg: debugPrefix);
  }

  void init({List<SiteBase> preset = const []}) {
    String debugPrefix = '$runtimeType.init()';
    lazy.log(debugPrefix);
    load().then((_) {
      lazy.log('$debugPrefix:load().then()');
      if (isEmpty) {
        lazy.log('$debugPrefix:load().then():addDefault()');
        // If sites is empty, add default with day zero
        defaultsAdd(dateTime: lazy.dayZero, defaultSites: preset);
      } else {
        lazy.log('$debugPrefix:load().then():$length');
      }
    });
  }

  void reorder(int indexOld, int indexNew) async {
    String debugPrefix = '$runtimeType.reorder()';
    lazy.log(debugPrefix);
    noSave(() {
      var site = removeAt(indexOld);
      insert(indexNew, site);
    });
    save(debugMsg: debugPrefix);
    msg.value = SitesMsg(
        action: SitesAction.reorder, indexNew: indexNew, indexOld: indexOld);
  }

  void refreshAllIcons() async {
    String debugPrefix = '$runtimeType.refreshAllIcons()';
    lazy.log(debugPrefix);
    for (var i = 0; i < _sites.length; i++) {
      _sites[i].getIcon(refresh: true);
    }
  }

  void removeDuplicate({bool checkUrlOnly = true}) async {
    String debugPrefix = '$runtimeType.removeDuplicate()';
    Set<Site> toBeRemoved = {};
    // Create list
    for (int i = 0; i < _sites.length; i++) {
      for (int j = i + 1; j < _sites.length; j++) {
        if (toBeRemoved.contains(_sites[j])) {
          continue;
        }
        if (checkUrlOnly) {
          if (_sites[i].url == _sites[j].url) {
            lazy.log('$debugPrefix:added');
            toBeRemoved.add(_sites[j]);
          }
        } else {
          if (_sites[i].name == _sites[j].name &&
              _sites[i].url == _sites[j].url) {
            lazy.log('$debugPrefix:added');
            toBeRemoved.add(_sites[j]);
          }
        }
      }
    }
    // Remove
    noSave(() {
      lazy.log('$debugPrefix:toBeRemoved:${toBeRemoved.length}');
      for (Site s in toBeRemoved) {
        remove(s);
      }
    });
    // Save
    save();
  }

  bool get presetOnly {
    for (Site s in _sites) {
      if (!s.isPreset) return false;
    }
    return true;
  }

  /// export() - export site list with name and url only
  List export({bool includePreset = false}) {
    List<Map<String, dynamic>> list = [];
    for (var site in _sites) {
      // Don't export preset
      if (includePreset || !site.isPreset) {
        list.add(site.export());
      }
    }
    // return {SitesField.sites: list};
    return list;
  }

  import(String string, {bool replace = false}) {
    String debugPrefix = '$runtimeType.import()';
    try {
      var setting = jsonDecode(string);
      // lazy.log('$debugPrefix:${lazy.jsonPretty(setting)}');
      lazy.log('$debugPrefix:${setting.jsonPretty()}');
      noSave(() {
        for (var s in setting) {
          if (s[SiteBaseFields.name] != null && s[SiteBaseFields.url] != null) {
            add(Site(
              name: s[SiteBaseFields.name]!,
              url: s[SiteBaseFields.url]!,
            ));
          }
        }
        removeDuplicate();
      });
      save();
    } catch (e) {
      lazy.log('$debugPrefix:catch:$e');
      throw ('$debugPrefix:catch:$e');
    }
  }
}
