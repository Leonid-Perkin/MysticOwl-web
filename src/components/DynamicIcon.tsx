import React from 'react';
import {
  Sun,
  Wand2,
  Moon,
  Flower2,
  Shield,
  Landmark,
  Heart,
  Rocket,
  Cat,
  Lightbulb,
  RotateCw,
  Scale,
  RefreshCcw,
  Infinity as InfinityIcon,
  Hourglass,
  Flame,
  Zap,
  Star,
  MoonStar,
  SunMedium,
  Megaphone,
  Globe,
  Trophy,
  Wine,
  HeartHandshake,
  Home,
  Sword,
  HeartCrack,
  Coins,
  Gem,
  Castle,
  Droplets,
  Wind,
  Mountain,
  Sparkles,
  Compass,
  GitCommit,
  LucideIcon,
} from 'lucide-react';

interface DynamicIconProps {
  name: string;
  className?: string;
  size?: number | string;
  color?: string;
}

const ICON_MAP: Record<string, LucideIcon> = {
  Sun,
  Wand2,
  Moon,
  Flower2,
  Shield,
  Landmark,
  Heart,
  Rocket,
  Cat,
  Lightbulb,
  RotateCw,
  Scale,
  RefreshCcw,
  Infinity: InfinityIcon,
  Hourglass,
  Flame,
  Zap,
  Star,
  MoonStar,
  SunMedium,
  Megaphone,
  Globe,
  Trophy,
  Wine,
  HeartHandshake,
  Home,
  Sword,
  HeartCrack,
  Coins,
  Gem,
  Castle,
  Droplets,
  Wind,
  Mountain,
  Sparkles,
  Compass,
  GitCommit,
};

export const DynamicIcon: React.FC<DynamicIconProps> = ({
  name,
  className = '',
  size = 20,
  color,
}) => {
  const Component = ICON_MAP[name] || Sparkles;
  return <Component className={className} size={size} color={color} />;
};
