import 'dart:async';

import 'package:location/location.dart';
import 'package:maplibre_gl/mapbox_gl.dart';

import '_service.dart';

abstract class LocationState {
  const LocationState();
}

class InitLocationState extends LocationState {
  const InitLocationState();
}

class PendingLocationState extends LocationState {
  const PendingLocationState();
}

class FailureLocationState extends LocationState {
  const FailureLocationState({
    required this.message,
    this.event,
  });
  final LocationEvent? event;
  final String message;
}

class LocationItemState extends LocationState {
  const LocationItemState({
    required this.data,
    this.subscription,
  });
  final StreamSubscription? subscription;
  final LocationData data;
}

class UserLocationItemState extends LocationState {
  const UserLocationItemState({
    required this.data,
    this.subscription,
  });
  final StreamSubscription? subscription;
  final UserLocation data;
}

class LocationItemListState extends LocationState {
  const LocationItemListState({
    required this.data,
    this.subscription,
  });
  final StreamSubscription? subscription;
  final List<LocationData> data;
}
