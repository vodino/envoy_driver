import 'package:flutter/cupertino.dart';


class HomeOrderStartAppBar extends StatelessWidget {
  const HomeOrderStartAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      border: const Border.fromBorderSide(BorderSide.none),
      automaticallyImplyLeading: false,
      transitionBetweenRoutes: false,
      middle: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            CupertinoIcons.cube_box_fill,
            color: CupertinoColors.systemGrey,
          ),
          SizedBox(width: 8.0),
          Text('Nouvelle course'),
        ],
      ),
    );
  }
}
