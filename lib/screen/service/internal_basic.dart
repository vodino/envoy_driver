import 'package:flutter/foundation.dart';

import '_service.dart';

Future<void> runService() async {
  late Service service;
  if (kDebugMode) {
    service = const DevelopmentService();
  } else {
    service = const ProductionService();
  }
  await service._initialize();

  await ClientService.instance().handle(const GetClient());
}

abstract class Service {
  const Service();

  Future<void> _initialize();
}

class DevelopmentService extends Service {
  const DevelopmentService();
  @override
  Future<void> _initialize() async {
    RepositoryService.development();
    await FirebaseService.development();
    await HiveService.developement();
  }
}

class ProductionService extends Service {
  const ProductionService();

  @override
  Future<void> _initialize() async {
    RepositoryService.production();
    await FirebaseService.production();
    await HiveService.production();
  }
}
