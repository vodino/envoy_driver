class RepositoryService {
  const RepositoryService._();

  static final _rootURL = Uri(scheme: 'https', host: 'envoy.silamashop.com');

  static String? _httpURL;
  static String get httpURL => _httpURL!;

  static void development() {
    _httpURL = _rootURL.toString();
  }

  static void production() {
    development();
  }
}
