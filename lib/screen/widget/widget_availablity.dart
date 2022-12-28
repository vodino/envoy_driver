import 'package:flutter/cupertino.dart';

import '_widget.dart';

class AvailablityAppBar extends DefaultAppBar {
  const AvailablityAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return  CupertinoNavigationBar(
      middle: Text(localizations.availablity.capitalize()),
    );
  }
}
