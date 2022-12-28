import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '_widget.dart';

class HomeOrderPickupAppBar extends StatelessWidget {
  const HomeOrderPickupAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return CupertinoNavigationBar(
      border: const Border.fromBorderSide(BorderSide.none),
      automaticallyImplyLeading: false,
      transitionBetweenRoutes: false,
      middle: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(CupertinoIcons.cube_box_fill, color: CupertinoColors.systemGrey),
          const SizedBox(width: 8.0),
          Text(localizations.orderpickup.capitalize()),
        ],
      ),
    );
  }
}

class HomeOrderPickupTile extends StatelessWidget {
  const HomeOrderPickupTile({
    super.key,
    this.onTap,
    this.onLeadingTap,
    required this.color,
    required this.title,
    this.subtitle,
  });

  final Color color;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final VoidCallback? onLeadingTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = context.theme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CustomListTile(
        height: 60.0,
        tileColor: color,
        textColor: context.theme.colorScheme.onPrimary,
        iconColor: context.theme.colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        leading: CustomButton(
          onPressed: onLeadingTap,
          child: CustomCircleAvatar(
            foregroundColor: theme.colorScheme.onPrimary,
            backgroundColor: CupertinoColors.systemGrey,
            child: const Icon(CupertinoIcons.person_crop_circle, size: 33.0),
          ),
        ),
        title: Text(
          title,
          style: context.cupertinoTheme.textTheme.navTitleTextStyle.copyWith(
            color: context.theme.colorScheme.onPrimary,
          ),
        ),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: const RotatedBox(
          quarterTurns: -45,
          child: Icon(CupertinoIcons.phone_fill),
        ),
        onTap: onTap,
      ),
    );
  }
}

class HomeOrderPickupPhonesModal extends StatelessWidget {
  const HomeOrderPickupPhonesModal({
    super.key,
    this.onCancel,
    this.onPhone,
    required this.phones,
  });

  final ValueChanged<String>? onPhone;
  final VoidCallback? onCancel;
  final List<String> phones;

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return CupertinoAlertDialog(
      content: Text(localizations.selectphonenumbercall.capitalize()),
      actions: [
        ...phones.map((phone) {
          return CupertinoDialogAction(
            onPressed: () => onPhone?.call(phone),
            isDefaultAction: true,
            child: Text(phone),
          );
        }),
        CupertinoDialogAction(
          onPressed: onCancel,
          isDestructiveAction: true,
          child: Text(localizations.cancel.capitalize()),
        ),
      ],
    );
  }
}
