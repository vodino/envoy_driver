import 'dart:convert';

import 'package:isar/isar.dart';

part 'schema_purchase.g.dart';

@collection
class Purchase {
  Purchase({
    this.id,
    this.tokens,
    this.amount,
    this.createdAt,
    this.updatedAt,
    this.totalTokens,
  });

  static const String idKey = 'id';
  static const String amountKey = 'amount';
  static const String tokensKey = 'nb_tokens';
  static const String createdAtKey = 'created_at';
  static const String updatedAtKey = 'updated_at';
  static const String totalTokensKey = 'nb_available_tokens';

  Id? id;
  int? tokens;
  double? amount;
  int? totalTokens;
  DateTime? createdAt;
  DateTime? updatedAt;

  Purchase copyWith({
    int? id,
    int? tokens,
    double? amount,
    int? totalTokens,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Purchase(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      tokens: tokens ?? this.tokens,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      totalTokens: totalTokens ?? this.totalTokens,
    );
  }

  Purchase clone() {
    return copyWith(
      id: id,
      tokens: tokens,
      amount: amount,
      createdAt: createdAt,
      updatedAt: updatedAt,
      totalTokens: totalTokens,
    );
  }

  static Purchase fromMap(Map<String, dynamic> data) {
    return Purchase(
      id: data[idKey],
      tokens: int.tryParse(data[tokensKey]),
      amount: double.tryParse(data[amountKey] ?? ''),
      totalTokens: int.tryParse(data[totalTokensKey] ?? ''),
      createdAt: data[createdAtKey] != null ? DateTime.parse(data[createdAtKey]) : null,
      updatedAt: data[updatedAtKey] != null ? DateTime.parse(data[updatedAtKey]) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      idKey: id,
      tokensKey: tokens,
      amountKey: amount,
      totalTokensKey: totalTokens,
      createdAtKey: createdAt?.toString(),
      updatedAtKey: updatedAt?.toString(),
    };
  }

  static List<Purchase> fromListJson(String source) {
    final value = jsonDecode(source);
    return List.of((value['data'] as List).map(
      (map) => fromMap(map).copyWith(totalTokens: value[totalTokensKey]),
    ));
  }

  static Purchase fromJson(String source) {
    return fromMap(jsonDecode(source));
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
