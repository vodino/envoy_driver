import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

import '_service.dart';

class LocationService extends ValueNotifier<LocationState> {
  LocationService([
    LocationState value = const InitLocationState(),
  ]) : super(value);

  static LocationService? _instance;
  static LocationService instance([
    LocationState value = const InitLocationState(),
  ]) {
    return _instance ??= LocationService(value);
  }

  Future<void> handle(LocationEvent event) => event._execute(this);
}

abstract class LocationEvent {
  const LocationEvent();

  Future<void> _execute(LocationService service);
}
class GetLocation extends LocationEvent {
  const GetLocation({
    this.subscription = false,
    this.distanceFilter = 0,
  });

  final bool subscription;
  final double distanceFilter;

  @override
  Future<void> _execute(LocationService service) async {
    try {
      final location = Location();
      if (subscription) {
        location.changeSettings(distanceFilter: distanceFilter, interval: const Duration(seconds: 15).inMilliseconds);
        StreamSubscription? subscription;
        subscription = location.onLocationChanged.listen((data) {
          service.value = LocationItemState(subscription: subscription, data: data);
        });
      } else {
        final data = await location.getLocation();
        service.value = LocationItemState(data: data);
      }
    } catch (error) {
      service.value = FailureLocationState(
        message: error.toString(),
        event: this,
      );
    }
  }
}