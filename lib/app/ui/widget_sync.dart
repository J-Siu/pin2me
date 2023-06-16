import 'package:lazy_log/lazy_log.dart' as lazy;
import 'package:lazy_ui_utils/lazy_ui_utils.dart' as lazy;
import 'ui.dart';

class WidgetSync extends StatefulWidget {
  const WidgetSync({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WidgetSync();
}

class _WidgetSync extends State {
  @override
  void initState() {
    String debugPrefix = '$runtimeType.initState()';
    lazy.log(debugPrefix);
    globalLazyGSync.error.addListener(_syncErrorHandler);
    super.initState();
  }

  @override
  void dispose() {
    String debugPrefix = '$runtimeType.dispose()';
    lazy.log(debugPrefix);
    globalLazyGSync.error.removeListener(_syncErrorHandler);
    super.dispose();
  }

  @override
  build(BuildContext context) {
    return lazy.SpinningWidget(
      minSyncSpinningSeconds: 10,
      spin: globalLazyGSync.syncing,
      child: IconButton(
        icon: Icon(
          Icons.sync,
          color: (globalLazyGSync.error.value) ? Colors.red : null,
        ),
        onPressed: _buttonSyncOnPress,
      ),
    );
  }

  void _buttonSyncOnPress() async {
    String debugPrefix = '$runtimeType._buttonSyncOnPress()';
    if (globalLazyGSync.error.value) {
      lazy.log('$debugPrefix:signIn');
      await globalLazySignIn.signIn(reAuthenticate: true);
    } else {
      lazy.log('$debugPrefix:sync');
      globalLazyGSync.sync(ignoreError: true);
    }
  }

  void _syncErrorHandler() async {
    // Trigger setState to change color of the sync icon
    String debugPrefix = '$runtimeType._syncErrorHandler()';
    lazy.log(debugPrefix);
    setState(() {});
  }
}
