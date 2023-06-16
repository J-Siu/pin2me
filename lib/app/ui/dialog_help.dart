import 'package:flutter/material.dart';
import 'package:lazy_ui_utils/lazy_ui_utils.dart' as lazy;

void dialogHelp(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: const Text('Help'),
      children: [
        lazy.textPadding(
          'Long-Press to move.',
          textAlign: TextAlign.center,
        ),
        lazy.textPadding(
          'Double-Tap to edit.',
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
