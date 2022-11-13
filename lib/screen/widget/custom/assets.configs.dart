import 'assets.configs.io.dart' if (dart.library.html) 'assets.configs.web.dart' as configs;

Future<void> runAssets() {
  return configs.$AssetsConfigs().initialize();
}

abstract class AssetsConfigs {
  const AssetsConfigs();

  Future<void> initialize();
}
