import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '_widget.dart';

class HomeOrderPickupAppBar extends StatelessWidget {
  const HomeOrderPickupAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      border: const Border.fromBorderSide(BorderSide.none),
      automaticallyImplyLeading: false,
      transitionBetweenRoutes: false,
      middle: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(CupertinoIcons.cube_box_fill, color: CupertinoColors.systemGrey),
          SizedBox(width: 8.0),
          Text('Ramassage de commande'),
        ],
      ),
    );
  }
}

class HomeOrderPickupTile extends StatelessWidget {
  const HomeOrderPickupTile({
    super.key,
    this.onPressed,
    required this.color,
    required this.title,
  });

  final Color color;
  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = context.theme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CustomButton(
        onPressed: onPressed,
        child: CustomListTile(
          tileColor: color,
          textColor: theme.colorScheme.onPrimary,
          iconColor: theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          leading: CustomCircleAvatar(
            foregroundColor: theme.colorScheme.onPrimary,
            backgroundColor: CupertinoColors.systemGrey,
            child: const Icon(CupertinoIcons.person_crop_circle, size: 22.0),
          ),
          title: Text(
            title,
            style: context.cupertinoTheme.textTheme.navTitleTextStyle.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
          trailing: const RotatedBox(
            quarterTurns: -45,
            child: Icon(CupertinoIcons.phone_fill),
          ),
        ),
      ),
    );
  }
}
