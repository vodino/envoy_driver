import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '_widget.dart';

class OrderRecordingAppBar extends DefaultAppBar {
  const OrderRecordingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return CupertinoNavigationBar(
      middle: Text('${localizations.order.capitalize()}s'),
      transitionBetweenRoutes: false,
    );
  }
}

class OrderRecordingTab extends StatelessWidget {
  const OrderRecordingTab({
    super.key,
    required this.counter,
    required this.label,
    this.active = false,
    this.onPressed,
  });

  final VoidCallback? onPressed;
  final int counter;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = active ? context.theme.colorScheme.primary : CupertinoColors.systemFill;
    Color foregroundColor = context.theme.colorScheme.onSurface;
    if (active) foregroundColor = context.theme.colorScheme.surface;
    return CustomButton(
      onPressed: onPressed,
      child: Card(
        elevation: 0.0,
        color: backgroundColor,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          child: IconTheme(
            data: IconThemeData(color: foregroundColor),
            child: DefaultTextStyle(
              style: TextStyle(color: foregroundColor),
              child: Tab(
                icon: FittedBox(child: Text(label)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(CupertinoIcons.cube_box, size: 30.0),
                    const SizedBox(width: 8.0),
                    Text(counter.toString().padLeft(2, '0'), style: const TextStyle(fontSize: 30.0)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OrderRecordingShimmer extends StatelessWidget {
  const OrderRecordingShimmer({super.key});

  Widget _tile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          // Container(
          //   width: 20.0,
          //   height: 30.0,
          //   decoration: BoxDecoration(
          //     color: CupertinoColors.white,
          //     borderRadius: BorderRadius.circular(8.0),
          //   ),
          // ),
          // const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 12.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                const SizedBox(height: 4.0),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 12.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: List.filled(
                2,
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 24.0),
          ListView.separated(
            itemCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) {
              return const SizedBox(height: 24.0);
            },
            itemBuilder: (context, index) {
              return _tile();
            },
          ),
        ],
      ),
    );
  }
}


class OrderRecordingItemTile extends StatelessWidget {
  const OrderRecordingItemTile({
    super.key,
    required this.price,
    required this.title,
    required this.from,
    required this.to,
    this.onTap,
  });
  final String? title;
  final double price;
  final String from;
  final String to;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    final cupertinoTheme = context.cupertinoTheme;
    return CustomListTile(
      height: 60.0,
      leading: CustomCircleAvatar(
        radius: 18.0,
        elevation: 0.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: const Icon(Icons.motorcycle),
      ),
      trailing: Text('$price F', style: cupertinoTheme.textTheme.navTitleTextStyle),
      title: Text((title ?? localizations.order).capitalize(), style: cupertinoTheme.textTheme.textStyle),
      // subtitle: Text(localizations.fromto(from, to).capitalize()),
      onTap: onTap,
    );
  }
}
