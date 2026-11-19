<div align="center">

<img src="public/icons/logo.svg" alt="MysticOwl Logo" width="128" height="128" />

# 🦉 MysticOwl

**Интерактивный мистический оракул и PWA-приложение для раскладов Таро**

[![Live Demo](https://img.shields.io/badge/Live_Demo-GitHub_Pages-ffd700?style=for-the-badge&logo=github&logoColor=black)](https://leonid-perkin.github.io/MysticOwl-web/)
[![GitHub Actions CI/CD](https://img.shields.io/github/actions/workflow/status/Leonid-Perkin/MysticOwl-web/deploy_pages.yml?branch=main&style=for-the-badge&logo=githubactions&logoColor=white&label=Deploy)](https://github.com/Leonid-Perkin/MysticOwl-web/actions)
[![Security Audit](https://img.shields.io/badge/Security_Audit-0_Vulnerabilities-brightgreen?style=for-the-badge&logo=shield&logoColor=white)](https://github.com/Leonid-Perkin/MysticOwl-web)
[![Vitest](https://img.shields.io/badge/Tests-13%2F13_Passed-41b883?style=for-the-badge&logo=vitest&logoColor=white)](https://github.com/Leonid-Perkin/MysticOwl-web)

<br/>

[![React](https://img.shields.io/badge/React_18-20232A?style=flat-square&logo=react&logoColor=61DAFB)](https://react.dev/)
[![TypeScript](https://img.shields.io/badge/TypeScript_5-007ACC?style=flat-square&logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![Vite](https://img.shields.io/badge/Vite_6-646CFF?style=flat-square&logo=vite&logoColor=white)](https://vitejs.dev/)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS_3-38B2AC?style=flat-square&logo=tailwind-css&logoColor=white)](https://tailwindcss.com/)
[![PWA Ready](https://img.shields.io/badge/PWA-Ready-5A0FC8?style=flat-square&logo=pwa&logoColor=white)](https://web.dev/progressive-web-apps/)

<p align="center">
  <b><a href="https://leonid-perkin.github.io/MysticOwl-web/">🌐 Открыть приложение онлайн</a></b> •
  <a href="#-возможности">Возможности</a> •
  <a href="#-расклады-таро">Расклады</a> •
  <a href="#-безопасность-и-архитектура">Безопасность</a> •
  <a href="#-установка-и-запуск">Запуск</a>
</p>

---

</div>

## 🔮 О проекте

**MysticOwl** — это интерактивное веб-приложение нового поколения (PWA) для проведения аутентичных раскладов Таро, глубокого изучения символики Арканов и ведения личного журнала предсказаний.

Приложение полностью переписано на современный стек **React 18 + TypeScript + Vite** с поддержкой плавной 3D-анимации, адаптивности под любые экраны (от смартфонов до 4K-мониторов) и строгими стандартами безопасности **OWASP**.

---

## ✨ Возможности

- 🎴 **Интерактивный стол Таро с 3D-физикой**:
  - Реалистичная анимация тасования колоды с парящими картами.
  - Честный 3D-переворот карт по оси Y (`perspective` + `transform-style: preserve-3d`).
  - Отрисовка сакральной геометрии рубашки карт (золотая 8-конечная звезда) и полотна стола (орбиты и координатные лучи).
  - Поддержка **прямых и перевёрнутых карт** (визуальный разворот внутреннего медальона на 180° и отдельное теневое толкование).
  - Фильтры: выбор между полной колодой и режимом **«Только Старшие Арканы»**.
  - **Автоматический синтез расклада**: анализ баланса 5 стихий (Огонь, Вода, Воздух, Земля, Дух), доли Старших Арканов, теневых блоков и итогового совета.

- 📖 **Энциклопедия 32 Арканов**:
  - Полная база 22 Старших Арканов + ключевые Младшие Арканы всех мастей.
  - Мгновенный поиск по названию, римским цифрам и ключевым словам с кнопкой быстрой очистки.
  - Фильтрация по мастям: *Жезлы*, *Кубки*, *Мечи*, *Пентакли*.
  - Детальные модальные карточки: прямое значение, тень, астрологический знак, любовь, карьера и совет.

- 📜 **Журнал раскладов в LocalStorage**:
  - Надежное локальное сохранение сессий в браузере.
  - Интерактивный просмотр сохраненных карт с цветовой дифференциацией мастей.
  - Безопасное удаление с диалоговым окном подтверждения.

- 📱 **Превосходная адаптивность (Mobile-First & 2K/4K)**:
  - **На смартфонах**: двухрежимное разделение (`[ 🎴 Стол расклада ]` / `[ 📜 Толкование ]`) с центрированием карт и полным отсутствием наложений в 10-карточном «Кельтском Кресте».
  - **На десктопе**: панорамный режим Side-by-Side с гармоничным сакральным столом и боковым журналом.

- 🛡️ **PWA & Офлайн-режим**:
  - Поддержка установки на смартфон или ПК как нативного приложения.
  - Автономный Service Worker (`sw.js`) с кэшированием и механизмом обновления в один клик.

---

## 🎴 Расклады Таро

| Расклад | Карт | Назначение и суть позиций |
| :--- | :---: | :--- |
| **Карта Дня** | `1` | Быстрый утренний фокус, доминирующая энергия и главный совет суток. |
| **Нить Времени** | `3` | Универсальный хронологический анализ: **Прошлое (Истоки)** • **Настоящее (Суть)** • **Будущее (Перспектива)**. |
| **Зеркало Отношений** | `4` | Глубокий анализ союза: ваши чувства, мотивы партнёра, связующее звено и вектор развития пары. |
| **Перекрёсток Выбора** | `5` | Анализ дилеммы: точка выбора, развитие Пути А, развитие Пути Б, скрытый фактор и стратегия Таро. |
| **Кельтский Крест** | `10` | Легендарный классический расклад: ядро ситуации, преграда, венец мыслей, подсознание, прошлое, будущее, настрой, окружение, надежды/страхи и кульминационный итог. |

---

## 🛠️ Стек технологий

- **Фреймворк**: [React 18](https://react.dev/) + [TypeScript 5](https://www.typescriptlang.org/)
- **Сборщик**: [Vite 6](https://vitejs.dev/) (сверхбыстрый HMR и сборка за ~2 секунды)
- **Стилизация**: [Tailwind CSS 3](https://tailwindcss.com/) (кастомная тёмно-пурпурная палитра с золотыми акцентами)
- **Иконки**: [Lucide React](https://lucide.dev/) (оптимизированный бандл без лишних зависимостей)
- **Тестирование**: [Vitest](https://vitest.dev/) + [Happy DOM](https://github.com/capricorn86/happy-dom)
- **Эффекты**: [Canvas Confetti](https://www.npmjs.com/package/canvas-confetti)
- **PWA**: Service Worker Cache API + Manifest JSON

---

## 🛡️ Безопасность и архитектура

Приложение спроектировано в соответствии с лучшими практиками **OWASP Frontend Security**:

- 🔒 **Строгая Content Security Policy (CSP)**: запрет сторонних небезопасных скриптов, защита `object-src 'none'`, `base-uri 'self'`.
- 🧼 **XSS-иммунитет**: полное отсутствие `dangerouslySetInnerHTML`, `eval` и `innerHTML`. Безопасный рендеринг через виртуальное дерево React.
- 🛡️ **Защита LocalStorage от Prototype Pollution**: парсинг JSON с предикатом-ревайвером, блокирующим внедрение прототипных свойств (`__proto__`, `constructor`, `prototype`).
- 🛑 **Защита от отказа в обслуживании (Storage Quota Defense)**: лимит на 100 записей, авторотация при переполнении квоты браузера, валидация ID и санитизация строк (удаление ASCII-контрольных символов).
- 📦 **Безопасный Service Worker**: обработка исключительно `GET`-запросов с того же origin, предотвращение Cache Poisoning.
- 🧪 **Аудит зависимостей**: `npm audit` — **0 уязвимостей**.

---

## 📂 Структура проекта

```text
MysticOwl-web/
├── public/                 # Статические ресурсы PWA
│   ├── favicon.png         # Иконка сайта
│   ├── manifest.json       # Манифест PWA-приложения
│   ├── sw.js               # Service Worker для офлайн-режима
│   └── icons/              # Логотипы и маскируемые иконки (SVG, PNG)
├── src/
│   ├── components/         # Переиспользуемые UI-компоненты
│   │   ├── CardDetailsModal.tsx     # Модальное окно с описанием карты
│   │   ├── DynamicIcon.tsx          # Оптимизированный адаптер иконок
│   │   ├── Navbar.tsx               # Верхняя панель и диалог обновления PWA
│   │   ├── Navigation.tsx           # Десктопный рейл и мобильный BottomBar
│   │   ├── SacredTablePainter.tsx   # Векторное сакральное полотно стола
│   │   └── TarotCardWidget.tsx      # 3D-карта с анимацией переворота
│   ├── data/
│   │   └── tarotDeck.ts    # База Арканов, схемы раскладов и генератор синтеза
│   ├── screens/            # Основные экраны приложения
│   │   ├── SpreadsCatalogScreen.tsx # Каталог раскладов с баннером
│   │   ├── SpreadScreen.tsx         # Интерактивный стол для проведения расклада
│   │   ├── EncyclopediaScreen.tsx   # Справочник всех 32 Арканов
│   │   └── HistoryScreen.tsx        # Журнал сохранённых сессий с подтверждением
│   ├── services/
│   │   └── storageService.ts        # Защищённое хранилище LocalStorage
│   ├── tests/
│   │   └── tarot.test.ts   # Автоматические тесты (Vitest)
│   ├── types/
│   │   └── tarot.ts        # TypeScript-интерфейсы карт, позиций и раскладов
│   ├── App.tsx             # Корневой компонент и маршрутизация экранов
│   ├── index.css           # Tailwind-директивы и 3D-классы
│   └── main.tsx            # Точка входа React
├── .github/workflows/      # CI/CD автоматизация
│   └── deploy_pages.yml    # Автоматический деплой на GitHub Pages
├── index.html              # Базовый HTML с CSP и предзагрузкой шрифтов
├── package.json            # Зависимости и скрипты
├── tailwind.config.js      # Конфигурация темы Tailwind
├── tsconfig.json           # Конфигурация TypeScript
└── vite.config.ts          # Конфигурация Vite
```

---

## 🚀 Установка и запуск

### Требования
- **Node.js** версии 18+ (рекомендуется 20 или 22)
- **npm** версии 9+

### 1. Клонирование репозитория
```bash
git clone https://github.com/Leonid-Perkin/MysticOwl-web.git
cd MysticOwl-web
```

### 2. Установка зависимостей
```bash
npm install
```

### 3. Запуск в режиме разработки
```bash
npm run dev
```
Приложение откроется по адресу: **`http://localhost:3000`**

### 4. Запуск автоматических тестов
```bash
npm test
```

### 5. Сборка для продакшена
```bash
npm run build
```
Готовая статическая сборка будет скомпилирована в директорию `dist/`.

### 6. Локальный предпросмотр сборки
```bash
npm run preview
```

---

## 🌐 Деплой на GitHub Pages

Проект полностью настроен для автоматического деплоя при пуше в ветку `main`:
- Workflow `.github/workflows/deploy_pages.yml` собирает проект и разворачивает его в окружение `github-pages`.
- Автоматически генерируется `404.html` для поддержки прямой маршрутизации.
- Добавляется `.nojekyll` для корректной раздачи ассетов.

---

<div align="center">

Разработано с любовью к Таро и современному вебу ✨  
**© 2026 MysticOwl**

</div>
