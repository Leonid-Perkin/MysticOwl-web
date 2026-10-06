import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/tarot_card.dart';
import '../models/tarot_spread.dart';

class TarotRepository {
  static const List<TarotCard> allCards = [
    // ==================== СТАРШИЕ АРКАНЫ (0 - XXI) ====================
    TarotCard(
      id: 0,
      numeral: '0',
      name: 'Шут (Дурак)',
      arcana: ArcanaType.major,
      element: TarotElement.air,
      astrologicalSign: 'Уран',
      keywords: ['Новое начало', 'Спонтанность', 'Доверие', 'Свобода', 'Прыжок веры'],
      uprightGeneral:
          'Чистый лист и открытость миру. Карта предвещает новый этап, неожиданный шанс и смелое путешествие, где важно отпустить страх и довериться интуиции.',
      reversedGeneral:
          'Опрометчивость, наивность, страх сделать первый шаг или уход от ответственности. Возможен неоправданный риск без анализа последствий.',
      loveMeaning:
          'Лёгкость, флирт, спонтанное знакомство или обновление чувств без строгих обязательств.',
      careerMeaning:
          'Старт нового проекта, смена сферы деятельности, нестандартный творческий подход.',
      advice: 'Сделайте шаг в неизвестность с открытым сердцем, но не теряйте связь с реальностью.',
      symbolIcon: Icons.wb_sunny_outlined,
      accentColor: Color(0xFFFFD54F),
    ),
    TarotCard(
      id: 1,
      numeral: 'I',
      name: 'Маг',
      arcana: ArcanaType.major,
      element: TarotElement.air,
      astrologicalSign: 'Меркурий',
      keywords: ['Воля', 'Мастерство', 'Ресурсы', 'Инициатива', 'Фокус'],
      uprightGeneral:
          'В ваших руках уже есть все четыре стихии и необходимые инструменты для воплощения замысла. Время действовать решительно и брать инициативу на себя.',
      reversedGeneral:
          'Манипуляции, сомнения в своих силах, распыление энергии или использование талантов во вред.',
      loveMeaning:
          'Яркое притяжение, харизма, активные шаги со стороны партнёра или желание управлять отношениями.',
      careerMeaning:
          'Успешные переговоры, высокое мастерство, запуск собственного дела, лидерская позиция.',
      advice: 'Сфокусируйте волю на одной цели и переходите от планов к действиям.',
      symbolIcon: Icons.auto_fix_high,
      accentColor: Color(0xFFFFB74D),
    ),
    TarotCard(
      id: 2,
      numeral: 'II',
      name: 'Верховная Жрица',
      arcana: ArcanaType.major,
      element: TarotElement.water,
      astrologicalSign: 'Луна',
      keywords: ['Интуиция', 'Тайна', 'Подсознание', 'Мудрость', 'Тишина'],
      uprightGeneral:
          'Скрытые знания и глубокая внутренняя интуиция. Сейчас не время для активного натиска — наблюдайте, слушайте внутренний голос и читайте между строк.',
      reversedGeneral:
          'Игнорирование интуиции, поверхностность, раскрытие чужих секретов или самообман.',
      loveMeaning:
          'Тайная симпатия, платоническая или глубокая духовная связь, недосказанность между партнёрами.',
      careerMeaning:
          'Работа с конфиденциальной информацией, аналитика, обучение, необходимость скрывать свои планы.',
      advice: 'Доверьтесь снам и предчувствиям; истина откроется в тишине.',
      symbolIcon: Icons.nightlight_round,
      accentColor: Color(0xFF7986CB),
    ),
    TarotCard(
      id: 3,
      numeral: 'III',
      name: 'Императрица',
      arcana: ArcanaType.major,
      element: TarotElement.earth,
      astrologicalSign: 'Венера',
      keywords: ['Изобилие', 'Творчество', 'Красота', 'Забота', 'Плодородие'],
      uprightGeneral:
          'Расцвет, процветание и созидательная энергия. Ваши идеи и начинания дадут богатые плоды, если вложить в них любовь и терпеливую заботу.',
      reversedGeneral:
          'Творческий застой, гиперопека, расточительность или нехватка внутренней гармонии.',
      loveMeaning:
          'Гармоничный чувственный союз, тепло, забота, укрепление семьи или рождение нового этапа.',
      careerMeaning:
          'Финансовый рост, успех в творческих и созидательных проектах, комфортные условия труда.',
      advice: 'Окружите себя красотой, позвольте событиям созревать естественно.',
      symbolIcon: Icons.spa,
      accentColor: Color(0xFF81C784),
    ),
    TarotCard(
      id: 4,
      numeral: 'IV',
      name: 'Император',
      arcana: ArcanaType.major,
      element: TarotElement.fire,
      astrologicalSign: 'Овен',
      keywords: ['Власть', 'Структура', 'Стабильность', 'Авторитет', 'Защита'],
      uprightGeneral:
          'Порядок, дисциплина и твёрдый фундамент. Ситуация требует стратегического мышления, ответственности и чётких границ.',
      reversedGeneral:
          'Деспотизм, жёсткость, упрямство или, напротив, потеря контроля и слабость духа.',
      loveMeaning:
          'Надёжный, но требовательный партнёр; стремление к традиционным и стабильным отношениям.',
      careerMeaning:
          'Укрепление авторитета, руководящая должность, чёткий регламент и системный рост.',
      advice: 'Наведите порядок в делах и опирайтесь на логику и проверенные правила.',
      symbolIcon: Icons.shield,
      accentColor: Color(0xFFE57373),
    ),
    TarotCard(
      id: 5,
      numeral: 'V',
      name: 'Иерофант (Жрец)',
      arcana: ArcanaType.major,
      element: TarotElement.earth,
      astrologicalSign: 'Телец',
      keywords: ['Традиция', 'Наставник', 'Мораль', 'Обучение', 'Духовный закон'],
      uprightGeneral:
          'Опора на проверенные временем ценности, мудрый совет учителя или официальное закрепление союза и договорённостей.',
      reversedGeneral:
          'Догматизм, устаревшие правила, бунт против системы или слепое следование чужим советам.',
      loveMeaning:
          'Серьёзные намерения, брак, общие духовные ценности и взаимное уважение.',
      careerMeaning:
          'Повышение квалификации, менторство, работа в крупной традиционной структуре.',
      advice: 'Обратитесь к опыту наставника или действуйте строго по совести и правилам.',
      symbolIcon: Icons.account_balance,
      accentColor: Color(0xFFD4AF37),
    ),
    TarotCard(
      id: 6,
      numeral: 'VI',
      name: 'Влюблённые',
      arcana: ArcanaType.major,
      element: TarotElement.air,
      astrologicalSign: 'Близнецы',
      keywords: ['Выбор сердца', 'Союз', 'Гармония', 'Притяжение', 'Ценности'],
      uprightGeneral:
          'Глубокое единство противоположностей и важный выбор, который необходимо сделать не из расчёта, а по велению сердца.',
      reversedGeneral:
          'Сомнения, внутренний конфликт, неверность своему выбору или дисгармония в паре.',
      loveMeaning:
          'Взаимная любовь, сильное притяжение, судьбоносная встреча или переход на новый уровень доверия.',
      careerMeaning:
          'Успешное партнёрство, необходимость выбрать между двумя направлениями работы.',
      advice: 'Прислушайтесь к тому, что вы действительно любите, и сделайте честный выбор.',
      symbolIcon: Icons.favorite,
      accentColor: Color(0xFFF06292),
    ),
    TarotCard(
      id: 7,
      numeral: 'VII',
      name: 'Колесница',
      arcana: ArcanaType.major,
      element: TarotElement.water,
      astrologicalSign: 'Рак',
      keywords: ['Прорыв', 'Победа', 'Контроль', 'Движение', 'Целеустремлённость'],
      uprightGeneral:
          'Стремительное движение вперёд и триумф благодаря силе воли. Удерживайте поводья противоположных импульсов в своих руках.',
      reversedGeneral:
          'Потеря управления, спешка, агрессия или остановка на полпути из-за разброса целей.',
      loveMeaning:
          'Бурное развитие романа, совместная поездка или стремление завоевать сердце партнёра.',
      careerMeaning:
          'Быстрый карьерный рывок, командировки, победа над конкурентами, амбициозный проект.',
      advice: 'Не сбавляйте скорость — крепко держите курс на выбранную цель.',
      symbolIcon: Icons.rocket_launch,
      accentColor: Color(0xFF4FC3F7),
    ),
    TarotCard(
      id: 8,
      numeral: 'VIII',
      name: 'Сила',
      arcana: ArcanaType.major,
      element: TarotElement.fire,
      astrologicalSign: 'Лев',
      keywords: ['Мягкая мощь', 'Мужество', 'Терпение', 'Самообладание', 'Милосердие'],
      uprightGeneral:
          'Истинная сила кроется не в грубом принуждении, а в любви, спокойствии и умении укротить собственные страсти и страхи.',
      reversedGeneral:
          'Упадок сил, вспышка гнева, неуверенность в себе или подавление эмоций.',
      loveMeaning:
          'Глубокая страсть, согретая нежностью и принятием партнёра со всеми его особенностями.',
      careerMeaning:
          'Выносливость в сложной задаче, дипломатичное разрешение конфликта, высокий авторитет.',
      advice: 'Действуйте мягко, но настойчиво; побеждайте терпением и добротой.',
      symbolIcon: Icons.pets,
      accentColor: Color(0xFFFF8A65),
    ),
    TarotCard(
      id: 9,
      numeral: 'IX',
      name: 'Отшельник',
      arcana: ArcanaType.major,
      element: TarotElement.earth,
      astrologicalSign: 'Дева',
      keywords: ['Уединение', 'Поиск истины', 'Мудрость', 'Осознанность', 'Свет души'],
      uprightGeneral:
          'Время отстраниться от внешней суеты, чтобы услышать свой внутренний голос и обрести подлинную ясность.',
      reversedGeneral:
          'Чувство одиночества, изоляция, нежелание принимать помощь или уход от реальности.',
      loveMeaning:
          'Потребность в личном пространстве, переосмысление отношений или зрелая, спокойная привязанность.',
      careerMeaning:
          'Глубокая экспертная работа, исследования, фриланс или поиск своего истинного призвания.',
      advice: 'Возьмите паузу для размышлений — ответы уже внутри вас.',
      symbolIcon: Icons.lightbulb_outline,
      accentColor: Color(0xFF90A4AE),
    ),
    TarotCard(
      id: 10,
      numeral: 'X',
      name: 'Колесо Фортуны',
      arcana: ArcanaType.major,
      element: TarotElement.fire,
      astrologicalSign: 'Юпитер',
      keywords: ['Судьба', 'Перемены', 'Цикличность', 'Удача', 'Поворотный момент'],
      uprightGeneral:
          'Колесо судьбы приходит в движение, принося счастливый случай и неожиданные перемены к лучшему. Примите поток жизни.',
      reversedGeneral:
          'Временная полоса задержек, сопротивление неизбежным переменам или повторение старых уроков.',
      loveMeaning:
          'Судьбоносная встреча, неожиданный виток в отношениях, выход из застоя.',
      careerMeaning:
          'Удачное стечение обстоятельств, новые рыночные возможности, смена цикла в бизнесе.',
      advice: 'Будьте гибкими и ловите попутный ветер перемен.',
      symbolIcon: Icons.cyclone,
      accentColor: Color(0xFFBA68C8),
    ),
    TarotCard(
      id: 11,
      numeral: 'XI',
      name: 'Справедливость',
      arcana: ArcanaType.major,
      element: TarotElement.air,
      astrologicalSign: 'Весы',
      keywords: ['Равновесие', 'Закон кармы', 'Честность', 'Объективность', 'Решение'],
      uprightGeneral:
          'Вы пожинаете плоды прошлых поступков. Ситуация разрешится честно и беспристрастно, если вы сохраните объективность.',
      reversedGeneral:
          'Предвзятость, попытка уйти от ответственности, юридические проволочки или нарушение баланса.',
      loveMeaning:
          'Равноправное партнёрство, честный разговор, официальное оформление отношений.',
      careerMeaning:
          'Подписание договоров, аудит, справедливое вознаграждение за труд, правовые вопросы.',
      advice: 'Взвесьте все «за» и «против» без эмоций и поступите по совести.',
      symbolIcon: Icons.balance,
      accentColor: Color(0xFF64B5F6),
    ),
    TarotCard(
      id: 12,
      numeral: 'XII',
      name: 'Повешенный',
      arcana: ArcanaType.major,
      element: TarotElement.water,
      astrologicalSign: 'Нептун',
      keywords: ['Новый взгляд', 'Пауза', 'Жертва ради высшего', 'Переосмысление'],
      uprightGeneral:
          'Временная остановка нужна для того, чтобы увидеть ситуацию под совершенно иным углом. Откажитесь от шаблонных действий.',
      reversedGeneral:
          'Бессмысленная жертвенность, застревание в позиции жертвы, суета без результата.',
      loveMeaning:
          'Неопределённость, необходимость пойти на уступку или пересмотреть свои ожидания от партнёра.',
      careerMeaning:
          'Проект на паузе, нестандартное решение задачи, временный отказ от быстрой выгоды ради стратегии.',
      advice: 'Не форсируйте события — смените точку зрения, и тупик превратится в открытие.',
      symbolIcon: Icons.flip_camera_android,
      accentColor: Color(0xFF4DB6AC),
    ),
    TarotCard(
      id: 13,
      numeral: 'XIII',
      name: 'Смерть (Трансформация)',
      arcana: ArcanaType.major,
      element: TarotElement.water,
      astrologicalSign: 'Скорпион',
      keywords: ['Обновление', 'Завершение', 'Трансформация', 'Освобождение'],
      uprightGeneral:
          'Естественное завершение отжившего этапа, расчищающее место для новой жизни. Отпустите прошлое с благодарностью.',
      reversedGeneral:
          'Страх перемен, цепляние за то, что уже ушло, затянувшийся кризис из-за сопротивления обновлению.',
      loveMeaning:
          'Глубокая трансформация союза или окончание изживших себя отношений ради нового старта.',
      careerMeaning:
          'Закрытие старого направления, кардинальная смена профессии или бизнес-модели.',
      advice: 'Позвольте старому уйти — за закатом неизбежно следует рассвет.',
      symbolIcon: Icons.autorenew,
      accentColor: Color(0xFF9575CD),
    ),
    TarotCard(
      id: 14,
      numeral: 'XIV',
      name: 'Умеренность',
      arcana: ArcanaType.major,
      element: TarotElement.fire,
      astrologicalSign: 'Стрелец',
      keywords: ['Гармония', 'Золотая середина', 'Исцеление', 'Терпение', 'Алхимия'],
      uprightGeneral:
          'Спокойное течение энергии, примирение крайностей и постепенное исцеление. Всё придёт в нужное время без спешки.',
      reversedGeneral:
          'Крайности, нетерпеливость, внутренний раздрай или несогласованность действий.',
      loveMeaning:
          'Мир, душевный комфорт, взаимопонимание и бережное отношение друг к другу.',
      careerMeaning:
          'Слаженная командная работа, стабильный темп, успешный компромисс в переговорах.',
      advice: 'Соблюдайте меру во всём и соединяйте противоположные подходы в единое целое.',
      symbolIcon: Icons.water,
      accentColor: Color(0xFF4DD0E1),
    ),
    TarotCard(
      id: 15,
      numeral: 'XV',
      name: 'Дьявол',
      arcana: ArcanaType.major,
      element: TarotElement.earth,
      astrologicalSign: 'Козерог',
      keywords: ['Искушение', 'Зависимость', 'Страсть', 'Тень', 'Материальная привязка'],
      uprightGeneral:
          'Проверка на искушения, скрытые страхи или чрезмерную привязанность к желаниям. Осознайте свои «цепи» — и вы увидите, что можете их снять.',
      reversedGeneral:
          'Освобождение от зависимости, прозрение, преодоление манипуляций и возвращение контроля.',
      loveMeaning:
          'Роковая страсть, ревность, созависимость или сильное магнетическое притяжение.',
      careerMeaning:
          'Большие амбиции и деньги, но риск попасть в кабальные условия или пойти на сделку с совестью.',
      advice: 'Посмотрите в лицо своим теневым желаниям и не позволяйте им управлять вами.',
      symbolIcon: Icons.whatshot,
      accentColor: Color(0xFFEF5350),
    ),
    TarotCard(
      id: 16,
      numeral: 'XVI',
      name: 'Башня',
      arcana: ArcanaType.major,
      element: TarotElement.fire,
      astrologicalSign: 'Марс',
      keywords: ['Крах иллюзий', 'Внезапность', 'Инсайт', 'Очищение', 'Правда'],
      uprightGeneral:
          'Внезапное разрушение шатких конструкций и ложных иллюзий. Хотя перемены кажутся резкими, они освобождают вас для строительства на честном фундаменте.',
      reversedGeneral:
          'Попытка удержать рушащееся здание, отсрочка неизбежного кризиса или смягчённый удар.',
      loveMeaning:
          'Откровенный разговор, снятие масок, кризис, который либо очистит отношения, либо прекратит ложь.',
      careerMeaning:
          'Резкая реорганизация, внезапная смена планов, необходимость быстро адаптироваться.',
      advice: 'Не держитесь за иллюзии — пусть рухнет то, что давно потеряло прочность.',
      symbolIcon: Icons.flash_on,
      accentColor: Color(0xFFFF7043),
    ),
    TarotCard(
      id: 17,
      numeral: 'XVII',
      name: 'Звезда',
      arcana: ArcanaType.major,
      element: TarotElement.air,
      astrologicalSign: 'Водолей',
      keywords: ['Надежда', 'Вдохновение', 'Мечта', 'Чистота', 'Путеводный свет'],
      uprightGeneral:
          'Светлая полоса обновления, вдохновения и веры в будущее после бури. Вы находитесь под защитой высших сил и идёте верным путём.',
      reversedGeneral:
          'Разочарование, неверие в себя, оторванность мечты от реальных шагов.',
      loveMeaning:
          'Романтика, искренность, возвышенные чувства и духовная близость.',
      careerMeaning:
          'Творческий взлёт, работа над вдохновляющим долгосрочным проектом, признание таланта.',
      advice: 'Храните веру в свою путеводную звезду и делитесь светом с миром.',
      symbolIcon: Icons.star_outline,
      accentColor: Color(0xFF80DEEA),
    ),
    TarotCard(
      id: 18,
      numeral: 'XVIII',
      name: 'Луна',
      arcana: ArcanaType.major,
      element: TarotElement.water,
      astrologicalSign: 'Рыбы',
      keywords: ['Сумерки', 'Иллюзии', 'Глубины подсознания', 'Сны', 'Тайные страхи'],
      uprightGeneral:
          'Путь в сумерках, где не всё является тем, чем кажется. Возможны сомнения и скрытые факторы — полагайтесь на чуткость, но проверяйте факты.',
      reversedGeneral:
          'Рассеивание тумана, разоблачение обмана, выход из состояния тревоги к ясности.',
      loveMeaning:
          'Неясность намерений, ревность, тайны или глубокое эмоциональное погружение.',
      careerMeaning:
          'Скрытые интриги, неполная информация в сделках, но богатая почва для психологии и искусства.',
      advice: 'Идите вперёд осторожно, шаг за шагом, не поддаваясь теням собственного воображения.',
      symbolIcon: Icons.bedtime,
      accentColor: Color(0xFF9FA8DA),
    ),
    TarotCard(
      id: 19,
      numeral: 'XIX',
      name: 'Солнце',
      arcana: ArcanaType.major,
      element: TarotElement.fire,
      astrologicalSign: 'Солнце',
      keywords: ['Радость', 'Успех', 'Ясность', 'Тепло', 'Триумф'],
      uprightGeneral:
          'Абсолютная ясность, жизнелюбие, успех и благополучие. Все сомнения уходят, уступая место радости и заслуженному признанию.',
      reversedGeneral:
          'Эгоцентризм, преувеличение своих возможностей или небольшая задержка на пути к успеху.',
      loveMeaning:
          'Счастливый, тёплый и открытый союз, совместный праздник, дети и радость бытия.',
      careerMeaning:
          'Блестящий результат, публичный успех, премия, реализация амбициозного замысла.',
      advice: 'Сияйте открыто, радуйтесь жизни и делитесь своей солнечной энергией.',
      symbolIcon: Icons.wb_sunny,
      accentColor: Color(0xFFFFCA28),
    ),
    TarotCard(
      id: 20,
      numeral: 'XX',
      name: 'Страшный Суд',
      arcana: ArcanaType.major,
      element: TarotElement.fire,
      astrologicalSign: 'Плутон',
      keywords: ['Пробуждение', 'Призвание', 'Возрождение', 'Прощение', 'Итог'],
      uprightGeneral:
          'Момент духовного пробуждения и важного жизненного рубежа. Прошлый опыт складывается в единую картину, открывая ваше истинное призвание.',
      reversedGeneral:
          'Самоосуждение, страх перемен, игнорирование зова души или откладывание важного решения.',
      loveMeaning:
          'Возрождение чувств, прощение старых обид или переход союза на качественно новый уровень.',
      careerMeaning:
          'Обретение истинного призвания, подведение итогов большого этапа, заслуженное повышение.',
      advice: 'Откликнитесь на внутренний зов и освободитесь от груза прошлых сожалений.',
      symbolIcon: Icons.campaign,
      accentColor: Color(0xFFFFAB91),
    ),
    TarotCard(
      id: 21,
      numeral: 'XXI',
      name: 'Мир',
      arcana: ArcanaType.major,
      element: TarotElement.earth,
      astrologicalSign: 'Сатурн',
      keywords: ['Целостность', 'Завершение цикла', 'Гармония', 'Триумф', 'Безграничность'],
      uprightGeneral:
          'Блестящее завершение большого жизненного цикла, обретение целостности и гармонии с миром. Перед вами открыты любые горизонты.',
      reversedGeneral:
          'Незавершённость дела, страх поставить финальную точку или нехватка последнего шага до цели.',
      loveMeaning:
          'Полная гармония в паре, зрелая любовь, совместные путешествия и общность взглядов.',
      careerMeaning:
          'Международные проекты, успешное окончание крупного дела, признание и свобода выбора.',
      advice: 'Отпразднуйте свою победу, завершите начатое и смело открывайте новую главу.',
      symbolIcon: Icons.public,
      accentColor: Color(0xFFA5D6A7),
    ),

    // ==================== МЛАДШИЕ АРКАНЫ (КЛЮЧЕВЫЕ КАРТЫ СТИХИЙ) ====================
    TarotCard(
      id: 22,
      numeral: 'Туз',
      name: 'Туз Жезлов',
      arcana: ArcanaType.wands,
      element: TarotElement.fire,
      astrologicalSign: 'Стихия Огня',
      keywords: ['Искра', 'Энтузиазм', 'Творческий импульс', 'Смелый старт'],
      uprightGeneral:
          'Мощный выброс энергии, вдохновения и страсти к новому делу. Идеальный момент, чтобы зажечь свою идею.',
      reversedGeneral:
          'Угасший запал, фальстарт или отсутствие чёткого направления для энергии.',
      loveMeaning: 'Вспышка страсти, яркое начало романа, обновление темперамента в паре.',
      careerMeaning: 'Запуск перспективного стартапа, вдохновляющая идея, карьерный импульс.',
      advice: 'Куйте железо, пока горячо — действуйте на волне вдохновения.',
      symbolIcon: Icons.local_fire_department,
      accentColor: Color(0xFFFF7043),
    ),
    TarotCard(
      id: 23,
      numeral: 'VI',
      name: 'Шестёрка Жезлов',
      arcana: ArcanaType.wands,
      element: TarotElement.fire,
      astrologicalSign: 'Юпитер во Льве',
      keywords: ['Признание', 'Победа', 'Лидерство', 'Успех', 'Почёт'],
      uprightGeneral:
          'Триумфальное достижение цели и заслуженное признание окружающих. Ваши усилия увенчаются победой.',
      reversedGeneral:
          'Гордыня, зависимость от чужой похвалы или задержка с получением награды.',
      loveMeaning: 'Гордость за партнёра, взаимное восхищение, преодоление трудностей.',
      careerMeaning: 'Повышение, публичный успех, победа в конкурсе или тендере.',
      advice: 'Примите свой успех с достоинством и вдохновляйте тех, кто идёт рядом.',
      symbolIcon: Icons.emoji_events,
      accentColor: Color(0xFFFFB74D),
    ),
    TarotCard(
      id: 24,
      numeral: 'Туз',
      name: 'Туз Кубков',
      arcana: ArcanaType.cups,
      element: TarotElement.water,
      astrologicalSign: 'Стихия Воды',
      keywords: ['Любовь', 'Полнота чувств', 'Благодать', 'Эмпатия', 'Вдохновение'],
      uprightGeneral:
          'Переполняющая чаша искренних чувств, радости и душевного исцеления. Открытие сердца для любви и творчества.',
      reversedGeneral:
          'Эмоциональная закрытость, сдерживание чувств или пустые переживания.',
      loveMeaning: 'Зарождение большой любви, нежность, глубокое эмоциональное слияние.',
      careerMeaning: 'Творческое вдохновение, работа по душе, тёплая атмосфера в коллективе.',
      advice: 'Откройте сердце и позвольте чувствам течь свободно.',
      symbolIcon: Icons.wine_bar,
      accentColor: Color(0xFF4FC3F7),
    ),
    TarotCard(
      id: 25,
      numeral: 'II',
      name: 'Двойка Кубков',
      arcana: ArcanaType.cups,
      element: TarotElement.water,
      astrologicalSign: 'Венера в Раке',
      keywords: ['Взаимность', 'Союз душ', 'Партнёрство', 'Доверие', 'Примирение'],
      uprightGeneral:
          'Гармоничная встреча двух сердец, основанная на симпатии, равенстве и глубоком взаимопонимании.',
      reversedGeneral:
          'Недопонимание, временная размолвка или дисбаланс в отдаче и принятии чувств.',
      loveMeaning: 'Искренняя взаимная любовь, свидание, помолвка или примирение после ссоры.',
      careerMeaning: 'Удачный деловой альянс, подписание взаимовыгодного соглашения.',
      advice: 'Ищите точки соприкосновения и стройте диалог на доверии.',
      symbolIcon: Icons.volunteer_activism,
      accentColor: Color(0xFFF48FB1),
    ),
    TarotCard(
      id: 26,
      numeral: 'X',
      name: 'Десятка Кубков',
      arcana: ArcanaType.cups,
      element: TarotElement.water,
      astrologicalSign: 'Марс в Рыбах',
      keywords: ['Счастье', 'Семья', 'Уют', 'Полнота жизни', 'Радуга'],
      uprightGeneral:
          'Эмоциональная вершина счастья, домашнего тепла, мира и согласия с близкими людьми.',
      reversedGeneral:
          'Мелкие семейные разногласия или ощущение, что внешняя картинка важнее внутренней близости.',
      loveMeaning: 'Крепкий семейный очаг, безоблачное счастье, поддержка рода.',
      careerMeaning: 'Гармоничный коллектив, удовлетворение результатами своего труда.',
      advice: 'Цените близких и разделите свою радость с теми, кто вам дорог.',
      symbolIcon: Icons.home_filled,
      accentColor: Color(0xFF81D4FA),
    ),
    TarotCard(
      id: 27,
      numeral: 'Туз',
      name: 'Туз Мечей',
      arcana: ArcanaType.swords,
      element: TarotElement.air,
      astrologicalSign: 'Стихия Воздуха',
      keywords: ['Ясность ума', 'Истина', 'Решительность', 'Инсайт', 'Отсечение лишнего'],
      uprightGeneral:
          'Острый луч разума, рассекающий сомнения и туман. Время принять чёткое, бескомпромиссное решение и назвать вещи своими именами.',
      reversedGeneral:
          'Путаница в мыслях, резкие слова сгоряча или отсутствие чёткого плана.',
      loveMeaning: 'Откровенный разговор, прояснение отношений, честность без иллюзий.',
      careerMeaning: 'Блестящая аналитическая идея, победа в споре, чёткая стратегия.',
      advice: 'Опирайтесь на факты и холодную логику; отсеките всё лишнее.',
      symbolIcon: Icons.content_cut,
      accentColor: Color(0xFFB0BEC5),
    ),
    TarotCard(
      id: 28,
      numeral: 'III',
      name: 'Тройка Мечей',
      arcana: ArcanaType.swords,
      element: TarotElement.air,
      astrologicalSign: 'Сатурн в Весах',
      keywords: ['Горькая правда', 'Катарсис', 'Освобождение через боль', 'Урок сердца'],
      uprightGeneral:
          'Болезненное, но необходимое осознание правды. Принятие реальности освобождает сердце для будущего исцеления.',
      reversedGeneral:
          'Постепенное заживление ран, прощение и отпускание прошлой обиды.',
      loveMeaning: 'Обида, разочарование или честное признание, которое требует мужества.',
      careerMeaning: 'Критика, срыв договорённости, необходимость трезво оценить потери.',
      advice: 'Позвольте себе прожить эмоции, чтобы очистить сердце и идти дальше.',
      symbolIcon: Icons.heart_broken,
      accentColor: Color(0xFF78909C),
    ),
    TarotCard(
      id: 29,
      numeral: 'Туз',
      name: 'Туз Пентаклей',
      arcana: ArcanaType.pentacles,
      element: TarotElement.earth,
      astrologicalSign: 'Стихия Земли',
      keywords: ['Дар судьбы', 'Процветание', 'Фундамент', 'Материальный шанс'],
      uprightGeneral:
          'Золотой шанс для финансового благополучия, здоровья и создания прочной материальной базы.',
      reversedGeneral:
          'Упущенная выгода, неразумные траты или задержка прибыли.',
      loveMeaning: 'Стабильные, надёжные отношения, подкреплённые реальными поступками.',
      careerMeaning: 'Выгодное предложение, премия, инвестиция, начало прибыльного дела.',
      advice: 'Не упустите практическую возможность — вложите силы в долгосрочный результат.',
      symbolIcon: Icons.monetization_on,
      accentColor: Color(0xFFFFD54F),
    ),
    TarotCard(
      id: 30,
      numeral: 'IX',
      name: 'Девятка Пентаклей',
      arcana: ArcanaType.pentacles,
      element: TarotElement.earth,
      astrologicalSign: 'Венера в Деве',
      keywords: ['Самодостаточность', 'Комфорт', 'Достаток', 'Плоды труда', 'Эстетика'],
      uprightGeneral:
          'Заслуженный материальный комфорт, независимость и умение наслаждаться результатами собственного мастерства.',
      reversedGeneral:
          'Финансовая неосторожность или чувство одиночества в золотой клетке.',
      loveMeaning: 'Гармония зрелых личностей, где каждый ценит свободу и достоинство другого.',
      careerMeaning: 'Финансовая независимость, высокий статус эксперта, стабильный доход.',
      advice: 'Поблагодарите себя за пройденный путь и позвольте себе заслуженный комфорт.',
      symbolIcon: Icons.diamond,
      accentColor: Color(0xFFAED581),
    ),
    TarotCard(
      id: 31,
      numeral: 'X',
      name: 'Десятка Пентаклей',
      arcana: ArcanaType.pentacles,
      element: TarotElement.earth,
      astrologicalSign: 'Меркурий в Деве',
      keywords: ['Наследие', 'Богатство', 'Род', 'Незыблемость', 'Традиция'],
      uprightGeneral:
          'Прочное благосостояние, семейные традиции и уверенность в завтрашнем дне. Успех, рассчитанный на годы вперёд.',
      reversedGeneral:
          'Споры вокруг имущества или консервативность, мешающая развитию.',
      loveMeaning: 'Крепкий брак, благословение семьи, общий дом и долгосрочный союз.',
      careerMeaning: 'Крупный семейный или корпоративный капитал, надёжные активы, недвижимость.',
      advice: 'Стройте на века и опирайтесь на поддержку своей семьи и традиций.',
      symbolIcon: Icons.castle,
      accentColor: Color(0xFFFFCA28),
    ),
  ];

  static const List<TarotSpread> spreads = [
    // 1. Карта дня
    TarotSpread(
      id: 'card_of_day',
      name: 'Карта Дня',
      subtitle: '1 карта • Энергия и совет сегодняшнего дня',
      description:
          'Быстрый и точный настрой на день. Показывает главную тему суток, скрытую возможность и мудрый фокус внимания.',
      category: 'На каждый день',
      icon: Icons.wb_twilight,
      themeColor: Color(0xFFD4AF37),
      positions: [
        SpreadPosition(
          index: 1,
          title: 'Энергия и послание дня',
          description: 'Ключевой урок, атмосфера и главный совет на сегодня.',
          dx: 0.50,
          dy: 0.50,
        ),
      ],
    ),

    // 2. Три карты: Прошлое - Настоящее - Будущее
    TarotSpread(
      id: 'three_cards',
      name: 'Нить Времени (3 карты)',
      subtitle: '3 карты • Прошлое • Настоящее • Будущее',
      description:
          'Классический универсальный расклад для анализа любой ситуации в динамике: от истоков к вероятному итогу.',
      category: 'Универсальный',
      icon: Icons.timeline,
      themeColor: Color(0xFF9575CD),
      positions: [
        SpreadPosition(
          index: 1,
          title: 'Прошлое (Истоки)',
          description: 'Причины и предшествующие события, сформировавшие ситуацию.',
          dx: 0.20,
          dy: 0.50,
        ),
        SpreadPosition(
          index: 2,
          title: 'Настоящее (Суть)',
          description: 'Текущее положение дел и ключевая энергия момента.',
          dx: 0.50,
          dy: 0.50,
        ),
        SpreadPosition(
          index: 3,
          title: 'Будущее (Перспектива)',
          description: 'Естественное развитие событий при сохранении текущего курса.',
          dx: 0.80,
          dy: 0.50,
        ),
      ],
    ),

    // 3. Любовь и Отношения (4 карты)
    TarotSpread(
      id: 'love_mirror',
      name: 'Зеркало Отношений',
      subtitle: '4 карты • Чувства, связь и перспектива союза',
      description:
          'Глубокий взгляд на динамику в паре: истинные чувства обоих партнёров, точка соприкосновения и вектор развития.',
      category: 'Любовь и союзы',
      icon: Icons.favorite_border,
      themeColor: Color(0xFFF06292),
      positions: [
        SpreadPosition(
          index: 1,
          title: 'Ваша позиция и чувства',
          description: 'Как вы проявляете себя в союзе и чего ждёте от партнёра.',
          dx: 0.22,
          dy: 0.45,
        ),
        SpreadPosition(
          index: 2,
          title: 'Позиция и чувства партнёра',
          description: 'Истинное отношение, мысли и мотивы другого человека.',
          dx: 0.78,
          dy: 0.45,
        ),
        SpreadPosition(
          index: 3,
          title: 'Связующее звено',
          description: 'Что объединяет вас сейчас или какой урок вы проходите вместе.',
          dx: 0.50,
          dy: 0.25,
        ),
        SpreadPosition(
          index: 4,
          title: 'Будущее союза и совет',
          description: 'Перспектива развития отношений и рекомендация Арканов.',
          dx: 0.50,
          dy: 0.75,
        ),
      ],
    ),

    // 4. Перекрёсток Выбора (5 карт)
    TarotSpread(
      id: 'crossroads_choice',
      name: 'Перекрёсток Выбора',
      subtitle: '5 карт • Сравнение двух путей и совет',
      description:
          'Помогает принять взвешенное решение, когда вы стоите перед дилеммой или выбираете между двумя направлениями.',
      category: 'Карьера и решения',
      icon: Icons.alt_route,
      themeColor: Color(0xFF4FC3F7),
      positions: [
        SpreadPosition(
          index: 1,
          title: 'Точка выбора',
          description: 'Ваше состояние и суть дилеммы прямо сейчас.',
          dx: 0.50,
          dy: 0.80,
        ),
        SpreadPosition(
          index: 2,
          title: 'Путь А (Первый вариант)',
          description: 'К чему приведёт выбор первого направления.',
          dx: 0.24,
          dy: 0.48,
        ),
        SpreadPosition(
          index: 3,
          title: 'Путь Б (Второй вариант)',
          description: 'К чему приведёт выбор второго направления.',
          dx: 0.76,
          dy: 0.48,
        ),
        SpreadPosition(
          index: 4,
          title: 'Скрытый фактор',
          description: 'Обстоятельство, которое важно учесть перед решением.',
          dx: 0.24,
          dy: 0.18,
        ),
        SpreadPosition(
          index: 5,
          title: 'Мудрый совет Таро',
          description: 'Оптимальная стратегия для достижения успеха.',
          dx: 0.76,
          dy: 0.18,
        ),
      ],
    ),

    // 5. Кельтский Крест (10 карт)
    TarotSpread(
      id: 'celtic_cross',
      name: 'Кельтский Крест',
      subtitle: '10 карт • Полный классический анализ судьбы',
      description:
          'Легендарный расклад Таро, охватывающий внутренние мотивы, внешние влияния, страхи, прошлое, будущее и финальный итог.',
      category: 'Глубокий анализ',
      icon: Icons.auto_awesome,
      themeColor: Color(0xFFFFB74D),
      positions: [
        SpreadPosition(
          index: 1,
          title: '1. Суть ситуации',
          description: 'Центральное ядро вопроса и ваше положение сейчас.',
          dx: 0.34,
          dy: 0.48,
        ),
        SpreadPosition(
          index: 2,
          title: '2. Пересечение (Импульс / Преграда)',
          description: 'То, что способствует или бросает вызов в данной ситуации.',
          dx: 0.34,
          dy: 0.48,
          rotation: math.pi / 12,
        ),
        SpreadPosition(
          index: 3,
          title: '3. Сознательная цель (Венец)',
          description: 'Ваши осознанные мысли, идеалы и то, к чему вы стремитесь.',
          dx: 0.34,
          dy: 0.16,
        ),
        SpreadPosition(
          index: 4,
          title: '4. Корни и подсознание',
          description: 'Глубинный фундамент ситуации и скрытые чувства.',
          dx: 0.34,
          dy: 0.80,
        ),
        SpreadPosition(
          index: 5,
          title: '5. Уходящее прошлое',
          description: 'Недавние события, которые уже теряют свою силу.',
          dx: 0.13,
          dy: 0.48,
        ),
        SpreadPosition(
          index: 6,
          title: '6. Ближайшее будущее',
          description: 'События и энергии, которые вот-вот войдут в вашу жизнь.',
          dx: 0.55,
          dy: 0.48,
        ),
        SpreadPosition(
          index: 7,
          title: '7. Ваша роль и настрой',
          description: 'Как вы сами воспринимаете ситуацию и воздействуете на неё.',
          dx: 0.83,
          dy: 0.84,
        ),
        SpreadPosition(
          index: 8,
          title: '8. Внешняя среда и люди',
          description: 'Влияние окружающих людей и обстоятельств извне.',
          dx: 0.83,
          dy: 0.62,
        ),
        SpreadPosition(
          index: 9,
          title: '9. Надежды и опасения',
          description: 'Ваши сокровенные ожидания или тайные тревоги.',
          dx: 0.83,
          dy: 0.40,
        ),
        SpreadPosition(
          index: 10,
          title: '10. Итог и кульминация',
          description: 'Финальный результат, к которому ведут все нити расклада.',
          dx: 0.83,
          dy: 0.16,
        ),
      ],
    ),
  ];

  static String generateSpreadSynthesis(
    TarotSpread spread,
    List<DrawnCard> drawnCards,
    String question,
  ) {
    if (drawnCards.isEmpty) return '';

    final majorCount =
        drawnCards.where((d) => d.card.arcana == ArcanaType.major).length;
    final reversedCount = drawnCards.where((d) => d.isReversed).length;

    final Map<TarotElement, int> elementCounts = {};
    for (final d in drawnCards) {
      elementCounts[d.card.element] = (elementCounts[d.card.element] ?? 0) + 1;
    }

    TarotElement dominantElement = drawnCards.first.card.element;
    int maxCount = 0;
    elementCounts.forEach((el, count) {
      if (count > maxCount) {
        maxCount = count;
        dominantElement = el;
      }
    });

    final buffer = StringBuffer();
    if (question.trim().isNotEmpty) {
      buffer.writeln('Вопрос: «${question.trim()}»\n');
    }

    if (majorCount == drawnCards.length) {
      buffer.writeln(
          '• Судьбоносный акцент: В раскладе выпали исключительно Старшие Арканы. Это указывает на высокую значимость ситуации и влияние глубинных жизненных законов.');
    } else if (majorCount >= (drawnCards.length / 2).ceil()) {
      buffer.writeln(
          '• Преобладание Старших Арканов ($majorCount из ${drawnCards.length}): Ситуация несёт важный кармический или личностный урок, выходящий за рамки бытовой суеты.');
    } else {
      buffer.writeln(
          '• Практический вектор: Многое зависит от ваших ежедневных решений и конкретных шагов.');
    }

    switch (dominantElement) {
      case TarotElement.fire:
        buffer.writeln(
            '• Доминирующая стихия — Огонь: Главная движущая сила сейчас — воля, инициатива, творческий напор и смелость.');
        break;
      case TarotElement.water:
        buffer.writeln(
            '• Доминирующая стихия — Вода: Ключ к ситуации лежит в сфере чувств, эмпатии, интуиции и доверия внутреннему потоку.');
        break;
      case TarotElement.air:
        buffer.writeln(
            '• Доминирующая стихия — Воздух: На первый план выходят ясность мысли, честный диалог, анализ и свобода выбора.');
        break;
      case TarotElement.earth:
        buffer.writeln(
            '• Доминирующая стихия — Земля: Важны терпение, практичность, последовательность и опора на реальные факты и ресурсы.');
        break;
      case TarotElement.spirit:
        buffer.writeln(
            '• Доминирующая стихия — Дух: Высший синтез и гармония всех сфер жизни.');
        break;
    }

    if (reversedCount > drawnCards.length / 2) {
      buffer.writeln(
          '• Обратите внимание: Несколько перевёрнутых карт ($reversedCount) говорят о том, что энергия ситуации пока направлена внутрь или требует устранения внутренних блоков перед активным рывком.');
    }

    final lastCard = drawnCards.last;
    buffer.write(
        '• Ключевой совет финальной позиции («${lastCard.card.name}»): ${lastCard.card.advice}');

    return buffer.toString();
  }
}
