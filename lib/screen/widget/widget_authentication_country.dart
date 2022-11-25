import 'package:flutter/cupertino.dart';

import '_widget.dart';

class AuthCountryAppBar extends DefaultAppBar {
  const AuthCountryAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      border: const Border.fromBorderSide(BorderSide.none),
      middle: const Text("Selectionner un pays"),
      backgroundColor: context.theme.colorScheme.surface,
      automaticallyImplyLeading: false,
    );
  }
}