import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '_widget.dart';

class HomeSearchAppBar extends StatelessWidget {
  const HomeSearchAppBar({super.key, this.active = false});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return SizedBox(
      height: 60.0,
      child: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        automaticallyImplyLeading: false,
        border: const Border.fromBorderSide(BorderSide.none),
        middle: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: active,
              replacement: Text(localizations.youcurrentlyoffline.capitalize()),
              child: Text("${localizations.waitingneworder.capitalize()}..."),
            ),
            const SizedBox(width: 8.0),
            Icon(
              CupertinoIcons.circle_fill,
              color: active ? CupertinoColors.activeGreen : CupertinoColors.destructiveRed,
              size: 12.0,
            ),
          ],
        ),
      ),
    );
  }
}

class HomeSearchLoading extends StatelessWidget {
  const HomeSearchLoading({super.key, this.active = false});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 1.7,
        child: SizedBox.fromSize(
          size: const Size.fromRadius(100.0),
          child: FittedBox(
            child: Ripple(
              animate: active,
              color: context.theme.primaryColorDark,
              child: Padding(
                padding: const EdgeInsets.all(60.0),
                child: CircleAvatar(
                  radius: 60.0,
                  foregroundColor: active ? null : CupertinoColors.systemGrey,
                  backgroundColor: active ? null : CupertinoColors.systemFill,
                  child: Visibility(
                    visible: active,
                    replacement: const Icon(CupertinoIcons.wifi_slash, size: 50.0),
                    child: const Icon(CupertinoIcons.wifi, size: 50.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
