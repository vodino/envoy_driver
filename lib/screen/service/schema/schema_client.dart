import 'dart:convert';

import 'package:isar/isar.dart';

part 'schema_client.g.dart';

enum ClientStatus {
  online('online'),
  offline('offline');

  const ClientStatus(this.value);
  final String value;

  static ClientStatus? fromString(String? value) {
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
    this.status,
    this.avatar,
    this.fullName,
    this.accessToken,
    this.phoneNumber,
  });

  static const String idKey = 'id';
  static const String avatarKey = 'avatar';
  static const String statusKey = 'status';
  static const String fullNameKey = 'full_name';
  static const String accessTokenKey = 'accessToken';
  static const String phoneNumberKey = 'phone_number';

  int? id;
  String? avatar;
  String? fullName;
  String? phoneNumber;
  String? accessToken;
  ClientStatus? status;

  @override
  String toString() {
    return toMap().toString();
  }

  Client copyWith({
    int? id,
    String? avatar,
    String? fullName,
    String? accessToken,
    String? phoneNumber,
    ClientStatus? status,
  }) {
    return Client(
      id: id ?? this.id,
      avatar: avatar ?? this.avatar,
      status: status ?? this.status,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      accessToken: accessToken ?? this.accessToken,
    );
  }

  Client clone() {
    return copyWith(
      id: id,
      status: status,
      avatar: avatar,
      fullName: fullName,
      phoneNumber: phoneNumber,
      accessToken: accessToken,
    );
  }

  static Client fromMap(Map<String, dynamic> value) {
    return Client(
      id: value[idKey],
      avatar: value[avatarKey],
      fullName: value[fullNameKey],
      phoneNumber: value[phoneNumberKey],
      accessToken: value[accessTokenKey],
      status: ClientStatus.fromString(value[value]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      idKey: id,
      avatarKey: avatar,
      fullNameKey: fullName,
      statusKey: status?.value,
      phoneNumberKey: phoneNumber,
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
