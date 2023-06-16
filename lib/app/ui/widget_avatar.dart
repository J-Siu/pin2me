// import 'package:lazy_sign_in/lazy_sign_in.dart' as lazy;
import 'package:lazy_log/lazy_log.dart' as lazy;
import 'package:lazy_ui_utils/lazy_ui_utils.dart' as lazy;
import 'ui.dart';

class WidgetAvatar extends StatefulWidget {
  const WidgetAvatar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WidgetAvatar();
}

class _WidgetAvatar extends State {
  @override
  void initState() {
    String debugPrefix = '$runtimeType.initState()';
    lazy.log(debugPrefix);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  build(BuildContext context) {
    double appbarIconSize = lazy.textStyleHeadlineM(context)!.fontSize!;
    return SizedBox(
      height: appbarIconSize,
      width: appbarIconSize,
      child: imageAvatar(Image.network(globalLazySignIn.photoUrl)),
    );
  }
}
