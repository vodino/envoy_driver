import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

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

class SubscribeNewOrder extends OrderEvent {
  const SubscribeNewOrder();

  @override
  Future<void> _execute(OrderService service) async {
    print('helloworld');
    final firebaseMessaging = FirebaseService.firebaseMessaging;
    firebaseMessaging.requestPermission();
    firebaseMessaging.subscribeToTopic('online_users');
    firebaseMessaging.setForegroundNotificationPresentationOptions(alert: true);
    final subscription = FirebaseMessaging.onMessage.listen((event) {
      print(event.data);
      service.value = NewOrderOrderState(data: OrderSchema.fromMap(event.data));
    });
    service.value = SubscriptionOrderState(
      canceller: () async {
        await firebaseMessaging.unsubscribeFromTopic('online_users');
        await subscription.cancel();
      },
    );
  }
}
