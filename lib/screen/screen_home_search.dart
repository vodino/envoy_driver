import 'dart:async';

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
  /// Customer
  late final ValueNotifier<bool> _activeController;

  void _openNewOrderModal(OrderSchema data) async {
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
      if (mounted) Navigator.pop(context, data);
    }
  }

  /// OrderService
  late final OrderService _orderService;
  Future<void> Function()? _canceller;

  void _listenOrderState(BuildContext context, OrderState state) {
    print(state);
    if (state is SubscriptionOrderState) {
      _canceller = state.canceller;
    } else if (state is NewOrderOrderState) {
      _openNewOrderModal(state.data);
    } else if (state is FailureOrderState) {
      // _activeController.value = false;
      // _canceller?.call();
    }
  }

  void _subscribe() {
    _activeController.value = true;
    _orderService.handle(const SubscribeNewOrder());
  }

  void _unsubscribe() async {
    await _canceller?.call();
    _activeController.value = false;
  }

  @override
  void initState() {
    super.initState();

    /// Customer
    _activeController = ValueNotifier(false);

    /// OrderService
    _orderService = OrderService();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.5,
      child: BottomAppBar(
        elevation: 0.0,
        color: Colors.transparent,
        child: ValueListenableConsumer<OrderState>(
            listener: _listenOrderState,
            valueListenable: _orderService,
            builder: (context, pusherState, child) {
              return ValueListenableBuilder<bool>(
                valueListenable: _activeController,
                builder: (context, active, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HomeSearchAppBar(active: active),
                      Expanded(child: HomeSearchLoading(active: active)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Visibility(
                          visible: active,
                          replacement: Builder(
                            builder: (context) {
                              VoidCallback? onPressed = _subscribe;
                              if (pusherState is PendingPusherState) onPressed = null;
                              return CupertinoButton.filled(
                                onPressed: onPressed,
                                child: Visibility(
                                  visible: onPressed != null,
                                  replacement: const CupertinoActivityIndicator.partiallyRevealed(),
                                  child: const Text('Se mettre en ligne'),
                                ),
                              );
                            },
                          ),
                          child: CustomOutlineButton(
                            onPressed: _unsubscribe,
                            child: const Text('Arrêter'),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
      ),
    );
  }
}
