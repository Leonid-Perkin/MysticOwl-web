import React, { useEffect } from 'react';
import { TarotCard, SpreadPosition, TAROT_ELEMENTS, ARCANA_LABELS } from '../types/tarot';
import { DynamicIcon } from './DynamicIcon';
import { X, Sparkles, Heart, Briefcase, Sun, Moon, Globe, ArrowUp, ArrowDown } from 'lucide-react';

interface CardDetailsModalProps {
  card: TarotCard | null;
  position?: SpreadPosition;
  isReversed?: boolean;
  onClose: () => void;
}

export const CardDetailsModal: React.FC<CardDetailsModalProps> = ({
  card,
  position,
  isReversed,
  onClose,
}) => {
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') onClose();
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [onClose]);

  if (!card) return null;

  const elementInfo = TAROT_ELEMENTS[card.element];

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 sm:p-6 bg-black/80 backdrop-blur-sm animate-fadeIn">
      {/* Backdrop click to dismiss */}
      <div className="fixed inset-0" onClick={onClose} />

      <div
        className="relative z-10 w-full max-w-2xl max-h-[90vh] overflow-y-auto bg-[#160F29] border border-[#D4AF37]/50 rounded-2xl shadow-2xl p-6 sm:p-8 text-[#F5EFE6]"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Close Button */}
        <button
          onClick={onClose}
          className="absolute top-4 right-4 p-2 rounded-full bg-white/5 hover:bg-white/10 text-white/70 hover:text-white transition-colors"
          title="Закрыть"
        >
          <X size={20} />
        </button>

        {/* Position context (if opened from spread) */}
        {position && (
          <div className="mb-6 p-4 rounded-xl bg-[#23183E] border border-[#D4AF37]/35 flex items-start gap-3.5">
            <div className="w-8 h-8 rounded-full bg-[#D4AF37] text-[#140D24] font-bold text-sm flex items-center justify-center flex-shrink-0 mt-0.5">
              {position.index}
            </div>
            <div>
              <h4 className="text-[#FFE082] font-bold text-base">{position.title}</h4>
              <p className="text-white/70 text-xs sm:text-sm mt-0.5">{position.description}</p>
            </div>
          </div>
        )}

        {/* Main Header */}
        <div className="flex flex-col sm:flex-row items-center sm:items-start gap-5 pb-6 border-b border-[#D4AF37]/20">
          {/* Card Icon Medallion */}
          <div
            className="w-20 h-20 rounded-full flex items-center justify-center border-2 flex-shrink-0"
            style={{
              backgroundColor: `${card.accentColor}20`,
              borderColor: card.accentColor,
              boxShadow: `0 0 20px ${card.accentColor}30`,
            }}
          >
            <div className={`transition-transform duration-300 ${isReversed ? 'rotate-180' : ''}`}>
              <DynamicIcon name={card.symbolIcon} size={40} color={card.accentColor} />
            </div>
          </div>

          <div className="flex-1 text-center sm:text-left">
            <div className="text-[#D4AF37] font-semibold text-xs tracking-wider">
              {card.numeral} • {ARCANA_LABELS[card.arcana]}
            </div>
            <h2 className="text-2xl sm:text-3xl font-bold font-cinzel text-white mt-1">
              {card.name}
            </h2>

            {/* Badges / Chips */}
            <div className="flex flex-wrap items-center justify-center sm:justify-start gap-2 mt-3">
              {/* Element */}
              <div
                className="flex items-center gap-1.5 px-2.5 py-1 rounded-lg text-xs font-semibold"
                style={{
                  backgroundColor: `${elementInfo.color}25`,
                  color: elementInfo.color,
                  border: `1px solid ${elementInfo.color}50`,
                }}
              >
                <DynamicIcon name={elementInfo.iconName} size={13} color={elementInfo.color} />
                <span>{elementInfo.name}</span>
              </div>

              {/* Astrological Sign */}
              <div className="flex items-center gap-1.5 px-2.5 py-1 rounded-lg text-xs font-semibold bg-[#D4AF37]/15 text-[#D4AF37] border border-[#D4AF37]/40">
                <Globe size={13} />
                <span>{card.astrologicalSign}</span>
              </div>

              {/* Orientation chip */}
              {isReversed !== undefined && (
                <div
                  className={`flex items-center gap-1.5 px-2.5 py-1 rounded-lg text-xs font-semibold border ${
                    isReversed
                      ? 'bg-amber-500/20 text-amber-300 border-amber-500/50'
                      : 'bg-emerald-500/20 text-emerald-300 border-emerald-500/50'
                  }`}
                >
                  {isReversed ? <ArrowDown size={13} /> : <ArrowUp size={13} />}
                  <span>{isReversed ? 'Перевёрнутое положение' : 'Прямое положение'}</span>
                </div>
              )}
            </div>
          </div>
        </div>

        {/* Keywords */}
        <div className="my-5 flex flex-wrap gap-2">
          {card.keywords.map((kw) => (
            <span
              key={kw}
              className="px-3 py-1 rounded-full text-xs bg-white/5 border border-white/15 text-[#FFE082]"
            >
              #{kw}
            </span>
          ))}
        </div>

        {/* Detailed Interpretations */}
        <div className="space-y-4">
          {/* Upright Meaning */}
          <Section
            title="Прямое значение"
            content={card.uprightGeneral}
            icon={<Sun size={18} className="text-amber-300" />}
            highlight={isReversed === false}
          />

          {/* Reversed Meaning */}
          <Section
            title="Перевёрнутое значение (Тень)"
            content={card.reversedGeneral}
            icon={<Moon size={18} className="text-violet-300" />}
            highlight={isReversed === true}
          />

          {/* Love Meaning */}
          <Section
            title="Любовь и отношения"
            content={card.loveMeaning}
            icon={<Heart size={18} className="text-rose-400" />}
          />

          {/* Career Meaning */}
          <Section
            title="Работа, бизнес и финансы"
            content={card.careerMeaning}
            icon={<Briefcase size={18} className="text-sky-400" />}
          />

          {/* Advice */}
          <Section
            title="Совет Аркана"
            content={card.advice}
            icon={<Sparkles size={18} className="text-[#D4AF37]" />}
            highlight
          />
        </div>
      </div>
    </div>
  );
};

interface SectionProps {
  title: string;
  content: string;
  icon: React.ReactNode;
  highlight?: boolean;
}

const Section: React.FC<SectionProps> = ({ title, content, icon, highlight }) => {
  return (
    <div
      className={`p-4 rounded-xl border transition-colors ${
        highlight
          ? 'bg-[#D4AF37]/10 border-[#D4AF37]/60'
          : 'bg-white/[0.03] border-white/10'
      }`}
    >
      <div className="flex items-center gap-2 mb-2">
        {icon}
        <h4
          className={`font-bold text-sm ${
            highlight ? 'text-[#FFE082]' : 'text-white'
          }`}
        >
          {title}
        </h4>
      </div>
      <p className="text-sm leading-relaxed text-[#E5DFF0]">{content}</p>
    </div>
  );
};
