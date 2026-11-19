import React from 'react';

export const SacredTablePainter: React.FC = () => {
  return (
    <svg
      className="absolute inset-0 w-full h-full pointer-events-none select-none"
      xmlns="http://www.w3.org/2000/svg"
    >
      <defs>
        <radialGradient id="tableGlow" cx="50%" cy="50%" r="50%">
          <stop offset="0%" stopColor="#D4AF37" stopOpacity="0.06" />
          <stop offset="60%" stopColor="#2A174A" stopOpacity="0.03" />
          <stop offset="100%" stopColor="#120B21" stopOpacity="0" />
        </radialGradient>
      </defs>

      <rect width="100%" height="100%" fill="url(#tableGlow)" />

      {/* Center Sacred Orbits */}
      <svg x="50%" y="50%" overflow="visible">
        {/* Concentric rings */}
        <circle r="360" fill="none" stroke="#D4AF37" strokeWidth="1" opacity="0.04" strokeDasharray="4 8" />
        <circle r="260" fill="none" stroke="#D4AF37" strokeWidth="1" opacity="0.08" />
        <circle r="185" fill="none" stroke="#D4AF37" strokeWidth="1" opacity="0.07" strokeDasharray="3 6" />
        <circle r="105" fill="none" stroke="#D4AF37" strokeWidth="1.2" opacity="0.09" />
        <circle r="50" fill="none" stroke="#D4AF37" strokeWidth="0.8" opacity="0.08" />

        {/* Crosshair Cardinal Lines */}
        <line x1="-420" y1="0" x2="420" y2="0" stroke="#D4AF37" strokeWidth="1" opacity="0.08" />
        <line x1="0" y1="-320" x2="0" y2="320" stroke="#D4AF37" strokeWidth="1" opacity="0.08" />

        {/* Diagonal Rays */}
        <line x1="-200" y1="-200" x2="200" y2="200" stroke="#D4AF37" strokeWidth="0.8" opacity="0.04" />
        <line x1="-200" y1="200" x2="200" y2="-200" stroke="#D4AF37" strokeWidth="0.8" opacity="0.04" />

        {/* Subtle corner octagram points */}
        {[0, 45, 90, 135, 180, 225, 270, 315].map((deg) => (
          <circle
            key={deg}
            cx={260 * Math.cos((deg * Math.PI) / 180)}
            cy={260 * Math.sin((deg * Math.PI) / 180)}
            r="2.5"
            fill="#D4AF37"
            opacity="0.25"
          />
        ))}
      </svg>
    </svg>
  );
};
