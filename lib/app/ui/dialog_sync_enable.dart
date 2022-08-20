import 'ui.dart';
import 'package:flutter/material.dart';
import 'package:lazy_collection/lazy_collection.dart' as lazy;

void dialogSyncEnable(
  BuildContext context,
  DateTime lastSaveLocal,
  DateTime lastSaveRemote,
) {
  // String debugPrefix = 'dialogSetting()';
  Widget builder(BuildContext context) {
    const String title = 'Enable Google Drive Sync';
    final gSync = globalLazyGSync;

    Widget content = SizedBox(
      child: Table(
        children: [
          TableRow(children: [
            Text(
              'Local last Save',
              style: lazy.textStyleBodyS(context),
            ),
            Text(
              lastSaveLocal.toIso8601String(),
              style: lazy.textStyleBodyS(context),
            ),
          ]),
          TableRow(children: [
            Text(
              'Remote last Save',
              style: lazy.textStyleBodyS(context),
            ),
            Text(
              lastSaveRemote.toIso8601String(),
              style: lazy.textStyleBodyS(context),
            ),
          ]),
        ],
      ),
    );

    Widget buttonDownload = TextButton(
      child: const Text("Download"),
      onPressed: () async {
        Navigator.of(context).pop();
        await gSync.sync(forceDownload: true);
        settingTurnOnGSync();
      },
    );

    Widget buttonUpload = TextButton(
      child: const Text("Upload"),
      onPressed: () async {
        Navigator.of(context).pop();
        await gSync.sync(forceUpload: true);
        settingTurnOnGSync();
      },
    );

    Widget buttonCancel = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
        settingTurnOffGSync();
      },
    );

    return AlertDialog(
      title: const Text(title),
      actions: [buttonUpload, buttonDownload, buttonCancel],
      content: content,
    );
  }

  showDialog(
    context: context,
    builder: builder,
  );
}
