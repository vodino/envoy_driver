import 'dart:convert';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:maplibre_gl/mapbox_gl.dart';

import '_schema.dart';

class RouteSchema extends Equatable {
  const RouteSchema({
    this.coordinates,
    this.bounds,
  });

  static const coordinatesKey = 'coordinates';
  static const boundsKey = 'bounds';

  final LatLngBounds? bounds;
  final List<LatLng>? coordinates;

  @override
  List<Object?> get props => [
        coordinates,
        bounds,
      ];

  RouteSchema copyWith({
    LatLngBounds? bounds,
    List<LatLng>? coordinates,
  }) {
    return RouteSchema(
      coordinates: coordinates ?? this.coordinates,
      bounds: bounds ?? this.bounds,
    );
  }

  RouteSchema clone() {
    return copyWith(
      coordinates: coordinates,
      bounds: bounds,
    );
  }

  static RouteSchema fromMap(Map<String, dynamic> data) {
    return RouteSchema(
      bounds: data[boundsKey],
      coordinates: data[coordinatesKey].cast<double>(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      coordinatesKey: coordinates,
      boundsKey: bounds,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  static RouteSchema fromJson(String value) {
    return fromMap(jsonDecode(value));
  }

  static List<RouteSchema> fromJsonList(String value) {
    return List.of(
      (jsonDecode(value) as List).map((map) => fromMap(map)),
    );
  }

  static List<RouteSchema> fromRawJsonList(String value) {
    final result = RouteResult.fromJson(value);
    return List.of(result.routes.map((route) {
      final coordinates = route.polyline;
      return RouteSchema(
        coordinates: coordinates,
        bounds: computeBounds(coordinates),
      );
    }));
  }

  static String toJsonList(List<RouteSchema> value) {
    return jsonEncode(List.of(value.map((e) => e.toMap())));
  }

  @override
  String toString() {
    return toMap().toString();
  }

  static LatLngBounds computeBounds(List<LatLng> list) {
    assert(list.isNotEmpty);
    var firstLatLng = list.first;
    var s = firstLatLng.latitude, n = firstLatLng.latitude, w = firstLatLng.longitude, e = firstLatLng.longitude;
    for (var i = 1; i < list.length; i++) {
      var latlng = list[i];
      s = min(s, latlng.latitude);
      n = max(n, latlng.latitude);
      w = min(w, latlng.longitude);
      e = max(e, latlng.longitude);
    }
    return LatLngBounds(southwest: LatLng(s, w), northeast: LatLng(n, e));
  }
}
