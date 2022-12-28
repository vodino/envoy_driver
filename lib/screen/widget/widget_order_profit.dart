import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '_widget.dart';

class OrderProfitAppBar extends DefaultAppBar {
  const OrderProfitAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return CupertinoNavigationBar(
      middle: Text('${localizations.earning.capitalize()}s'),
      transitionBetweenRoutes: false,
    );
  }
}

class OrderProfitTab extends StatelessWidget {
  const OrderProfitTab({
    super.key,
    required this.label,
    this.active = false,
    this.onPressed,
  });

  final VoidCallback? onPressed;
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
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: IconTheme(
            data: IconThemeData(color: foregroundColor),
            child: DefaultTextStyle(
              style: TextStyle(color: foregroundColor),
              child: Tab(icon: FittedBox(child: Text(label))),
            ),
          ),
        ),
      ),
    );
  }
}

class OrderProfitCard extends StatelessWidget {
  const OrderProfitCard({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3.5,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: CupertinoColors.systemFill,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: context.theme.textTheme.caption),
            const SizedBox(height: 4.0),
            Text(
              content,
              style: context.cupertinoTheme.textTheme.navLargeTitleTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderProfitShimmer extends StatelessWidget {
  const OrderProfitShimmer({super.key});

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
          AspectRatio(
            aspectRatio: 3.5,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(12.0),
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
