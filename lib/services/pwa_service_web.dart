import 'dart:html' as html;
import 'dart:js' as js;

Future<void> reloadApp() async {
  try {
    // 1. Try to tell Service Worker to update
    if (html.window.navigator.serviceWorker != null) {
      final registrations =
          await html.window.navigator.serviceWorker!.getRegistrations();
      for (final reg in registrations) {
        try {
          await reg.update();
        } catch (_) {}
      }
    }

    // 2. Call JS helper if available
    try {
      if (js.context.hasProperty('updateMysticOwlApp')) {
        js.context.callMethod('updateMysticOwlApp');
        return;
      }
    } catch (_) {}

    // 3. Force reload ignoring cache
    html.window.location.reload();
  } catch (e) {
    html.window.location.reload();
  }
}
