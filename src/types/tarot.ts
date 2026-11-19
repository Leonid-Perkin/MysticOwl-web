export type ArcanaType = 'major' | 'wands' | 'cups' | 'swords' | 'pentacles';

export const ARCANA_LABELS: Record<ArcanaType, string> = {
  major: 'Старший Аркан',
  wands: 'Младший Аркан • Жезлы',
  cups: 'Младший Аркан • Кубки',
  swords: 'Младший Аркан • Мечи',
  pentacles: 'Младший Аркан • Пентакли',
};

export type TarotElementType = 'fire' | 'water' | 'air' | 'earth' | 'spirit';

export interface TarotElementInfo {
  name: string;
  iconName: string;
  color: string;
}

export const TAROT_ELEMENTS: Record<TarotElementType, TarotElementInfo> = {
  fire: { name: 'Огонь', iconName: 'Flame', color: '#E05A47' },
  water: { name: 'Вода', iconName: 'Droplets', color: '#4A90E2' },
  air: { name: 'Воздух', iconName: 'Wind', color: '#A3C1AD' },
  earth: { name: 'Земля', iconName: 'Mountain', color: '#81C784' },
  spirit: { name: 'Эфир / Дух', iconName: 'Sparkles', color: '#D4AF37' },
};

export interface TarotCard {
  id: number;
  numeral: string;
  name: string;
  arcana: ArcanaType;
  element: TarotElementType;
  astrologicalSign: string;
  keywords: string[];
  uprightGeneral: string;
  reversedGeneral: string;
  loveMeaning: string;
  careerMeaning: string;
  advice: string;
  symbolIcon: string;
  accentColor: string;
}

export interface DrawnCard {
  card: TarotCard;
  isReversed: boolean;
  isRevealed: boolean;
}

export interface SpreadPosition {
  index: number;
  title: string;
  description: string;
  dx: number;
  dy: number;
  rotation?: number; // radians
}

export interface TarotSpread {
  id: string;
  name: string;
  subtitle: string;
  description: string;
  category: string;
  iconName: string;
  themeColor: string;
  positions: SpreadPosition[];
}

export interface SavedReading {
  id: string;
  dateTime: string; // ISO string
  question: string;
  spreadId: string;
  spread: TarotSpread;
  drawnCards: {
    card: TarotCard;
    isReversed: boolean;
    isRevealed: boolean;
  }[];
  summaryText: string;
}
