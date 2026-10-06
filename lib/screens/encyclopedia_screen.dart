import 'package:flutter/material.dart';
import '../data/tarot_deck.dart';
import '../models/tarot_card.dart';
import '../widgets/tarot_card_widget.dart';

class EncyclopediaScreen extends StatefulWidget {
  const EncyclopediaScreen({super.key});

  @override
  State<EncyclopediaScreen> createState() => _EncyclopediaScreenState();
}

class _EncyclopediaScreenState extends State<EncyclopediaScreen> {
  String _searchQuery = '';
  ArcanaType? _selectedArcana;

  List<TarotCard> get _filteredCards {
    return TarotRepository.allCards.where((card) {
      final matchesArcana =
          _selectedArcana == null || card.arcana == _selectedArcana;
      if (!matchesArcana) return false;

      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final inName = card.name.toLowerCase().contains(q) ||
          card.numeral.toLowerCase().contains(q);
      final inKeywords =
          card.keywords.any((k) => k.toLowerCase().contains(q));
      return inName || inKeywords;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cards = _filteredCards;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Search bar
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Энциклопедия Арканов Таро',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Изучите символику, стихии и толкования карт в прямом и перевёрнутом положении',
                    style: TextStyle(color: Colors.white60, fontSize: 13.5),
                  ),
                ],
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Поиск по названию или ключу...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon:
                        const Icon(Icons.search, color: Color(0xFFD4AF37)),
                    filled: true,
                    fillColor: const Color(0xFF1F1536),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: const Color(0xFFD4AF37).withOpacity(0.4),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: const Color(0xFFD4AF37).withOpacity(0.35),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Filter chips by Arcana/Suit
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(label: 'Все карты', type: null),
                const SizedBox(width: 8),
                ...ArcanaType.values.map(
                  (t) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _buildFilterChip(label: t.label, type: t),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Cards grid
          Expanded(
            child: cards.isEmpty
                ? const Center(
                    child: Text(
                      'Карты по вашему запросу не найдены',
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 230,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      return _buildEncyclopediaCard(context, card);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({required String label, required ArcanaType? type}) {
    final selected = _selectedArcana == type;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => _selectedArcana = type),
      selectedColor: const Color(0xFFD4AF37),
      backgroundColor: const Color(0xFF1F1536),
      labelStyle: TextStyle(
        color: selected ? const Color(0xFF140D24) : Colors.white70,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        fontSize: 13,
      ),
      side: BorderSide(
        color: const Color(0xFFD4AF37).withOpacity(0.45),
      ),
    );
  }

  Widget _buildEncyclopediaCard(BuildContext context, TarotCard card) {
    return InkWell(
      onTap: () => showCardDetailsSheet(context: context, card: card),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF21163A),
              Color.lerp(const Color(0xFF150E26), card.accentColor, 0.14)!,
            ],
          ),
          border: Border.all(
            color: const Color(0xFFD4AF37).withOpacity(0.45),
            width: 1.4,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  card.numeral,
                  style: const TextStyle(
                    color: Color(0xFFD4AF37),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Icon(
                  card.element.icon,
                  color: card.element.color,
                  size: 16,
                ),
              ],
            ),
            const Spacer(),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: card.accentColor.withOpacity(0.16),
                border: Border.all(
                  color: card.accentColor.withOpacity(0.75),
                  width: 1.6,
                ),
              ),
              child: Icon(
                card.symbolIcon,
                color: card.accentColor,
                size: 36,
              ),
            ),
            const Spacer(),
            Text(
              card.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              card.keywords.take(3).join(' • '),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 11.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
