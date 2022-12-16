import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '_widget.dart';

class OrderRecordingAppBar extends DefaultAppBar {
  const OrderRecordingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoNavigationBar(
      middle: Text('Commandes'),
      transitionBetweenRoutes: false,
    );
  }
}

class OrderRecordingTab extends StatelessWidget {
  const OrderRecordingTab({
    super.key,
    required this.counter,
    required this.label,
    this.active = false,
    this.onPressed,
  });

  final VoidCallback? onPressed;
  final int counter;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = active ? context.theme.colorScheme.primary : CupertinoColors.systemFill;
    Color foregroundColor = context.theme.colorScheme.onSurface;
    if (active) foregroundColor = context.theme.colorScheme.surface;
    return CustomButton(
      onPressed: onPressed,
      child: Card(
        elevation: 0.0,
        color: backgroundColor,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          child: IconTheme(
            data: IconThemeData(color: foregroundColor),
            child: DefaultTextStyle(
              style: TextStyle(color: foregroundColor),
              child: Tab(
                icon: FittedBox(child: Text(label)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(CupertinoIcons.cube_box, size: 30.0),
                    const SizedBox(width: 8.0),
                    Text(counter.toString().padLeft(2, '0'), style: const TextStyle(fontSize: 30.0)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
