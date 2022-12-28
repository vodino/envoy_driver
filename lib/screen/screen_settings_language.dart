import 'package:flutter/material.dart';

import '_screen.dart';

class SettingsLanguageScreen extends StatefulWidget {
  const SettingsLanguageScreen({
    super.key,
  });

  static const String name = 'settings_language';
  static const String path = 'language';

  @override
  State<SettingsLanguageScreen> createState() => _SettingsLanguageScreenState();
}

class _SettingsLanguageScreenState extends State<SettingsLanguageScreen> {
  /// LocaleService
  late List<Locale> _localeItems;
  late final LocaleService _localeService;

  @override
  void initState() {
    super.initState();
    _localeService = LocaleService.instance();
    _localeItems = CustomBuildContext.supportedLocales;
  }

  String _language(String languageCode) {
    final localizations = context.localizations;
    switch (languageCode) {
      case 'fr':
        return localizations.french;
      default:
        return localizations.english;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return Scaffold(
      appBar: const SettingsLanguageAppBar(),
      body: ValueListenableBuilder<Locale?>(
        valueListenable: _localeService,
        builder: (context, locale, child) {
          return ListView(
            children: [
              CustomCheckListTile(
                value: locale == null,
                onChanged: (value) {
                  _localeService.clear();
                  Navigator.pop(context);
                },
                title: Text(localizations.systemlanguage.capitalize()),
              ),
              const Divider(),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemBuilder: (context, index) {
                  final item = _localeItems[index];
                  return CustomCheckListTile(
                    value: locale == item,
                    onChanged: (value) {
                      _localeService.setLocale(item.languageCode);
                      Navigator.pop(context);
                    },
                    title: Text(_language(item.languageCode).capitalize()),
                  );
                },
                itemCount: _localeItems.length,
              ),
            ],
          );
        },
      ),
    );
  }
}
