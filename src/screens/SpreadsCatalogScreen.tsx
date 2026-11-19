import React from 'react';
import { TAROT_SPREADS } from '../data/tarotDeck';
import { TarotSpread } from '../types/tarot';
import { DynamicIcon } from '../components/DynamicIcon';
import { ArrowRight, SunMedium } from 'lucide-react';

interface SpreadsCatalogScreenProps {
  onSelectSpread: (spread: TarotSpread) => void;
}

export const SpreadsCatalogScreen: React.FC<SpreadsCatalogScreenProps> = ({
  onSelectSpread,
}) => {
  return (
    <div className="p-4 sm:p-8 max-w-7xl mx-auto space-y-8 animate-fadeIn">
      {/* Hero Banner */}
      <div className="p-6 sm:p-8 rounded-2xl bg-gradient-to-br from-[#2B194D] via-[#1E1136] to-[#170E2B] border border-[#D4AF37]/50 shadow-[0_8px_32px_rgba(0,0,0,0.5)] flex flex-col md:flex-row items-start md:items-center justify-between gap-6">
        <div className="max-w-2xl space-y-2">
          <h2 className="text-2xl sm:text-3xl font-bold font-cinzel text-white">
            Выберите расклад для вашего вопроса
          </h2>
          <p className="text-sm sm:text-base text-white/75 leading-relaxed">
            От быстрой «Карты Дня» до классического 10-карточного «Кельтского Креста».
            Каждая карта учитывает прямое и перевёрнутое положение, стихийный баланс и контекст позиции.
          </p>
        </div>

        <button
          onClick={() => onSelectSpread(TAROT_SPREADS[0])}
          className="flex-shrink-0 flex items-center gap-2.5 px-6 py-4 rounded-xl bg-[#D4AF37] hover:bg-[#FFE082] text-[#140D24] font-bold text-sm sm:text-base transition-all duration-200 shadow-[0_0_20px_rgba(212,175,55,0.4)] hover:scale-105 active:scale-95"
        >
          <SunMedium size={20} />
          <span>Вытянуть Карту Дня</span>
        </button>
      </div>

      {/* Grid of Spreads */}
      <div>
        <h3 className="text-lg sm:text-xl font-bold text-[#FFE082] mb-4 flex items-center gap-2">
          <span>Доступные расклады Таро</span>
        </h3>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
          {TAROT_SPREADS.map((spread) => (
            <div
              key={spread.id}
              onClick={() => onSelectSpread(spread)}
              className="p-6 rounded-2xl bg-[#18102C] border transition-all duration-300 hover:scale-[1.02] cursor-pointer flex flex-col justify-between group shadow-lg hover:shadow-2xl"
              style={{
                borderColor: `${spread.themeColor}55`,
              }}
            >
              <div>
                {/* Header: Icon, Category, Name & Card Count */}
                <div className="flex items-start justify-between gap-3 mb-3">
                  <div className="flex items-center gap-3">
                    <div
                      className="p-3 rounded-xl border flex items-center justify-center flex-shrink-0"
                      style={{
                        backgroundColor: `${spread.themeColor}20`,
                        borderColor: `${spread.themeColor}60`,
                        color: spread.themeColor,
                      }}
                    >
                      <DynamicIcon name={spread.iconName} size={24} color={spread.themeColor} />
                    </div>
                    <div>
                      <div
                        className="text-[11px] font-bold tracking-wider uppercase"
                        style={{ color: spread.themeColor }}
                      >
                        {spread.category}
                      </div>
                      <h4 className="text-lg font-bold text-white group-hover:text-[#FFE082] transition-colors">
                        {spread.name}
                      </h4>
                    </div>
                  </div>

                  <span className="px-2.5 py-1 rounded-full bg-white/5 border border-white/10 text-xs font-semibold text-[#FFE082] flex-shrink-0">
                    {spread.positions.length} карт
                  </span>
                </div>

                {/* Description */}
                <p className="text-sm text-white/70 line-clamp-3 leading-relaxed mb-4">
                  {spread.description}
                </p>
              </div>

              {/* Subtitle & Open Action */}
              <div className="pt-3 border-t border-white/10 flex items-center justify-between text-xs">
                <span className="text-white/50 truncate max-w-[170px]" title={spread.subtitle}>
                  {spread.subtitle}
                </span>

                <div className="flex items-center gap-1 font-bold text-[#D4AF37] group-hover:text-[#FFE082] transition-colors">
                  <span>Открыть стол</span>
                  <ArrowRight size={14} className="group-hover:translate-x-1 transition-transform" />
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};
