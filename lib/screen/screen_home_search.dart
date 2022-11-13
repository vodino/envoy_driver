import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '_screen.dart';

class HomeOfflineScreen extends StatefulWidget {
  const HomeOfflineScreen({
    super.key,
    required this.popController,
  });

  final ValueNotifier<bool?> popController;

  @override
  State<HomeOfflineScreen> createState() => _HomeOfflineScreenState();
}

class _HomeOfflineScreenState extends State<HomeOfflineScreen> {
  late final ValueNotifier<bool> _userStatus;

  @override
  void initState() {
    super.initState();
    _userStatus = ValueNotifier(false);
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.5,
      child: BottomAppBar(
        elevation: 0.0,
        color: Colors.transparent,
        child: ValueListenableBuilder<bool>(
          valueListenable: _userStatus,
          builder: (context, active, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 60.0,
                  child: CupertinoNavigationBar(
                    transitionBetweenRoutes: false,
                    automaticallyImplyLeading: false,
                    border: const Border.fromBorderSide(BorderSide.none),
                    middle: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: active,
                          replacement: const Text('Vous êtes actuellement hors ligne'),
                          child: const Text("En attente de nouvelles courses..."),
                        ),
                        const SizedBox(width: 8.0),
                        Icon(
                          CupertinoIcons.circle_fill,
                          color: active ? CupertinoColors.activeGreen : CupertinoColors.destructiveRed,
                          size: 12.0,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    child: AspectRatio(
                      aspectRatio: 1.7,
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(100.0),
                        child: FittedBox(
                          child: Ripple(
                            animate: active,
                            color: context.theme.primaryColorDark,
                            child: CustomButton(
                              onPressed: () {
                                _userStatus.value = !_userStatus.value;
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: CircleAvatar(
                                  radius: 60.0,
                                  foregroundColor: active ? null : CupertinoColors.systemGrey,
                                  backgroundColor: active ? null : CupertinoColors.systemFill,
                                  child: Visibility(
                                    visible: active,
                                    replacement: const Icon(CupertinoIcons.wifi_slash, size: 50.0),
                                    child: const Icon(CupertinoIcons.wifi, size: 50.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Visibility(
                    visible: active,
                    replacement: CupertinoButton.filled(
                      child: const Text('Se mettre en ligne'),
                      onPressed: () {
                        _userStatus.value = true;
                      },
                    ),
                    child: CustomOutlineButton(
                      child: const Text('Arrêter'),
                      onPressed: () async {
                        _userStatus.value = false;
                        final value = await showModalBottomSheet<bool>(
                          context: context,
                          enableDrag: false,
                          isDismissible: false,
                          isScrollControlled: true,
                          builder: (context) {
                            return const HomeOrderNewScreen();
                          },
                        );
                        if (value != null) {
                          widget.popController.value = true;
                          if (mounted) Navigator.pop(context, true);
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
