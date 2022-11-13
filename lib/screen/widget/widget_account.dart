import 'package:flutter/cupertino.dart';

import '_widget.dart';

class AccountAppBar extends DefaultAppBar {
  const AccountAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoNavigationBar(
      middle: Text('Profil'),
    );
  }
}
