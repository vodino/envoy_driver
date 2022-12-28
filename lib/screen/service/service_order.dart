import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import '_service.dart';

class OrderService extends ValueNotifier<OrderState> {
  OrderService([
    OrderState value = const InitOrderState(),
  ]) : super(value);

  static OrderService? _instance;
  static OrderService instance([
    OrderState value = const InitOrderState(),
  ]) {
    return _instance ??= OrderService(value);
  }

  Future<void> handle(OrderEvent event) => event._execute(this);
}

abstract class OrderEvent {
  const OrderEvent();

  Future<void> _execute(OrderService service);
}

class SubscribeToOrder extends OrderEvent {
  const SubscribeToOrder();

  String get _onlineUserTopic => 'online_users.${ClientService.authenticated!.id}';

  @override
  Future<void> _execute(OrderService service) async {
    service.value = const PendingOrderState();
    final firebaseMessaging = FirebaseService.firebaseMessaging;
    await firebaseMessaging.requestPermission();

    await firebaseMessaging.subscribeToTopic(_onlineUserTopic);

    /// Handle subscription
    final message = await firebaseMessaging.getInitialMessage();
    if (message != null) {
      service.value = OrderItemState(data: Order.fromFirebaseMap(message.data));
    } else {
      final subscriptionOpenedApp = FirebaseMessaging.onMessageOpenedApp.listen((message) {
        service.value = OrderItemState(data: Order.fromFirebaseMap(message.data));
      });
      final subscription = FirebaseMessaging.onMessage.listen((message) {
        service.value = OrderItemState(data: Order.fromFirebaseMap(message.data));
      });
      service.value = SubscriptionOrderState(
        canceller: () async {
          service.value = const PendingOrderState();
          await Future.wait([
            subscription.cancel(),
            subscriptionOpenedApp.cancel(),
            firebaseMessaging.unsubscribeFromTopic(_onlineUserTopic),
          ]);
          service.value = const InitOrderState();
        },
      );
    }
  }
}

class QueryOrderList extends OrderEvent {
  const QueryOrderList({
    this.search,
    this.limit = 30,
    this.offset = 0,
    this.isNullStatus,
    this.equalStatus,
    this.notEqualStatus,
    this.subscription = false,
    this.fireImmediately = true,
  });

  final int limit;
  final int offset;
  final String? search;
  final bool? isNullStatus;
  final bool fireImmediately;
  final OrderStatus? equalStatus;
  final OrderStatus? notEqualStatus;
  final bool subscription;

  String get _url => '${RepositoryService.httpURL}/v1/api/rider/deliveries';

  @override
  Future<void> _execute(OrderService service) async {
    try {
      final client = ClientService.authenticated!;
      final token = client.accessToken;
      final response = await Dio().getUri<String>(
        Uri.parse(_url),
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
      );
      switch (response.statusCode) {
        case 200:
          final data = await compute(Order.fromServerListJson, response.data!);
          await OrderService().handle(PutOrderList(data: data));
          service.handle(GetOrderList(
            limit: limit,
            offset: offset,
            search: search,
            equalStatus: equalStatus,
            isNullStatus: isNullStatus,
            subscription: subscription,
            notEqualStatus: notEqualStatus,
            fireImmediately: fireImmediately,
          ));
          break;
        default:
          service.value = FailureOrderState(
            message: 'internal error',
            event: this,
          );
      }
    } catch (error) {
      service.value = FailureOrderState(
        message: error.toString(),
        event: this,
      );
    }
  }
}

class ChangeOrderStatus extends OrderEvent {
  const ChangeOrderStatus({
    required this.status,
    required this.order,
    required this.latitude,
    required this.longitude,
  });

  final Order order;
  final OrderStatus status;
  final double latitude;
  final double longitude;

  String get _url => '${RepositoryService.httpURL}/v1/api/rider/deliveries/${order.id}';

  @override
  Future<void> _execute(OrderService service) async {
    service.value = const PendingOrderState();
    try {
      final client = ClientService.authenticated!;
      final body = {'status': status.value, 'lat': latitude, 'long': longitude};
      final response = await Dio().postUri<String>(
        Uri.parse(_url),
        data: jsonEncode(body),
        options: Options(headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${client.accessToken}',
        }),
      );
      switch (response.statusCode) {
        case 200:
          final data = order.copyWith(status: status, rider: client);
          OrderService().handle(PutOrderList(data: [data]));
          service.value = OrderItemState(data: data);
          break;
        default:
          service.value = FailureOrderState(
            message: 'internal error',
            event: this,
          );
      }
    } catch (error) {
      service.value = FailureOrderState(
        message: error.toString(),
        event: this,
      );
    }
  }
}

class GetOrderList extends OrderEvent {
  const GetOrderList({
    this.search,
    this.limit = 30,
    this.offset = 0,
    this.isNullStatus,
    this.equalStatus,
    this.notEqualStatus,
    this.subscription = false,
    this.fireImmediately = true,
  });

  final int limit;
  final int offset;
  final String? search;
  final bool? isNullStatus;
  final bool fireImmediately;
  final OrderStatus? equalStatus;
  final OrderStatus? notEqualStatus;
  final bool subscription;

  @override
  Future<void> _execute(OrderService service) async {
    service.value = const PendingOrderState();
    try {
      var query = IsarService.isar.orders.filter().idIsNotNull();
      if (isNullStatus != null) {
        if (isNullStatus!) {
          query = query.statusIsNull();
        } else {
          query = query.statusIsNotNull();
        }
      }
      if (equalStatus != null) query = query.statusEqualTo(equalStatus);
      if (notEqualStatus != null) query = query.not().statusEqualTo(notEqualStatus);

      if (search != null) {
        query = query
            .priceEqualTo(double.tryParse(search!))
            .or()
            .nameContains(search!, caseSensitive: false)
            .or()
            .pickupAdditionalInfoContains(search!, caseSensitive: false)
            .or()
            .deliveryAdditionalInfoContains(search!, caseSensitive: false)
            .or()
            .pickupPlace((q) => q.titleContains(search!, caseSensitive: false))
            .or()
            .deliveryPlace((q) => q.titleContains(search!, caseSensitive: false))
            .or()
            .pickupPhoneNumber((q) => q.nameContains(search!, caseSensitive: false).or().phonesElementContains(search!))
            .or()
            .deliveryPhoneNumber((q) => q.nameContains(search!, caseSensitive: false).or().phonesElementContains(search!));
      }

      if (subscription) {
        query.sortByUpdatedAtDesc().offset(offset).limit(limit).watch(fireImmediately: fireImmediately).listen((data) {
          service.value = OrderItemListState(data: data);
        });
      } else {
        final data = await query.sortByUpdatedAtDesc().offset(offset).limit(limit).findAll();
        service.value = OrderItemListState(data: data);
      }
    } catch (error) {
      service.value = FailureOrderState(
        message: error.toString(),
        event: this,
      );
    }
  }
}

class PutOrderList extends OrderEvent {
  const PutOrderList({
    required this.data,
  });

  final List<Order> data;

  @override
  Future<void> _execute(OrderService service) async {
    service.value = const PendingOrderState();
    try {
      await IsarService.isar.writeTxn(() async {
        await IsarService.isar.orders.putAll(data);
        service.value = OrderItemListState(data: data);
      });
    } catch (error) {
      service.value = FailureOrderState(
        message: error.toString(),
        event: this,
      );
    }
  }
}

class DeleteOrder extends OrderEvent {
  const DeleteOrder({
    required this.data,
  });

  final Order data;

  @override
  Future<void> _execute(OrderService service) async {
    service.value = const PendingOrderState();
    try {
      await IsarService.isar.orders.delete(data.id!);
      service.value = OrderItemState(data: data);
    } catch (error) {
      service.value = FailureOrderState(
        message: error.toString(),
        event: this,
      );
    }
  }
}
