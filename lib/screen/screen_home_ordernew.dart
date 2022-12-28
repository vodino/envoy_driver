import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '_screen.dart';

class HomeOrderNewScreen extends StatefulWidget {
  const HomeOrderNewScreen({
    super.key,
    required this.order,
  });

  final Order order;

  @override
  State<HomeOrderNewScreen> createState() => _HomeOrderNewScreenState();
}

class _HomeOrderNewScreenState extends State<HomeOrderNewScreen> {
  /// Customer
  late final Duration _timeout;

  void _onTimeout() {
    Navigator.pop(context);
  }

  /// OrderService
  late final OrderService _orderService;

  void _acceptOrder() {
    _orderService.handle(
      ChangeOrderStatus(
        longitude: _userLocation!.longitude!,
        latitude: _userLocation!.latitude!,
        status: OrderStatus.accepted,
        order: widget.order,
      ),
    );
  }

  void _listenOrderState(BuildContext context, OrderState state) {
    if (state is OrderItemState) {
      Navigator.pop(context, widget.order);
    } else if (state is FailureOrderState) {}
  }

  /// LocationService
  late final LocationService _locationService;
  StreamSubscription? _locationSubscription;
  LocationData? _userLocation;

  void _listenLocationState(BuildContext context, LocationState state) {
    if (state is LocationItemState) {
      _locationSubscription = state.subscription;
      _userLocation = state.data;
    }
  }

  @override
  void initState() {
    super.initState();

    /// Customer
    _timeout = const Duration(seconds: 30);

    /// OrderService
    _orderService = OrderService();

    /// LocationService
    _locationService = LocationService.instance();
  }

  @override
  void dispose() {
    /// LocationService
    _locationSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return ValueListenableListener<LocationState>(
      initiated: true,
      listener: _listenLocationState,
      valueListenable: _locationService,
      child: FractionallySizedBox(
        heightFactor: 0.7,
        child: Scaffold(
          body: BottomAppBar(
            elevation: 0.0,
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const HomeOrderNewAppBar(),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const HomeOrderNewLoading(),
                      const SizedBox(height: 16.0),
                      SlideCountdownSeparated(
                        duration: _timeout,
                        onDone: _onTimeout,
                        icon: Text(
                          '${localizations.youare.capitalize()} ',
                          style: context.cupertinoTheme.textTheme.textStyle,
                        ),
                        suffixIcon: Text(
                          ' ${localizations.second}s',
                          style: context.cupertinoTheme.textTheme.textStyle,
                        ),
                        slideDirection: SlideDirection.up,
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ValueListenableConsumer<OrderState>(
                    listener: _listenOrderState,
                    valueListenable: _orderService,
                    builder: (context, orderState, child) {
                      VoidCallback? onAcceptPressed = _acceptOrder;
                      VoidCallback? onDeclinePressed = () => Navigator.pop(context);
                      if (orderState is PendingOrderState) {
                        onAcceptPressed = null;
                        onDeclinePressed = null;
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: CustomOutlineButton(
                              onPressed: onDeclinePressed,
                              child: Text(localizations.refuse.capitalize()),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: CupertinoButton.filled(
                              onPressed: onAcceptPressed,
                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                              child: Visibility(
                                visible: onAcceptPressed != null,
                                replacement: const CupertinoActivityIndicator(),
                                child: Text(localizations.accept.capitalize()),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
