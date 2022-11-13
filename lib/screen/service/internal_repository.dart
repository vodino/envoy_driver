class RepositoryService {
  const RepositoryService._();

  static final _rootURL = Uri(scheme: 'https', host: 'envoy.silamashop.com');

  static String? _wsURL;
  static String get wsURL => _wsURL!;

  static String? _httpURL;
  static String get httpURL => _httpURL!;

  static void development() {
    _wsURL = _rootURL.replace(scheme: 'ws').toString();
    _httpURL = _rootURL.replace(scheme: 'http').toString();
  }

  static void production() {
    development();
  }
}
