import React from 'react';
import { DrawnCard, SpreadPosition, TAROT_ELEMENTS } from '../types/tarot';
import { DynamicIcon } from './DynamicIcon';

interface TarotCardWidgetProps {
  drawnCard: DrawnCard;
  position: SpreadPosition;
  width?: number;
  height?: number;
  isSelected?: boolean;
  onTap: () => void;
}

export const TarotCardWidget: React.FC<TarotCardWidgetProps> = ({
  drawnCard,
  position,
  width = 110,
  height = 174,
  isSelected = false,
  onTap,
}) => {
  const { card, isReversed, isRevealed } = drawnCard;
  const elementInfo = TAROT_ELEMENTS[card.element];

  // Proportional sizes
  const isCompact = width < 90;
  const badgeSize = isCompact ? 16 : 20;
  const iconSize = Math.max(14, width * 0.28);

  return (
    // Outer position & rotation wrapper (handles layout rotation, e.g. Celtic Cross card 2)
    <div
      style={{
        width: `${width}px`,
        height: `${height}px`,
        transform: position.rotation ? `rotate(${position.rotation}rad)` : undefined,
      }}
      className="select-none flex items-center justify-center"
    >
      {/* Interactive hover/scale & 3D perspective wrapper (NEVER conflicts with rotation) */}
      <div
        onClick={onTap}
        className="w-full h-full cursor-pointer group perspective-1000 transition-transform duration-200 hover:scale-105 active:scale-95"
      >
        <div
          className={`w-full h-full relative preserve-3d transition-transform duration-500 ease-in-out ${
            isRevealed ? 'rotate-y-180' : ''
          }`}
        >
          {/* ================= CARD BACK ================= */}
          <div
            className="absolute inset-0 w-full h-full rounded-xl bg-gradient-to-br from-[#23153C] via-[#120A22] to-[#2A1948] border-2 border-[#D4AF37]/85 shadow-[0_4px_16px_rgba(0,0,0,0.7),0_0_12px_rgba(212,175,55,0.22)] backface-hidden overflow-hidden flex flex-col justify-between p-1.5 sm:p-2"
          >
            {/* Sacred geometry 8-pointed star SVG */}
            <div className="absolute inset-1 pointer-events-none opacity-60">
              <svg viewBox="0 0 100 160" className="w-full h-full">
                <rect x="3" y="3" width="94" height="154" rx="8" fill="none" stroke="#D4AF37" strokeWidth="1" strokeOpacity="0.55" />
                <circle cx="50" cy="80" r="32" fill="none" stroke="#D4AF37" strokeWidth="1" strokeOpacity="0.6" />
                <circle cx="50" cy="80" r="21" fill="none" stroke="#D4AF37" strokeWidth="0.8" strokeOpacity="0.5" strokeDasharray="2 3" />
                <circle cx="50" cy="80" r="9" fill="none" stroke="#D4AF37" strokeWidth="0.8" strokeOpacity="0.7" />
                {[0, 45, 90, 135].map((deg) => (
                  <line
                    key={deg}
                    x1={50 + 32 * Math.cos((deg * Math.PI) / 180)}
                    y1={80 + 32 * Math.sin((deg * Math.PI) / 180)}
                    x2={50 - 32 * Math.cos((deg * Math.PI) / 180)}
                    y2={80 - 32 * Math.sin((deg * Math.PI) / 180)}
                    stroke="#D4AF37"
                    strokeWidth="0.9"
                    strokeOpacity="0.65"
                  />
                ))}
              </svg>
            </div>

            {/* Position Badge */}
            <div
              style={{ width: `${badgeSize}px`, height: `${badgeSize}px` }}
              className="relative z-10 rounded-full bg-[#D4AF37]/25 border border-[#D4AF37] flex items-center justify-center font-bold text-[#FFE082] text-[10px]"
            >
              {position.index}
            </div>

            {/* "Нажмите" hint */}
            <div className="relative z-10 mx-auto px-1.5 py-0.5 rounded bg-black/70 border border-[#D4AF37]/40 text-[8.5px] sm:text-[9.5px] text-[#D4AF37] tracking-wider font-medium animate-pulse-subtle">
              Нажмите
            </div>
          </div>

          {/* ================= CARD FRONT ================= */}
          <div
            className={`absolute inset-0 w-full h-full rounded-xl bg-gradient-to-b from-[#1F1633] via-[#140D24] to-[#0F0A1B] border-2 backface-hidden rotate-y-180 flex flex-col justify-between p-1.5 sm:p-2 shadow-[0_4px_16px_rgba(0,0,0,0.8)] ${
              isSelected
                ? 'border-[#FFE082] shadow-[0_0_20px_rgba(255,224,130,0.65)]'
                : 'border-[#D4AF37]/90 shadow-[0_0_12px_rgba(212,175,55,0.25)]'
            }`}
            style={{
              borderColor: isSelected ? '#FFE082' : card.accentColor || '#D4AF37',
            }}
          >
            {/* Top Bar: Position Badge, Numeral, Element Icon */}
            <div className="flex items-center justify-between">
              <div
                style={{
                  width: `${badgeSize}px`,
                  height: `${badgeSize}px`,
                  backgroundColor: `${card.accentColor}25`,
                  borderColor: card.accentColor,
                  color: '#FFE082',
                }}
                className="rounded-full flex items-center justify-center text-[9px] sm:text-[10px] font-bold border"
              >
                {position.index}
              </div>

              <span className="text-[#D4AF37] text-[10px] sm:text-[11.5px] font-bold tracking-wider font-cinzel">
                {card.numeral}
              </span>

              <div title={elementInfo.name}>
                <DynamicIcon
                  name={elementInfo.iconName}
                  size={isCompact ? 11 : 13}
                  color={elementInfo.color}
                />
              </div>
            </div>

            {/* Center Medallion (rotated 180° if reversed) */}
            <div className="flex-1 flex items-center justify-center my-0.5">
              <div
                className={`rounded-full flex items-center justify-center border transition-transform duration-500 ${
                  isReversed ? 'rotate-180' : ''
                }`}
                style={{
                  width: `${width * 0.54}px`,
                  height: `${width * 0.54}px`,
                  backgroundColor: `${card.accentColor}18`,
                  borderColor: `${card.accentColor}90`,
                  boxShadow: `0 0 14px ${card.accentColor}30`,
                }}
              >
                <DynamicIcon
                  name={card.symbolIcon}
                  size={iconSize}
                  color={card.accentColor}
                />
              </div>
            </div>

            {/* Bottom Title & Reversed tag */}
            <div className="text-center px-0.5">
              <div
                className="text-[#F5EFE6] font-semibold text-[9.5px] sm:text-[10.5px] leading-tight truncate"
                title={card.name}
              >
                {card.name}
              </div>
              {isReversed && (
                <div className="text-[8px] sm:text-[8.5px] text-amber-200/90 italic font-medium leading-none mt-0.5 truncate">
                  ⇅ Перевёрнута
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
