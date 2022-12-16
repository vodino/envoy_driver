import 'package:flutter/cupertino.dart';

import '_widget.dart';

class HomeDeliveryAppBar extends DefaultAppBar {
  const HomeDeliveryAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      border: const Border.fromBorderSide(BorderSide.none),
      backgroundColor: context.theme.colorScheme.surface,
      middle: const Text("Commandes en cours..."),
      automaticallyImplyLeading: false,
      transitionBetweenRoutes: false,
    );
  }
}
