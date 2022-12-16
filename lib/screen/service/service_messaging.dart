import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '_service.dart';

class MessagingService extends ValueNotifier<MessagingState> {
  MessagingService([MessagingState value = const InitMessagingState()]) : super(value);

  static MessagingService? _instance;

  static MessagingService instance([MessagingState state = const InitMessagingState()]) {
    return _instance ??= MessagingService(state);
  }

  Future<void> handle(MessagingEvent event) => event._execute(this);

  void onState(ValueChanged<MessagingState> callBack) => callBack(value);
}

abstract class MessagingEvent {
  const MessagingEvent();

  Future<void> _execute(MessagingService service);
}

class PushMessage extends MessagingEvent {
  const PushMessage({
    this.body,
    this.title,
    required this.data,
    required this.topic,
    this.silence = false,
    this.expiration = const Duration(days: 28),
  });

  final bool silence;
  final String topic;
  final Duration expiration;

  final String? body;
  final String? title;
  final Map<String, dynamic> data;

  String get _url => 'https://fcm.googleapis.com/fcm/send';

  @override
  Future<void> _execute(MessagingService service) async {
    service.value = const PendingMessagingState();
    try {
      final Map<String, dynamic>? notification = silence ? null : {'title': title, 'body': body};
      final json = <String, dynamic>{
        "data": data,
        "priority": "normal",
        "to": "/topics/$topic",
        "content_available": true,
        "notification": notification,
        "android": {"ttl": "${expiration.inSeconds}s"},
        "apns": {
          "headers": {"apns-expiration": "${expiration.inMilliseconds}"}
        },
        "webpush": {
          "headers": {"TTL": "${expiration.inMilliseconds}"}
        }
      }..removeWhere((key, value) => value == null);
      final response = await Dio().postUri(
        Uri.parse(_url),
        data: jsonEncode(json),
        options: Options(headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAA55CoBZc:APA91bGllEw9yVKfo8S9Reylfs4VQJ8WKRAPYQtZwnsL4R4l1DAR6anH1MrX5iFFUWPgw6xnU833HQ_qz9Rh1iAnqQlHeaIDctDG-e05t7YvWsmoFwjW135nBL2dsoAF6iNF_uWnEzha',
        }),
      );
      switch (response.statusCode) {
        case 200:
          service.value = const SuccessMessagingState();
          break;
        default:
          service.value = FailureMessagingState(
            message: 'internal error',
            event: this,
          );
      }
    } catch (error) {
      service.value = FailureMessagingState(
        message: error.toString(),
        event: this,
      );
    }
  }
}
