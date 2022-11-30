import 'dart:convert';

import 'package:equatable/equatable.dart';

class ContactSchema extends Equatable {
  const ContactSchema({
    this.name,
    this.phones,
  });

  static const nameKey = 'name';
  static const phonesKey = 'phones';

  final String? name;
  final List<String>? phones;

  @override
  List<Object?> get props => [
        name,
        phones,
      ];

  ContactSchema copyWith({
    String? name,
    List<String>? phones,
  }) {
    return ContactSchema(
      name: name ?? this.name,
      phones: phones ?? this.phones,
    );
  }

  ContactSchema clone() {
    return copyWith(
      name: name,
      phones: phones,
    );
  }

  static ContactSchema fromMap(Map<String, dynamic> data) {
    return ContactSchema(
      name: data[nameKey],
      phones: data[phonesKey],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      nameKey: name,
      phonesKey: phones,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  static ContactSchema fromJson(String value) {
    return fromMap(jsonDecode(value));
  }

  static List<ContactSchema> fromJsonList(String value) {
    return List.of(
      (jsonDecode(value) as List).map((map) => fromMap(map)),
    );
  }

  static String toJsonList(List<ContactSchema> value) {
    return jsonEncode(List.of(value.map((e) => e.toMap())));
  }

  @override
  String toString() {
    return toMap().toString();
  }
}