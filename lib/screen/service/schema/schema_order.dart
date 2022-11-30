import 'dart:convert';

import 'package:equatable/equatable.dart';

import '_schema.dart';

class OrderSchema extends Equatable {
  const OrderSchema({
    required this.deliveryPlace,
    required this.pickupPlace,
    this.clientID,
    this.id,
    this.isRiderPaied = false,
    this.riderId,
    this.name,
    this.description,
    this.pickupPhoneNumber,
    this.deliveryPhoneNumber,
    this.price,
    this.scheduledDate,
  });

  static const idKey = 'id';
  static const nameKey = 'name';
  static const descriptionKey = 'additional_info';
  static const priceKey = 'price';
  static const scheduledDateKey = 'scheduled_date';
  static const riderIDKey = 'rider_id';
  static const clientIDKey = 'client_id';

  static const isRiderPaiedKey = 'is_rider_paied';

  static const deliveryAddressKey = 'delivery_address';
  static const pickupAddressKey = 'pickup_address';

  static const pickupPhoneNumberKey = 'pickup_phone_number';
  static const deliveryPhoneNumberKey = 'recipient_phone_number';

  static const latFromKey = 'lat_from';
  static const longFromKey = 'long_from';

  static const latToKey = 'lat_to';
  static const longToKey = 'long_to';

  final int? id;
  final PlaceSchema deliveryPlace;
  final PlaceSchema pickupPlace;
  final String? name;
  final String? description;
  final int? clientID;
  final int? riderId;

  final ContactSchema? pickupPhoneNumber;
  final ContactSchema? deliveryPhoneNumber;
  final double? price;
  final DateTime? scheduledDate;

  final bool isRiderPaied;

  @override
  List<Object?> get props => [
        pickupPlace,
        deliveryPlace,
        name,
        description,
        pickupPhoneNumber,
        deliveryPhoneNumber,
        price,
        scheduledDate,
      ];

  OrderSchema copyWith({
    PlaceSchema? deliveryPlace,
    PlaceSchema? pickupPlace,
    String? name,
    String? description,
    ContactSchema? pickupPhoneNumber,
    ContactSchema? deliveryPhoneNumber,
    double? price,
    DateTime? scheduledDate,
    int? clientID,
    int? id,
  }) {
    return OrderSchema(
      deliveryPlace: deliveryPlace ?? this.deliveryPlace,
      pickupPlace: pickupPlace ?? this.pickupPlace,
      name: name ?? this.name,
      description: description ?? this.description,
      pickupPhoneNumber: pickupPhoneNumber ?? this.pickupPhoneNumber,
      deliveryPhoneNumber: deliveryPhoneNumber ?? this.deliveryPhoneNumber,
      price: price ?? this.price,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      clientID: clientID ?? this.clientID,
      id: id ?? this.id,
    );
  }

  OrderSchema clone() {
    return copyWith(
      deliveryPlace: deliveryPlace,
      pickupPlace: pickupPlace,
      name: name,
      description: description,
      pickupPhoneNumber: pickupPhoneNumber,
      deliveryPhoneNumber: deliveryPhoneNumber,
      price: price,
      scheduledDate: scheduledDate,
    );
  }

  static OrderSchema fromMap(Map<String, dynamic> data) {
    return OrderSchema(
      deliveryPlace: PlaceSchema(
        title: data[deliveryAddressKey],
        latitude: double.parse(data[latToKey]),
        longitude: double.parse(data[longToKey]),
      ),
      pickupPlace: PlaceSchema(
        title: data[pickupAddressKey],
        latitude: double.parse(data[latFromKey]),
        longitude: double.parse(data[longFromKey]),
      ),
      deliveryPhoneNumber: ContactSchema(
        phones: (data[deliveryPhoneNumberKey] as String).split(', '),
      ),
      pickupPhoneNumber: ContactSchema(
        phones: (data[pickupPhoneNumberKey] as String).split(', '),
      ),
      id: data[idKey],
      name: data[nameKey],
      clientID: data[clientIDKey],
      description: data[descriptionKey],
      price: double.parse(data[priceKey]),
      // scheduledDate: DateTime.parse(data[scheduledDateKey]),
    );
  }

  static List<OrderSchema> fromListJson(String source) {
    return List.of(
      (jsonDecode(source)['data'] as List).map((map) => fromMap(map)),
    );
  }

  static OrderSchema fromJson(String source) {
    return fromMap(jsonDecode(source));
  }
}
