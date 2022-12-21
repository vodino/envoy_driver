import 'package:flutter/cupertino.dart';

import '_widget.dart';

class AccountAppBar extends DefaultAppBar {
  const AccountAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoNavigationBar(
      middle: Text('Profil'),
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
    return CupertinoAlertDialog(
      content: const Text("Selectionner l'option pour obtenir une image."),
      actions: [
        CupertinoDialogAction(
          onPressed: onCamera,
          isDefaultAction: true,
          child: const Text('Ouvrir la camera'),
        ),
        CupertinoDialogAction(
          onPressed: onGallery,
          isDefaultAction: true,
          child: const Text('Ouvrir la gallerie'),
        ),
        CupertinoDialogAction(
          onPressed: onCancel,
          isDestructiveAction: true,
          child: const Text('Annuler'),
        ),
      ],
    );
  }
}
