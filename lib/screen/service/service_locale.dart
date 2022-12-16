import 'package:flutter/widgets.dart';

import '_service.dart';

class LocaleService extends ValueNotifier<Locale?> {
  LocaleService([Locale? value]) : super(value);

  static LocaleService? _instance;
  static LocaleService instance([Locale? value]) {
    return _instance ??= LocaleService(value);
  }

  void getLocale() {
    final languageCode = HiveService.settingsBox.get('locale');
    if (languageCode != null) value = Locale(languageCode);
  }

  void setLocale(String languageCode) async {
    await HiveService.settingsBox.put('locale', languageCode);
    value = Locale(languageCode);
  }

  void clear() {
    value = null;
    HiveService.settingsBox.put('locale', null);
  }
}
