import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lazy_collection/lazy_collection.dart' as lazy;
import 'package:lazy_extensions/lazy_extensions.dart' as lazy;
import 'package:lazy_log/lazy_log.dart' as lazy;
import 'ui.dart';

class DialogImportExport extends StatefulWidget {
  const DialogImportExport({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DialogImportExport();
}

class _DialogImportExport extends State<DialogImportExport> {
  final String _title = 'Import/Export';
  final _sites = globalSites;
  String _setting = '';

  @override
  void initState() {
    super.initState();
    _setting = lazy.jsonPretty(_sites.export(includePreset: true));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrlList =
        Provider.of<List<TextEditingController>>(context, listen: false);
    final ctrlSetting = ctrlList[0];
    ctrlSetting.text = _setting;
    Widget fieldSetting = TextField(
      autofocus: true,
      controller: ctrlSetting,
      maxLines: null,
      minLines: 1,
      textAlign: TextAlign.left,
    );
    Widget buttonCopy = TextButton(
      onPressed: () {
        Clipboard.setData(ClipboardData(text: ctrlSetting.text)).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Copied to clipped'),
          ));
        });
      },
      child: const Text('Copy'),
    );
    Widget buttonSave = TextButton(
      onPressed: () {
        download(ctrlSetting.text.toUtf8(), downloadName: 'Pin2Me.json');
      },
      child: const Text('Save'),
    );
    Widget buttonApply = TextButton(
      onPressed: () {
        try {
          _sites.import(ctrlSetting.text);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Applied')));
        } catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Not Apply: $e')));
        }
      },
      child: const Text('Apply'),
    );

    Widget buttonClose = TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text('Close'),
    );
    return AlertDialog(
      title: Text(_title),
      actions: [buttonSave, buttonApply, buttonCopy, buttonClose],
      content: Container(
        decoration: lazy.boxDecoration(),
        child: SingleChildScrollView(
          padding: lazy.padAll(10),
          child: fieldSetting,
        ),
      ),
    );
  }
}

void dialogImportExport(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => const DialogImportExport(),
  );
}

// url_luncher for save to download, cannot set filename
// void downloadLaunchUrl(String setting) {
//   Uri uri = Uri.parse(
//       'data:attachment/octet-stream;headers="Content-Disposition:attachment;filename=Pin2Me.json";base64,${base64Encode(setting.codeUnits)}');
//   launchUrl(
//     uri,
//     webViewConfiguration: const WebViewConfiguration(headers: {'Content-Disposition': 'attachment;filename="Pin2Me.json"'}),
//     webOnlyWindowName: 'Pin2Me.json',
//   );
// }

// web only
void download(
  List<int> bytes, {
  required String downloadName,
}) {
  // Create the link with the file
  final anchor = AnchorElement(
      href: 'data:application/octet-stream;base64,${base64Encode(bytes)}');
  anchor.target = 'blank';
  // Set filename
  anchor.download = downloadName;
  // Download
  if (document.body != null) {
    document.body!.append(anchor);
    anchor.click();
    anchor.remove();
  } else {
    lazy.log('download():document.body==null');
  }
  return;
}
