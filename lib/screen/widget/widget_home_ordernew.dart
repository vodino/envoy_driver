import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

import '_widget.dart';

class HomeOrderNewAppBar extends StatelessWidget {
  const HomeOrderNewAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoNavigationBar(
      transitionBetweenRoutes: false,
      middle: Text('Nouvelle course'),
      automaticallyImplyLeading: false,
    );
  }
}

class HomeOrderNewLoading extends StatelessWidget {
  const HomeOrderNewLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 3.0,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const ShapeDecoration(
            color: CupertinoColors.systemFill,
            shape: CircleBorder(),
          ),
          child: Lottie.asset(Assets.images.box),
        ),
      ),
    );
  }
}
