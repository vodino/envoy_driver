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

  static ClientService? _navigationInstance;
  static ClientService navigationInstance([ClientState state = const InitClientState()]) {
    return _navigationInstance ??= ClientService(state);
  }

  Future<void> handle(ClientEvent event) => event._execute(this);

  static Client? get authenticated {
    final state = ClientService.instance().value;
    if (state is ClientItemState) return state.data;
    return null;
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
          final data = await compute(Client.fromServerJson, response.data!);
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
          final data = await compute(Client.fromServerJson, response.data!);
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
      service.value = FailureClientState(
        message: error.toString(),
        event: this,
      );
    }
  }
}

class SetClientStatus extends ClientEvent {
  const SetClientStatus({
    required this.status,
  });

  final ClientStatus status;

  String get url => '${RepositoryService.httpURL}/v1/api/go/${status.value}';

  @override
  Future<void> _execute(ClientService service) async {
    service.value = const PendingClientState();
    try {
      final client = ClientService.authenticated!;
      final token = client.accessToken;
      final response = await Dio().postUri<String>(
        Uri.parse(url),
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
      );
      switch (response.statusCode) {
        case 200:
          if (status == ClientStatus.online) {
            service.value = const OnlineClient();
          } else {
            service.value = const OfflineClient();
          }
          break;
        default:
          service.value = FailureClientState(
            message: response.data!,
            event: this,
          );
      }
    } catch (error) {
      service.value = FailureClientState(
        message: error.toString(),
        event: this,
      );
    }
  }
}

class UpdateLocation extends ClientEvent {
  const UpdateLocation({
    required this.latitude,
    required this.longitude,
    this.orderId,
  });

  final double latitude;
  final double longitude;

  final int? orderId;

  String get url => '${RepositoryService.httpURL}/v1/api/riders/location';

  @override
  Future<void> _execute(ClientService service) async {
    final client = ClientService.authenticated!;
    final token = client.accessToken;
    service.value = const PendingClientState();
    try {
      final body = {
        'lat': latitude,
        'long': longitude,
        'delivery_id': orderId,
      }..removeWhere((key, value) => value == null);
      final response = await Dio().postUri<String>(
        Uri.parse(url),
        data: jsonEncode(body),
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
      );
      switch (response.statusCode) {
        case 200:
          print(response.data);
          break;
        default:
          service.value = FailureClientState(
            message: response.data!,
            event: this,
          );
      }
    } catch (error) {
      if (error is DioError) print(error.response?.data);
      print(error);
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
        final data = Client.fromJson(value);
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

  final Client client;

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

  final Client client;

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
