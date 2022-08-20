import 'package:flutter/material.dart';
import 'package:lazy_collection/lazy_collection.dart' as lazy;
import 'package:lazy_log/lazy_log.dart' as lazy;
import 'ui.dart';

void dialogSetting(BuildContext context) {
  // String debugPrefix = 'dialogSetting()';
  Widget builder(BuildContext context) {
    const String title = 'Options';
    final gSync = globalLazyGSync;
    final lazySwitch = lazy.Switch(context, width: 80, margin: 4);
    final optionUI = Provider.of<OptionUI>(context);
    final themeController = ThemeProvider.controllerOf(context);

    Widget buttonAdvance = TextButton(
      child: const Text("Advance"),
      onPressed: () {
        Navigator.of(context).pop();
        dialogSettingAdvance(context);
      },
    );

    Widget buttonClose = TextButton(
      child: const Text("Close"),
      onPressed: () => Navigator.of(context).pop(),
    );

    Widget content(
        BuildContext context, OptionService optionService, Widget? child) {
      String debugPrefix = 'content()';

      //Complex logic for turning sync on and off
      void syncOnToggle(BuildContext context, {required bool enable}) async {
        if (enable) {
          try {
            // enable(true) sync start
            var gFiles = await globalLazyGSync.remoteFiles();
            // globalLazyGSync.remoteFiles().then((gFiles) {
            if (globalSites.isEmpty || globalSites.presetOnly) {
              // local save empty or preset only
              lazy.log('$debugPrefix:local empty/preset only -> set enable');
              settingTurnOnGSync();
              if (gFiles.isNotEmpty) {
                lazy.log(
                    '$debugPrefix:local empty/preset only, remote not empty -> download');
                gSync.sync(forceDownload: true);
              }
            } else {
              lazy.log('$debugPrefix:local not empty');
              if (gFiles.isEmpty) {
                // Have local save, no remote save -> set option -> do first upload
                lazy.log(
                    '$debugPrefix:local not empty, remote empty -> set enable -> upload');
                settingTurnOnGSync();
              } else {
                lazy.log(
                    '$debugPrefix:local and remote not empty -> ask before enable');
                // Delay sync option to next dialog
                var lastSaveLocal = globalSites.lastSaveTime;
                globalLazyGSync.remoteLastSaveTime(gFiles).then(
                      (lastSaveRemote) => dialogSyncEnable(
                        context,
                        lastSaveLocal,
                        lastSaveRemote,
                      ),
                    );
              }
            }
          } catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Sign-In error: $e')));
          }

          // enable(true) sync end
        } else {
          settingTurnOffGSync();
          globalLazySignIn.signOutHandler();
        }
      }

      List<lazy.LabeledSwitch> lazyLabeledSwitches = [];
      // Theme Switch
      lazyLabeledSwitches.add(lazy.LabeledSwitch(
        lazySwitch: lazySwitch,
        activeIcon: Icons.nightlight,
        activeText: 'Dark',
        inactiveIcon: Icons.sunny,
        inactiveText: 'Light',
        name: 'Theme',
        onToggle: (v) {
          String nextTheme =
              (themeController.currentThemeId == 'dark') ? 'light' : 'dark';
          themeController.setTheme(nextTheme);
        },
        showOnOff: true,
        type: lazy.SwitchType.toggle,
        value: themeController.currentThemeId == 'dark',
      ));
      // Name Switch
      lazyLabeledSwitches.add(lazy.LabeledSwitch(
        name: 'Show Name',
        lazySwitch: lazySwitch,
        onToggle: (v) => optionUI.showName = v,
        type: lazy.SwitchType.onOff,
        value: optionUI.showName,
      ));
      // Large IconName Switch
      lazyLabeledSwitches.add(lazy.LabeledSwitch(
        activeText: 'Large',
        inactiveText: 'Small',
        lazySwitch: lazySwitch,
        name: 'Icon Size',
        onToggle: (v) => optionUI.largeIcon = v,
        type: lazy.SwitchType.onOff,
        value: optionUI.largeIcon,
      ));
      // Google Sync
      lazyLabeledSwitches.add(lazy.LabeledSwitch(
        name: 'Google Drive Sync',
        lazySwitch: lazySwitch,
        onToggle: (enable) => syncOnToggle(context, enable: enable),
        type: lazy.SwitchType.onOff,
        value: optionService.gSync,
      ));
      // Google Sync Auto
      lazyLabeledSwitches.add(lazy.LabeledSwitch(
        disabled: !optionService.gSync,
        name: 'Auto Sync',
        lazySwitch: lazySwitch,
        onToggle: (v) {
          optionService.gSyncAuto = gSync.enableAutoSync = v;
        },
        type: lazy.SwitchType.onOff,
        value: optionService.gSyncAuto,
      ));

      return Consumer<OptionService>(builder: (context, _, __) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [lazy.LabeledSwitch.table(switches: lazyLabeledSwitches)],
        );
      });
    }

    return AlertDialog(
      title: const Text(title),
      actions: [buttonAdvance, buttonClose],
      content: Consumer<OptionService>(builder: content),
    );
  }

  showDialog(
    context: context,
    builder: builder,
  );
}
