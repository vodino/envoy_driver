import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import '_service.dart';

class PurchaseService extends ValueNotifier<PurchaseState> {
  PurchaseService([
    PurchaseState value = const InitPurchaseState(),
  ]) : super(value);

  static PurchaseService? _instance;
  static PurchaseService instance([
    PurchaseState value = const InitPurchaseState(),
  ]) {
    return _instance ??= PurchaseService(value);
  }

  Future<void> handle(PurchaseEvent event) => event._execute(this);
}

abstract class PurchaseEvent {
  const PurchaseEvent();

  Future<void> _execute(PurchaseService service);
}

class QueryPurchaseList extends PurchaseEvent {
  const QueryPurchaseList();

  String get _url => '${RepositoryService.httpURL}/v1/api/rider/purchases';

  @override
  Future<void> _execute(PurchaseService service) async {
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
          final data = await compute(Purchase.fromListJson, response.data!);
          await PurchaseService().handle(PutPurchaseList(data: data));
          service.value = PurchaseItemListState(data: data);
          break;
        default:
          service.value = FailurePurchaseState(
            message: 'internal error',
            event: this,
          );
      }
    } catch (error) {
      print(error);
      service.value = FailurePurchaseState(
        message: error.toString(),
        event: this,
      );
    }
  }
}

class GetPurchaseList extends PurchaseEvent {
  const GetPurchaseList({
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
  Future<void> _execute(PurchaseService service) async {
    service.value = const PendingPurchaseState();
    try {
      var query = IsarService.isar.purchases.where(sort: sort).filter().idIsNotNull();

      if (subscription) {
        query.offset(offset).limit(limit).watch(fireImmediately: true).listen((data) {
          service.value = PurchaseItemListState(data: data);
        });
      } else {
        final data = await query.offset(offset).limit(limit).findAll();
        service.value = PurchaseItemListState(data: data);
      }
    } catch (error) {
      service.value = FailurePurchaseState(
        message: error.toString(),
        event: this,
      );
    }
  }
}

class PutPurchaseList extends PurchaseEvent {
  const PutPurchaseList({
    required this.data,
  });

  final List<Purchase> data;

  @override
  Future<void> _execute(PurchaseService service) async {
    service.value = const PendingPurchaseState();
    try {
      await IsarService.isar.writeTxn(() async {
        await IsarService.isar.purchases.putAll(data);
        service.value = PurchaseItemListState(data: data);
      });
    } catch (error) {
      service.value = FailurePurchaseState(
        message: error.toString(),
        event: this,
      );
    }
  }
}

class DeletePurchase extends PurchaseEvent {
  const DeletePurchase({
    required this.data,
  });

  final Purchase data;

  @override
  Future<void> _execute(PurchaseService service) async {
    service.value = const PendingPurchaseState();
    try {
      await IsarService.isar.purchases.delete(data.id!);
      service.value = PurchaseItemState(data: data);
    } catch (error) {
      service.value = FailurePurchaseState(
        message: error.toString(),
        event: this,
      );
    }
  }
}
