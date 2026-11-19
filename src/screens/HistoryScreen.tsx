import React, { useState } from 'react';
import { SavedReading, TarotCard, SpreadPosition } from '../types/tarot';
import { CardDetailsModal } from '../components/CardDetailsModal';
import { DynamicIcon } from '../components/DynamicIcon';
import { BookOpen, Trash2, AlertCircle } from 'lucide-react';

interface HistoryScreenProps {
  readings: SavedReading[];
  onDeleteReading: (id: string) => void;
}

export const HistoryScreen: React.FC<HistoryScreenProps> = ({
  readings,
  onDeleteReading,
}) => {
  const [modalCard, setModalCard] = useState<TarotCard | null>(null);
  const [modalPosition, setModalPosition] = useState<SpreadPosition | undefined>(undefined);
  const [modalIsReversed, setModalIsReversed] = useState<boolean | undefined>(undefined);

  // Delete confirmation modal state
  const [readingToDelete, setReadingToDelete] = useState<SavedReading | null>(null);

  const formatDate = (isoString: string) => {
    try {
      const dt = new Date(isoString);
      const d = String(dt.getDate()).padStart(2, '0');
      const m = String(dt.getMonth() + 1).padStart(2, '0');
      const y = dt.getFullYear();
      const h = String(dt.getHours()).padStart(2, '0');
      const min = String(dt.getMinutes()).padStart(2, '0');
      return `${d}.${m}.${y} в ${h}:${min}`;
    } catch {
      return isoString;
    }
  };

  const confirmDelete = () => {
    if (readingToDelete) {
      onDeleteReading(readingToDelete.id);
      setReadingToDelete(null);
    }
  };

  return (
    <div className="p-4 sm:p-6 lg:p-8 max-w-[1400px] mx-auto space-y-6 animate-fadeIn">
      <div>
        <h2 className="text-xl sm:text-2xl lg:text-3xl font-bold font-cinzel text-white">
          Журнал сохранённых раскладов
        </h2>
        <p className="text-xs sm:text-sm text-white/60 mt-1">
          Храните историю своих вопросов, выпавших Арканов и синтеза раскладов
        </p>
      </div>

      {readings.length === 0 ? (
        <div className="py-20 sm:py-24 flex flex-col items-center justify-center text-center space-y-4 text-white/50 px-4">
          <div className="w-16 h-16 sm:w-20 sm:h-20 rounded-full bg-[#D4AF37]/10 border border-[#D4AF37]/30 flex items-center justify-center text-[#D4AF37]">
            <BookOpen size={36} />
          </div>
          <div>
            <h3 className="text-lg sm:text-xl font-bold text-white">Журнал пока пуст</h3>
            <p className="text-xs sm:text-sm text-white/60 max-w-sm mt-1 leading-relaxed">
              Выполните любой расклад, откройте все карты и нажмите кнопку «В журнал».
            </p>
          </div>
        </div>
      ) : (
        <div className="space-y-4">
          {readings.map((item) => (
            <div
              key={item.id}
              className="p-4 sm:p-6 rounded-2xl bg-[#19112E] border border-[#D4AF37]/40 shadow-xl space-y-3.5"
            >
              {/* Top Row: Spread info & Date & Delete Button */}
              <div className="flex items-start justify-between gap-3">
                <div className="flex items-center gap-3">
                  <div
                    className="p-2 sm:p-2.5 rounded-xl border flex-shrink-0"
                    style={{
                      backgroundColor: `${item.spread.themeColor}20`,
                      borderColor: `${item.spread.themeColor}60`,
                    }}
                  >
                    <DynamicIcon
                      name={item.spread.iconName}
                      size={18}
                      color={item.spread.themeColor}
                    />
                  </div>
                  <div>
                    <h4 className="text-sm sm:text-base font-bold text-[#FFE082]">
                      {item.spread.name}
                    </h4>
                    <span className="text-[11px] sm:text-xs text-white/50">
                      {formatDate(item.dateTime)}
                    </span>
                  </div>
                </div>

                <button
                  onClick={() => setReadingToDelete(item)}
                  className="p-2 rounded-xl text-white/40 hover:text-rose-400 hover:bg-rose-500/10 transition-colors"
                  title="Удалить запись"
                >
                  <Trash2 size={17} />
                </button>
              </div>

              {/* Question */}
              <div className="text-xs sm:text-sm font-semibold text-white">
                Вопрос: «{item.question}»
              </div>

              {/* Drawn Cards Chips */}
              <div className="flex flex-wrap gap-1.5 sm:gap-2">
                {item.drawnCards.map((drawn, idx) => {
                  const pos = item.spread.positions[idx] || {
                    index: idx + 1,
                    title: `Позиция ${idx + 1}`,
                    description: '',
                    dx: 0.5,
                    dy: 0.5,
                  };
                  return (
                    <button
                      key={idx}
                      onClick={() => {
                        setModalCard(drawn.card);
                        setModalPosition(pos);
                        setModalIsReversed(drawn.isReversed);
                      }}
                      className="flex items-center gap-1.5 sm:gap-2 px-2.5 sm:px-3 py-1 sm:py-1.5 rounded-xl bg-[#251942] hover:bg-[#322157] border transition-colors text-[11px] sm:text-xs font-medium text-white/90"
                      style={{
                        borderColor: `${drawn.card.accentColor}50`,
                      }}
                    >
                      <DynamicIcon
                        name={drawn.card.symbolIcon}
                        size={13}
                        color={drawn.card.accentColor}
                      />
                      <span>
                        {pos.index}. {drawn.card.name}
                        {drawn.isReversed ? ' (⇅)' : ''}
                      </span>
                    </button>
                  );
                })}
              </div>

              {/* Synthesis Summary */}
              {item.summaryText && (
                <div className="p-3 sm:p-3.5 rounded-xl bg-black/30 border border-white/5 text-xs sm:text-sm text-white/75 leading-relaxed whitespace-pre-line">
                  {item.summaryText}
                </div>
              )}
            </div>
          ))}
        </div>
      )}

      {/* Delete Confirmation Modal */}
      {readingToDelete && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm animate-fadeIn">
          <div
            className="w-full max-w-md bg-[#1B1130] border border-rose-500/50 rounded-2xl p-6 shadow-2xl text-[#F5EFE6]"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex items-center gap-3 text-rose-400 mb-3">
              <AlertCircle size={22} />
              <h3 className="text-base sm:text-lg font-bold text-white">Удалить запись из журнала?</h3>
            </div>
            <p className="text-xs sm:text-sm text-white/70 leading-relaxed mb-6">
              Вы уверены, что хотите удалить расклад «{readingToDelete.spread.name}» от{' '}
              {formatDate(readingToDelete.dateTime)}? Это действие необратимо.
            </p>

            <div className="flex justify-end gap-3">
              <button
                onClick={() => setReadingToDelete(null)}
                className="px-4 py-2 rounded-xl text-xs sm:text-sm text-white/60 hover:text-white hover:bg-white/5 transition-colors"
              >
                Отмена
              </button>
              <button
                onClick={confirmDelete}
                className="px-4 py-2 rounded-xl text-xs sm:text-sm font-bold bg-rose-600 hover:bg-rose-500 text-white shadow-lg transition-colors flex items-center gap-1.5"
              >
                <Trash2 size={15} />
                <span>Удалить</span>
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Details modal */}
      <CardDetailsModal
        card={modalCard}
        position={modalPosition}
        isReversed={modalIsReversed}
        onClose={() => setModalCard(null)}
      />
    </div>
  );
};
