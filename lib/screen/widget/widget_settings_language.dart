import 'package:flutter/cupertino.dart';

import '_widget.dart';

class SettingsLanguageAppBar extends DefaultAppBar {
  const SettingsLanguageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return CupertinoNavigationBar(
      middle: Text(localizations.selectlanguage),
      transitionBetweenRoutes: false,
    );
  }
}
