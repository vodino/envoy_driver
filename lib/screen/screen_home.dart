import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/mapbox_gl.dart';

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

  Future<void> _openOrderDelivery(void value) async {
    final popController = ValueNotifier<bool?>(null);
    final controller = showBottomSheet(
      context: _context,
      enableDrag: false,
      builder: (context) {
        return HomeOrderDeliveryScreen(
          popController: popController,
        );
      },
    );
    await controller.closed;
    final value = popController.value;
    if (value != null) {}
  }

  Future<void> _openOrderPickup(void value) async {
    final popController = ValueNotifier<bool?>(null);
    final controller = showBottomSheet(
      context: _context,
      enableDrag: false,
      builder: (context) {
        return HomeOrderPickupScreen(
          popController: popController,
        );
      },
    );
    await controller.closed;
    final value = popController.value;
    if (value != null) {
      _openOrderDelivery(null);
    }
  }

  Future<void> _openOrderStart(void value) async {
    final popController = ValueNotifier<bool?>(null);
    final controller = showBottomSheet(
      context: _context,
      enableDrag: false,
      builder: (context) {
        return HomeOrderStartScreen(
          popController: popController,
        );
      },
    );
    await controller.closed;
    final value = popController.value;
    if (value != null) {
      _openOrderPickup(null);
    }
  }

  Future<void> _openOfflineSheet() async {
    final popController = ValueNotifier<bool?>(null);
    final controller = showBottomSheet<bool?>(
      context: _context,
      enableDrag: false,
      builder: (context) {
        return HomeOfflineScreen(
          popController: popController,
        );
      },
    );
    await controller.closed;
    final value = popController.value;
    if (value != null) {
      _openOrderStart(null);
    }
  }

  void _locationPressed() {
    _myPositionFocus.value = true;
    _goToMyPosition();
  }

  void _afterLayout(BuildContext context) async {
    _context = context;
    await _openOfflineSheet();
  }

  /// MapLibre
  MaplibreMapController? _mapController;
  late final ValueNotifier<bool> _myPositionFocus;
  UserLocation? _userLocation;

  void _onMapCreated(MaplibreMapController controller) async {
    _mapController = controller;
    await _mapController!.updateContentInsets(EdgeInsets.only(bottom: _height * 0.4));
    _goToMyPosition();
  }

  void _onCameraIdle(PointerMoveEvent event) {
    _myPositionFocus.value = false;
  }

  void _onUserLocationUpdated(UserLocation location) {
    _locationService.value = UserLocationItemState(data: location);
  }

  void _goToMyPosition() {
    if (_userLocation != null && _mapController != null && _myPositionFocus.value) {
      final position = _userLocation!.position;
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
          bearing: _userLocation!.bearing!,
          target: position,
          tilt: 60.0,
          zoom: 18.0,
        )),
        duration: const Duration(seconds: 1),
      );
    }
  }

  /// LocationService
  late final LocationService _locationService;
  StreamSubscription? _locationSubscription;

  void _getCurrentLocation() {
    _locationService.handle(const GetLocation(subscription: true, distanceFilter: 5));
  }

  void _listenLocationState(BuildContext context, LocationState state) {
    if (state is UserLocationItemState) {
      _locationSubscription = state.subscription;
      _userLocation = state.data;
      _goToMyPosition();
    }
  }

  @override
  void initState() {
    super.initState();

    /// Maplibre
    _myPositionFocus = ValueNotifier(true);

    /// LocationService
    _locationService = LocationService.instance();
    _getCurrentLocation();
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
    return Scaffold(
      appBar: const HomeAppBar(),
      drawer: const HomeDrawer(),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      floatingActionButton: HomeFloatingActionButton(
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
      body: ValueListenableListener(
        listener: _listenLocationState,
        valueListenable: _locationService,
        child: AfterLayout(
          listener: _afterLayout,
          child: Listener(
            onPointerMove: _onCameraIdle,
            child: HomeMap(
              onMapCreated: _onMapCreated,
              onUserLocationUpdated: _onUserLocationUpdated,
            ),
          ),
        ),
      ),
    );
  }
}
