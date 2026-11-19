/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        mystic: {
          darkest: '#0E0918',
          dark: '#140D24',
          surface: '#160F29',
          card: '#18102C',
          cardLight: '#21163A',
          overlay: '#2B194D',
          gold: '#D4AF37',
          goldLight: '#FFE082',
          goldDark: '#996515',
          violet: '#9575CD',
          violetDark: '#22163B',
          accent: '#BA68C8',
        },
      },
      fontFamily: {
        sans: ['Cinzel', 'Trajan Pro', 'Cinzel Decorative', 'system-ui', '-apple-system', 'sans-serif'],
      },
      animation: {
        'spin-slow': 'spin 20s linear infinite',
        'pulse-subtle': 'pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite',
      },
    },
  },
  plugins: [],
}
