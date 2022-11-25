import 'dart:convert';

import 'package:equatable/equatable.dart';

class CountrySchema extends Equatable {
  const CountrySchema({
    required this.name,
    required this.dialCode,
    required this.code,
  });

  static const dialCodeKey = 'dial_code';
  static const codeKey = 'country_code';
  static const nameKey = 'name';

  final String code;
  final String dialCode;
  final String name;

  @override
  List<Object?> get props => [
        dialCode,
        code,
        name,
      ];

  CountrySchema copyWith({
    String? dialCode,
    String? code,
    String? name,
  }) {
    return CountrySchema(
      dialCode: dialCode ?? this.dialCode,
      code: code ?? this.code,
      name: name ?? this.name,
    );
  }

  CountrySchema clone() {
    return copyWith(
      dialCode: dialCode,
      code: code,
      name: name,
    );
  }

  static CountrySchema fromMap(Map<String, dynamic> data) {
    return CountrySchema(
      dialCode: data[dialCodeKey],
      code: data[codeKey],
      name: data[nameKey],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      dialCodeKey: dialCode,
      codeKey: code,
      nameKey: name,
    };
  }

  static List<CountrySchema> fromListJson(String source) {
    return List.of(
      (jsonDecode(source)['data'] as List).map((map) => fromMap(map)),
    );
  }

  static CountrySchema fromJson(String source) {
    return fromMap(jsonDecode(source));
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
