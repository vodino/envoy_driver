import 'package:isar/isar.dart';

import '_service.dart';

class IsarService {
  const IsarService._();

  static Isar? _isar;
  static Isar get isar => _isar!;

  static Future<void> developement() async {
    _isar ??= await Isar.open([OrderSchema]);
  }

  static Future<void> production() async {
    return developement();
  }
}
