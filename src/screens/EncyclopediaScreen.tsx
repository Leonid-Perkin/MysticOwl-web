import React, { useState, useMemo } from 'react';
import { ALL_TAROT_CARDS } from '../data/tarotDeck';
import { ArcanaType, TarotCard, ARCANA_LABELS, TAROT_ELEMENTS } from '../types/tarot';
import { CardDetailsModal } from '../components/CardDetailsModal';
import { DynamicIcon } from '../components/DynamicIcon';
import { Search, X } from 'lucide-react';

export const EncyclopediaScreen: React.FC = () => {
  const [searchQuery, setSearchQuery] = useState<string>('');
  const [selectedArcana, setSelectedArcana] = useState<ArcanaType | 'all'>('all');
  const [selectedCard, setSelectedCard] = useState<TarotCard | null>(null);

  const filteredCards = useMemo(() => {
    return ALL_TAROT_CARDS.filter((card) => {
      const matchesArcana = selectedArcana === 'all' || card.arcana === selectedArcana;
      if (!matchesArcana) return false;

      if (!searchQuery.trim()) return true;
      const q = searchQuery.toLowerCase().trim();
      const inName = card.name.toLowerCase().includes(q) || card.numeral.toLowerCase().includes(q);
      const inKeywords = card.keywords.some((k) => k.toLowerCase().includes(q));
      return inName || inKeywords;
    });
  }, [searchQuery, selectedArcana]);

  const arcanaOptions: { id: ArcanaType | 'all'; label: string }[] = [
    { id: 'all', label: 'Все карты' },
    { id: 'major', label: ARCANA_LABELS.major },
    { id: 'wands', label: ARCANA_LABELS.wands },
    { id: 'cups', label: ARCANA_LABELS.cups },
    { id: 'swords', label: ARCANA_LABELS.swords },
    { id: 'pentacles', label: ARCANA_LABELS.pentacles },
  ];

  return (
    <div className="p-4 sm:p-6 lg:p-8 max-w-[1800px] mx-auto space-y-6 animate-fadeIn">
      {/* Header & Search */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-xl sm:text-2xl lg:text-3xl font-bold font-cinzel text-white">
            Энциклопедия Арканов Таро
          </h2>
          <p className="text-xs sm:text-sm text-white/60 mt-1">
            Изучите символику, стихии и толкования карт в прямом и перевёрнутом положении
          </p>
        </div>

        {/* Search input with Clear button */}
        <div className="relative w-full sm:w-80">
          <input
            type="text"
            maxLength={100}
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder="Поиск по названию или ключу..."
            className="w-full bg-[#1F1536] border border-[#D4AF37]/35 focus:border-[#D4AF37] rounded-xl px-3 py-2 sm:py-2.5 pl-9 pr-9 text-white placeholder-white/40 focus:outline-none text-xs sm:text-sm transition-colors"
          />
          <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-[#D4AF37]" />
          {searchQuery && (
            <button
              onClick={() => setSearchQuery('')}
              className="absolute right-3 top-1/2 -translate-y-1/2 text-white/40 hover:text-white transition-colors"
              title="Очистить поиск"
            >
              <X size={15} />
            </button>
          )}
        </div>
      </div>

      {/* Suit / Arcana Filter Chips */}
      <div className="flex items-center gap-2 overflow-x-auto pb-2 scrollbar-none -mx-4 px-4 sm:mx-0 sm:px-0">
        {arcanaOptions.map((opt) => {
          const isSelected = selectedArcana === opt.id;
          return (
            <button
              key={opt.id}
              onClick={() => setSelectedArcana(opt.id)}
              className={`px-3.5 py-1.5 sm:py-2 rounded-xl text-xs sm:text-sm whitespace-nowrap font-medium transition-all ${
                isSelected
                  ? 'bg-[#D4AF37] text-[#140D24] font-bold shadow-md'
                  : 'bg-[#1F1536] text-white/70 hover:text-white border border-[#D4AF37]/30'
              }`}
            >
              {opt.label}
            </button>
          );
        })}
      </div>

      {/* Cards Grid */}
      {filteredCards.length === 0 ? (
        <div className="py-20 text-center text-white/50 text-sm sm:text-base">
          Карты по вашему запросу не найдены
        </div>
      ) : (
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 2xl:grid-cols-7 gap-3.5 sm:gap-5">
          {filteredCards.map((card) => {
            const elementInfo = TAROT_ELEMENTS[card.element];
            return (
              <div
                key={card.id}
                onClick={() => setSelectedCard(card)}
                className="p-3.5 sm:p-4 rounded-2xl bg-gradient-to-br from-[#21163A] to-[#150E26] border border-[#D4AF37]/45 hover:border-[#D4AF37] shadow-lg hover:shadow-2xl transition-all duration-300 hover:scale-105 cursor-pointer flex flex-col justify-between group min-h-[190px] sm:min-h-[220px]"
                style={{
                  boxShadow: `0 4px 16px ${card.accentColor}15`,
                }}
              >
                {/* Top numeral & element */}
                <div className="flex items-center justify-between text-xs mb-1">
                  <span className="font-bold text-[#D4AF37] font-cinzel text-xs sm:text-sm">
                    {card.numeral}
                  </span>
                  <div title={elementInfo.name}>
                    <DynamicIcon name={elementInfo.iconName} size={15} color={elementInfo.color} />
                  </div>
                </div>

                {/* Central Medallion */}
                <div className="my-auto py-2 flex items-center justify-center">
                  <div
                    className="w-13 h-13 sm:w-16 sm:h-16 rounded-full flex items-center justify-center border-2 group-hover:scale-110 transition-transform duration-300"
                    style={{
                      width: '56px',
                      height: '56px',
                      backgroundColor: `${card.accentColor}18`,
                      borderColor: `${card.accentColor}80`,
                    }}
                  >
                    <DynamicIcon name={card.symbolIcon} size={26} color={card.accentColor} />
                  </div>
                </div>

                {/* Card Title & Keywords */}
                <div className="text-center mt-1.5">
                  <h4 className="text-xs sm:text-sm font-bold text-white group-hover:text-[#FFE082] transition-colors truncate">
                    {card.name}
                  </h4>
                  <p className="text-[10px] sm:text-[11px] text-white/50 truncate mt-0.5">
                    {card.keywords.slice(0, 3).join(' • ')}
                  </p>
                </div>
              </div>
            );
          })}
        </div>
      )}

      {/* Modal Details */}
      <CardDetailsModal
        card={selectedCard}
        onClose={() => setSelectedCard(null)}
      />
    </div>
  );
};
