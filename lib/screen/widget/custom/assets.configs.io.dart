import 'package:flutter/services.dart';

import 'dart:io';

import 'assets.gen.dart';
import 'assets.configs.dart';

class $AssetsConfigs extends AssetsConfigs {
  @override
  Future<void> initialize() async {
    return SecurityContext.defaultContext.setTrustedCertificatesBytes(
      (await rootBundle.load(Assets.files.letsEncryptR3)).buffer.asUint8List(),
    );
  }
}
