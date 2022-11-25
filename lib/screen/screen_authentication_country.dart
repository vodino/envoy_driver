import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '_screen.dart';

class AuthCountryScreen extends StatelessWidget {
  const AuthCountryScreen({
    super.key,
    this.currentItem,
    required this.items,
  });

  final CountrySchema? currentItem;
  final List<CountrySchema> items;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 1.0,
      minChildSize: 1.0,
      initialChildSize: 1.0,
      builder: (context, scrollController) {
        return Scaffold(
          appBar: const AuthCountryAppBar(),
          body: BottomAppBar(
            elevation: 0.0,
            color: Colors.transparent,
            child: ListView.separated(
              itemCount: items.length,
              controller: scrollController,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 8.0);
              },
              itemBuilder: (context, index) {
                final item = items[index];
                return CustomBoxShadow(
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (value) {
                      if (value != null) Navigator.pop(context, item);
                    },
                    secondary: Text(CustomString.toFlag(item.code), style: const TextStyle(fontSize: 24.0)),
                    activeColor: CupertinoColors.systemGreen,
                    visualDensity: VisualDensity.compact,
                    value: item == currentItem,
                    title: Text(item.name),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
