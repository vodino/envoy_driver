import 'dart:convert';

import 'package:equatable/equatable.dart';

class ClientSchema extends Equatable {
  const ClientSchema({
    required this.accessToken,
    required this.fullName,
    required this.phoneNumber,
    required this.id,
  });

  static const idKey = 'id';
  static const fullNameKey = 'full_name';
  static const accessTokenKey = 'accessToken';
  static const phoneNumberKey = 'phone_number';

  final int? id;
  final String fullName;
  final String phoneNumber;
  final String accessToken;

  @override
  List<Object?> get props => [
        fullName,
        accessToken,
      ];

  @override
  String toString() {
    return toMap().toString();
  }

  ClientSchema copyWith({
    int? id,
    String? fullName,
    String? accessToken,
    String? phoneNumber,
  }) {
    return ClientSchema(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fullName: fullName ?? this.fullName,
      accessToken: accessToken ?? this.accessToken,
    );
  }

  ClientSchema clone() {
    return copyWith(
      id: id,
      phoneNumber: phoneNumber,
      fullName: fullName,
      accessToken: accessToken,
    );
  }

  static ClientSchema fromServerMap(Map<String, dynamic> value) {
    final Map<String, dynamic> data = value['data'];
    return ClientSchema(
      id: (data[idKey] as num).toInt(),
      phoneNumber: data[phoneNumberKey],
      fullName: data[fullNameKey],
      accessToken: value[accessTokenKey],
    );
  }

  static ClientSchema fromMap(Map<String, dynamic> value) {
    return ClientSchema(
      id: (value[idKey] as num).toInt(),
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

  static List<ClientSchema> fromServerListJson(String source) {
    return List.of(
      (jsonDecode(source)['data'] as List).map((map) => fromMap(map)),
    );
  }

  static ClientSchema fromServerJson(String source) {
    return fromServerMap(jsonDecode(source));
  }

  static ClientSchema fromJson(String source) {
    return fromMap(jsonDecode(source));
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
