import 'package:flutter/material.dart';
import 'tarot_card.dart';

class SpreadPosition {
  final int index;
  final String title;
  final String description;
  /// Normalized horizontal center (0.0 .. 1.0) on the spread board
  final double dx;
  /// Normalized vertical center (0.0 .. 1.0) on the spread board
  final double dy;
  /// Optional rotation in radians (e.g., pi/2 for crossed card in Celtic Cross)
  final double rotation;

  const SpreadPosition({
    required this.index,
    required this.title,
    required this.description,
    required this.dx,
    required this.dy,
    this.rotation = 0.0,
  });
}

class TarotSpread {
  final String id;
  final String name;
  final String subtitle;
  final String description;
  final String category;
  final IconData icon;
  final Color themeColor;
  final List<SpreadPosition> positions;

  const TarotSpread({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.description,
    required this.category,
    required this.icon,
    required this.themeColor,
    required this.positions,
  });

  int get cardCount => positions.length;
}

class SavedReading {
  final String id;
  final DateTime dateTime;
  final String question;
  final TarotSpread spread;
  final List<DrawnCard> drawnCards;
  final String summaryText;

  const SavedReading({
    required this.id,
    required this.dateTime,
    required this.question,
    required this.spread,
    required this.drawnCards,
    required this.summaryText,
  });
}
