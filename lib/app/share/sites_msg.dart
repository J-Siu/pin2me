import 'share.dart';

class SitesMsg {
  Site? site;
  SitesAction action = SitesAction.noAction;
  int index = -1;
  int? indexNew;
  int? indexOld;

  SitesMsg({
    this.action = SitesAction.noAction,
    this.site,
    this.index = -1,
    this.indexNew,
    this.indexOld,
  });

  Map<dynamic, dynamic> toJson() {
    Map<dynamic, dynamic> map = {
      'action': action,
      'index': index,
    };

    if (site != null) map['name'] = site!.name;
    if (indexNew != null) map['indexNew'] = indexNew;
    if (indexOld != null) map['indexOld'] = indexOld;

    return map;
  }
}
