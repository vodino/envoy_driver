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
    final state = ClientService.instance().value as ClientItemState;
    final token = state.data.accessToken;
    return PusherClient(
      'ebfafd3c927ce67edeff',
      PusherOptions(
        auth: PusherAuth(
          '${RepositoryService.httpURL}/broadcasting/auth',
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
        cluster: 'eu',
      ),
    );
  }

  Future<void> _execute(PusherService service);
}

class SubscribeToEvent extends CustomPusherEvent {
  const SubscribeToEvent();

  void onEvent(PusherEvent? event) {
    print(event?.data);
  }

  @override
  Future<void> _execute(PusherService service) async {
    final state = ClientService.instance().value as ClientItemState;
    final id = state.data.accessToken;
    try {
      final client = createClient();
      client.onConnectionError((error) {
        service.value = FailurePusherState(
          message: error.toString(),
          event: this,
        );
      });
      final channel = client.subscribe('private-delivery.1');
      await channel.bind('delivery-created', onEvent);
    } catch (error) {
      service.value = FailurePusherState(
        message: error.toString(),
        event: this,
      );
    }
  }
}
