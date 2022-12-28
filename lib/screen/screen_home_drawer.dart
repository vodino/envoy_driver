import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '_screen.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return Drawer(
      child: BottomAppBar(
        elevation: 0.0,
        color: Colors.transparent,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 45.0,
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  onPressed: () => Navigator.pop(context),
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Icon(CupertinoIcons.back),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: CustomListTile(
                title: Text(localizations.profile.capitalize()),
                leading: const Icon(CupertinoIcons.person),
                onTap: () => context.pushNamed(AccountScreen.name),
              ),
            ),
            SliverToBoxAdapter(
              child: CustomListTile(
                leading: const Icon(CupertinoIcons.calendar),
                title: const Text('Disponibilité'),
                onTap: () => context.pushNamed(AvailablityScreen.name),
              ),
            ),
            const SliverToBoxAdapter(child: Divider()),
            SliverToBoxAdapter(
              child: CustomListTile(
                leading: const Icon(CupertinoIcons.cube_box),
                title: Text('${localizations.order.capitalize()}s'),
                onTap: () => context.pushNamed(OrderRecordingScreen.name),
              ),
            ),
            SliverToBoxAdapter(
              child: CustomListTile(
                onTap: () => context.pushNamed(OrderProfitScreen.name),
                leading: const Icon(CupertinoIcons.tickets),
                title: Text('${localizations.earning.capitalize()}s'),
              ),
            ),
            SliverToBoxAdapter(
              child: CustomListTile(
                leading: const Icon(CupertinoIcons.info_circle),
                title: Text(localizations.faq.capitalize()),
                onTap: () => context.pushNamed(HelpFaqScreen.name),
              ),
            ),
            const SliverToBoxAdapter(
              child: CustomListTile(
                leading: Icon(CupertinoIcons.info_circle),
                title: Text('Support'),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              fillOverscroll: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Divider(),
                  CustomListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    onTap: () => context.pushNamed(SettingsScreen.name),
                    leading: const Icon(CupertinoIcons.gear),
                    title: Text(localizations.settings.capitalize()),
                    height: 55.0,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
