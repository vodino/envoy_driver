import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '_widget.dart';

class ImageEditorAppBar extends DefaultAppBar {
  const ImageEditorAppBar({
    super.key,
    required this.title,
    this.onTrailingPressed,
  });

  final String title;
  final VoidCallback? onTrailingPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      middle: Text(title),
      transitionBetweenRoutes: false,
      trailing: CustomButton(
        onPressed: onTrailingPressed,
        child: const Icon(CupertinoIcons.check_mark, color: CupertinoColors.activeGreen),
      ),
    );
  }
}

class ImageEditorButton extends StatelessWidget {
  const ImageEditorButton({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.text,
  }) : super(key: key);

  final VoidCallback? onTap;
  final String text;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Tab(
        icon: IconTheme(data: const IconThemeData(color: CupertinoColors.systemGrey), child: icon),
        iconMargin: const EdgeInsets.symmetric(vertical: 4.0),
        child: FittedBox(child: Text(text)),
      ),
    );
  }
}


class ImageEditorBottomAppBar extends StatelessWidget {
  const ImageEditorBottomAppBar({
    super.key,
    this.onRefresh,
    this.onRotateLeft,
    this.onRotateRight,
    this.onFlip,
  });

  final VoidCallback? onFlip;
  final VoidCallback? onRotateLeft;
  final VoidCallback? onRotateRight;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return BottomAppBar(
      elevation: 0.0,
      shape: const AutomaticNotchedShape(Border(top: BorderSide(color: CupertinoColors.systemGrey))),
      child: SizedBox(
        height: 50.0,
        child: Row(
          children: [
            Expanded(
              child: ImageEditorButton(
                icon: const Icon(CupertinoIcons.arrow_left_right_square_fill),
                text: localizations.flip.capitalize(),
                onTap: onFlip,
              ),
            ),
            Expanded(
              child: ImageEditorButton(
                icon: const Icon(CupertinoIcons.rotate_left_fill),
                text: localizations.rotateleft.capitalize(),
                onTap: onRotateLeft,
              ),
            ),
            Expanded(
              child: ImageEditorButton(
                icon: const Icon(CupertinoIcons.rotate_right_fill),
                text: localizations.rotateright.capitalize(),
                onTap: onRotateRight,
              ),
            ),
            Expanded(
              child: ImageEditorButton(
                icon: const Icon(CupertinoIcons.refresh_circled_solid),
                text: localizations.reset.capitalize(),
                onTap: onRefresh,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
