import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '_service.dart';

class RubricService extends ValueNotifier<RubricState> {
  RubricService([RubricState value = const InitRubricState()]) : super(value);

  static RubricService? _instance;
  static RubricService instance([RubricState state = const InitRubricState()]) {
    return _instance ??= RubricService(state);
  }

  Future<void> handle(RubricEvent event) => event._execute(this);
}

abstract class RubricEvent {
  const RubricEvent();

  Future<void> _execute(RubricService service);
}

class QueryRubricList extends RubricEvent {
  const QueryRubricList();

  String get _url => '${RepositoryService.httpURL}/v1/api/rider/faqs';

  @override
  Future<void> _execute(RubricService service) async {
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
          final data = await compute(RubricSchema.fromListJson, response.data!);
          service.value = RubricItemListState(data: data);
          break;
        default:
          service.value = FailureRubricState(
            message: 'internal',
            event: this,
          );
      }
    } catch (error) {
      service.value = FailureRubricState(
        message: error.toString(),
        event: this,
      );
    }
  }
}
