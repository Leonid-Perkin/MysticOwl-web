import { ALL_TAROT_CARDS, TAROT_SPREADS } from '../data/tarotDeck';
import { SavedReading } from '../types/tarot';

const HISTORY_KEY = 'mysticowl_saved_readings';

export function loadSavedReadings(): SavedReading[] {
  try {
    const jsonStr = localStorage.getItem(HISTORY_KEY);
    if (!jsonStr || jsonStr.trim().length === 0) {
      return [];
    }

    const list = JSON.parse(jsonStr);
    if (!Array.isArray(list)) return [];

    const result: SavedReading[] = [];

    for (const item of list) {
      try {
        const spreadId = item.spreadId;
        const spread =
          TAROT_SPREADS.find((s) => s.id === spreadId) || TAROT_SPREADS[0];

        const drawnCardsRaw = item.drawnCards || [];
        const drawnCards = drawnCardsRaw.map((dj: any) => {
          const cardId = typeof dj.cardId === 'number' ? dj.cardId : dj.card?.id ?? 0;
          const card =
            ALL_TAROT_CARDS.find((c) => c.id === cardId) || ALL_TAROT_CARDS[0];
          return {
            card,
            isReversed: Boolean(dj.isReversed),
            isRevealed: dj.isRevealed !== undefined ? Boolean(dj.isRevealed) : true,
          };
        });

        result.push({
          id: String(item.id),
          dateTime: item.dateTime || new Date().toISOString(),
          question: item.question || '',
          spreadId: spread.id,
          spread,
          drawnCards,
          summaryText: item.summaryText || '',
        });
      } catch (err) {
        console.warn('Error parsing single reading:', err);
      }
    }

    return result;
  } catch (err) {
    console.error('Error loading readings from storage:', err);
    return [];
  }
}

export function saveReadings(readings: SavedReading[]): void {
  try {
    const list = readings.map((r) => ({
      id: r.id,
      dateTime: r.dateTime,
      question: r.question,
      spreadId: r.spread.id,
      drawnCards: r.drawnCards.map((d) => ({
        cardId: d.card.id,
        isReversed: d.isReversed,
        isRevealed: d.isRevealed,
      })),
      summaryText: r.summaryText,
    }));

    localStorage.setItem(HISTORY_KEY, JSON.stringify(list));
  } catch (err) {
    console.error('Error saving readings to storage:', err);
  }
}
