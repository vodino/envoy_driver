import 'package:flutter/material.dart';

import '_screen.dart';

class HelpFaqScreen extends StatelessWidget {
  const HelpFaqScreen({super.key});

  static const String path = 'helpfaq';
  static const String name = 'helpfaq';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HelpFaqAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
              child: ExpansionTile(
                backgroundColor: context.theme.colorScheme.primary,
                textColor: context.theme.colorScheme.onPrimary,
                iconColor: context.theme.colorScheme.onPrimary,
                leading: const CircleAvatar(child: Text('01')),
                title: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('Comment commander un livreur ?'),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                    child: DefaultTextStyle(
                      style: TextStyle(color: context.theme.colorScheme.onPrimary),
                      child: const Text('To order a rider input the required information in the fields provided an tap the lets go button to find the nearest ride for you'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
              child: ExpansionTile(
                backgroundColor: context.theme.colorScheme.primary,
                textColor: context.theme.colorScheme.onPrimary,
                iconColor: context.theme.colorScheme.onPrimary,
                leading: const CircleAvatar(child: Text('02')),
                title: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('Comment commander un livreur ?'),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                    child: DefaultTextStyle(
                      style: TextStyle(color: context.theme.colorScheme.onPrimary),
                      child: const Text('To order a rider input the required information in the fields provided an tap the lets go button to find the nearest ride for you'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
