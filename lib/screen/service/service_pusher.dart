import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:pusher_client/pusher_client.dart';

import '_service.dart';

class PusherService extends ValueNotifier<PusherState> {
  PusherService([PusherState value = const InitPusherState()]) : super(value);

  static PusherService? _instance;

  static PusherService instance([PusherState value = const InitPusherState()]) {
    return _instance ??= PusherService(value);
  }

  Future<void> handle(CustomPusherEvent event) => event._execute(this);
}

abstract class CustomPusherEvent {
  const CustomPusherEvent();

  PusherClient createClient() {
    final authenticated = ClientService.authenticated!;
    final token = authenticated.accessToken;
    return PusherClient(
      'ebfafd3c927ce67edeff',
      PusherOptions(
        cluster: 'eu',
        auth: PusherAuth(
          '${RepositoryService.httpURL}/broadcasting/auth',
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      ),
    );
  }

  Future<void> _execute(PusherService service);
}

class ListenNewOrderEvent extends CustomPusherEvent {
  const ListenNewOrderEvent();

  static const _presenceDeliveryChannel = 'presence-delivery';
  static const _privateDeliveryChannel = 'private-delivery';
  static const _deliveryToSpecificUserEvent = 'delivery-to-specific-user';

  @override
  Future<void> _execute(PusherService service) async {
    service.value = const PendingPusherState();
    try {
      final client = createClient();
      client.onConnectionError((error) {
        service.value = FailurePusherState(
          message: error.toString(),
          event: this,
        );
      });
      final user = ClientService.authenticated!;
      //  client.unsubscribe('$_presenceDeliveryChannel.1');
      client.subscribe('$_presenceDeliveryChannel.1');

      //  client.unsubscribe('$_privateDeliveryChannel.${user.id}');
      final privateChannel = client.subscribe('$_privateDeliveryChannel.${user.id}');
      privateChannel.bind(_deliveryToSpecificUserEvent, (event) async {
        print(service.value);
        final data = await compute(OrderSchema.fromJson, event!.data!);
        service.value = NewOrderPusherState(data: data);
        print(service.value);
        print(data);
      });

      Future<void> canceller() {
        return Future.wait([
          client.unsubscribe('$_presenceDeliveryChannel.1'),
          client.unsubscribe('$_privateDeliveryChannel.${user.id}'),
        ]);
      }

      service.value = SubscriptionPusherState(canceller: canceller);
    } catch (error) {
      service.value = FailurePusherState(
        message: error.toString(),
        event: this,
      );
    }
  }
}
