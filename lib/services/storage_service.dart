import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../data/tarot_deck.dart';
import '../models/tarot_card.dart';
import '../models/tarot_spread.dart';

// Conditionally import dart:html only on web, using stub on other platforms
import 'storage_service_stub.dart'
    if (dart.library.html) 'storage_service_web.dart' as impl;

class StorageService {
  static const String _historyKey = 'mysticowl_saved_readings';

  static Future<List<SavedReading>> loadSavedReadings() async {
    try {
      final jsonStr = impl.readString(_historyKey);
      if (jsonStr == null || jsonStr.trim().isEmpty) {
        return [];
      }
      final List<dynamic> list = jsonDecode(jsonStr);
      final List<SavedReading> result = [];

      for (final item in list) {
        try {
          final map = item as Map<String, dynamic>;
          final spreadId = map['spreadId'] as String;
          final spread = TarotRepository.spreads.firstWhere(
            (s) => s.id == spreadId,
            orElse: () => TarotRepository.spreads.first,
          );

          final drawnJsonList = map['drawnCards'] as List<dynamic>;
          final List<DrawnCard> drawnCards = [];
          for (final dj in drawnJsonList) {
            final dMap = dj as Map<String, dynamic>;
            final cardId = dMap['cardId'] as int;
            final card = TarotRepository.allCards.firstWhere(
              (c) => c.id == cardId,
              orElse: () => TarotRepository.allCards.first,
            );
            drawnCards.add(DrawnCard(
              card: card,
              isReversed: dMap['isReversed'] as bool? ?? false,
              isRevealed: dMap['isRevealed'] as bool? ?? true,
            ));
          }

          result.add(SavedReading(
            id: map['id'] as String,
            dateTime: DateTime.tryParse(map['dateTime'] as String? ?? '') ??
                DateTime.now(),
            question: map['question'] as String? ?? '',
            spread: spread,
            drawnCards: drawnCards,
            summaryText: map['summaryText'] as String? ?? '',
          ));
        } catch (e) {
          debugPrint('Error parsing saved reading item: $e');
        }
      }
      return result;
    } catch (e) {
      debugPrint('Error loading saved readings from storage: $e');
      return [];
    }
  }

  static Future<void> saveReadings(List<SavedReading> readings) async {
    try {
      final list = readings.map((r) {
        return {
          'id': r.id,
          'dateTime': r.dateTime.toIso8601String(),
          'question': r.question,
          'spreadId': r.spread.id,
          'drawnCards': r.drawnCards.map((d) {
            return {
              'cardId': d.card.id,
              'isReversed': d.isReversed,
              'isRevealed': d.isRevealed,
            };
          }).toList(),
          'summaryText': r.summaryText,
        };
      }).toList();

      final jsonStr = jsonEncode(list);
      impl.writeString(_historyKey, jsonStr);
    } catch (e) {
      debugPrint('Error saving readings to storage: $e');
    }
  }
}
