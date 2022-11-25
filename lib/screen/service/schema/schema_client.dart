import 'dart:convert';

import 'package:equatable/equatable.dart';

class ClientSchema extends Equatable {
  const ClientSchema({
    required this.accessToken,
    required this.fullName,
    required this.phoneNumber,
  });

  static const fullNameKey = 'full_name';
  static const accessTokenKey = 'accessToken';
  static const phoneNumberKey = 'phone_number';

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
    String? fullName,
    String? accessToken,
    String? phoneNumber,
  }) {
    return ClientSchema(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fullName: fullName ?? this.fullName,
      accessToken: accessToken ?? this.accessToken,
    );
  }

  ClientSchema clone() {
    return copyWith(
      fullName: fullName,
      accessToken: accessToken,
    );
  }

  static ClientSchema fromServerMap(Map<String, dynamic> value) {
    final Map<String, dynamic> data = value['data'];
    return ClientSchema(
      phoneNumber: data[phoneNumberKey],
      fullName: data[fullNameKey],
      accessToken: value[accessTokenKey],
    );
  }

  static ClientSchema fromMap(Map<String, dynamic> value) {
    return ClientSchema(
      phoneNumber: value[phoneNumberKey],
      fullName: value[fullNameKey],
      accessToken: value[accessTokenKey],
    );
  }

  Map<String, dynamic> toMap() {
    return {
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
