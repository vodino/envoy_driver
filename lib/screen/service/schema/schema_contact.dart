import 'dart:convert';
import 'package:isar/isar.dart';

part 'schema_contact.g.dart';

@embedded
class Contact {
  Contact({
    this.name,
    this.phones,
  });

  static const nameKey = 'name';
  static const phonesKey = 'phones';

  String? name;
  List<String>? phones;

  Contact copyWith({
    String? name,
    List<String>? phones,
  }) {
    return Contact(
      name: name ?? this.name,
      phones: phones ?? this.phones,
    );
  }

  Contact clone() {
    return copyWith(
      name: name,
      phones: phones,
    );
  }

  static Contact fromMap(Map<String, dynamic> data) {
    return Contact(
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

  static Contact fromJson(String value) {
    return fromMap(jsonDecode(value));
  }

  static List<Contact> fromJsonList(String value) {
    return List.of(
      (jsonDecode(value) as List).map((map) => fromMap(map)),
    );
  }

  static String toJsonList(List<Contact> value) {
    return jsonEncode(List.of(value.map((e) => e.toMap())));
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
