import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../data/tarot_deck.dart';
import '../models/tarot_card.dart';
import '../models/tarot_spread.dart';
import '../widgets/tarot_card_widget.dart';

class SpreadScreen extends StatefulWidget {
  final TarotSpread initialSpread;
  final void Function(SavedReading reading) onSaveReading;

  const SpreadScreen({
    super.key,
    required this.initialSpread,
    required this.onSaveReading,
  });

  @override
  State<SpreadScreen> createState() => _SpreadScreenState();
}

class _SpreadScreenState extends State<SpreadScreen>
    with SingleTickerProviderStateMixin {
  late TarotSpread _currentSpread;
  final TextEditingController _questionController = TextEditingController();

  bool _allowReversed = true;
  bool _onlyMajorArcana = false;
  bool _isShuffling = false;
  bool _isSaved = false;

  List<DrawnCard> _drawnCards = [];
  int? _selectedPositionIndex;

  late AnimationController _shuffleController;

  @override
  void initState() {
    super.initState();
    _currentSpread = widget.initialSpread;
    _shuffleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void didUpdateWidget(covariant SpreadScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSpread.id != widget.initialSpread.id) {
      setState(() {
        _currentSpread = widget.initialSpread;
        _drawnCards = [];
        _selectedPositionIndex = null;
        _isSaved = false;
      });
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _shuffleController.dispose();
    super.dispose();
  }

  Future<void> _dealCards() async {
    setState(() {
      _isShuffling = true;
      _drawnCards = [];
      _selectedPositionIndex = null;
      _isSaved = false;
    });

    _shuffleController.forward(from: 0.0);
    await Future.delayed(const Duration(milliseconds: 850));

    final random = math.Random();
    final pool = _onlyMajorArcana
        ? TarotRepository.allCards
            .where((c) => c.arcana == ArcanaType.major)
            .toList()
        : List<TarotCard>.from(TarotRepository.allCards);

    pool.shuffle(random);

    final count = _currentSpread.cardCount;
    final selected = pool.take(count).map((card) {
      final isRev = _allowReversed ? random.nextDouble() < 0.35 : false;
      return DrawnCard(card: card, isReversed: isRev, isRevealed: false);
    }).toList();

    if (!mounted) return;
    setState(() {
      _isShuffling = false;
      _drawnCards = selected;
    });
  }

  void _onCardTapped(int index) {
    final drawn = _drawnCards[index];
    final position = _currentSpread.positions[index];

    if (!drawn.isRevealed) {
      setState(() {
        drawn.isRevealed = true;
        _selectedPositionIndex = index;
      });
    } else {
      setState(() {
        _selectedPositionIndex = index;
      });
      showCardDetailsSheet(
        context: context,
        card: drawn.card,
        isReversed: drawn.isReversed,
        position: position,
      );
    }
  }

  void _revealAll() {
    setState(() {
      for (final d in _drawnCards) {
        d.isRevealed = true;
      }
      if (_drawnCards.isNotEmpty) {
        _selectedPositionIndex ??= 0;
      }
    });
  }

  bool get _allRevealed =>
      _drawnCards.isNotEmpty && _drawnCards.every((d) => d.isRevealed);

  void _saveCurrentReading() {
    if (_drawnCards.isEmpty || _isSaved) return;
    final synthesis = TarotRepository.generateSpreadSynthesis(
      _currentSpread,
      _drawnCards,
      _questionController.text,
    );

    final reading = SavedReading(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      dateTime: DateTime.now(),
      question: _questionController.text.trim().isEmpty
          ? 'Без вопроса (${_currentSpread.name})'
          : _questionController.text.trim(),
      spread: _currentSpread,
      drawnCards: _drawnCards
          .map((d) => DrawnCard(
                card: d.card,
                isReversed: d.isReversed,
                isRevealed: true,
              ))
          .toList(),
      summaryText: synthesis,
    );

    widget.onSaveReading(reading);
    setState(() {
      _isSaved = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Расклад сохранён в Журнал раскладов ✨'),
        backgroundColor: Color(0xFF2B1D48),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 960;

    return Column(
      children: [
        _buildTopControlBar(),
        Expanded(
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 6,
                      child: _buildSpreadTableArea(),
                    ),
                    Expanded(
                      flex: 5,
                      child: _buildInterpretationPanel(),
                    ),
                  ],
                )
              : ListView(
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    SizedBox(
                      height: _currentSpread.cardCount >= 10 ? 640 : 480,
                      child: _buildSpreadTableArea(),
                    ),
                    _buildInterpretationPanel(shrinkWrap: true),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildTopControlBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF160E26),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFD4AF37).withOpacity(0.25),
          ),
        ),
      ),
      child: Wrap(
        spacing: 14,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          // Spread selector dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF22163B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFD4AF37).withOpacity(0.5),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _currentSpread.id,
                dropdownColor: const Color(0xFF22163B),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFFD4AF37),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                items: TarotRepository.spreads.map((sp) {
                  return DropdownMenuItem<String>(
                    value: sp.id,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(sp.icon, size: 18, color: sp.themeColor),
                        const SizedBox(width: 8),
                        Text('${sp.name} (${sp.cardCount})'),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (newId) {
                  if (newId == null) return;
                  final found = TarotRepository.spreads
                      .firstWhere((s) => s.id == newId);
                  setState(() {
                    _currentSpread = found;
                    _drawnCards = [];
                    _selectedPositionIndex = null;
                    _isSaved = false;
                  });
                },
              ),
            ),
          ),

          // Question input field
          SizedBox(
            width: 320,
            child: TextField(
              controller: _questionController,
              style: const TextStyle(color: Colors.white, fontSize: 13.5),
              decoration: InputDecoration(
                hintText: 'Ваш вопрос картам Таро...',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(
                  Icons.psychology_alt,
                  color: Color(0xFFD4AF37),
                  size: 20,
                ),
                isDense: true,
                filled: true,
                fillColor: const Color(0xFF22163B),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: const Color(0xFFD4AF37).withOpacity(0.35),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: const Color(0xFFD4AF37).withOpacity(0.35),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFD4AF37)),
                ),
              ),
            ),
          ),

          // Options & Action buttons
          Wrap(
            spacing: 10,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FilterChip(
                label: const Text('Перевёрнутые'),
                selected: _allowReversed,
                onSelected: (v) => setState(() => _allowReversed = v),
                selectedColor: const Color(0xFFD4AF37).withOpacity(0.28),
                checkmarkColor: const Color(0xFFFFE082),
                labelStyle: TextStyle(
                  color: _allowReversed
                      ? const Color(0xFFFFE082)
                      : Colors.white70,
                  fontSize: 12.5,
                ),
                backgroundColor: const Color(0xFF22163B),
                side: BorderSide(
                  color: const Color(0xFFD4AF37).withOpacity(0.4),
                ),
              ),
              FilterChip(
                label: const Text('Только Старшие Арканы'),
                selected: _onlyMajorArcana,
                onSelected: (v) => setState(() => _onlyMajorArcana = v),
                selectedColor: const Color(0xFFD4AF37).withOpacity(0.28),
                checkmarkColor: const Color(0xFFFFE082),
                labelStyle: TextStyle(
                  color: _onlyMajorArcana
                      ? const Color(0xFFFFE082)
                      : Colors.white70,
                  fontSize: 12.5,
                ),
                backgroundColor: const Color(0xFF22163B),
                side: BorderSide(
                  color: const Color(0xFFD4AF37).withOpacity(0.4),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _isShuffling ? null : _dealCards,
                icon: const Icon(Icons.auto_awesome, size: 18),
                label: Text(
                  _drawnCards.isEmpty ? 'Разложить карты' : 'Новый расклад',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  foregroundColor: const Color(0xFF140D24),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              if (_drawnCards.isNotEmpty && !_allRevealed)
                OutlinedButton.icon(
                  onPressed: _revealAll,
                  icon: const Icon(Icons.visibility, size: 17),
                  label: const Text('Открыть все'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFFFE082),
                    side: const BorderSide(color: Color(0xFFD4AF37)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              if (_allRevealed)
                OutlinedButton.icon(
                  onPressed: _isSaved ? null : _saveCurrentReading,
                  icon: Icon(
                    _isSaved ? Icons.check : Icons.bookmark_add_outlined,
                    size: 17,
                  ),
                  label: Text(_isSaved ? 'Сохранено' : 'В журнал'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFFFE082),
                    side: const BorderSide(color: Color(0xFFD4AF37)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpreadTableArea() {
    return Container(
      margin: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const RadialGradient(
          center: Alignment.center,
          radius: 0.95,
          colors: [
            Color(0xFF241640),
            Color(0xFF120B21),
          ],
        ),
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.35),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Sacred geometry background table circles
          Positioned.fill(
            child: CustomPaint(
              painter: _SacredTablePainter(),
            ),
          ),

          if (_isShuffling)
            Center(
              child: AnimatedBuilder(
                animation: _shuffleController,
                builder: (context, _) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 180,
                        height: 180,
                        child: Stack(
                          alignment: Alignment.center,
                          children: List.generate(5, (i) {
                            final progress = _shuffleController.value;
                            final angle =
                                (i - 2) * 0.25 * math.sin(progress * math.pi * 2);
                            final offsetX =
                                (i - 2) * 28.0 * math.sin(progress * math.pi * 2);
                            return Transform.translate(
                              offset: Offset(offsetX, 0),
                              child: Transform.rotate(
                                angle: angle,
                                child: Container(
                                  width: 90,
                                  height: 145,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF23153C),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: const Color(0xFFD4AF37),
                                      width: 1.8,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.auto_awesome,
                                      color: Color(0xFFD4AF37),
                                      size: 32,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Тасуем колоду и настраиваемся на ваш вопрос...',
                        style: TextStyle(
                          color: Color(0xFFFFE082),
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  );
                },
              ),
            )
          else if (_drawnCards.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentSpread.themeColor.withOpacity(0.15),
                        border: Border.all(
                          color: _currentSpread.themeColor.withOpacity(0.6),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        _currentSpread.icon,
                        size: 52,
                        color: _currentSpread.themeColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _currentSpread.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _currentSpread.subtitle,
                      style: const TextStyle(
                        color: Color(0xFFD4AF37),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 460),
                      child: Text(
                        _currentSpread.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.45,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    ElevatedButton.icon(
                      onPressed: _dealCards,
                      icon: const Icon(Icons.style),
                      label: const Text('Перетасовать колоду и вытянуть карты'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: const Color(0xFF140D24),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final isDense = _currentSpread.cardCount >= 10;
                final cardW = isDense
                    ? (constraints.maxWidth * 0.14).clamp(76.0, 108.0)
                    : (constraints.maxWidth * 0.17).clamp(90.0, 130.0);
                final cardH = cardW * 1.58;

                return Stack(
                  children: [
                    for (int i = 0; i < _drawnCards.length; i++)
                      Builder(
                        builder: (context) {
                          final pos = _currentSpread.positions[i];
                          final left =
                              (pos.dx * constraints.maxWidth) - (cardW / 2);
                          final top =
                              (pos.dy * constraints.maxHeight) - (cardH / 2);

                          return AnimatedPositioned(
                            duration: Duration(milliseconds: 350 + (i * 60)),
                            curve: Curves.easeOutCubic,
                            left: left.clamp(
                                8.0, constraints.maxWidth - cardW - 8.0),
                            top: top.clamp(
                                8.0, constraints.maxHeight - cardH - 8.0),
                            child: TarotCardWidget(
                              drawnCard: _drawnCards[i],
                              position: pos,
                              width: cardW,
                              height: cardH,
                              isSelected: _selectedPositionIndex == i,
                              onTap: () => _onCardTapped(i),
                            ),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildInterpretationPanel({bool shrinkWrap = false}) {
    final revealedCount = _drawnCards.where((d) => d.isRevealed).length;

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 14, 14, 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF160F29),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.3),
        ),
      ),
      child: _drawnCards.isEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
              children: [
                const Row(
                  children: [
                    Icon(Icons.menu_book, color: Color(0xFFD4AF37), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Схема позиций расклада',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ..._currentSpread.positions.map(
                  (pos) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor:
                              const Color(0xFFD4AF37).withOpacity(0.2),
                          child: Text(
                            '${pos.index}',
                            style: const TextStyle(
                              color: Color(0xFFFFE082),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pos.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.5,
                                ),
                              ),
                              Text(
                                pos.description,
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : ListView(
              shrinkWrap: shrinkWrap,
              physics: shrinkWrap
                  ? const NeverScrollableScrollPhysics()
                  : const AlwaysScrollableScrollPhysics(),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.auto_stories,
                            color: Color(0xFFD4AF37), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Толкование расклада',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Открыто $revealedCount из ${_drawnCards.length}',
                      style: const TextStyle(
                        color: Color(0xFFD4AF37),
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (_allRevealed) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFD4AF37).withOpacity(0.18),
                          const Color(0xFF241640),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withOpacity(0.65),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.auto_awesome,
                                color: Color(0xFFFFE082), size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Синтез и общий итог расклада',
                              style: TextStyle(
                                color: Color(0xFFFFE082),
                                fontWeight: FontWeight.bold,
                                fontSize: 14.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          TarotRepository.generateSpreadSynthesis(
                            _currentSpread,
                            _drawnCards,
                            _questionController.text,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                for (int i = 0; i < _drawnCards.length; i++)
                  _buildPositionReadingTile(i),
              ],
            ),
    );
  }

  Widget _buildPositionReadingTile(int index) {
    final pos = _currentSpread.positions[index];
    final drawn = _drawnCards[index];
    final isSelected = _selectedPositionIndex == index;

    if (!drawn.isRevealed) {
      return InkWell(
        onTap: () => _onCardTapped(index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor: Colors.white10,
                child: Text(
                  '${pos.index}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${pos.title} — Нажмите, чтобы открыть карту',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                  ),
                ),
              ),
              const Icon(Icons.touch_app, color: Color(0xFFD4AF37), size: 17),
            ],
          ),
        ),
      );
    }

    return InkWell(
      onTap: () => _onCardTapped(index),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF281A47)
              : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD4AF37)
                : Colors.white.withOpacity(0.12),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor: const Color(0xFFD4AF37),
                  child: Text(
                    '${pos.index}',
                    style: const TextStyle(
                      color: Color(0xFF140D24),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    pos.title,
                    style: const TextStyle(
                      color: Color(0xFFFFE082),
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                    ),
                  ),
                ),
                Icon(
                  drawn.card.symbolIcon,
                  color: drawn.card.accentColor,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${drawn.card.numeral} • ${drawn.card.name}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: drawn.isReversed
                        ? Colors.orange.withOpacity(0.2)
                        : Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    drawn.isReversed ? 'Перевёрнутая' : 'Прямая',
                    style: TextStyle(
                      color: drawn.isReversed
                          ? Colors.orangeAccent
                          : Colors.greenAccent,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              drawn.currentMeaning,
              style: const TextStyle(
                color: Color(0xFFE0D8EE),
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Совет: ${drawn.card.advice}',
              style: const TextStyle(
                color: Color(0xFFD4AF37),
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SacredTablePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4AF37).withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final center = Offset(size.width / 2, size.height / 2);
    final maxR = math.min(size.width, size.height) * 0.43;

    canvas.drawCircle(center, maxR, paint);
    canvas.drawCircle(center, maxR * 0.72, paint);
    canvas.drawCircle(center, maxR * 0.4, paint);

    canvas.drawLine(
      Offset(center.dx - maxR * 1.1, center.dy),
      Offset(center.dx + maxR * 1.1, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - maxR * 1.1),
      Offset(center.dx, center.dy + maxR * 1.1),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
