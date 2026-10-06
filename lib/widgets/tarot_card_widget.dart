import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/tarot_card.dart';
import '../models/tarot_spread.dart';

class TarotCardWidget extends StatefulWidget {
  final DrawnCard drawnCard;
  final SpreadPosition position;
  final double width;
  final double height;
  final bool isSelected;
  final VoidCallback onTap;

  const TarotCardWidget({
    super.key,
    required this.drawnCard,
    required this.position,
    this.width = 115,
    this.height = 185,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  State<TarotCardWidget> createState() => _TarotCardWidgetState();
}

class _TarotCardWidgetState extends State<TarotCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
      value: widget.drawnCard.isRevealed ? 1.0 : 0.0,
    );
    _flipAnimation = CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOutBack,
    );
  }

  @override
  void didUpdateWidget(covariant TarotCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.drawnCard.isRevealed && _flipController.value < 1.0) {
      _flipController.forward();
    } else if (!widget.drawnCard.isRevealed && _flipController.value > 0.0) {
      _flipController.reverse();
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Transform.rotate(
          angle: widget.position.rotation,
          child: AnimatedBuilder(
            animation: _flipAnimation,
            builder: (context, child) {
              final angle = _flipAnimation.value * math.pi;
              final isFrontVisible = angle >= (math.pi / 2);

              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0012)
                  ..rotateY(angle),
                child: isFrontVisible
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(math.pi),
                        child: _buildCardFront(),
                      )
                    : _buildCardBack(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF23153C),
            Color(0xFF120A22),
            Color(0xFF2A1948),
          ],
        ),
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.85),
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withOpacity(0.22),
            blurRadius: 12,
            spreadRadius: 1,
          ),
          const BoxShadow(
            color: Colors.black87,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: CustomPaint(
                painter: _MysticCardBackPainter(),
              ),
            ),
          ),
          Positioned(
            top: 6,
            left: 6,
            child: _buildPositionBadge(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.65),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFD4AF37).withOpacity(0.4),
                  width: 0.8,
                ),
              ),
              child: const Text(
                'Нажмите',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 9.5,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFront() {
    final card = widget.drawnCard.card;
    final isReversed = widget.drawnCard.isReversed;

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF1F1633),
            Color.lerp(const Color(0xFF140D24), card.accentColor, 0.16)!,
            const Color(0xFF0F0A1B),
          ],
        ),
        border: Border.all(
          color: widget.isSelected
              ? const Color(0xFFFFE082)
              : const Color(0xFFD4AF37),
          width: widget.isSelected ? 2.6 : 1.8,
        ),
        boxShadow: [
          BoxShadow(
            color: card.accentColor.withOpacity(widget.isSelected ? 0.55 : 0.25),
            blurRadius: widget.isSelected ? 18 : 10,
            spreadRadius: widget.isSelected ? 2 : 0,
          ),
          const BoxShadow(
            color: Colors.black87,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top bar: position number + numeral + reversed indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPositionBadge(),
                Text(
                  card.numeral,
                  style: const TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                Icon(
                  card.element.icon,
                  size: 13,
                  color: card.element.color,
                ),
              ],
            ),

            // Central artwork medallion (rotated 180 deg if reversed)
            Expanded(
              child: Center(
                child: Transform.rotate(
                  angle: isReversed ? math.pi : 0.0,
                  child: Container(
                    width: widget.width * 0.58,
                    height: widget.width * 0.58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          card.accentColor.withOpacity(0.32),
                          const Color(0xFF150E26),
                        ],
                      ),
                      border: Border.all(
                        color: card.accentColor.withOpacity(0.75),
                        width: 1.4,
                      ),
                    ),
                    child: Icon(
                      card.symbolIcon,
                      size: widget.width * 0.30,
                      color: card.accentColor,
                    ),
                  ),
                ),
              ),
            ),

            // Card Name & Reversed tag
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  card.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFF5EFE6),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    height: 1.15,
                  ),
                ),
                if (isReversed)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      '⇅ Перевёрнута',
                      style: TextStyle(
                        color: Colors.amberAccent.shade100.withOpacity(0.85),
                        fontSize: 8.5,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionBadge() {
    return Container(
      width: 19,
      height: 19,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withOpacity(0.22),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFD4AF37), width: 1),
      ),
      child: Text(
        '${widget.position.index}',
        style: const TextStyle(
          color: Color(0xFFFFE082),
          fontSize: 9.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _MysticCardBackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final goldPaint = Paint()
      ..color = const Color(0xFFD4AF37).withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final innerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(2, 2, size.width - 4, size.height - 4),
      const Radius.circular(8),
    );
    canvas.drawRRect(innerRect, goldPaint);

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.34;

    canvas.drawCircle(center, radius, goldPaint);
    canvas.drawCircle(center, radius * 0.65, goldPaint);

    // Draw 8-pointed sacred star
    final starPath = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4);
      final p1 = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      final p2 = Offset(
        center.dx + radius * math.cos(angle + math.pi * 0.75),
        center.dy + radius * math.sin(angle + math.pi * 0.75),
      );
      starPath.moveTo(p1.dx, p1.dy);
      starPath.lineTo(p2.dx, p2.dy);
    }
    canvas.drawPath(starPath, goldPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void showCardDetailsSheet({
  required BuildContext context,
  required TarotCard card,
  bool? isReversed,
  SpreadPosition? position,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return DraggableScrollableSheet(
        initialChildSize: 0.72,
        minChildSize: 0.45,
        maxChildSize: 0.92,
        expand: false,
        builder: (_, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF160F29),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border.all(
                color: const Color(0xFFD4AF37).withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 32),
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withOpacity(0.45),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                if (position != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF23183E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withOpacity(0.35),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: const Color(0xFFD4AF37),
                          child: Text(
                            '${position.index}',
                            style: const TextStyle(
                              color: Color(0xFF140D24),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                position.title,
                                style: const TextStyle(
                                  color: Color(0xFFFFE082),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                position.description,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
                Row(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: card.accentColor.withOpacity(0.18),
                        border: Border.all(color: card.accentColor, width: 2),
                      ),
                      child: Transform.rotate(
                        angle: (isReversed == true) ? math.pi : 0.0,
                        child: Icon(
                          card.symbolIcon,
                          size: 34,
                          color: card.accentColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${card.numeral} • ${card.arcana.label}',
                            style: const TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            card.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              _buildChip(
                                icon: card.element.icon,
                                label: card.element.name,
                                color: card.element.color,
                              ),
                              _buildChip(
                                icon: Icons.public,
                                label: card.astrologicalSign,
                                color: const Color(0xFFD4AF37),
                              ),
                              if (isReversed != null)
                                _buildChip(
                                  icon: isReversed
                                      ? Icons.swap_vert
                                      : Icons.arrow_upward,
                                  label: isReversed
                                      ? 'Перевёрнутая'
                                      : 'Прямая',
                                  color: isReversed
                                      ? Colors.orangeAccent
                                      : Colors.greenAccent,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: card.keywords
                      .map(
                        (kw) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Text(
                            '#$kw',
                            style: const TextStyle(
                              color: Color(0xFFFFE082),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                _buildSection(
                  title: 'Прямое значение',
                  content: card.uprightGeneral,
                  icon: Icons.light_mode,
                  highlight: isReversed == false,
                ),
                _buildSection(
                  title: 'Перевёрнутое значение (Тень)',
                  content: card.reversedGeneral,
                  icon: Icons.dark_mode,
                  highlight: isReversed == true,
                ),
                _buildSection(
                  title: 'Любовь и отношения',
                  content: card.loveMeaning,
                  icon: Icons.favorite,
                ),
                _buildSection(
                  title: 'Работа, бизнес и финансы',
                  content: card.careerMeaning,
                  icon: Icons.work_outline,
                ),
                _buildSection(
                  title: 'Совет Аркана',
                  content: card.advice,
                  icon: Icons.auto_awesome,
                  highlight: true,
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildChip({
  required IconData icon,
  required String label,
  required Color color,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withOpacity(0.5)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

Widget _buildSection({
  required String title,
  required String content,
  required IconData icon,
  bool highlight = false,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: highlight
          ? const Color(0xFFD4AF37).withOpacity(0.12)
          : Colors.white.withOpacity(0.04),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: highlight
            ? const Color(0xFFD4AF37).withOpacity(0.6)
            : Colors.white12,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 17,
              color: highlight ? const Color(0xFFFFE082) : Colors.white70,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: highlight ? const Color(0xFFFFE082) : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          content,
          style: const TextStyle(
            color: Color(0xFFE5DFF0),
            fontSize: 13.5,
            height: 1.45,
          ),
        ),
      ],
    ),
  );
}
