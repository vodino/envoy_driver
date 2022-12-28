import 'package:flutter/cupertino.dart';

import '_widget.dart';

class HomeDeliveryAppBar extends DefaultAppBar {
  const HomeDeliveryAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return CupertinoNavigationBar(
      middle: Text("${localizations.currentorder.capitalize()}..."),
      border: const Border.fromBorderSide(BorderSide.none),
      backgroundColor: context.theme.colorScheme.surface,
      automaticallyImplyLeading: false,
      transitionBetweenRoutes: false,
    );
  }
}
