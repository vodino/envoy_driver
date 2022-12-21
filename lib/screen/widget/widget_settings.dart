import 'package:flutter/cupertino.dart';

import '_widget.dart';

class SettingsAppBar extends DefaultAppBar {
  const SettingsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return CupertinoNavigationBar(
      middle: Text(localizations.settings.capitalize()),
      transitionBetweenRoutes: false,
    );
  }
}

class SettingsLogoutModal extends StatelessWidget {
  const SettingsLogoutModal({
    super.key,
    this.onCancel,
    this.onDelete,
    this.onLogout,
  });

  final VoidCallback? onLogout;
  final VoidCallback? onDelete;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      content: const Text('Voulez-vous vraiment vous deconnecter de votre compte ?'),
      actions: [
        CupertinoDialogAction(
          onPressed: onDelete,
          child: const Text('Supprimer mon compte'),
        ),
        CupertinoDialogAction(
          onPressed: onLogout,
          isDefaultAction: true,
          isDestructiveAction: true,
          child: const Text('Me deconnecter'),
        ),
        CupertinoDialogAction(
          onPressed: onCancel,
          isDefaultAction: true,
          child: const Text('Annuler'),
        ),
      ],
    );
  }
}

class SettingsDeleteModal extends StatelessWidget {
  const SettingsDeleteModal({
    super.key,
    this.onCancelled,
    this.onDeleted,
  });

  final VoidCallback? onDeleted;
  final VoidCallback? onCancelled;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      content: const Text(
        'Voulez-vous vraiment vous supprimer votre compte ?\nLa suppression de votre compte entrainera la suppression de toutes vos données sur Envoy Serveur',
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: onDeleted,
          isDefaultAction: true,
          child: const Text('Annuler'),
        ),
        CupertinoDialogAction(
          onPressed: onCancelled,
          isDefaultAction: true,
          isDestructiveAction: true,
          child: const Text('Supprimer'),
        ),
      ],
    );
  }
}
