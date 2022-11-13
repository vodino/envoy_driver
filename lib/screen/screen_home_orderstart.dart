import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '_screen.dart';

class HomeOrderStartScreen extends StatelessWidget {
  const HomeOrderStartScreen({
    super.key,
    required this.popController,
  });

  final ValueNotifier<bool?> popController;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.5,
      child: BottomAppBar(
        elevation: 0.0,
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const HomeOrderStartAppBar(),
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 8.0),
                  CustomListTile(
                    leading: const Icon(CupertinoIcons.circle, color: CupertinoColors.activeBlue, size: 16.0),
                    title: Text(
                      "Quartier Akeikoi",
                      style: context.cupertinoTheme.textTheme.textStyle,
                    ),
                    onTap: () {},
                  ),
                  const Divider(),
                  CustomListTile(
                    leading: const Icon(CupertinoIcons.circle, color: CupertinoColors.activeOrange, size: 16.0),
                    title: Text(
                      "Adjamé Mairie",
                      style: context.cupertinoTheme.textTheme.textStyle,
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(height: 8.0),
                  const Divider(thickness: 8.0, height: 12.0),
                  CustomListTile(
                    title: const Text('Revenu :'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "500 FCFA",
                          style: context.cupertinoTheme.textTheme.navTitleTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.0,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Assets.images.moneyStack.svg(height: 24.0),
                      ],
                    ),
                    onTap: () {},
                  ),
                  CustomListTile(
                    title: const Text('Distance :'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "15 KM",
                          style: context.cupertinoTheme.textTheme.navTitleTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.0,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        const Icon(CupertinoIcons.arrow_branch)
                      ],
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CupertinoButton.filled(
                child: const Text('Commencer'),
                onPressed: () {
                  popController.value = true;
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
