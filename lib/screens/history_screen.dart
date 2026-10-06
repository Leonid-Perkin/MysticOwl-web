import 'package:flutter/material.dart';
import '../models/tarot_spread.dart';
import '../widgets/tarot_card_widget.dart';

class HistoryScreen extends StatelessWidget {
  final List<SavedReading> readings;
  final void Function(String id) onDeleteReading;

  const HistoryScreen({
    super.key,
    required this.readings,
    required this.onDeleteReading,
  });

  String _formatDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year;
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$d.$m.$y в $h:$min';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Журнал сохранённых раскладов',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Храните историю своих вопросов, выпавших Арканов и синтеза раскладов',
            style: TextStyle(color: Colors.white60, fontSize: 13.5),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: readings.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_stories_outlined,
                          size: 64,
                          color: const Color(0xFFD4AF37).withOpacity(0.45),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Журнал пока пуст',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Выполните любой расклад, откройте все карты и нажмите «В журнал».',
                          style: TextStyle(color: Colors.white54, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: readings.length,
                    itemBuilder: (context, index) {
                      final item = readings[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF19112E),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(0xFFD4AF37).withOpacity(0.4),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  item.spread.icon,
                                  color: item.spread.themeColor,
                                  size: 24,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.spread.name,
                                        style: const TextStyle(
                                          color: Color(0xFFFFE082),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        _formatDate(item.dateTime),
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => onDeleteReading(item.id),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.white54,
                                  ),
                                  tooltip: 'Удалить запись',
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Вопрос: ${item.question}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: List.generate(
                                item.drawnCards.length,
                                (i) {
                                  final d = item.drawnCards[i];
                                  final pos = item.spread.positions[i];
                                  return ActionChip(
                                    avatar: Icon(
                                      d.card.symbolIcon,
                                      size: 16,
                                      color: d.card.accentColor,
                                    ),
                                    backgroundColor: const Color(0xFF251942),
                                    side: BorderSide(
                                      color: d.card.accentColor.withOpacity(0.5),
                                    ),
                                    label: Text(
                                      '${pos.index}. ${d.card.name}${d.isReversed ? " (⇅)" : ""}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.5,
                                      ),
                                    ),
                                    onPressed: () => showCardDetailsSheet(
                                      context: context,
                                      card: d.card,
                                      isReversed: d.isReversed,
                                      position: pos,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item.summaryText,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12.5,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
