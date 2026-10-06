#!/usr/bin/env bash
set -euo pipefail

echo "=== Сборка Astral Tarot для macOS (.app & .dmg) ==="
flutter config --enable-macos-desktop
flutter pub get
flutter build macos --release

STAGING_DIR="build/macos_dmg_staging"
rm -rf "$STAGING_DIR"
mkdir -p "$STAGING_DIR"

cp -R "build/macos/Build/Products/Release/tarot_flutter.app" "$STAGING_DIR/Astral Tarot.app"
ln -s /Applications "$STAGING_DIR/Applications"

DMG_NAME="Astral-Tarot-macOS-Installer.dmg"
rm -f "$DMG_NAME"

hdiutil create \
  -volname "Astral Tarot" \
  -srcfolder "$STAGING_DIR" \
  -ov -format UDZO \
  "$DMG_NAME"

rm -rf "$STAGING_DIR"
echo "Готово! Установщик создан: $DMG_NAME"
