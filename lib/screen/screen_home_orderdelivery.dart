import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '_screen.dart';

class HomeOrderDeliveryScreen extends StatelessWidget {
  const HomeOrderDeliveryScreen({
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
            const HomeOrderDeliveryAppBar(),
            HomeOrderPickupTile(
              color: CupertinoColors.activeOrange,
              title: '+225 0749414602',
              onPressed: () {},
            ),
            const CustomLocationTile(
              title: 'Adjamé Mairie, Abidjan',
            ),
            Expanded(
              child: CustomBoxShadow(
                border: false,
                shadow: false,
                color: CupertinoColors.systemGrey5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Recupere mon colis à Adjamé chez monsieur Karim et ramène ma nourriture au plus vite.',
                        style: context.cupertinoTheme.textTheme.textStyle,
                      ),
                    ),
                    const CustomAudioPlayer(),
                  ],
                ),
              ),
            ),
            CustomSheetButton(
              child: const Text("J'ai livré"),
              onPressed: () {
                popController.value = true;
              },
            ),
          ],
        ),
      ),
    );
  }
}
