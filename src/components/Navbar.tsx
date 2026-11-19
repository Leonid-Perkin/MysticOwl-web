import React, { useState } from 'react';
import { Sparkles, RefreshCw } from 'lucide-react';

interface NavbarProps {
  savedReadingsCount: number;
}

export const Navbar: React.FC<NavbarProps> = ({ savedReadingsCount }) => {
  const [showUpdateModal, setShowUpdateModal] = useState(false);
  const [isUpdating, setIsUpdating] = useState(false);

  const handleUpdateApp = () => {
    setIsUpdating(true);
    if ((window as any).updateMysticOwlApp) {
      (window as any).updateMysticOwlApp();
    } else {
      window.location.reload();
    }
  };

  return (
    <>
      <header className="h-16 px-4 sm:px-6 bg-[#150D25] border-b border-[#D4AF37]/25 flex items-center justify-between sticky top-0 z-40">
        {/* Brand */}
        <div className="flex items-center gap-3">
          <div className="w-9 h-9 rounded-full bg-[#D4AF37]/20 border border-[#D4AF37] flex items-center justify-center text-[#D4AF37] shadow-[0_0_12px_rgba(212,175,55,0.35)]">
            <Sparkles size={18} />
          </div>
          <div>
            <h1 className="text-sm sm:text-base font-bold text-[#FFE082] tracking-wider font-cinzel leading-none">
              MYSTICOWL • МИСТИЧЕСКИЙ ОРАКУЛ
            </h1>
            <p className="text-[11px] text-white/50 hidden sm:block mt-1">
              Интерактивные расклады и энциклопедия Арканов Таро
            </p>
          </div>
        </div>

        {/* Actions */}
        <div className="flex items-center gap-3">
          {/* PWA Update Button */}
          <button
            onClick={() => setShowUpdateModal(true)}
            className="p-2 rounded-xl text-[#D4AF37] hover:bg-[#D4AF37]/10 transition-colors"
            title="Обновить PWA приложение"
          >
            <RefreshCw size={19} className={isUpdating ? 'animate-spin' : ''} />
          </button>

          {/* History count badge */}
          <div className="px-3 py-1.5 rounded-full bg-[#22163B] border border-[#D4AF37]/40 text-[#FFE082] text-xs font-medium">
            <span className="hidden sm:inline">Записей в журнале: </span>
            <span className="font-bold">{savedReadingsCount}</span>
          </div>
        </div>
      </header>

      {/* PWA Update Confirmation Modal */}
      {showUpdateModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/75 backdrop-blur-sm animate-fadeIn">
          <div
            className="w-full max-w-md bg-[#1E1333] border border-[#D4AF37] rounded-2xl p-6 shadow-2xl text-[#F5EFE6]"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex items-center gap-3 text-[#D4AF37] mb-3">
              <RefreshCw size={22} />
              <h3 className="text-lg font-bold text-[#FFE082]">Обновление MysticOwl</h3>
            </div>
            <p className="text-sm text-white/70 leading-relaxed mb-6">
              Проверить наличие обновлений, очистить кэш приложения и загрузить последнюю версию?
            </p>

            <div className="flex justify-end gap-3">
              <button
                onClick={() => setShowUpdateModal(false)}
                className="px-4 py-2 rounded-xl text-sm text-white/60 hover:text-white hover:bg-white/5 transition-colors"
              >
                Отмена
              </button>
              <button
                onClick={handleUpdateApp}
                disabled={isUpdating}
                className="px-5 py-2 rounded-xl text-sm font-bold bg-[#D4AF37] hover:bg-[#FFE082] text-[#140D24] shadow-lg flex items-center gap-2 transition-colors disabled:opacity-50"
              >
                <RefreshCw size={16} className={isUpdating ? 'animate-spin' : ''} />
                {isUpdating ? 'Обновляем...' : 'Обновить'}
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
};
