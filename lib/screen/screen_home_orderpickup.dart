import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '_screen.dart';

class HomeOrderPickupScreen extends StatelessWidget {
  const HomeOrderPickupScreen({
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
            const HomeOrderPickupAppBar(),
            HomeOrderPickupTile(
              color: CupertinoColors.activeBlue,
              title: '+225 0749414602',
              onPressed: () {},
            ),
            CustomListTile(
              leading: const Icon(
                CupertinoIcons.location_solid,
                color: CupertinoColors.systemGrey2,
              ),
              title: Text(
                'Quartier Akeikoi',
                style: context.cupertinoTheme.textTheme.textStyle,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Material(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  color: CupertinoColors.systemGrey5,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recupere mon colis à Adjamé chez monsieur Karim et ramène ma nourriture au plus vite.',
                          style: context.cupertinoTheme.textTheme.textStyle,
                        ),
                        const CustomAudioPlayer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            CustomSheetButton(
              child: const Text("J'ai récuperé"),
              onPressed: () {
                popController.value = true;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
