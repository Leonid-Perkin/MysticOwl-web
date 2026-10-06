import 'package:flutter/material.dart';
import '../data/tarot_deck.dart';
import '../models/tarot_spread.dart';
import 'encyclopedia_screen.dart';
import 'history_screen.dart';
import 'spread_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  TarotSpread _activeSpread = TarotRepository.spreads.first;
  final List<SavedReading> _savedReadings = [];

  void _openSpread(TarotSpread spread) {
    setState(() {
      _activeSpread = spread;
      _currentTab = 1;
    });
  }

  void _addSavedReading(SavedReading reading) {
    setState(() {
      _savedReadings.insert(0, reading);
    });
  }

  void _deleteSavedReading(String id) {
    setState(() {
      _savedReadings.removeWhere((r) => r.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 820;

    final pages = [
      _buildSpreadsCatalog(context),
      SpreadScreen(
        initialSpread: _activeSpread,
        onSaveReading: _addSavedReading,
      ),
      const EncyclopediaScreen(),
      HistoryScreen(
        readings: _savedReadings,
        onDeleteReading: _deleteSavedReading,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0E0918),
      appBar: AppBar(
        backgroundColor: const Color(0xFF150D25),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFD4AF37).withOpacity(0.18),
                border: Border.all(color: const Color(0xFFD4AF37)),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Color(0xFFD4AF37),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ASTRAL TAROT • МИСТИЧЕСКИЙ ОРАКУЛ',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFFFFE082),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  Text(
                    'Интерактивные расклады и энциклопедия Арканов Таро',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF22163B),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFD4AF37).withOpacity(0.4),
                  ),
                ),
                child: Text(
                  'Записей в журнале: ${_savedReadings.length}',
                  style: const TextStyle(
                    color: Color(0xFFFFE082),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          if (isWide)
            NavigationRail(
              backgroundColor: const Color(0xFF140C24),
              selectedIndex: _currentTab,
              onDestinationSelected: (idx) =>
                  setState(() => _currentTab = idx),
              labelType: NavigationRailLabelType.all,
              selectedIconTheme:
                  const IconThemeData(color: Color(0xFF140D24), size: 24),
              unselectedIconTheme:
                  const IconThemeData(color: Colors.white60, size: 22),
              indicatorColor: const Color(0xFFD4AF37),
              selectedLabelTextStyle: const TextStyle(
                color: Color(0xFFFFE082),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              unselectedLabelTextStyle: const TextStyle(
                color: Colors.white60,
                fontSize: 11.5,
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_customize_outlined),
                  selectedIcon: Icon(Icons.dashboard_customize),
                  label: Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text('Расклады'),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.style_outlined),
                  selectedIcon: Icon(Icons.style),
                  label: Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text('Стол Таро'),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.menu_book_outlined),
                  selectedIcon: Icon(Icons.menu_book),
                  label: Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text('Арканы'),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.history_edu_outlined),
                  selectedIcon: Icon(Icons.history_edu),
                  label: Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text('Журнал'),
                  ),
                ),
              ],
            ),
          if (isWide)
            VerticalDivider(
              width: 1,
              color: const Color(0xFFD4AF37).withOpacity(0.2),
            ),
          Expanded(
            child: pages[_currentTab],
          ),
        ],
      ),
      bottomNavigationBar: isWide
          ? null
          : BottomNavigationBar(
              currentIndex: _currentTab,
              onTap: (idx) => setState(() => _currentTab = idx),
              backgroundColor: const Color(0xFF140C24),
              selectedItemColor: const Color(0xFFD4AF37),
              unselectedItemColor: Colors.white54,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_customize),
                  label: 'Расклады',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.style),
                  label: 'Стол Таро',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book),
                  label: 'Арканы',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history_edu),
                  label: 'Журнал',
                ),
              ],
            ),
    );
  }

  Widget _buildSpreadsCatalog(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Hero Banner
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2B194D),
                Color(0xFF170E2B),
              ],
            ),
            border: Border.all(
              color: const Color(0xFFD4AF37).withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: Wrap(
            spacing: 20,
            runSpacing: 16,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Выберите расклад для вашего вопроса',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'От быстрой «Карты Дня» до классического 10-карточного «Кельтского Креста». Каждая карта учитывает прямое и перевёрнутое положение, стихийный баланс и контекст позиции.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _openSpread(TarotRepository.spreads.first),
                icon: const Icon(Icons.wb_twilight),
                label: const Text('Вытянуть Карту Дня'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  foregroundColor: const Color(0xFF140D24),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        const Text(
          'Доступные расклады Таро',
          style: TextStyle(
            color: Color(0xFFFFE082),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 420,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.25,
          ),
          itemCount: TarotRepository.spreads.length,
          itemBuilder: (context, index) {
            final spread = TarotRepository.spreads[index];
            return _buildSpreadCard(spread);
          },
        ),
      ],
    );
  }

  Widget _buildSpreadCard(TarotSpread spread) {
    return InkWell(
      onTap: () => _openSpread(spread),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF18102C),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: spread.themeColor.withOpacity(0.45),
            width: 1.4,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: spread.themeColor.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    spread.icon,
                    color: spread.themeColor,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spread.category.toUpperCase(),
                        style: TextStyle(
                          color: spread.themeColor,
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.9,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        spread.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${spread.cardCount} карт',
                    style: const TextStyle(
                      color: Color(0xFFFFE082),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Text(
                spread.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    spread.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Row(
                  children: [
                    Text(
                      'Открыть стол',
                      style: TextStyle(
                        color: Color(0xFFD4AF37),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: Color(0xFFD4AF37),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
