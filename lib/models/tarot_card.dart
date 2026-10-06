import 'package:flutter/material.dart';

enum ArcanaType {
  major('Старший Аркан'),
  wands('Младший Аркан • Жезлы'),
  cups('Младший Аркан • Кубки'),
  swords('Младший Аркан • Мечи'),
  pentacles('Младший Аркан • Пентакли');

  final String label;
  const ArcanaType(this.label);
}

enum TarotElement {
  fire('Огонь', Icons.local_fire_department, Color(0xFFE05A47)),
  water('Вода', Icons.water_drop, Color(0xFF4A90E2)),
  air('Воздух', Icons.air, Color(0xFFA3C1AD)),
  earth('Земля', Icons.terrain, Color(0xFF6B8E23)),
  spirit('Эфир / Дух', Icons.auto_awesome, Color(0xFFD4AF37));

  final String name;
  final IconData icon;
  final Color color;
  const TarotElement(this.name, this.icon, this.color);
}

class TarotCard {
  final int id;
  final String numeral;
  final String name;
  final ArcanaType arcana;
  final TarotElement element;
  final String astrologicalSign;
  final List<String> keywords;
  final String uprightGeneral;
  final String reversedGeneral;
  final String loveMeaning;
  final String careerMeaning;
  final String advice;
  final IconData symbolIcon;
  final Color accentColor;

  const TarotCard({
    required this.id,
    required this.numeral,
    required this.name,
    required this.arcana,
    required this.element,
    required this.astrologicalSign,
    required this.keywords,
    required this.uprightGeneral,
    required this.reversedGeneral,
    required this.loveMeaning,
    required this.careerMeaning,
    required this.advice,
    required this.symbolIcon,
    required this.accentColor,
  });
}

class DrawnCard {
  final TarotCard card;
  final bool isReversed;
  bool isRevealed;

  DrawnCard({
    required this.card,
    required this.isReversed,
    this.isRevealed = false,
  });

  String get currentMeaning =>
      isReversed ? card.reversedGeneral : card.uprightGeneral;

  String get orientationLabel =>
      isReversed ? 'Перевёрнутое положение' : 'Прямое положение';
}
