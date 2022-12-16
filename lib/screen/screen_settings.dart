import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const String path = 'settings';
  static const String name = 'settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _language(String languageCode) {
    final localizations = context.localizations;
    switch (languageCode) {
      case 'fr':
        return localizations.french;
      default:
        return localizations.english;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return Scaffold(
      appBar: const SettingsAppBar(),
      body: BottomAppBar(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: CustomListTile(
                height: 60.0,
                title: Text(localizations.notifications.capitalize()),
                trailing: CupertinoSwitch(
                  value: true,
                  onChanged: (value) {},
                ),
                onTap: () {},
              ),
            ),
            SliverToBoxAdapter(
              child: CustomListTile(
                height: 60.0,
                title: Text(localizations.receivingcalls.capitalize()),
                trailing: CupertinoSwitch(
                  value: true,
                  onChanged: (value) {},
                ),
                onTap: () {},
              ),
            ),
            const SliverToBoxAdapter(child: Divider(indent: 16.0, endIndent: 16.0)),
            SliverToBoxAdapter(
              child: Builder(builder: (context) {
                final locale = Localizations.localeOf(context);
                return CustomListTile(
                  height: 65.0,
                  title: Text(localizations.language.capitalize()),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _language(locale.languageCode).capitalize(),
                        style: const TextStyle(color: CupertinoColors.systemGrey),
                      ),
                      const Icon(CupertinoIcons.forward, color: CupertinoColors.systemFill),
                    ],
                  ),
                  onTap: () {
                    context.pushNamed(SettingsLanguageScreen.name);
                  },
                );
              }),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              fillOverscroll: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Divider(indent: 16.0, endIndent: 16.0),
                  CupertinoButton(
                    child: Text(
                      localizations.logout.capitalize(),
                      style: const TextStyle(color: CupertinoColors.destructiveRed),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
