import 'package:flutter/cupertino.dart';

import '_widget.dart';

class OrderFeedbackAppBar extends DefaultAppBar {
  const OrderFeedbackAppBar({
    super.key,
    this.close,
  });

  final VoidCallback? close;

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return CupertinoNavigationBar(
      trailing: CustomButton(
        onPressed: close,
        child: const Icon(CupertinoIcons.clear_circled_solid),
      ),
      transitionBetweenRoutes: false,
      middle: Text(localizations.evaluation.capitalize()),
      automaticallyImplyLeading: false,
    );
  }
}
