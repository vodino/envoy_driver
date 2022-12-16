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
