import 'dart:convert';

import 'package:isar/isar.dart';

import '_schema.dart';

part 'schema_order.g.dart';

enum OrderStatus {
  accepted('ACCEPTED'),
  started('STARTED'),
  collected('COLLECTED'),
  delivered('DELIVERED');

  const OrderStatus(this.value);
  final String value;

  static OrderStatus? fromString(String value) {
    for (final item in values) {
      if (item.value == value) return item;
    }
    return null;
  }
}

@collection
class Order {
  Order({
    this.id,
    this.name,
    this.price,
    this.status,
    this.scheduledDate,
    this.audioPath,
    this.pickupPlace,
    this.deliveryPlace,
    this.createdAt,
    this.updatedAt,
    this.pickupPhoneNumber,
    this.deliveryPhoneNumber,
    this.pickupAdditionalInfo,
    this.deliveryAdditionalInfo,
    this.onlineRiders,
    this.amountPaidedByRider,
    this.client,
    this.rider,
  });

  static const String idKey = 'id';
  static const String priceKey = 'price';
  static const String nameKey = 'name';
  static const String statusKey = 'status';
  static const String audioPathKey = 'audio_path';
  static const String scheduledDateKey = 'scheduled_date';
  static const String amountPaidedByRiderKey = 'amount_paided_by_rider';

  static const String pickupAdditionalInfoKey = 'pickup_additional_info';
  static const String deliveryAdditionalInfoKey = 'destination_additional_info';
  static const String pickupPhoneNumberKey = 'pickup_phone_number';
  static const String deliveryPhoneNumberKey = 'recipient_phone_number';
  static const String pickupAddressKey = 'pickup_address';
  static const String deliveryAddressKey = 'destination_address';
  static const String latFromKey = 'lat_from';
  static const String longFromKey = 'long_from';
  static const String latToKey = 'lat_to';
  static const String longToKey = 'long_to';

  static const String onlineRidersKey = 'users_online';

  static const String riderKey = 'rider';
  static const String clientKey = 'sender';

  static const String createdAtKey = 'created_at';
  static const String updatedAtKey = 'updated_at';

  Id? id;
  String? name;
  double? price;
  @Enumerated(EnumType.name)
  OrderStatus? status;
  DateTime? scheduledDate;
  String? audioPath;
  double? amountPaidedByRider;

  String? pickupAdditionalInfo;
  String? deliveryAdditionalInfo;

  Place? pickupPlace;
  Place? deliveryPlace;
  Contact? pickupPhoneNumber;
  Contact? deliveryPhoneNumber;

  @ignore
  List<Client>? onlineRiders;
  Client? rider;
  Client? client;

  DateTime? createdAt;
  DateTime? updatedAt;

  Order copyWith({
    int? id,
    String? name,
    double? price,
    OrderStatus? status,
    DateTime? scheduledDate,
    String? audioPath,
    Place? pickupPlace,
    Place? deliveryPlace,
    Contact? pickupPhoneNumber,
    Contact? deliveryPhoneNumber,
    String? pickupAdditionalInfo,
    String? deliveryAdditionalInfo,
    List<Client>? onlineRiders,
    Client? rider,
    Client? client,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? amountPaidedByRider,
  }) {
    return Order(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      status: status ?? this.status,
      audioPath: audioPath ?? this.audioPath,
      pickupPlace: pickupPlace ?? this.pickupPlace,
      deliveryPlace: deliveryPlace ?? this.deliveryPlace,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      pickupPhoneNumber: pickupPhoneNumber ?? this.pickupPhoneNumber,
      amountPaidedByRider: amountPaidedByRider ?? this.amountPaidedByRider,
      deliveryPhoneNumber: deliveryPhoneNumber ?? this.deliveryPhoneNumber,
      pickupAdditionalInfo: pickupAdditionalInfo ?? this.pickupAdditionalInfo,
      deliveryAdditionalInfo: deliveryAdditionalInfo ?? this.deliveryAdditionalInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rider: rider ?? this.rider,
      client: client ?? this.client,
      onlineRiders: onlineRiders ?? this.onlineRiders,
    );
  }

  Order clone() {
    return Order(
      id: id,
      name: name,
      price: price,
      status: status,
      audioPath: audioPath,
      pickupPlace: pickupPlace,
      deliveryPlace: deliveryPlace,
      scheduledDate: scheduledDate,
      pickupPhoneNumber: pickupPhoneNumber,
      amountPaidedByRider: amountPaidedByRider,
      deliveryPhoneNumber: deliveryPhoneNumber,
      pickupAdditionalInfo: pickupAdditionalInfo,
      deliveryAdditionalInfo: deliveryAdditionalInfo,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static List<Order> fromListServerMap(Iterable<Map<String, dynamic>> data) {
    return data.map((e) => fromServerMap(e)).toList();
  }

  static Order fromServerMap(Map<String, dynamic> data) {
    return Order(
      id: data[idKey],
      name: data[nameKey],
      audioPath: data[audioPathKey],
      pickupAdditionalInfo: data[pickupAdditionalInfoKey],
      deliveryAdditionalInfo: data[deliveryAdditionalInfoKey],
      price: (data[priceKey] as num?)?.toDouble(),
      amountPaidedByRider: (data[amountPaidedByRiderKey] as num?)?.toDouble(),
      status: data[statusKey] != null ? OrderStatus.fromString(data[statusKey]) : null,
      scheduledDate: data[scheduledDateKey] != null ? DateTime.parse(data[scheduledDateKey]) : null,
      pickupPhoneNumber: Contact(
        phones: (data[pickupPhoneNumberKey] as String?)?.split(', ').toList(),
      ),
      deliveryPhoneNumber: Contact(
        phones: (data[deliveryPhoneNumberKey] as String?)?.split(', ').toList(),
      ),
      pickupPlace: Place(
        title: data[pickupAddressKey],
        latitude: (data[latFromKey] as num?)?.toDouble(),
        longitude: (data[longFromKey] as num?)?.toDouble(),
      ),
      deliveryPlace: Place(
        title: data[deliveryAddressKey],
        latitude: (data[latToKey] as num?)?.toDouble(),
        longitude: (data[longToKey] as num?)?.toDouble(),
      ),
      rider: data[riderKey] != null ? Client.fromMap(data[riderKey]) : null,
      client: data[clientKey] != null
          ? data[clientKey] is String
              ? Client.fromJson(data[clientKey])
              : Client.fromMap(data[clientKey])
          : null,
      onlineRiders: (data[onlineRidersKey] as List?)?.map((e) => Client.fromMap(e)).toList(),
      createdAt: data[createdAtKey] != null ? DateTime.parse(data[createdAtKey]) : null,
      updatedAt: data[updatedAtKey] != null ? DateTime.parse(data[updatedAtKey]) : null,
    );
  }

  static Order fromFirebaseMap(Map<String, dynamic> data) {
    return Order(
      name: data[nameKey],
      audioPath: data[audioPathKey],
      pickupAdditionalInfo: data[pickupAdditionalInfoKey],
      deliveryAdditionalInfo: data[deliveryAdditionalInfoKey],
      price: data[priceKey] != null ? double.parse(data[priceKey]) : null,
      id: data[idKey] is String ? int.tryParse(data[idKey]) : data[idKey],
      status: data[statusKey] != null ? OrderStatus.fromString(data[statusKey]) : null,
      scheduledDate: data[scheduledDateKey] != null ? DateTime.parse(data[scheduledDateKey]) : null,
      amountPaidedByRider: data[amountPaidedByRiderKey] != null ? double.parse(data[amountPaidedByRiderKey]) : null,
      pickupPhoneNumber: Contact(
        phones: (data[pickupPhoneNumberKey] as String?)?.split(', ').toList(),
      ),
      deliveryPhoneNumber: Contact(
        phones: (data[deliveryPhoneNumberKey] as String?)?.split(', ').toList(),
      ),
      pickupPlace: Place(
        title: data[pickupAddressKey],
        latitude: double.parse(data[latFromKey]),
        longitude: double.parse(data[longFromKey]),
      ),
      deliveryPlace: Place(
        title: data[deliveryAddressKey],
        latitude: double.parse(data[latToKey]),
        longitude: double.parse(data[longToKey]),
      ),
      rider: data[riderKey] != null ? Client.fromMap(data[riderKey]) : null,
      client: data[clientKey] != null
          ? data[clientKey] is String
              ? Client.fromJson(data[clientKey])
              : Client.fromMap(data[clientKey])
          : null,
      onlineRiders: (data[onlineRidersKey] as List?)?.map((e) => Client.fromMap(e)).toList(),
      createdAt: data[createdAtKey] != null ? DateTime.parse(data[createdAtKey]) : null,
      updatedAt: data[updatedAtKey] != null ? DateTime.parse(data[updatedAtKey]) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      idKey: id,
      nameKey: name,
      priceKey: price,
      audioPathKey: audioPath,
      riderKey: rider?.toMap(),
      statusKey: status?.value,
      clientKey: client?.toMap(),
      latFromKey: pickupPlace?.latitude,
      latToKey: deliveryPlace?.latitude,
      longToKey: deliveryPlace?.longitude,
      longFromKey: pickupPlace?.longitude,
      createdAtKey: createdAt?.toString(),
      updatedAtKey: updatedAt?.toString(),
      pickupAddressKey: pickupPlace?.title,
      deliveryAddressKey: deliveryPlace?.title,
      amountPaidedByRiderKey: amountPaidedByRider,
      scheduledDateKey: scheduledDate?.toString(),
      pickupAdditionalInfoKey: pickupAdditionalInfo,
      deliveryAdditionalInfoKey: deliveryAdditionalInfo,
      pickupPhoneNumberKey: pickupPhoneNumber!.phones?.join(', '),
      deliveryPhoneNumberKey: deliveryPhoneNumber!.phones?.join(', '),
    }..removeWhere((key, value) => value == null);
  }

  static Order fromFirebaseJson(String source) {
    return fromFirebaseMap(jsonDecode(source));
  }

  static Order fromServerJson(String source) {
    final value = jsonDecode(source);
    return fromServerMap(value['data']).copyWith(
      onlineRiders: (value[onlineRidersKey] as List?)?.map((e) => Client.fromMap(e)).toList(),
    );
  }

  static List<Order> fromServerListJson(String source) {
    return List.of((jsonDecode(source)['data'] as List).map((map) => fromFirebaseMap(map)));
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
