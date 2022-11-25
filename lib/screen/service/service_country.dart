import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '_service.dart';

class CountryService extends ValueNotifier<CountryState> {
  CountryService([CountryState value = const InitCountryState()]) : super(value);

  static CountryService? _instance;

  static CountryService instance([CountryState value = const InitCountryState()]) {
    return _instance ??= CountryService(value);
  }

  Future<void> handle(CountryEvent event) => event._execute(this);

  void onState(ValueChanged<CountryState> callBack) => callBack(value);
}

abstract class CountryEvent {
  const CountryEvent();

  Future<void> _execute(CountryService service);
}

class GetCountries extends CountryEvent {
  const GetCountries();

  String get url => '${RepositoryService.httpURL}/v1/api/countries';

  @override
  Future<void> _execute(CountryService service) async {
    service.value = const PendingCountryState();
    try {
      final response = await Dio().getUri<String>(Uri.parse(url));
      final data = compute(CountrySchema.fromListJson, response.data!);
      data.then(
        (data) async {
          final countryCode = window.locale.countryCode;
          final currentCountry = data.firstWhere(
            (item) => item.code == countryCode,
            orElse: () => data.first,
          );
          service.value = CountryItemListState(
            currentCountry: currentCountry,
            data: data,
          );
        },
        onError: (error) {
          service.value = FailureCountryState(
            message: error.toString(),
          );
        },
      );
    } catch (error) {
      service.value = FailureCountryState(
        message: error.toString(),
        event: this,
      );
    }
  }
}
