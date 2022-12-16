import 'dart:convert';

import 'package:isar/isar.dart';

part 'schema_client.g.dart';

enum ClientStatus {
  online('online'),
  offline('offline');

  const ClientStatus(this.value);
  final String value;

  static ClientStatus? fromString(String value) {
    for (final item in values) {
      if (item.value == value) return item;
    }
    return null;
  }
}

@embedded
class Client {
  Client({
    this.id,
    this.accessToken,
    this.fullName,
    this.phoneNumber,
  });

  static const idKey = 'id';
  static const fullNameKey = 'full_name';
  static const accessTokenKey = 'accessToken';
  static const phoneNumberKey = 'phone_number';

  int? id;
  String? fullName;
  String? phoneNumber;
  String? accessToken;

  @override
  String toString() {
    return toMap().toString();
  }

  Client copyWith({
    int? id,
    String? fullName,
    String? accessToken,
    String? phoneNumber,
  }) {
    return Client(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fullName: fullName ?? this.fullName,
      accessToken: accessToken ?? this.accessToken,
    );
  }

  Client clone() {
    return copyWith(
      id: id,
      fullName: fullName,
      phoneNumber: phoneNumber,
      accessToken: accessToken,
    );
  }

  static Client fromMap(Map<String, dynamic> value) {
    return Client(
      id: value[idKey],
      phoneNumber: value[phoneNumberKey],
      fullName: value[fullNameKey],
      accessToken: value[accessTokenKey],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      idKey: id,
      phoneNumberKey: phoneNumber,
      fullNameKey: fullName,
      accessTokenKey: accessToken,
    };
  }

  static List<Client> fromServerListJson(String source) {
    return List.of((jsonDecode(source)['data'] as List).map((map) => fromMap(map)));
  }

  static Client fromServerJson(String source) {
    final data = jsonDecode(source);
    return fromMap(data['data']).copyWith(
      accessToken: data[accessTokenKey],
    );
  }

  static Client fromJson(String source) {
    return fromMap(jsonDecode(source));
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
