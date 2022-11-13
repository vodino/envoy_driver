import 'package:flutter/cupertino.dart';

import '_widget.dart';

class HelpFaqAppBar extends DefaultAppBar {
  const HelpFaqAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoNavigationBar(
      middle: Text('Aide/Faq'),
    );
  }
}
