import 'package:flutter/cupertino.dart';

import '_widget.dart';

class AccountAppBar extends DefaultAppBar {
  const AccountAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return CupertinoNavigationBar(
      transitionBetweenRoutes: false,
      middle: Text(localizations.profile.capitalize()),
    );
  }
}

class AccountPhotoModal extends StatelessWidget {
  const AccountPhotoModal({
    super.key,
    this.onCancel,
    this.onCamera,
    this.onGallery,
  });

  final VoidCallback? onGallery;
  final VoidCallback? onCamera;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return CupertinoAlertDialog(
      content: Text(localizations.selectoptionimage.capitalize()),
      actions: [
        CupertinoDialogAction(
          onPressed: onCamera,
          isDefaultAction: true,
          child: Text(localizations.opencamera.capitalize()),
        ),
        CupertinoDialogAction(
          onPressed: onGallery,
          isDefaultAction: true,
          child: Text(localizations.opengallery.capitalize()),
        ),
        CupertinoDialogAction(
          onPressed: onCancel,
          isDestructiveAction: true,
          child: Text(localizations.cancel.capitalize()),
        ),
      ],
    );
  }
}
