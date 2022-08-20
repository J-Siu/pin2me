import 'package:lazy_collection/lazy_collection.dart' as lazy;
import 'package:flutter/material.dart';

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
