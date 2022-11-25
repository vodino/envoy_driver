import '_service.dart';

abstract class CountryState {
  const CountryState();
}

class InitCountryState extends CountryState {
  const InitCountryState();
}

class PendingCountryState extends CountryState {
  const PendingCountryState();
}

class FailureCountryState extends CountryState {
  const FailureCountryState({
    required this.message,
    this.event,
  });
  final CountryEvent? event;
  final String message;
}

class CountryItemState extends CountryState {
  const CountryItemState({
    required this.data,
  });
  final CountrySchema data;
}

class CountryItemListState extends CountryState {
  const CountryItemListState({
    required this.data,
    this.currentCountry,
  });
  final CountrySchema? currentCountry;
  final List<CountrySchema> data;
}
