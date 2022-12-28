import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:maplibre_gl/mapbox_gl.dart';
import 'package:url_launcher/url_launcher.dart';

import '_screen.dart';

class HomeOrderDeliveryScreen extends StatefulWidget {
  const HomeOrderDeliveryScreen({
    super.key,
    required this.popController,
    required this.order,
  });

  final ValueNotifier<Order?> popController;
  final Order order;

  @override
  State<HomeOrderDeliveryScreen> createState() => _HomeOrderDeliveryScreenState();
}

class _HomeOrderDeliveryScreenState extends State<HomeOrderDeliveryScreen> {
  /// Customer

  Future<void> _openPhonesModal(List<String> phones) async {
    final value = await showDialog<String>(
      context: context,
      builder: (context) {
        return HomeOrderPickupPhonesModal(
          onPhone: (value) => Navigator.pop(context, value),
          onCancel: () => Navigator.pop(context),
          phones: phones,
        );
      },
    );
    if (value != null) {
      _launchPhone(value);
    }
  }

  void _launchPhone(String phone) {
    launchUrl(Uri(scheme: 'tel', host: phone));
  }

  /// OrderService
  late final OrderService _orderService;

  void _listenOrderState(BuildContext context, OrderState state) {
    if (state is OrderItemState) {
      widget.popController.value = widget.order;
      Navigator.pop(context);
    }
  }

  void _deliveryOrder() {
    _orderService.handle(
      ChangeOrderStatus(
        longitude: _userLocation!.longitude!,
        latitude: _userLocation!.latitude!,
        status: OrderStatus.delivered,
        order: widget.order,
      ),
    );
  }

  /// LocationService
  late final LocationService _locationService;
  StreamSubscription? _locationSubscription;
  LocationData? _userLocation;

  void _listenLocationState(BuildContext context, LocationState state) {
    if (state is LocationItemState) {
      _locationSubscription = state.subscription;
      _userLocation = state.data;
      _updateLocation(_userLocation!);
      _getDeliveryRoute(_userLocation!);
    }
  }

  /// ClientService
  late final ClientService _clientService;

  void _listenClientState(BuildContext context, ClientState state) {}

  void _updateLocation(LocationData position) {
    _clientService.handle(UpdateClientLocation(
      longitude: position.longitude!,
      latitude: position.latitude!,
      orderId: widget.order.id,
    ));
  }

  /// RouteService
  late final RouteService _travelRouteService;
  late final RouteService _deliveryRouteService;

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

  void _getDeliveryRoute(LocationData position) {
    _deliveryRouteService.handle(GetRoute(
      destination: LatLng(
        widget.order.deliveryPlace!.latitude!,
        widget.order.deliveryPlace!.longitude!,
      ),
      source: LatLng(
        position.latitude!,
        position.longitude!,
      ),
    ));
  }

  @override
  void initState() {
    super.initState();

    /// OrderService
    _orderService = OrderService();

    /// LocationService
    _locationService = LocationService.instance();

    /// RouteService
    _travelRouteService = RouteService.travelInstance();
    _deliveryRouteService = RouteService.deliveryInstance();
    _getRoute();

    /// ClientService
    _clientService = ClientService();
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
    return ValueListenableListener<ClientState>(
      listener: _listenClientState,
      valueListenable: _clientService,
      child: ValueListenableListener<LocationState>(
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
                const HomeOrderDeliveryAppBar(),
                Builder(
                  builder: (context) {
                    final phones = widget.order.deliveryPhoneNumber!.phones!;
                    return HomeOrderPickupTile(
                      color: CupertinoColors.activeOrange,
                      title: phones.join(', '),
                      onTap: () {
                        if (phones.length == 1) {
                          _launchPhone(phones.first);
                        } else {
                          _openPhonesModal(phones);
                        }
                      },
                    );
                  }
                ),
                CustomLocationTile(
                  title: widget.order.deliveryPlace!.title!,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Material(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      color: CupertinoColors.systemGrey5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Visibility(
                              visible: widget.order.deliveryAdditionalInfo != null,
                              child: Builder(
                                builder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      widget.order.deliveryAdditionalInfo!,
                                      style: context.cupertinoTheme.textTheme.textStyle,
                                      overflow: TextOverflow.clip,
                                      softWrap: true,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Visibility(
                              visible: widget.order.audioPath != null,
                              child: const CustomAudioPlayer(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                ValueListenableConsumer<OrderState>(
                  listener: _listenOrderState,
                  valueListenable: _orderService,
                  builder: (context, state, child) {
                    VoidCallback? onPressed = _deliveryOrder;
                    if (state is PendingOrderState) onPressed = null;
                    return CustomSheetButton(
                      onPressed: onPressed,
                      child: Visibility(
                        visible: onPressed != null,
                        replacement: const CupertinoActivityIndicator(),
                        child: Text(localizations.idelivered.capitalize()),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
