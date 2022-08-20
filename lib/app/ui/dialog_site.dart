// ignore_for_file: invalid_use_of_protected_member

import 'ui.dart';
import 'package:lazy_collection/lazy_collection.dart' as lazy;
import 'package:flutter/material.dart';

void dialogSite(
  BuildContext context, {
  required bool add,
  required Site site,
  required String title,
}) {
  Widget builder(BuildContext context) {
    final ctrlList =
        Provider.of<List<TextEditingController>>(context, listen: false);
    final ctrlName = ctrlList[0];
    final ctrlUrl = ctrlList[1];
    final sites = globalSites;
    ctrlName.text = site.name;
    ctrlUrl.text = site.url;

    void onSubmitted(String value) {
      Navigator.of(context).pop();
      if (ctrlName.text.trim().isNotEmpty || ctrlUrl.text.trim().isNotEmpty) {
        site
          ..name = ctrlName.text.trim()
          ..url = ctrlUrl.text.trim();
        if (add) sites.add(site);
      }
    }

    Widget fieldName = TextField(
      autofocus: true,
      controller: ctrlName,
      decoration: const InputDecoration(labelText: 'Name'),
      textAlign: TextAlign.left,
      textInputAction: TextInputAction.next,
    );

    Widget fieldUrl = TextField(
      controller: ctrlUrl,
      decoration: const InputDecoration(labelText: 'URL'),
      textAlign: TextAlign.left,
      textInputAction: TextInputAction.done,
      onSubmitted: onSubmitted,
    );

    Widget buttonCancel = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget buttonDel = TextButton(
      child: const Text("Delete"),
      onPressed: () {
        Navigator.of(context).pop();
        sites.remove(site);
      },
    );

    Widget buttonRefreshIcon = TextButton(
      child: const Text("Refresh Icon"),
      onPressed: () {
        Navigator.of(context).pop();
        site.getIcon(refresh: true);
      },
    );

    Widget buttonOK = TextButton(
      child: const Text("OK"),
      onPressed: () {
        onSubmitted('');
      },
    );

    Widget defaultSiteTextBox = Text(
      'This is a default site icon and cannot be modified.',
      style: lazy.textStyleBodyM(context),
    );

    List<Widget> fields = [];
    if (site.isPreset) {
      fields = [defaultSiteTextBox];
    } else {
      fields = [fieldName, fieldUrl];
    }

    List<Widget> buttons = [];
    if (!add) {
      buttons.add(buttonRefreshIcon);
      buttons.add(buttonDel);
    }
    buttons.add(buttonCancel);
    if (!site.isPreset) buttons.add(buttonOK);

    return AlertDialog(
      title: Text(title),
      actions: buttons,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: fields,
      ),
    );
  }

  showDialog(
    context: context,
    builder: builder,
  );
}
