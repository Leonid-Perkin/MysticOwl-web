import 'dart:html' as html;

String? readString(String key) {
  try {
    return html.window.localStorage[key];
  } catch (e) {
    return null;
  }
}

void writeString(String key, String value) {
  try {
    html.window.localStorage[key] = value;
  } catch (e) {
    // Ignore storage quota or security exceptions in iframe/private browsing
  }
}
