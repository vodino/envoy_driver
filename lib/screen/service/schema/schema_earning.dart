import 'dart:convert';

import 'package:isar/isar.dart';

part 'schema_earning.g.dart';


@collection
class Earning {
  Earning({
    this.id,
    this.amount,
    this.deliveryId,
    this.createdAt,
    this.updatedAt,
  });

  static const String idKey = 'id';
  static const String deliveryIdKey = 'delivery_id';
  static const String amountKey = 'amount';

  static const String createdAtKey = 'created_at';
  static const String updatedAtKey = 'updated_at';

  Id? id;
  int? deliveryId;
  double? amount;
  DateTime? createdAt;
  DateTime? updatedAt;

  Earning copyWith({
    int? id,
    int? deliveryId,
    double? amount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Earning(
      deliveryId: deliveryId ?? this.deliveryId,
      amount: amount ?? this.amount,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Earning clone() {
    return copyWith(
      deliveryId: deliveryId,
      amount: amount,
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static Earning fromMap(Map<String, dynamic> data) {
    return Earning(
      id: data[idKey],
      deliveryId: data[deliveryIdKey],
      amount: double.tryParse(data[amountKey]),
      createdAt: data[createdAtKey] != null ? DateTime.parse(data[createdAtKey]) : null,
      updatedAt: data[updatedAtKey] != null ? DateTime.parse(data[updatedAtKey]) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      deliveryIdKey: deliveryId,
      amountKey: amount,
      idKey: id,
      createdAtKey: createdAt?.toString(),
      updatedAtKey: updatedAt?.toString(),
    };
  }

  static List<Earning> fromListJson(String source) {
    return List.of(
      (jsonDecode(source)['data'] as List).map((map) => fromMap(map)),
    );
  }

  static Earning fromJson(String source) {
    return fromMap(jsonDecode(source));
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
