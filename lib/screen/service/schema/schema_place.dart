import 'dart:convert';

import 'package:equatable/equatable.dart';

class PlaceSchema extends Equatable {
  const PlaceSchema({
    this.title,
    this.subtitle,
    this.latitude,
    this.longitude,
  });

  static const titleKey = 'title';
  static const subtitleKey = 'subtitle';
  static const latitudeKey = 'latitude';
  static const longitudeKey = 'longitude';

  final String? title;
  final String? subtitle;
  final double? latitude;
  final double? longitude;

  @override
  List<Object?> get props => [
        title,
        subtitle,
        latitude,
        longitude,
      ];

  PlaceSchema copyWith({
    String? title,
    String? subtitle,
    double? latitude,
    double? longitude,
  }) {
    return PlaceSchema(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  PlaceSchema clone() {
    return copyWith(
      title: title,
      subtitle: subtitle,
      latitude: latitude,
      longitude: longitude,
    );
  }

  static PlaceSchema fromMap(Map<String, dynamic> data) {
    return PlaceSchema(
      title: data[titleKey],
      subtitle: data[subtitleKey],
      latitude: data[latitudeKey],
      longitude: data[longitudeKey],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      titleKey: title,
      subtitleKey: subtitle,
      latitudeKey: latitude,
      longitudeKey: longitude,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  static PlaceSchema fromJson(String value) {
    return fromMap(jsonDecode(value));
  }

  static List<PlaceSchema> fromJsonList(String value) {
    return List.of(
      (jsonDecode(value) as List).map((map) => fromMap(map)),
    );
  }

  static String toJsonList(List<PlaceSchema> value) {
    return jsonEncode(List.of(value.map((e) => e.toMap())));
  }

  @override
  String toString() {
    return toMap().toString();
  }
}