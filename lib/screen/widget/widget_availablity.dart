import 'package:flutter/cupertino.dart';

import '_widget.dart';

class AvailablityAppBar extends DefaultAppBar {
  const AvailablityAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoNavigationBar(
      middle: Text('Disponibilité'),
    );
  }
}
