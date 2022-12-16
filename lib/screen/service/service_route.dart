import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:maplibre_gl/mapbox_gl.dart';

import '_service.dart';

class RouteService extends ValueNotifier<RouteState> {
  RouteService([RouteState value = const InitRouteState()]) : super(value);

  static RouteService? _travelInstance;
  static RouteService travelInstance([RouteState value = const InitRouteState()]) {
    return _travelInstance ??= RouteService(value);
  }

  static RouteService? _pickupInstance;
  static RouteService pickupInstance([RouteState value = const InitRouteState()]) {
    return _pickupInstance ??= RouteService(value);
  }

  static RouteService? _deliveryInstance;
  static RouteService deliveryInstance([RouteState value = const InitRouteState()]) {
    return _deliveryInstance ??= RouteService(value);
  }

  Future<void> handle(RouteEvent event) => event._execute(this);

  void onState(ValueChanged<RouteState> callBack) => callBack(value);
}

abstract class RouteEvent {
  const RouteEvent();

  Future<void> _execute(RouteService service);
}

class GetRoute extends RouteEvent {
  const GetRoute({
    required this.destination,
    required this.source,
  });

  final LatLng source;
  final LatLng destination;

  String get _url => 'https://router.project-osrm.org/route/v1/driving/$_route?steps=true&continue_straight=true&overview=full';
  String get _route => '${destination.longitude},${destination.latitude};${source.longitude},${source.latitude}';

  @override
  Future<void> _execute(RouteService service) async {
    service.value = const PendingRouteState();
    try {
      final request = await HttpClient().getUrl(Uri.parse(_url));
      final response = await request.close();

      switch (response.statusCode) {
        case 200:
          final body = await response.transform(utf8.decoder).join();
          final data = await compute(RouteSchema.fromRawJsonList, body);
          service.value = RouteItemListState(data: data);
          break;
        default:
          service.value = FailureRouteState(
            message: 'internal error',
            event: this,
          );
      }
    } catch (error) {
      service.value = FailureRouteState(
        message: error.toString(),
        event: this,
      );
    }
  }

  // String get _url => '${RepositoryService.httpURL}/v1/api/routing';

  // @override
  // Future<void> _execute(RouteService service) async {
  //   service.value = const PendingRouteState();
  //   try {
  //     final response = await Dio().postUri<String>(
  //       Uri.parse(_url),
  //       data: jsonEncode({
  //         "long_from": source.longitude,
  //         "lat_from": source.latitude,
  //         "long_to": destination.longitude,
  //         "lat_to": destination.latitude,
  //       }),
  //     );
  //     log(response.data.toString());
  //     final data = await compute(RouteResult.fromServerJson, response.data!);
  //     service.value = RouteItemState(points: data.waypoints, routes: data.routes);
  //   } catch (error) {
  //     print(error);
  //     service.value = FailureRouteState(
  //       message: error.toString(),
  //       event: this,
  //     );
  //   }
  // }
}
