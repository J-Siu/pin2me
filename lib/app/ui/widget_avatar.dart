// import 'package:lazy_sign_in/lazy_sign_in.dart' as lazy;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lazy_collection/lazy_collection.dart' as lazy;
import 'package:lazy_log/lazy_log.dart' as lazy;
import 'ui.dart';

class WidgetAvatar extends StatefulWidget {
  const WidgetAvatar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WidgetAvatar();
}

class _WidgetAvatar extends State {
  bool _show = false;

  @override
  void initState() {
    String debugPrefix = '$runtimeType.initState()';
    lazy.log(debugPrefix);
    super.initState();
    lazy.log('$debugPrefix:_setShow');
    _setShow();
    globalLazySignIn.msg.addListener(() => _setShow());
    globalOptionService.addListener(() => _setShow());
  }

  @override
  void dispose() {
    globalLazySignIn.msg.removeListener(() => _setShow());
    globalOptionService.removeListener(() => _setShow());
    super.dispose();
  }

  @override
  build(BuildContext context) {
    double appbarIconSize = lazy.textStyleHeadlineM(context)!.fontSize!;
    List<Widget> children = [];
    if (_show) {
      children.add(SizedBox(
        height: appbarIconSize,
        width: appbarIconSize,
        child: imageAvatar(Image.network(globalLazySignIn.photoUrl)),
      ));
    }
    return Row(
      // mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  _setShow({bool refresh = true}) async {
    String debugPrefix = '$runtimeType._setShow()';
    lazy.log(debugPrefix);

    await Future.delayed(const Duration(seconds: 2));

    bool sync = (globalOptionService.gSync);
    bool signIn = globalLazySignIn.token.isNotEmpty;
    bool show = sync && signIn && globalLazySignIn.photoUrl.isNotEmpty;
    lazy.log('$debugPrefix:refresh:$refresh');
    lazy.log('$debugPrefix:_gSync:$sync');
    lazy.log('$debugPrefix:_SignIn:$signIn');
    lazy.log(
        '$debugPrefix:globalLazySignIn.photoUrl:${globalLazySignIn.photoUrl}');
    lazy.log('$debugPrefix:globalLazySignIn.token:${globalLazySignIn.token}');
    lazy.log('$debugPrefix:$show');
    if (_show != show) {
      _show = show;
      if (refresh) {
        setState(() {});
      }
    }
  }
}
