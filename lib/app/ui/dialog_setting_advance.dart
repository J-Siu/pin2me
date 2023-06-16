import 'package:lazy_log/lazy_log.dart' as lazy;
import 'package:lazy_ui_utils/lazy_ui_utils.dart' as lazy;
import 'ui.dart';

void dialogSettingAdvance(BuildContext context) {
  Widget builder(BuildContext context) {
    const String title = ' Advance Options';
    final lazySwitch = lazy.Switch(context, width: 80, margin: 4);
    final optionsDebug = Provider.of<OptionService>(context);
    final gSync = globalLazyGSync;
    final sites = globalSites;

    Widget content() {
      List<Widget> children = [];
      List<lazy.LabeledSwitch> lazyLabeledSwitches = [];
      // Debug Switch
      lazyLabeledSwitches.add(lazy.LabeledSwitch(
        lazySwitch: lazySwitch,
        name: 'Debug',
        onToggle: (v) => lazy.logEnable = optionsDebug.debug = v,
        type: lazy.SwitchType.onOff,
        value: optionsDebug.debug,
      ));
      children.add(lazy.LabeledSwitch.table(switches: lazyLabeledSwitches));

      // Del Duplicate
      children.add(lazy.outlinedTextButton(
        child: const Text("Remove Duplicate"),
        onPressed: () {
          sites.removeDuplicate();
          Navigator.of(context).pop();
        },
      ));
      // // Refresh all icon
      // children.add(lazy.outlinedTextButton(
      //   child: const Text("Refresh All Icons"),
      //   onPressed: () {
      //     sites.refreshAllIcons();
      //     Navigator.of(context).pop();
      //   },
      // ));
      // Import/Export
      children.add(lazy.outlinedTextButton(
        child: const Text("Import/Export"),
        onPressed: () {
          Navigator.of(context).pop();
          dialogImportExport(context);
        },
      ));
      // Force Upload
      children.add(lazy.outlinedTextButton(
        child: const Text("Force Upload"),
        onPressed: () {
          Navigator.of(context).pop();
          gSync.sync(forceUpload: true);
        },
      ));
      // Force Download
      children.add(lazy.outlinedTextButton(
        child: const Text("Force Download"),
        onPressed: () {
          Navigator.of(context).pop();
          gSync.sync(forceDownload: true);
        },
      ));
      // Add Default
      children.add(lazy.outlinedTextButton(
        child: const Text("Add Default Sites"),
        onPressed: () {
          sites.defaultsAdd(defaultSites: sitesPreset);
          Navigator.of(context).pop();
        },
      ));
      // // Add Default x 10
      // children.add(lazy.outlinedTextButton(
      //   child: const Text("Add Default Sites 10x"),
      //   onPressed: () {
      //     sites.defaultsAdd(defaultSites: sitesPreset, num: 10);
      //     Navigator.of(context).pop();
      //   },
      // ));
      // Del Default
      children.add(lazy.outlinedTextButton(
        child: const Text("Remove Default Sites"),
        onPressed: () {
          sites.defaultsDel();
          Navigator.of(context).pop();
        },
      ));
      // Del All
      children.add(lazy.outlinedTextButton(
        child: const Text("Remove All Sites"),
        onPressed: () {
          sites.clear();
          Navigator.of(context).pop();
        },
      ));
      // Clear all
      // children.add(lazy.outlinedTextButton(
      //   child: const Text("Clear Site List"),
      //   onPressed: () {
      //     Navigator.of(context).pop();
      //     sites.clear();
      //   },
      // ));

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    }

    Widget buttonClose = TextButton(
      child: const Text("Close"),
      onPressed: () => Navigator.of(context).pop(),
    );

    return AlertDialog(
      title: const Text(title),
      actions: [buttonClose],
      content: content(),
    );
  }

  showDialog(
    context: context,
    builder: builder,
  );
}
