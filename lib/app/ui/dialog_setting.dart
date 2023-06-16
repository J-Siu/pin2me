import 'package:lazy_ui_utils/lazy_ui_utils.dart' as lazy;
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
      BuildContext context,
      OptionService optionService,
      Widget? child,
    ) {
      void onToggleSignIn(BuildContext context, {required bool enable}) async {
        if (enable) {
          try {
            globalOptionService.gSignIn = true;
            globalLazySignIn.signIn();
          } catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Sign-In error: $e')));
          }
        } else {
          globalOptionService.gSignIn = false;
          globalLazySignIn.signOut();
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
      // Large Lock Switch
      lazyLabeledSwitches.add(lazy.LabeledSwitch(
        activeText: 'Lock',
        inactiveText: 'Small',
        lazySwitch: lazySwitch,
        name: 'Lock',
        onToggle: (v) => optionUI.lock = v,
        type: lazy.SwitchType.onOff,
        value: optionUI.lock,
      ));
      // Google Sign In
      lazyLabeledSwitches.add(lazy.LabeledSwitch(
        name: 'Google Sign In',
        lazySwitch: lazySwitch,
        onToggle: (enable) => onToggleSignIn(context, enable: enable),
        type: lazy.SwitchType.onOff,
        value: optionService.gSignIn,
      ));
      // Google Sync Auto
      lazyLabeledSwitches.add(lazy.LabeledSwitch(
        disabled: !optionService.gSignIn,
        name: 'Auto Sync',
        lazySwitch: lazySwitch,
        onToggle: (v) {
          optionService.autoSync = gSync.auto = v;
        },
        type: lazy.SwitchType.onOff,
        value: optionService.autoSync,
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
