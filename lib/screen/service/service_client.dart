import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '_service.dart';

class ClientService extends ValueNotifier<ClientState> {
  ClientService([ClientState value = const InitClientState()]) : super(value);

  static ClientService? _instance;

  static ClientService instance([ClientState state = const InitClientState()]) {
    return _instance ??= ClientService(state);
  }

  Future<void> handle(ClientEvent event) => event._execute(this);

  static bool get authenticated {
    return ClientService.instance().value is ClientItemState;
  }
}

abstract class ClientEvent {
  const ClientEvent();

  Future<void> _execute(ClientService service);
}

class LoginClient extends ClientEvent {
  const LoginClient({
    required this.phoneNumber,
    required this.token,
  });

  final String phoneNumber;
  final String token;

  String get url => '${RepositoryService.httpURL}/v1/api/rider/auth';

  @override
  Future<void> _execute(ClientService service) async {
    service.value = const PendingClientState();
    try {
      final body = {'phone_number': phoneNumber, 'firebase_token': token};
      final response = await Dio().postUri<String>(
        Uri.parse(url),
        data: jsonEncode(body),
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      );
      switch (response.statusCode) {
        case 200:
          final data = await compute(ClientSchema.fromServerJson, response.data!);
          await service.handle(PutClient(client: data));
          break;
        case 404:
          service.value = NoClientItemState(
            phoneNumber: phoneNumber,
            token: token,
          );
          break;
        default:
          service.value = FailureClientState(
            message: 'internal error',
            event: this,
          );
      }
    } catch (error) {
      if (error is DioError && error.type == DioErrorType.response) {
        service.value = NoClientItemState(
          phoneNumber: phoneNumber,
          token: token,
        );
      } else {
        service.value = FailureClientState(
          message: error.toString(),
          event: this,
        );
      }
    }
  }
}

class RegisterClient extends ClientEvent {
  const RegisterClient({
    required this.phoneNumber,
    required this.fullName,
    required this.token,
  });

  final String phoneNumber;
  final String fullName;
  final String token;

  String get url => '${RepositoryService.httpURL}/v1/api/rider/register';

  @override
  Future<void> _execute(ClientService service) async {
    service.value = const PendingClientState();
    try {
      final body = {'phone_number': phoneNumber, 'firebase_token': token, 'full_name': fullName};
      final response = await Dio().postUri<String>(
        Uri.parse(url),
        data: jsonEncode(body),
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      );
      switch (response.statusCode) {
        case 200:
          final data = await compute(ClientSchema.fromServerJson, response.data!);
          await service.handle(PutClient(client: data));
          break;
        case 404:
          service.value = NoClientItemState(
            phoneNumber: phoneNumber,
            token: token,
          );
          break;
        default:
          service.value = FailureClientState(
            message: response.data!,
            event: this,
          );
      }
    } catch (error) {
      if (error is DioError) {
        print(error.response?.data);
      }
      service.value = FailureClientState(
        message: error.toString(),
        event: this,
      );
    }
  }
}

class GetClient extends ClientEvent {
  const GetClient();

  @override
  Future<void> _execute(ClientService service) async {
    service.value = const PendingClientState();
    try {
      final value = HiveService.settingsBox.get('current_client');
      if (value != null) {
        final data = ClientSchema.fromJson(value);
        service.value = ClientItemState(data: data);
      } else {
        service.value = const NoClientItemState();
      }
    } catch (error) {
      service.value = FailureClientState(
        message: error.toString(),
        event: this,
      );
    }
  }
}

class PutClient extends ClientEvent {
  const PutClient({
    required this.client,
  });

  final ClientSchema client;

  @override
  Future<void> _execute(ClientService service) async {
    service.value = const PendingClientState();
    try {
      await HiveService.settingsBox.put('current_client', client.toJson());
      service.value = ClientItemState(data: client);
    } catch (error) {
      service.value = FailureClientState(
        message: error.toString(),
        event: this,
      );
    }
  }
}

class DeleteClient extends ClientEvent {
  const DeleteClient({
    required this.client,
  });

  final ClientSchema client;

  @override
  Future<void> _execute(ClientService service) async {
    service.value = const PendingClientState();
    try {
      await HiveService.settingsBox.delete('current_client');
      service.value = ClientItemState(data: client);
    } catch (error) {
      service.value = FailureClientState(
        message: error.toString(),
        event: this,
      );
    }
  }
}
