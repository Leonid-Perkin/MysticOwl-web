import 'pwa_service_stub.dart'
    if (dart.library.html) 'pwa_service_web.dart' as impl;

class PwaService {
  static Future<void> updateApp() async {
    await impl.reloadApp();
  }
}
