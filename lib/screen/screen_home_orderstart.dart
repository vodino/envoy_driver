import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:location/location.dart';
import 'package:maplibre_gl/mapbox_gl.dart';

import '_screen.dart';

class HomeOrderStartScreen extends StatefulWidget {
  const HomeOrderStartScreen({
    super.key,
    required this.popController,
    required this.order,
  });

  final ValueNotifier<Order?> popController;
  final Order order;

  @override
  State<HomeOrderStartScreen> createState() => _HomeOrderStartScreenState();
}

class _HomeOrderStartScreenState extends State<HomeOrderStartScreen> {
  /// OrderService
  late final OrderService _orderService;

  void _listenOrderState(BuildContext context, OrderState state) {
    if (state is OrderItemState) {
      widget.popController.value = widget.order;
      Navigator.pop(context);
    }
  }

  void _startOrder() {
    _orderService.handle(
      ChangeOrderStatus(
        longitude: _userLocation!.longitude!,
        latitude: _userLocation!.latitude!,
        status: OrderStatus.started,
        order: widget.order,
      ),
    );
  }

  /// RouteService
  late final RouteService _travelRouteService;

  void _getRoute() {
    _travelRouteService.handle(GetRoute(
      destination: LatLng(
        widget.order.deliveryPlace!.latitude!,
        widget.order.deliveryPlace!.longitude!,
      ),
      source: LatLng(
        widget.order.pickupPlace!.latitude!,
        widget.order.pickupPlace!.longitude!,
      ),
    ));
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

    /// OrderService
    _orderService = OrderService();

    /// RouteService
    _travelRouteService = RouteService.travelInstance();
    _getRoute();

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
    return ValueListenableListener<LocationState>(
      initiated: true,
      listener: _listenLocationState,
      valueListenable: _locationService,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: BottomAppBar(
          elevation: 0.0,
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HomeOrderStartAppBar(),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 8.0),
                    CustomListTile(
                      leading: const Icon(CupertinoIcons.circle, color: CupertinoColors.activeBlue, size: 16.0),
                      title: Text(
                        widget.order.pickupPlace!.title!,
                        style: context.cupertinoTheme.textTheme.textStyle,
                      ),
                    ),
                    const Divider(),
                    CustomListTile(
                      leading: const Icon(CupertinoIcons.circle, color: CupertinoColors.activeOrange, size: 16.0),
                      title: Text(
                        widget.order.deliveryPlace!.title!,
                        style: context.cupertinoTheme.textTheme.textStyle,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Divider(thickness: 8.0, height: 12.0),
                    CustomListTile(
                      title: const Text('Revenu :'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${widget.order.price} FCFA",
                            style: context.cupertinoTheme.textTheme.navTitleTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: -1.0,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Assets.images.moneyStack.svg(height: 24.0),
                        ],
                      ),
                    ),
                    CustomListTile(
                      title: const Text('Distance :'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "15 KM",
                            style: context.cupertinoTheme.textTheme.navTitleTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: -1.0,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          const Icon(CupertinoIcons.arrow_branch),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: CounterBuilder(
                  duration: widget.order.scheduledDate?.difference(DateTime.now()) ?? Duration.zero,
                  builder: (context, duration, child) {
                    return ValueListenableConsumer<OrderState>(
                      listener: _listenOrderState,
                      valueListenable: _orderService,
                      builder: (context, state, child) {
                        VoidCallback? onPressed = _startOrder;
                        if (state is PendingOrderState) onPressed = null;
                        if (duration.inSeconds != 0) onPressed = null;
                        final style = TextStyle(color: onPressed == null ? CupertinoColors.systemGrey2 : null);
                        Jiffy.locale(window.locale.languageCode);
                        final jiffy = Jiffy({"year": widget.order.scheduledDate?.year, "month": widget.order.scheduledDate?.month, "day": widget.order.scheduledDate?.day, "hour": widget.order.scheduledDate?.hour, "minute": widget.order.scheduledDate?.minute});
                        return CupertinoButton.filled(
                          padding: EdgeInsets.zero,
                          onPressed: onPressed,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Visibility(
                              visible: state is! PendingOrderState,
                              replacement: const CupertinoActivityIndicator(),
                              child: Text('Commencer${duration != Duration.zero ? ' ${jiffy.fromNow()}' : ''}', style: style),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
