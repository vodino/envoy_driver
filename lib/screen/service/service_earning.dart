import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import '_service.dart';

class EarningService extends ValueNotifier<EarningState> {
  EarningService([
    EarningState value = const InitEarningState(),
  ]) : super(value);

  static EarningService? _instance;
  static EarningService instance([
    EarningState value = const InitEarningState(),
  ]) {
    return _instance ??= EarningService(value);
  }

  Future<void> handle(EarningEvent event) => event._execute(this);
}

abstract class EarningEvent {
  const EarningEvent();

  Future<void> _execute(EarningService service);
}

class QueryEarningList extends EarningEvent {
  const QueryEarningList();

  String get _url => '${RepositoryService.httpURL}/v1/api/rider/earnings';

  @override
  Future<void> _execute(EarningService service) async {
    final client = ClientService.authenticated!;
    final token = client.accessToken;
    try {
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
          final data = await compute(Earning.fromListJson, response.data!);
          await EarningService().handle(PutEarningList(data: data));
          service.value = EarningItemListState(data: data);
          break;
        default:
          service.value = FailureEarningState(
            message: 'internal error',
            event: this,
          );
      }
    } catch (error) {
      service.value = FailureEarningState(
        message: error.toString(),
        event: this,
      );
    }
  }
}

class GetEarningList extends EarningEvent {
  const GetEarningList({
    this.subscription = false,
    this.limit = 30,
    this.offset = 0,
    this.sort = Sort.asc,
  });

  final Sort sort;
  final int limit;
  final int offset;

  final bool subscription;

  @override
  Future<void> _execute(EarningService service) async {
    service.value = const PendingEarningState();
    try {
      var query = IsarService.isar.earnings.where(sort: sort).filter().idIsNotNull();

      if (subscription) {
        query.offset(offset).limit(limit).watch(fireImmediately: true).listen((data) {
          service.value = EarningItemListState(data: data);
        });
      } else {
        final data = await query.offset(offset).limit(limit).findAll();
        service.value = EarningItemListState(data: data);
      }
    } catch (error) {
      service.value = FailureEarningState(
        message: error.toString(),
        event: this,
      );
    }
  }
}

class PutEarningList extends EarningEvent {
  const PutEarningList({
    required this.data,
  });

  final List<Earning> data;

  @override
  Future<void> _execute(EarningService service) async {
    service.value = const PendingEarningState();
    try {
      await IsarService.isar.writeTxn(() async {
        await IsarService.isar.earnings.putAll(data);
        service.value = EarningItemListState(data: data);
      });
    } catch (error) {
      service.value = FailureEarningState(
        message: error.toString(),
        event: this,
      );
    }
  }
}

class DeleteEarning extends EarningEvent {
  const DeleteEarning({
    required this.data,
  });

  final Earning data;

  @override
  Future<void> _execute(EarningService service) async {
    service.value = const PendingEarningState();
    try {
      await IsarService.isar.earnings.delete(data.id!);
      service.value = EarningItemState(data: data);
    } catch (error) {
      service.value = FailureEarningState(
        message: error.toString(),
        event: this,
      );
    }
  }
}
