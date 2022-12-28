import 'dart:async';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:maplibre_gl/mapbox_gl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String path = '/';
  static const String name = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Customer
  late final BuildContext _context;
  late double _height;

  void _openOrderFeedback(Order order) {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        return OrderFeedbackScreen(order: order);
      },
    );
  }

  void _openHomeOrderList() async {
    await _clearMap();

    ///
    final popController = ValueNotifier<Order?>(null);
    final controller = showBottomSheet(
      context: _context,
      enableDrag: false,
      builder: (context) {
        return HomeDeliveryScreen(
          popController: popController,
        );
      },
    );
    await controller.closed;
    final value = popController.value;
    if (value != null) {
      switch (value.status) {
        case OrderStatus.accepted:
          _openOrderStart(value);
          break;
        case OrderStatus.started:
          _openOrderPickup(value);
          break;
        case OrderStatus.collected:
          _openOrderDelivery(value);
          break;
        default:
      }
    } else {
      _openOnlineSheet();
    }
  }

  Future<void> _openOrderDelivery(Order data) async {
    final popController = ValueNotifier<Order?>(null);
    final controller = showBottomSheet(
      context: _context,
      enableDrag: false,
      builder: (context) {
        return HomeOrderDeliveryScreen(
          popController: popController,
          order: data,
        );
      },
    );
    await controller.closed;
    final value = popController.value;
    if (value != null) {
      _openOnlineSheet(true);
      _openOrderFeedback(value);
    } else {
      _openOnlineSheet();
    }
  }

  Future<void> _openOrderPickup(Order data) async {
    final popController = ValueNotifier<Order?>(null);
    final controller = showBottomSheet(
      context: _context,
      enableDrag: false,
      builder: (context) {
        return HomeOrderPickupScreen(
          popController: popController,
          order: data,
        );
      },
    );
    await controller.closed;
    final value = popController.value;
    if (value != null) {
      _openOrderDelivery(value);
    } else {
      _openOnlineSheet();
    }
  }

  Future<void> _openOrderStart(Order data) async {
    final popController = ValueNotifier<Order?>(null);
    final controller = showBottomSheet(
      context: _context,
      enableDrag: false,
      builder: (context) {
        return HomeOrderStartScreen(
          popController: popController,
          order: data,
        );
      },
    );
    await controller.closed;
    final value = popController.value;
    if (value != null) {
      _openOrderPickup(value);
    } else {
      _openOnlineSheet();
    }
  }

  Future<void> _openOnlineSheet([bool subscribed = false]) async {
    await _clearMap();

    ///
    final popController = ValueNotifier<Order?>(null);
    final controller = showBottomSheet(
      context: _context,
      enableDrag: false,
      builder: (context) {
        return HomeOnlineScreen(
          popController: popController,
        );
      },
    );
    await controller.closed;
    final value = popController.value;
    if (value != null) {
      _openOrderStart(value);
    } else {
      _openOnlineSheet();
    }
  }

  void _locationPressed() {
    _myPositionFocus.value = true;
    _goToMyPosition();
  }

  void _afterLayout(BuildContext context) async {
    _context = context;
    await _openOnlineSheet();
  }

  /// MapLibre
  MaplibreMapController? _mapController;
  late final ValueNotifier<bool> _myPositionFocus;
  UserLocation? _userLocation;

  void _onMapCreated(MaplibreMapController controller) async {
    _mapController = controller;
    final bottom =  Platform.isIOS ? _height * 0.4 : _height * 0.75;
    await _mapController!.updateContentInsets(EdgeInsets.only(bottom: bottom));
    _goToMyPosition();
  }

  void _onPointUp(PointerUpEvent event) {
    _myPositionFocus.value = false;
  }

  void _onUserLocationUpdated(UserLocation location) {
    if (_userLocation == null) {
      _locationService.value = LocationItemState(
        data: LocationData.fromMap({
          'longitude': location.position.longitude,
          'latitude': location.position.latitude,
        }),
      );
    }
    _userLocation = location;
    _goToMyPosition();
  }

  void _goToMyPosition() {
    if (_userLocation != null && _mapController != null && _myPositionFocus.value) {
      final position = _userLocation!.position;
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
          bearing: _userLocation!.heading?.trueHeading ?? 0,
          target: position,
          tilt: 60.0,
          zoom: 16.0,
        )),
        duration: const Duration(seconds: 1),
      );
    }
  }

  Future<void> _drawLines({
    required RouteSchema route,
    required Color color,
  }) async {
    _myPositionFocus.value = false;

    /// Draw
    final options = LineOptions(lineColor: color.toHexStringRGB(), lineJoin: 'round', lineWidth: 4.0);
    // _drawIcon(path: Assets.images.mappinBlue.path, position: route.coordinates!.last);
    // _drawIcon(path: Assets.images.mappinOrange.path, position: route.coordinates!.first);
    _mapController!.addLine(options.copyWith(LineOptions(geometry: route.coordinates)));
    // final bottom = _height * 0.2;
    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(route.bounds! // ,bottom: bottom, left: 30.0, right: 30.0
        ));
  }

  Future<Symbol> _drawSymbol({required String path, required LatLng position, double? heading}) {
    final options = SymbolOptions(iconRotate: heading, geometry: position, iconImage: path);
    return _mapController!.addSymbol(options);
  }

  Future<Symbol> _loadImage({required String path, required LatLng position, double? heading}) async {
    final buffer = await rootBundle.load(path);
    final bytes = buffer.buffer.asUint8List();
    await _mapController!.addImage(path, bytes);
    return _drawSymbol(path: path, position: position, heading: heading);
  }

  Future<void> _clearMap() async {
    if (_mapController == null) return;
    await Future.wait([
      // if (_pickupSymbol != null) _mapController!.removeSymbol(_pickupSymbol!),
      // if (_deliverySymbol != null) _mapController!.removeSymbol(_deliverySymbol!),
      _mapController!.clearSymbols(),
      _mapController!.clearLines(),
    ]);
  }

  /// LocationService
  late final LocationService _locationService;
  StreamSubscription? _locationSubscription;

  void _getCurrentLocation() {
    _locationService.handle(const GetLocation(
      subscription: true,
      distanceFilter: 5,
    ));
  }

  void _listenLocationState(BuildContext context, LocationState state) {
    if (state is LocationItemState) {
      _locationSubscription = state.subscription;
      _goToMyPosition();
    }
  }

  /// RouteService
  late final RouteService _travelRouteService;
  late final RouteService _pickupRouteService;
  late final RouteService _deliveryRouteService;

  void _listenTravelRouteState(BuildContext context, RouteState state) {
    if (state is InitRouteState) {
      _clearMap();
    } else if (state is RouteItemListState) {
      final route = state.data.first;
      _loadImage(path: Assets.images.mappinBlue.path, position: route.coordinates!.last);
      _loadImage(path: Assets.images.mappinOrange.path, position: route.coordinates!.first);
      _drawLines(route: route, color: CupertinoColors.black);
    }
  }

  void _listenPickupRouteState(BuildContext context, RouteState state) {
    if (state is InitRouteState) {
      _clearMap();
    } else if (state is RouteItemListState) {
      final route = state.data.first;
      _drawLines(route: route, color: CupertinoColors.activeBlue.withOpacity(0.5));
    }
  }

  void _listenDeliveryRouteState(BuildContext context, RouteState state) {
    if (state is InitRouteState) {
      _clearMap();
    } else if (state is RouteItemListState) {
      final route = state.data.first;
      _drawLines(route: route, color: CupertinoColors.activeOrange.withOpacity(0.5));
    }
  }

  /// OrderService
  late final OrderService _orderService;

  void _getOrderList() {
    _orderService.handle(const GetOrderList(
      notEqualStatus: OrderStatus.delivered,
      isNullStatus: false,
      subscription: true,
    ));
  }

  void _listenOrderState(BuildContext context, OrderState state) {}

  @override
  void initState() {
    super.initState();

    /// Maplibre
    _myPositionFocus = ValueNotifier(true);

    /// LocationService
    _locationService = LocationService.instance();
    _getCurrentLocation();

    /// RouteService
    _travelRouteService = RouteService.travelInstance();
    _pickupRouteService = RouteService.pickupInstance();
    _deliveryRouteService = RouteService.deliveryInstance();

    /// OrderService
    _orderService = OrderService();
    _getOrderList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.of(context);
    _height = mediaQuery.size.height;
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableListener<RouteState>(
      listener: _listenDeliveryRouteState,
      valueListenable: _deliveryRouteService,
      child: ValueListenableListener<RouteState>(
        listener: _listenPickupRouteState,
        valueListenable: _pickupRouteService,
        child: ValueListenableListener<RouteState>(
          listener: _listenTravelRouteState,
          valueListenable: _travelRouteService,
          child: Scaffold(
            appBar: const HomeAppBar(),
            drawer: const HomeDrawer(),
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ValueListenableConsumer<OrderState>(
                    listener: _listenOrderState,
                    valueListenable: _orderService,
                    builder: (context, state, child) {
                      List<Order>? items;
                      if (state is OrderItemListState) items = state.data;
                      return Visibility(
                        visible: items != null && items.isNotEmpty,
                        child: HomeFloatingActionButton(
                          onPressed: _openHomeOrderList,
                          child: Builder(builder: (context) {
                            return Badge(
                              badgeContent: Text(
                                items!.length.toString(),
                                style: const TextStyle(color: CupertinoColors.white),
                              ),
                              child: const Icon(CupertinoIcons.cube_box_fill),
                            );
                          }),
                        ),
                      );
                    },
                  ),
                  HomeFloatingActionButton(
                    onPressed: _locationPressed,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _myPositionFocus,
                      builder: (context, visible, child) {
                        return Visibility(
                          visible: visible,
                          replacement: const Icon(CupertinoIcons.location),
                          child: const Icon(CupertinoIcons.location_fill),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            body: ValueListenableListener(
              initiated: true,
              listener: _listenLocationState,
              valueListenable: _locationService,
              child: AfterLayout(
                listener: _afterLayout,
                child: Listener(
                  onPointerUp: _onPointUp,
                  child: HomeMap(
                    onMapCreated: _onMapCreated,
                    onUserLocationUpdated: _onUserLocationUpdated,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
