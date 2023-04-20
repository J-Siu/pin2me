import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lazy_collection/lazy_collection.dart' as lazy;
import 'package:lazy_log/lazy_log.dart' as lazy;
import 'ui.dart';

// const double _defaultIconSize = 48;
// const double _defaultIconFrameSize = 64;
// const double _defaultIconWidgetPadding = 8;
// const double _defaultIconLabelWidth = _defaultIconFrameSize + (_defaultIconWidgetPadding * 2);
// const double _largeMultiplier = 1.5;

class WidgetSite extends StatelessWidget {
  static const double _defaultIconFrameSize = 64;
  static const double _defaultIconLabelWidth =
      _defaultIconFrameSize + (_defaultIconWidgetPadding * 2);
  static const double _defaultIconSize = 48;
  static const double _defaultIconTextSize = 40;
  static const double _defaultIconWidgetPadding = 8;
  static const double _largeMultiplier = 1.5;

  const WidgetSite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final String debugPrefix = ('$runtimeType');
    final site = Provider.of<Site>(context);
    final optionUI = Provider.of<OptionUI>(context);

    double iconSize =
        _defaultIconSize * (optionUI.largeIcon ? _largeMultiplier : 1);
    double iconFrameSize =
        _defaultIconFrameSize * (optionUI.largeIcon ? _largeMultiplier : 1);
    double iconWidgetPadding =
        _defaultIconWidgetPadding * (optionUI.largeIcon ? _largeMultiplier : 1);
    double iconLabelWidth =
        _defaultIconLabelWidth * (optionUI.largeIcon ? _largeMultiplier : 1);
    double iconTextSize =
        _defaultIconTextSize * (optionUI.largeIcon ? _largeMultiplier : 1);

    Widget textIcon() {
      var firstChar = '';
      if (site.name.isNotEmpty) firstChar = site.name[0].toUpperCase();
      return SizedBox(
        height: iconSize,
        width: iconSize,
        child: Center(
          child: Text(
            firstChar,
            style: TextStyle(
              fontSize: iconTextSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    Widget siteIcon(String iconBase64) {
      String debugPrefix = '$runtimeType.siteIcon';
      // if (site.noIcon) return Icon(Icons.web, size: iconSize);
      if (site.noIcon) return textIcon();

      // Using try/catch because base64.decode may fail
      try {
        // var iconBytes = base64.decode(site.iconBase64);
        var iconBytes = base64.decode(iconBase64);
        var image = Image.memory(
          iconBytes,
          fit: BoxFit.fill,
          errorBuilder: (_, __, ___) {
            // Mainly for canvaskit, which cannot display the .ico format
            //
            // We basically don't care about what cause the error,
            // just use a text icon
            return textIcon();
          },
        );
        return image;
      } catch (e) {
        lazy.log('$debugPrefix.siteIcon():${site.name}:catch:$e');
        // iconBase64 is likely corrupted, get a new one
        site.getIcon(refresh: true);
        return Icon(Icons.web, size: iconSize);
      }
    }

    Widget iconFrame = ClipRRect(
      // Icon frame/background
      borderRadius: lazy.borderRadius(10),
      child: Container(
        color: Theme.of(context).colorScheme.background,
        height: iconFrameSize,
        width: iconFrameSize,
        child: Center(
          // Icon
          child: SizedBox(
            height: iconSize,
            width: iconSize,
            child: ClipRRect(
              borderRadius: lazy.borderRadius(10),
              child: Consumer<String>(
                  builder: (_, iconBase64, ___) => siteIcon(iconBase64)),
            ),
          ),
        ),
      ),
    );

    Widget iconLabel = (optionUI.showName)
        ? Container(
            margin: const EdgeInsets.only(top: 8),
            width: iconLabelWidth,
            child: Center(
              child: Text(
                site.name,
                overflow: TextOverflow.ellipsis,
                style: lazy.textStyleBodyM(context),
              ),
            ),
          )
        : const SizedBox();

    Widget siteWidget = InkWell(
      borderRadius: lazy.borderRadius(10),
      hoverColor: Theme.of(context).hoverColor,
      onDoubleTap: () {
        dialogSite(context, add: false, title: 'Edit', site: site);
      },
      onTap: () {
        if (site.url.isNotEmpty) lazy.openUrl(site.url);
      },
      splashFactory: NoSplash.splashFactory,
      child: Container(
        padding: lazy.padAll(iconWidgetPadding),
        width: iconFrameSize + iconWidgetPadding * 2,
        child: Column(
          children: [iconFrame, iconLabel],
        ),
      ),
    );

    return siteWidget;
  }
}
