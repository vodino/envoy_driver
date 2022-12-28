import 'package:flutter/cupertino.dart';

import '_widget.dart';

class ImageContentAppBar extends DefaultAppBar {
  const ImageContentAppBar({
    super.key,
    required this.title,
    this.onTrailingPressed,
  });

  final String title;
  final VoidCallback? onTrailingPressed;

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return CupertinoNavigationBar(
      middle: Text(title),
      transitionBetweenRoutes: false,
      trailing: CustomButton(
        onPressed: onTrailingPressed,
        child: Text(
          localizations.edit.capitalize(),
          style: const TextStyle(color: CupertinoColors.activeBlue),
        ),
      ),
    );
  }
}



class OrderContentPlaceTile extends StatelessWidget {
  const OrderContentPlaceTile({
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

class OrderContentPriceTile extends StatelessWidget {
  const OrderContentPriceTile({
    super.key,
    required this.price,
    required this.title,
  });
  final String title;
  final double price;

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      title: Text('$title :'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$price F",
            style: context.cupertinoTheme.textTheme.navTitleTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(width: 8.0),
          Assets.images.moneyStack.svg(height: 24.0),
        ],
      ),
    );
  }
}
