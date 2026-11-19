import React, { useState, useEffect } from 'react';
import { TAROT_SPREADS } from './data/tarotDeck';
import { TarotSpread, SavedReading } from './types/tarot';
import { loadSavedReadings, saveReadings } from './services/storageService';
import { Navbar } from './components/Navbar';
import { DesktopNavRail, MobileBottomNav, TabType } from './components/Navigation';
import { SpreadsCatalogScreen } from './screens/SpreadsCatalogScreen';
import { SpreadScreen } from './screens/SpreadScreen';
import { EncyclopediaScreen } from './screens/EncyclopediaScreen';
import { HistoryScreen } from './screens/HistoryScreen';

export const App: React.FC = () => {
  const [currentTab, setCurrentTab] = useState<TabType>('spreads');
  const [activeSpread, setActiveSpread] = useState<TarotSpread>(TAROT_SPREADS[0]);
  const [savedReadings, setSavedReadings] = useState<SavedReading[]>([]);

  // Load readings from LocalStorage on mount
  useEffect(() => {
    const loaded = loadSavedReadings();
    setSavedReadings(loaded);
  }, []);

  const handleOpenSpread = (spread: TarotSpread) => {
    setActiveSpread(spread);
    setCurrentTab('table');
  };

  const handleAddSavedReading = (reading: SavedReading) => {
    const updated = [reading, ...savedReadings];
    setSavedReadings(updated);
    saveReadings(updated);
  };

  const handleDeleteSavedReading = (id: string) => {
    const updated = savedReadings.filter((r) => r.id !== id);
    setSavedReadings(updated);
    saveReadings(updated);
  };

  return (
    <div className="h-screen max-h-screen w-screen overflow-hidden flex flex-col bg-[#0E0918] text-[#F5EFE6]">
      {/* Top Navbar */}
      <Navbar savedReadingsCount={savedReadings.length} />

      {/* Main Workspace */}
      <div className="flex-1 flex overflow-hidden relative">
        {/* Desktop Navigation Rail */}
        <div className="hidden md:flex flex-shrink-0 h-full">
          <DesktopNavRail currentTab={currentTab} onTabChange={setCurrentTab} />
        </div>

        {/* Content Screens: Preserved in DOM like Flutter's IndexedStack so state is never lost */}
        <main className="flex-1 h-full overflow-hidden relative pb-16 md:pb-0">
          <div className={`h-full w-full overflow-y-auto ${currentTab === 'spreads' ? 'block' : 'hidden'}`}>
            <SpreadsCatalogScreen onSelectSpread={handleOpenSpread} />
          </div>

          <div className={`h-full w-full overflow-hidden ${currentTab === 'table' ? 'block' : 'hidden'}`}>
            <SpreadScreen
              initialSpread={activeSpread}
              onSpreadChange={setActiveSpread}
              onSaveReading={handleAddSavedReading}
            />
          </div>

          <div className={`h-full w-full overflow-y-auto ${currentTab === 'encyclopedia' ? 'block' : 'hidden'}`}>
            <EncyclopediaScreen />
          </div>

          <div className={`h-full w-full overflow-y-auto ${currentTab === 'history' ? 'block' : 'hidden'}`}>
            <HistoryScreen
              readings={savedReadings}
              onDeleteReading={handleDeleteSavedReading}
            />
          </div>
        </main>
      </div>

      {/* Mobile Bottom Navigation Bar */}
      <MobileBottomNav currentTab={currentTab} onTabChange={setCurrentTab} />
    </div>
  );
};

export default App;
