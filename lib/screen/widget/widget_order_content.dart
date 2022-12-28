import 'package:flutter/cupertino.dart';

import '_widget.dart';

class OrderContentAppBar extends DefaultAppBar {
  const OrderContentAppBar({
    super.key,
    this.onTrailingPressed,
  });

  final VoidCallback? onTrailingPressed;

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return CupertinoNavigationBar(
      middle: Text(localizations.order.capitalize()),
      transitionBetweenRoutes: false,
      trailing: CustomButton(
        onPressed: onTrailingPressed,
        child: const Icon(CupertinoIcons.ellipsis_circle),
      ),
    );
  }
}

class OrderContentListTile extends StatelessWidget {
  const OrderContentListTile({
    super.key,
    required this.title,
    required this.iconColor,
    this.onTap,
  });

  final Widget title;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      leading: Icon(CupertinoIcons.circle, color: iconColor, size: 16.0),
      title: title,
      onTap: onTap,
    );
  }
}
