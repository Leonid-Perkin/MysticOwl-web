import { describe, it, expect, beforeEach } from 'vitest';
import { ALL_TAROT_CARDS, TAROT_SPREADS, generateSpreadSynthesis } from '../data/tarotDeck';
import { loadSavedReadings, saveReadings } from '../services/storageService';
import { DrawnCard, SavedReading } from '../types/tarot';

describe('Tarot Deck Data Integrity', () => {
  it('should have exactly 32 cards (22 Major + 10 Minor Arcana)', () => {
    expect(ALL_TAROT_CARDS.length).toBe(32);
  });

  it('should have unique IDs from 0 to 31', () => {
    const ids = ALL_TAROT_CARDS.map((c) => c.id);
    const uniqueIds = new Set(ids);
    expect(uniqueIds.size).toBe(32);
    for (let i = 0; i < 32; i++) {
      expect(uniqueIds.has(i)).toBe(true);
    }
  });

  it('should have valid fields on all cards', () => {
    for (const card of ALL_TAROT_CARDS) {
      expect(card.name.trim().length).toBeGreaterThan(0);
      expect(card.numeral.trim().length).toBeGreaterThan(0);
      expect(card.symbolIcon.trim().length).toBeGreaterThan(0);
      expect(card.keywords.length).toBeGreaterThan(0);
      expect(card.uprightGeneral.trim().length).toBeGreaterThan(0);
      expect(card.reversedGeneral.trim().length).toBeGreaterThan(0);
      expect(card.loveMeaning.trim().length).toBeGreaterThan(0);
      expect(card.careerMeaning.trim().length).toBeGreaterThan(0);
      expect(card.advice.trim().length).toBeGreaterThan(0);
      expect(['fire', 'water', 'air', 'earth', 'spirit']).toContain(card.element);
      expect(['major', 'wands', 'cups', 'swords', 'pentacles']).toContain(card.arcana);
    }
  });

  it('should have 22 Major Arcana cards', () => {
    const majors = ALL_TAROT_CARDS.filter((c) => c.arcana === 'major');
    expect(majors.length).toBe(22);
  });
});

describe('Tarot Spreads Configuration', () => {
  it('should have exactly 5 spreads', () => {
    expect(TAROT_SPREADS.length).toBe(5);
  });

  it('should have correct positions configuration for each spread', () => {
    const expected = [
      { id: 'card_of_day', count: 1 },
      { id: 'three_cards', count: 3 },
      { id: 'love_mirror', count: 4 },
      { id: 'crossroads_choice', count: 5 },
      { id: 'celtic_cross', count: 10 },
    ];

    for (const exp of expected) {
      const spread = TAROT_SPREADS.find((s) => s.id === exp.id);
      expect(spread).toBeDefined();
      expect(spread!.positions.length).toBe(exp.count);

      // Verify normalized positions are strictly within canvas bounds
      for (const pos of spread!.positions) {
        expect(pos.dx).toBeGreaterThanOrEqual(0.05);
        expect(pos.dx).toBeLessThanOrEqual(0.95);
        expect(pos.dy).toBeGreaterThanOrEqual(0.05);
        expect(pos.dy).toBeLessThanOrEqual(0.95);
      }
    }
  });

  it('should verify Celtic Cross has separate positions for card 1 and card 2', () => {
    const celtic = TAROT_SPREADS.find((s) => s.id === 'celtic_cross')!;
    const pos1 = celtic.positions[0];
    const pos2 = celtic.positions[1];
    expect(pos1.index).toBe(1);
    expect(pos2.index).toBe(2);
    // They are distinctly separated horizontally
    expect(pos2.dx).toBeGreaterThan(pos1.dx);
  });
});

describe('Tarot Synthesis Engine', () => {
  it('should return empty string for empty drawn cards', () => {
    const spread = TAROT_SPREADS[0];
    const result = generateSpreadSynthesis(spread, [], 'Вопрос');
    expect(result).toBe('');
  });

  it('should generate synthesis with dominant element, major arcana ratio and advice', () => {
    const spread = TAROT_SPREADS[1]; // 3 cards
    const drawn: DrawnCard[] = [
      { card: ALL_TAROT_CARDS[0], isReversed: false, isRevealed: true }, // Air, Major
      { card: ALL_TAROT_CARDS[1], isReversed: false, isRevealed: true }, // Air, Major
      { card: ALL_TAROT_CARDS[4], isReversed: true, isRevealed: true },  // Fire, Major
    ];

    const result = generateSpreadSynthesis(spread, drawn, 'Тестовый вопрос?');
    expect(result).toContain('Тестовый вопрос?');
    expect(result).toContain('Старшие Арканы');
    expect(result).toContain('Воздух');
    expect(result).toContain(ALL_TAROT_CARDS[4].advice);
  });
});

describe('Storage Service Security & Integrity', () => {
  beforeEach(() => {
    localStorage.clear();
  });

  it('should return empty array when storage is empty', () => {
    expect(loadSavedReadings()).toEqual([]);
  });

  it('should save and load readings safely', () => {
    const mockReading: SavedReading = {
      id: 'test-1',
      dateTime: new Date().toISOString(),
      question: 'Test question?',
      spreadId: 'card_of_day',
      spread: TAROT_SPREADS[0],
      drawnCards: [
        { card: ALL_TAROT_CARDS[0], isReversed: false, isRevealed: true },
      ],
      summaryText: 'Summary advice text',
    };

    saveReadings([mockReading]);
    const loaded = loadSavedReadings();
    expect(loaded.length).toBe(1);
    expect(loaded[0].id).toBe('test-1');
    expect(loaded[0].question).toBe('Test question?');
    expect(loaded[0].drawnCards[0].card.name).toBe(ALL_TAROT_CARDS[0].name);
  });

  it('should withstand prototype pollution in LocalStorage', () => {
    const maliciousPayload = JSON.stringify([
      {
        id: 'polluted',
        __proto__: { injectedAdmin: true },
        constructor: { prototype: { hacked: true } },
        spreadId: 'card_of_day',
        drawnCards: [{ cardId: 0, isReversed: false }],
        question: 'Malicious?',
      },
    ]);

    localStorage.setItem('mysticowl_saved_readings', maliciousPayload);
    const loaded = loadSavedReadings();
    expect(loaded.length).toBe(1);
    expect((Object.prototype as any).injectedAdmin).toBeUndefined();
    expect((Object.prototype as any).hacked).toBeUndefined();
  });

  it('should clamp excessively long questions', () => {
    const giantQuestion = 'A'.repeat(5000);
    const mockReading: SavedReading = {
      id: 'long-q',
      dateTime: new Date().toISOString(),
      question: giantQuestion,
      spreadId: 'card_of_day',
      spread: TAROT_SPREADS[0],
      drawnCards: [{ card: ALL_TAROT_CARDS[0], isReversed: false, isRevealed: true }],
      summaryText: 'Summary',
    };

    saveReadings([mockReading]);
    const loaded = loadSavedReadings();
    expect(loaded[0].question.length).toBeLessThanOrEqual(200);
  });
});
