import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '_widget.dart';

class HelpFaqAppBar extends DefaultAppBar {
  const HelpFaqAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoNavigationBar(
      middle: Text('Aide/Faq'),
    );
  }
}

class HelpFaqListTile extends StatelessWidget {
  const HelpFaqListTile({
    super.key,
    required this.message,
    required this.title,
    required this.index,
  });
  final int index;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
      child: ExpansionTile(
        expandedAlignment: Alignment.topLeft,
        textColor: context.theme.colorScheme.onPrimary,
        iconColor: context.theme.colorScheme.onPrimary,
        backgroundColor: context.theme.colorScheme.primary,
        title: FittedBox(
          alignment: Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child: Text(title),
        ),
        leading: CircleAvatar(child: Text(index.toString().padLeft(2, '0'))),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: DefaultTextStyle(
              style: TextStyle(color: context.theme.colorScheme.onPrimary),
              child: Text(message),
            ),
          ),
        ],
      ),
    );
  }
}

class HelpFaqShimmer extends StatelessWidget {
  const HelpFaqShimmer({super.key});

  Widget _tile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0),
      child: Row(
        children: [
          const CircleAvatar(backgroundColor: CupertinoColors.white),
          const SizedBox(width: 12.0),
          Expanded(
            child: Container(
              height: 16.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(30.0),
              ),
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
      child: ListView.separated(
        itemCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        separatorBuilder: (context, index) {
          return const SizedBox(height: 26.0);
        },
        itemBuilder: (context, index) {
          return _tile();
        },
      ),
    );
  }
}
