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
        child: const Text('Valider'),
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
    return InkWell(onTap: onTap, child: Tab(icon: icon, child: Text(text)));
  }
}

class ImageEditorBottomAppBar extends StatelessWidget {
  const ImageEditorBottomAppBar({
    super.key,
    this.onRefresh,
    this.onRotateLeft,
    this.onRotateRight,
    this.onSwitch,
  });

  final VoidCallback? onSwitch;
  final VoidCallback? onRotateLeft;
  final VoidCallback? onRotateRight;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45.0,
      child: BottomAppBar(
        elevation: 0.0,
        color: Colors.transparent,
        child: Row(
          children: [
            ImageEditorButton(
              icon: const Icon(CupertinoIcons.arrow_left_right_square_fill),
              text: 'Inverser',
              onTap: onSwitch,
            ),
            ImageEditorButton(
              icon: const Icon(CupertinoIcons.rotate_left_fill),
              text: 'Tourner à gauche',
              onTap: onRotateLeft,
            ),
            ImageEditorButton(
              icon: const Icon(CupertinoIcons.rotate_right_fill),
              text: 'Tourner à droit',
              onTap: onRotateRight,
            ),
            ImageEditorButton(
              icon: const Icon(CupertinoIcons.refresh_circled_solid),
              text: 'Reinitialiser',
              onTap: onRefresh,
            ),
          ],
        ),
      ),
    );
  }
}
