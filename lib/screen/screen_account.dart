import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  static const String path = 'account';
  static const String name = 'account';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AccountAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 16.0)),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            sliver: SliverToBoxAdapter(
              child: AspectRatio(
                aspectRatio: 4.0,
                child: CircleAvatar(
                  backgroundColor: CupertinoColors.systemGrey,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 12.0)),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            sliver: SliverToBoxAdapter(
              child: CustomListTile(
                title: TextField(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Nom complet',
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 12.0)),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            sliver: SliverToBoxAdapter(
              child: CustomListTile(
                title: TextField(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Numréro de téléphone',
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 12.0)),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            sliver: SliverToBoxAdapter(
              child: CustomListTile(
                title: TextField(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Adresse mail (Optionnel)',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
