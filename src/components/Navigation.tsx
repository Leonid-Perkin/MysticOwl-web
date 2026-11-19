import React from 'react';
import { LayoutGrid, Sparkles, BookOpen, History, LucideIcon } from 'lucide-react';

export type TabType = 'spreads' | 'table' | 'encyclopedia' | 'history';

interface NavigationProps {
  currentTab: TabType;
  onTabChange: (tab: TabType) => void;
}

const NAV_ITEMS: { id: TabType; label: string; icon: LucideIcon }[] = [
  { id: 'spreads', label: 'Расклады', icon: LayoutGrid },
  { id: 'table', label: 'Стол Таро', icon: Sparkles },
  { id: 'encyclopedia', label: 'Арканы', icon: BookOpen },
  { id: 'history', label: 'Журнал', icon: History },
];

export const DesktopNavRail: React.FC<NavigationProps> = ({ currentTab, onTabChange }) => {
  return (
    <nav className="w-24 bg-[#140C24] border-r border-[#D4AF37]/20 flex flex-col items-center py-6 gap-6 flex-shrink-0 select-none">
      {NAV_ITEMS.map((item) => {
        const Icon = item.icon;
        const isActive = currentTab === item.id;
        return (
          <button
            key={item.id}
            onClick={() => onTabChange(item.id)}
            className={`flex flex-col items-center gap-1.5 p-2 rounded-2xl w-20 transition-all ${
              isActive
                ? 'bg-[#D4AF37]/15 text-[#FFE082]'
                : 'text-white/60 hover:text-white hover:bg-white/5'
            }`}
          >
            <div
              className={`w-12 h-10 rounded-xl flex items-center justify-center transition-all ${
                isActive
                  ? 'bg-[#D4AF37] text-[#140D24] shadow-[0_0_12px_rgba(212,175,55,0.4)]'
                  : ''
              }`}
            >
              <Icon size={22} />
            </div>
            <span
              className={`text-[11.5px] font-medium leading-tight ${
                isActive ? 'font-bold text-[#FFE082]' : 'text-white/60'
              }`}
            >
              {item.label}
            </span>
          </button>
        );
      })}
    </nav>
  );
};

export const MobileBottomNav: React.FC<NavigationProps> = ({ currentTab, onTabChange }) => {
  return (
    <nav className="fixed bottom-0 left-0 right-0 h-16 bg-[#140C24] border-t border-[#D4AF37]/25 flex items-center justify-around px-2 z-40 md:hidden select-none">
      {NAV_ITEMS.map((item) => {
        const Icon = item.icon;
        const isActive = currentTab === item.id;
        return (
          <button
            key={item.id}
            onClick={() => onTabChange(item.id)}
            className={`flex flex-col items-center justify-center flex-1 py-1.5 transition-colors ${
              isActive ? 'text-[#D4AF37]' : 'text-white/50 hover:text-white/80'
            }`}
          >
            <Icon size={20} className={isActive ? 'scale-110 transition-transform' : ''} />
            <span
              className={`text-[10px] mt-1 ${
                isActive ? 'font-bold text-[#FFE082]' : 'font-normal'
              }`}
            >
              {item.label}
            </span>
          </button>
        );
      })}
    </nav>
  );
};
