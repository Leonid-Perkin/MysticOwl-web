import React, { useState, useEffect, useRef } from 'react';
import { ALL_TAROT_CARDS, TAROT_SPREADS, generateSpreadSynthesis } from '../data/tarotDeck';
import { TarotSpread, DrawnCard, SpreadPosition, SavedReading, TarotCard } from '../types/tarot';
import { TarotCardWidget } from '../components/TarotCardWidget';
import { SacredTablePainter } from '../components/SacredTablePainter';
import { CardDetailsModal } from '../components/CardDetailsModal';
import { DynamicIcon } from '../components/DynamicIcon';
import confetti from 'canvas-confetti';
import {
  Sparkles,
  Eye,
  BookmarkPlus,
  Check,
  ChevronDown,
  HelpCircle,
  BookOpen,
} from 'lucide-react';

interface SpreadScreenProps {
  initialSpread: TarotSpread;
  onSaveReading: (reading: SavedReading) => void;
}

export const SpreadScreen: React.FC<SpreadScreenProps> = ({
  initialSpread,
  onSaveReading,
}) => {
  const [currentSpread, setCurrentSpread] = useState<TarotSpread>(initialSpread);
  const [question, setQuestion] = useState<string>('');
  const [allowReversed, setAllowReversed] = useState<boolean>(true);
  const [onlyMajorArcana, setOnlyMajorArcana] = useState<boolean>(false);
  const [isShuffling, setIsShuffling] = useState<boolean>(false);
  const [drawnCards, setDrawnCards] = useState<DrawnCard[]>([]);
  const [selectedCardIndex, setSelectedCardIndex] = useState<number | null>(null);
  const [isSaved, setIsSaved] = useState<boolean>(false);

  // Modal inspection
  const [modalCard, setModalCard] = useState<TarotCard | null>(null);
  const [modalPosition, setModalPosition] = useState<SpreadPosition | undefined>(undefined);
  const [modalIsReversed, setModalIsReversed] = useState<boolean | undefined>(undefined);

  const tableContainerRef = useRef<HTMLDivElement>(null);

  // Update current spread if prop changes
  useEffect(() => {
    setCurrentSpread(initialSpread);
    setDrawnCards([]);
    setSelectedCardIndex(null);
    setIsSaved(false);
  }, [initialSpread.id]);

  // Deal / Shuffle cards
  const handleDealCards = () => {
    setIsShuffling(true);
    setDrawnCards([]);
    setSelectedCardIndex(null);
    setIsSaved(false);

    setTimeout(() => {
      const pool = onlyMajorArcana
        ? ALL_TAROT_CARDS.filter((c) => c.arcana === 'major')
        : [...ALL_TAROT_CARDS];

      // Shuffle pool using Fisher-Yates
      for (let i = pool.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [pool[i], pool[j]] = [pool[j], pool[i]];
      }

      const count = currentSpread.positions.length;
      const selected: DrawnCard[] = pool.slice(0, count).map((card) => {
        const isReversed = allowReversed ? Math.random() < 0.35 : false;
        return {
          card,
          isReversed,
          isRevealed: false,
        };
      });

      setDrawnCards(selected);
      setIsShuffling(false);
    }, 850);
  };

  const handleCardTap = (index: number) => {
    const card = drawnCards[index];
    const position = currentSpread.positions[index];

    if (!card.isRevealed) {
      setDrawnCards((prev) => {
        const next = [...prev];
        next[index] = { ...next[index], isRevealed: true };
        return next;
      });
      setSelectedCardIndex(index);
    } else {
      setSelectedCardIndex(index);
      setModalCard(card.card);
      setModalPosition(position);
      setModalIsReversed(card.isReversed);
    }
  };

  const handleRevealAll = () => {
    setDrawnCards((prev) =>
      prev.map((c) => ({
        ...c,
        isRevealed: true,
      }))
    );
    if (drawnCards.length > 0 && selectedCardIndex === null) {
      setSelectedCardIndex(0);
    }
  };

  const allRevealed = drawnCards.length > 0 && drawnCards.every((d) => d.isRevealed);
  const revealedCount = drawnCards.filter((d) => d.isRevealed).length;

  const handleSaveReading = () => {
    if (drawnCards.length === 0 || isSaved) return;

    const synthesis = generateSpreadSynthesis(currentSpread, drawnCards, question);

    const reading: SavedReading = {
      id: Date.now().toString(),
      dateTime: new Date().toISOString(),
      question: question.trim().length === 0 ? `Без вопроса (${currentSpread.name})` : question.trim(),
      spreadId: currentSpread.id,
      spread: currentSpread,
      drawnCards: drawnCards.map((d) => ({
        card: d.card,
        isReversed: d.isReversed,
        isRevealed: true,
      })),
      summaryText: synthesis,
    };

    onSaveReading(reading);
    setIsSaved(true);

    // Launch mystical celebratory confetti
    confetti({
      particleCount: 50,
      spread: 60,
      origin: { y: 0.7 },
      colors: ['#D4AF37', '#FFE082', '#9575CD', '#BA68C8'],
    });
  };

  return (
    <div className="flex flex-col h-full animate-fadeIn">
      {/* ================= TOP CONTROL BAR ================= */}
      <div className="px-4 sm:px-6 py-3.5 bg-[#160E26] border-b border-[#D4AF37]/25 flex flex-wrap items-center justify-between gap-3 text-xs sm:text-sm">
        {/* Left: Spread Dropdown & Question */}
        <div className="flex flex-wrap items-center gap-3">
          {/* Spread Selector */}
          <div className="relative">
            <select
              value={currentSpread.id}
              onChange={(e) => {
                const found = TAROT_SPREADS.find((s) => s.id === e.target.value);
                if (found) {
                  setCurrentSpread(found);
                  setDrawnCards([]);
                  setSelectedCardIndex(null);
                  setIsSaved(false);
                }
              }}
              className="appearance-none bg-[#22163B] border border-[#D4AF37]/50 text-white rounded-xl px-3.5 py-2 pr-9 font-medium cursor-pointer focus:outline-none focus:border-[#D4AF37]"
            >
              {TAROT_SPREADS.map((sp) => (
                <option key={sp.id} value={sp.id} className="bg-[#1B1130] text-white">
                  {sp.name} ({sp.positions.length})
                </option>
              ))}
            </select>
            <ChevronDown
              size={16}
              className="absolute right-3 top-1/2 -translate-y-1/2 text-[#D4AF37] pointer-events-none"
            />
          </div>

          {/* Question input */}
          <div className="relative w-full sm:w-72">
            <input
              type="text"
              value={question}
              onChange={(e) => setQuestion(e.target.value)}
              placeholder="Ваш вопрос картам Таро..."
              className="w-full bg-[#22163B] border border-[#D4AF37]/35 focus:border-[#D4AF37] rounded-xl px-3 py-2 pl-9 text-white placeholder-white/40 focus:outline-none text-xs sm:text-sm transition-colors"
            />
            <HelpCircle
              size={16}
              className="absolute left-3 top-1/2 -translate-y-1/2 text-[#D4AF37]"
            />
          </div>
        </div>

        {/* Right: Toggles & Action Buttons */}
        <div className="flex flex-wrap items-center gap-2">
          {/* Allow Reversed toggle */}
          <button
            onClick={() => setAllowReversed(!allowReversed)}
            className={`px-3 py-1.5 rounded-xl border text-xs font-semibold transition-all ${
              allowReversed
                ? 'bg-[#D4AF37]/25 border-[#D4AF37] text-[#FFE082]'
                : 'bg-[#22163B] border-white/20 text-white/60 hover:text-white'
            }`}
          >
            {allowReversed ? '✓ Перевёрнутые' : 'Перевёрнутые'}
          </button>

          {/* Only Major Arcana toggle */}
          <button
            onClick={() => setOnlyMajorArcana(!onlyMajorArcana)}
            className={`px-3 py-1.5 rounded-xl border text-xs font-semibold transition-all ${
              onlyMajorArcana
                ? 'bg-[#D4AF37]/25 border-[#D4AF37] text-[#FFE082]'
                : 'bg-[#22163B] border-white/20 text-white/60 hover:text-white'
            }`}
          >
            {onlyMajorArcana ? '✓ Только Старшие' : 'Только Старшие'}
          </button>

          {/* Deal Cards Button */}
          <button
            onClick={handleDealCards}
            disabled={isShuffling}
            className="flex items-center gap-1.5 px-4 py-2 rounded-xl bg-[#D4AF37] hover:bg-[#FFE082] text-[#140D24] font-bold text-xs sm:text-sm shadow-md transition-all active:scale-95 disabled:opacity-50"
          >
            <Sparkles size={16} />
            <span>{drawnCards.length === 0 ? 'Разложить карты' : 'Новый расклад'}</span>
          </button>

          {/* Reveal All Button */}
          {drawnCards.length > 0 && !allRevealed && (
            <button
              onClick={handleRevealAll}
              className="flex items-center gap-1.5 px-3 py-2 rounded-xl border border-[#D4AF37] text-[#FFE082] hover:bg-[#D4AF37]/15 text-xs sm:text-sm font-semibold transition-colors"
            >
              <Eye size={16} />
              <span>Открыть все</span>
            </button>
          )}

          {/* Save to History Button */}
          {allRevealed && (
            <button
              onClick={handleSaveReading}
              disabled={isSaved}
              className={`flex items-center gap-1.5 px-3 py-2 rounded-xl border text-xs sm:text-sm font-semibold transition-all ${
                isSaved
                  ? 'bg-emerald-950/40 border-emerald-500/50 text-emerald-300'
                  : 'border-[#D4AF37] text-[#FFE082] hover:bg-[#D4AF37]/20'
              }`}
            >
              {isSaved ? <Check size={16} /> : <BookmarkPlus size={16} />}
              <span>{isSaved ? 'Сохранено' : 'В журнал'}</span>
            </button>
          )}
        </div>
      </div>

      {/* ================= MAIN SPREAD AREA ================= */}
      <div className="flex-1 flex flex-col lg:flex-row overflow-hidden">
        {/* ================= TABLE AREA ================= */}
        <div className="flex-1 relative p-4 sm:p-6 min-h-[500px] lg:min-h-0">
          <div
            ref={tableContainerRef}
            className="w-full h-full min-h-[500px] rounded-2xl bg-gradient-to-b from-[#241640] to-[#120B21] border border-[#D4AF37]/35 shadow-2xl relative overflow-hidden flex items-center justify-center select-none"
          >
            {/* Sacred Table Painter Background */}
            <SacredTablePainter />

            {/* Shuffling animation */}
            {isShuffling && (
              <div className="relative z-20 flex flex-col items-center justify-center gap-4 text-center">
                <div className="relative w-44 h-44 flex items-center justify-center">
                  {[0, 1, 2, 3, 4].map((i) => (
                    <div
                      key={i}
                      className="absolute w-24 h-36 rounded-xl bg-[#23153C] border-2 border-[#D4AF37] shadow-xl flex items-center justify-center text-[#D4AF37] transition-all"
                      style={{
                        transform: `translate(${(i - 2) * 22}px, 0) rotate(${(i - 2) * 8}deg)`,
                        animation: `pulse 1s ease-in-out infinite alternate ${i * 0.15}s`,
                      }}
                    >
                      <Sparkles size={26} />
                    </div>
                  ))}
                </div>
                <p className="text-sm sm:text-base font-cinzel text-[#FFE082] italic animate-pulse">
                  Тасуем колоду и настраиваемся на ваш вопрос...
                </p>
              </div>
            )}

            {/* Empty State before dealing */}
            {!isShuffling && drawnCards.length === 0 && (
              <div className="relative z-20 max-w-md p-6 text-center space-y-4">
                <div
                  className="w-20 h-20 mx-auto rounded-full border-2 flex items-center justify-center shadow-2xl"
                  style={{
                    backgroundColor: `${currentSpread.themeColor}18`,
                    borderColor: `${currentSpread.themeColor}80`,
                  }}
                >
                  <DynamicIcon
                    name={currentSpread.iconName}
                    size={40}
                    color={currentSpread.themeColor}
                  />
                </div>

                <div>
                  <h3 className="text-2xl font-bold font-cinzel text-white">
                    {currentSpread.name}
                  </h3>
                  <p className="text-xs sm:text-sm text-[#D4AF37] mt-1 font-medium">
                    {currentSpread.subtitle}
                  </p>
                </div>

                <p className="text-xs sm:text-sm text-white/70 leading-relaxed">
                  {currentSpread.description}
                </p>

                <button
                  onClick={handleDealCards}
                  className="inline-flex items-center gap-2 px-6 py-3.5 rounded-xl bg-[#D4AF37] hover:bg-[#FFE082] text-[#140D24] font-bold text-sm sm:text-base shadow-lg transition-transform hover:scale-105 active:scale-95"
                >
                  <Sparkles size={18} />
                  <span>Перетасовать колоду и вытянуть карты</span>
                </button>
              </div>
            )}

            {/* Dealt Cards positioned layout */}
            {!isShuffling && drawnCards.length > 0 && (
              <div className="absolute inset-0 w-full h-full p-6">
                {currentSpread.positions.map((pos, idx) => {
                  const drawn = drawnCards[idx];
                  if (!drawn) return null;

                  const isCeltic = currentSpread.positions.length >= 10;
                  const cardW = isCeltic ? 84 : 110;
                  const cardH = cardW * 1.58;

                  // Render order: selected card is raised to front
                  const isSelected = selectedCardIndex === idx;
                  const zIndex = isSelected ? 30 : idx + 10;

                  return (
                    <div
                      key={`card-pos-${idx}`}
                      style={{
                        position: 'absolute',
                        left: `calc(${pos.dx * 100}% - ${cardW / 2}px)`,
                        top: `calc(${pos.dy * 100}% - ${cardH / 2}px)`,
                        zIndex,
                      }}
                      className="transition-all duration-300"
                    >
                      <TarotCardWidget
                        drawnCard={drawn}
                        position={pos}
                        width={cardW}
                        height={cardH}
                        isSelected={isSelected}
                        onTap={() => handleCardTap(idx)}
                      />
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        </div>

        {/* ================= RIGHT / BOTTOM INTERPRETATION PANEL ================= */}
        <div className="w-full lg:w-[440px] flex-shrink-0 bg-[#160F29] border-t lg:border-t-0 lg:border-l border-[#D4AF37]/30 flex flex-col overflow-y-auto max-h-[500px] lg:max-h-none p-5 text-sm">
          {/* Initial State: Spread schema list */}
          {drawnCards.length === 0 ? (
            <div className="space-y-4">
              <div className="flex items-center gap-2 text-[#D4AF37] pb-2 border-b border-white/10">
                <BookOpen size={20} />
                <h3 className="font-bold text-base text-white">Схема позиций расклада</h3>
              </div>

              <div className="space-y-3">
                {currentSpread.positions.map((pos) => (
                  <div
                    key={pos.index}
                    className="p-3 rounded-xl bg-white/[0.03] border border-white/10 flex items-start gap-3"
                  >
                    <div className="w-6 h-6 rounded-full bg-[#D4AF37]/20 border border-[#D4AF37] flex items-center justify-center text-xs font-bold text-[#FFE082] flex-shrink-0 mt-0.5">
                      {pos.index}
                    </div>
                    <div>
                      <h4 className="font-bold text-white text-xs sm:text-sm">{pos.title}</h4>
                      <p className="text-white/60 text-xs mt-0.5 leading-relaxed">
                        {pos.description}
                      </p>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          ) : (
            /* Cards dealt state */
            <div className="space-y-4">
              {/* Header */}
              <div className="flex items-center justify-between pb-3 border-b border-white/10">
                <div className="flex items-center gap-2">
                  <Sparkles size={18} className="text-[#D4AF37]" />
                  <h3 className="font-bold text-base text-white font-cinzel">
                    Толкование расклада
                  </h3>
                </div>
                <span className="text-xs font-semibold text-[#D4AF37]">
                  Открыто {revealedCount} из {drawnCards.length}
                </span>
              </div>

              {/* Synthesis summary when all are revealed */}
              {allRevealed && (
                <div className="p-4 rounded-xl bg-gradient-to-br from-[#D4AF37]/20 to-[#241640] border border-[#D4AF37]/65 shadow-md">
                  <div className="flex items-center gap-2 text-[#FFE082] font-bold text-sm mb-2">
                    <Sparkles size={16} />
                    <span>Синтез и общий итог расклада</span>
                  </div>
                  <p className="text-xs sm:text-sm text-white/90 leading-relaxed whitespace-pre-line">
                    {generateSpreadSynthesis(currentSpread, drawnCards, question)}
                  </p>
                </div>
              )}

              {/* Position tiles */}
              <div className="space-y-2.5">
                {currentSpread.positions.map((pos, idx) => {
                  const drawn = drawnCards[idx];
                  if (!drawn) return null;
                  const isSelected = selectedCardIndex === idx;

                  if (!drawn.isRevealed) {
                    return (
                      <div
                        key={pos.index}
                        onClick={() => handleCardTap(idx)}
                        className="p-3 rounded-xl bg-white/[0.02] hover:bg-white/[0.06] border border-white/10 cursor-pointer flex items-center justify-between transition-colors"
                      >
                        <div className="flex items-center gap-3">
                          <div className="w-6 h-6 rounded-full bg-white/10 text-white/70 flex items-center justify-center text-xs font-bold">
                            {pos.index}
                          </div>
                          <div>
                            <div className="text-xs sm:text-sm text-white/80 font-medium">
                              {pos.title}
                            </div>
                            <div className="text-[11px] text-white/40 italic">
                              Нажмите, чтобы открыть карту
                            </div>
                          </div>
                        </div>
                        <Eye size={16} className="text-[#D4AF37]" />
                      </div>
                    );
                  }

                  return (
                    <div
                      key={pos.index}
                      onClick={() => handleCardTap(idx)}
                      className={`p-3.5 rounded-xl border cursor-pointer transition-all ${
                        isSelected
                          ? 'bg-[#281A47] border-[#D4AF37] shadow-lg'
                          : 'bg-white/[0.04] hover:bg-white/[0.08] border-white/15'
                      }`}
                    >
                      <div className="flex items-center justify-between mb-1.5">
                        <div className="flex items-center gap-2">
                          <div className="w-5 h-5 rounded-full bg-[#D4AF37] text-[#140D24] font-bold text-xs flex items-center justify-center flex-shrink-0">
                            {pos.index}
                          </div>
                          <span className="text-[#FFE082] font-bold text-xs">
                            {pos.title}
                          </span>
                        </div>
                        <DynamicIcon
                          name={drawn.card.symbolIcon}
                          size={16}
                          color={drawn.card.accentColor}
                        />
                      </div>

                      <div className="flex items-center gap-2 text-xs font-bold text-white mb-1">
                        <span>
                          {drawn.card.numeral} • {drawn.card.name}
                        </span>
                        <span
                          className={`text-[10px] px-1.5 py-0.5 rounded font-normal ${
                            drawn.isReversed
                              ? 'bg-amber-500/20 text-amber-300'
                              : 'bg-emerald-500/20 text-emerald-300'
                          }`}
                        >
                          {drawn.isReversed ? 'Перевёрнутая' : 'Прямая'}
                        </span>
                      </div>

                      <p className="text-xs text-white/80 line-clamp-2 leading-relaxed mb-1.5">
                        {drawn.isReversed
                          ? drawn.card.reversedGeneral
                          : drawn.card.uprightGeneral}
                      </p>

                      <div className="text-[11px] text-[#D4AF37] italic line-clamp-1">
                        Совет: {drawn.card.advice}
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Card Details Modal */}
      <CardDetailsModal
        card={modalCard}
        position={modalPosition}
        isReversed={modalIsReversed}
        onClose={() => setModalCard(null)}
      />
    </div>
  );
};
