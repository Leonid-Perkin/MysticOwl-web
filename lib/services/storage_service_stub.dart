final Map<String, String> _memoryStorage = {};

String? readString(String key) {
  return _memoryStorage[key];
}

void writeString(String key, String value) {
  _memoryStorage[key] = value;
}
