import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  const HiveService._();

  static late final Box settingsBox;

  static Future<void> developement() async {
    await Hive.initFlutter();
    const collection = '/developement';
    await _openAllBox(collection);
  }

  static Future<void> production() async {
    await Hive.initFlutter();
    const collection = '/production';
    await _openAllBox(collection);
  }

  static Future<Box<E>> _openBox<E>(String name, String collection) async {
    return Hive.openBox<E>(name, collection: collection);
  }

  static Future<void> _openAllBox(String collection) async {
    settingsBox = await _openBox('settings_box', collection);
  }
}
