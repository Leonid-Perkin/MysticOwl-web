import { ALL_TAROT_CARDS, TAROT_SPREADS } from '../data/tarotDeck';
import { SavedReading } from '../types/tarot';

const HISTORY_KEY = 'mysticowl_saved_readings';
const MAX_SAVED_READINGS = 100;
const MAX_QUESTION_LENGTH = 200;
const MAX_SUMMARY_LENGTH = 3000;

/**
 * Sanitizes untrusted strings: removes control characters and clamps length.
 */
function sanitizeString(input: unknown, maxLength: number): string {
  if (typeof input !== 'string') return '';
  // Strip dangerous ASCII control characters (0x00 - 0x1F, except newline) and 0x7F
  const cleaned = input.replace(/[\x00-\x09\x0B-\x1F\x7F]/g, '').trim();
  return cleaned.slice(0, maxLength);
}

/**
 * Validates ISO date string.
 */
function sanitizeDate(input: unknown): string {
  if (typeof input === 'string') {
    const parsed = Date.parse(input);
    if (!isNaN(parsed)) {
      return new Date(parsed).toISOString();
    }
  }
  return new Date().toISOString();
}

/**
 * Validates a safe card ID.
 */
function sanitizeCardId(input: unknown): number {
  const num = Number(input);
  if (!Number.isFinite(num) || num < 0 || num >= ALL_TAROT_CARDS.length) {
    return 0;
  }
  return Math.floor(num);
}

/**
 * Safely loads and validates saved readings from LocalStorage.
 * Immune to prototype pollution, malformed JSON, and oversized injection.
 */
export function loadSavedReadings(): SavedReading[] {
  try {
    const raw = localStorage.getItem(HISTORY_KEY);
    if (!raw || typeof raw !== 'string' || raw.trim().length === 0) {
      return [];
    }

    // Safe JSON parse with prototype pollution filter
    const parsed = JSON.parse(raw, (key, value) => {
      if (key === '__proto__' || key === 'constructor' || key === 'prototype') {
        return undefined;
      }
      return value;
    });

    if (!Array.isArray(parsed)) return [];

    const result: SavedReading[] = [];
    const safeList = parsed.slice(0, MAX_SAVED_READINGS);

    for (const item of safeList) {
      if (!item || typeof item !== 'object') continue;

      try {
        const spreadId = sanitizeString(item.spreadId, 50);
        const spread =
          TAROT_SPREADS.find((s) => s.id === spreadId) || TAROT_SPREADS[0];

        const drawnCardsRaw = Array.isArray(item.drawnCards) ? item.drawnCards : [];
        const drawnCards = drawnCardsRaw
          .slice(0, 15) // Celtic Cross has max 10
          .map((dj: any) => {
            const rawId = typeof dj?.cardId === 'number' ? dj.cardId : dj?.card?.id;
            const validId = sanitizeCardId(rawId);
            const card =
              ALL_TAROT_CARDS.find((c) => c.id === validId) || ALL_TAROT_CARDS[0];

            return {
              card,
              isReversed: Boolean(dj?.isReversed),
              isRevealed: dj?.isRevealed !== undefined ? Boolean(dj?.isRevealed) : true,
            };
          });

        const id = sanitizeString(item.id, 64) || Date.now().toString();
        const dateTime = sanitizeDate(item.dateTime);
        const question = sanitizeString(item.question, MAX_QUESTION_LENGTH);
        const summaryText = sanitizeString(item.summaryText, MAX_SUMMARY_LENGTH);

        result.push({
          id,
          dateTime,
          question,
          spreadId: spread.id,
          spread,
          drawnCards,
          summaryText,
        });
      } catch (innerErr) {
        console.warn('Skipping corrupted reading entry:', innerErr);
      }
    }

    return result;
  } catch (err) {
    console.error('Error loading readings from storage:', err);
    return [];
  }
}

/**
 * Safely writes saved readings to LocalStorage with quota defense and data pruning.
 */
export function saveReadings(readings: SavedReading[]): void {
  try {
    const safeReadings = readings.slice(0, MAX_SAVED_READINGS);

    const list = safeReadings.map((r) => ({
      id: sanitizeString(r.id, 64),
      dateTime: sanitizeDate(r.dateTime),
      question: sanitizeString(r.question, MAX_QUESTION_LENGTH),
      spreadId: sanitizeString(r.spread.id, 50),
      drawnCards: r.drawnCards.map((d) => ({
        cardId: sanitizeCardId(d.card.id),
        isReversed: Boolean(d.isReversed),
        isRevealed: Boolean(d.isRevealed),
      })),
      summaryText: sanitizeString(r.summaryText, MAX_SUMMARY_LENGTH),
    }));

    const serialized = JSON.stringify(list);

    try {
      localStorage.setItem(HISTORY_KEY, serialized);
    } catch (quotaErr: any) {
      // LocalStorage quota exceeded: prune oldest 20 readings and retry
      if (quotaErr?.name === 'QuotaExceededError' || quotaErr?.code === 22) {
        console.warn('LocalStorage quota exceeded. Pruning older readings...');
        const pruned = list.slice(0, Math.max(1, list.length - 20));
        localStorage.setItem(HISTORY_KEY, JSON.stringify(pruned));
      } else {
        throw quotaErr;
      }
    }
  } catch (err) {
    console.error('Error saving readings to storage:', err);
  }
}
