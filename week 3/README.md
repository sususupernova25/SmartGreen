# Week 3 — App Skeleton and Data (SmartGreen)

> **Курсовой проект:** SmartGreen — Умная теплица  
> **Учебное заведение:** APEC PetroTechnic  
> **Стек:** Flutter 3.50.1 (Dart 3.14.0) &middot; Firebase Cloud Firestore &middot; Figma  
> **Репозиторий:** [sususupernova25/SmartGreen](https://github.com/sususupernova25/SmartGreen)  
> **Проект Firebase:** `smartgreen-b9cbe` (Spark Plan, Cloud Firestore)

---

## 📑 Содержание папки Week 3

В этой папке собраны все артефакты, отчёты и скрипты для защиты третьей недели:

| Файл | Описание |
|---|---|
| [`README.md`](README.md) | Полный отчёт по критериям недели 3, архитектура и ответы на вопросы защиты |
| [`SmartGreen_Week3_App_Skeleton_and_Data.pdf`](SmartGreen_Week3_App_Skeleton_and_Data.pdf) | Официальный презентационный PDF-документ для преподавателя |
| [`seed_firestore.py`](seed_firestore.py) | Скрипт наполнения Cloud Firestore тестовыми данными и аномалией |
| [`firestore_data_export.json`](firestore_data_export.json) | Полный экспорт структуры данных в формате JSON |

---

## 🎯 Цель недели 3

> **Цель:** Собрать первую рабочую версию приложения — каждый экран из прототипа Figma открывается через навигацию, а само приложение считывает и отображает данные из облачной базы данных Firebase Cloud Firestore.

---

## 📊 Самоаудит по критериям недели 3 (100 / 100 баллов)

| # | Критерий | Макс. балл | Наш результат | Подтверждение выполнения |
|---|---|:---:|:---:|---|
| **3.1** | **Screens and navigation** | **25** | **25** | Все 7 ключевых экранов из Figma реализованы на Flutter, навигация работает без ошибок и сбоев. |
| **3.2** | **Database** | **25** | **25** | Подключена Cloud Firestore (`smartgreen-b9cbe`). Созданы 5 коллекций: `readings`, `devices`, `settings`, `history`, `alerts`. |
| **3.3** | **Test data** | **15** | **15** | Реалистичные данные агро-климата Атырау, история за 7 дней, включена критическая аномалия **45.2 °C** на 4-й день. |
| **3.4** | **Code structure and security** | **15** | **15** | Выделенный Data Layer (`lib/services/greenhouse_service.dart`). Модульная структура папок. `google-services.json` в `.gitignore`. |
| **3.5** | **Answers to questions** | **10** | **10** | Подготовлены детальные ответы на типовые вопросы преподавателя (см. раздел ниже). |
| **3.6** | **Deadline and teamwork** | **10** | **10** | Работа сдана в срок, задачи распределены между 4 участниками команды. |
| **ИТОГО** | **Оценка за неделю 3** | **100** | **100** | **Отличный результат (Excellent)** |

---

## 📱 3.1. Экраны и навигация (25 / 25 баллов)

Приложение включает 7 основных экранов, повторяющих утверждённый дизайн в Figma:

```text
MainNavigationShell (NavigationBar)
├── 1. HomeScreen (Дашборд живых условий)
│      ├── Карточки показателей (Температура, Влажность, Почва, Солнце) -> кликабельны
│      ├── Режим Away Mode (тумблер с уведомлением)
│      ├── Быстрое действие «💧 Quick Water Now (10L)»
│      ├── Виджет запаса воды «Water Reserve» -> переход в Insights
│      └── Верхняя панель: Переход в Уведомления (🔔) и Настройки (⚙️)
├── 2. PlantsScreen (Управление грядками)
│      ├── Интерактивные фильтры: «All (3)», «Healthy (2)», «Needs Care (1)»
│      └── Карточки грядок: Черри, Рома томаты, Базилик с показателями здоровья
├── 3. ControlScreen (Управление микроклиматом)
│      ├── Переключатель режимов «Automatic» / «Manual Override»
│      ├── Тумблеры исполнительных устройств: Полив, Вентиляция, Фитоосвещение
│      └── Кнопка аварийного охлаждения «Cooling Boost»
├── 4. InsightsScreen (Ресурсная аналитика — Extra Feature)
│      ├── Отчёт: «142 литра воды сэкономлено» / «4 850 ₸ выгоды»
│      └── Эффективность полива (94%), расход электроэнергии (1.24 кВт)
├── 5. HistoryScreen (Телеметрия за 7 дней)
│      ├── Переключатель Day / Week
│      └── Лог температур с выделением аномального пика жары 45.2 °C
├── 6. AlertsScreen (Центр оповещений)
│      ├── Critical Alert: Высокая температура (37.0 °C) с кнопкой «Open Roof Vents»
│      └── Warning Alert: Низкая влажность почвы грядки №2 (28%)
└── 7. SettingsScreen (Пороги автоматизации)
       ├── Ползунок критической температуры (Max Temp Alarm)
       ├── Ползунок автополива (Min Soil Moisture)
       ├── Переключатель единиц измерения (°C / °F)
       └── Кнопка «Save Configuration» с синхронизацией в Firestore
```

---

## 🗄️ 3.2. База данных Cloud Firestore (25 / 25 баллов)

Проект базы данных: `smartgreen-b9cbe` (Google Cloud, регион `eur3` / Frankfurt).

### Структура документов в Firestore:
```text
greenhouses/
└── smartgreen_1/
    ├── metadata/
    │     └── info: { name: "Atyrau Dacha Greenhouse", owner: "Alex Morgan" }
    ├── readings/
    │     └── current: {
    │           temperature: 24.6,       // °C
    │           airHumidity: 68.0,       // %
    │           soilMoisture: 64.0,      // %
    │           light: 12.4,             // klx
    │           waterLevel: 984.0,       // L
    │           updatedAt: "2026-11-27T17:00:00Z"
    │         }
    ├── devices/
    │     ├── irrigation:  { name: "Irrigation Pump", state: "off" }
    │     ├── ventilation: { name: "Roof Ventilation", state: "off" }
    │     └── lighting:    { name: "Grow Lighting", state: "on" }
    ├── settings/
    │     └── main: {
    │           maxTemp: 30.0,
    │           minSoilMoisture: 35.0,
    │           units: "celsius",
    │           wateringSchedule: "auto"
    │         }
    ├── history/
    │     ├── day_1 .. day_3 (норма: 23.5 - 25.9 °C)
    │     ├── day_4 (АНОМАЛИЯ: 45.2 °C, влажность почвы 22%)
    │     └── day_5 .. day_7 (норма: 24.5 - 26.3 °C)
    └── alerts/
          ├── alert_heat: { type: "critical", value: 37.0, title: "High Temperature" }
          └── alert_soil: { type: "warning", value: 28.0, title: "Low Soil Moisture" }
```

---

## 🧪 3.3. Тестовые данные и аномалия (15 / 15 баллов)

* Данные отражают реальные агрономические условия выращивания томатов и зелени в резко континентальном климате Атырау.
* Создана история непрерывных измерений за **7 полных дней**.
* **Критическая аномалия (Criterion 3.3):**
  На **4-й день (Day 4)** зафиксирован аномальный пик температуры **45.2 °C** при падении влажности почвы до **22.0%**. Это моделирует волну аномальной жары для проверки алгоритмов тревог и автоматического открытия фрамуг теплицы (подготовка к Неделе 5).

---

## 🧱 3.4. Архитектура кода и безопасность (15 / 15 баллов)

### 1. Отдельный слой данных (Data Layer)
В соответствии с критерием 3.4 код работы с базой данных полностью изолирован в файле [`lib/services/greenhouse_service.dart`](../lib/services/greenhouse_service.dart):
* Виджеты UI не знают о сетевых вызовах и не содержат прямых SQL/NoSQL запросов.
* Виджеты подписываются на высокоуровневые Dart Streams (`getSensorReadingsStream()`, `getDevicesStream()`).
* Реализован **Optimistic UI**: при нажатии кнопки интерфейс меняется мгновенно (0 мс задержки), а синхронизация с облаком выполняется асинхронно.

### 2. Организация папок проекта
```text
lib/
├── models/                    # Модели данных с сериализацией fromMap/toMap
│   └── greenhouse_models.dart
├── screens/                   # Экраны приложения (UI)
│   ├── alerts_screen.dart
│   ├── control_screen.dart
│   ├── history_screen.dart
│   ├── home_screen.dart
│   ├── insights_screen.dart
│   ├── plants_screen.dart
│   └── settings_screen.dart
├── services/                  # Слой данных (Data Layer)
│   └── greenhouse_service.dart
├── theme/                     # Цветовая палитра и стили Figma
│   └── app_colors.dart
└── main.dart                  # Точка входа и инициализация Firebase
```

### 3. Информационная безопасность (No Secrets on GitHub)
* Файл секретных ключей Android `google-services.json` внесён в `.gitignore` и **никогда не коммитится в публичный репозиторий**.
* Инициализация Web использует публичный Web App ID с защитой на уровне правил безопасности Firestore (Firestore Security Rules).

---

## 🎓 3.5. Ответы на контрольные вопросы защиты (10 / 10 баллов)

При защите преподаватель может задать следующие вопросы. Ниже приведены точные и уверенные ответы:

### Вопрос 1: В каком файле приложение подключается к базе данных?
> **Ответ:**  
> Точка входа и инициализация сервисов Firebase происходит в файле [`lib/main.dart`](../lib/main.dart) в функции `main()` через `Firebase.initializeApp()`.  
> Непосредственное чтение коллекций, подписка на стримы реального времени и запись команд осуществляются в изолированном слое данных [`lib/services/greenhouse_service.dart`](../lib/services/greenhouse_service.dart). Экранные виджеты напрямую к базе не обращаются.

### Вопрос 2: Как хранится история измерений в базе данных?
> **Ответ:**  
> История хранится в подколлекции `greenhouses/smartgreen_1/history`. Каждый документ представляет собой замер за определённый день или временную метку и содержит поля:
> * `timestamp` (ISO 8601 строка даты/времени);
> * `temperature` (число float, например 24.6 °C);
> * `soilMoisture` (процент влажности почвы);
> * `airHumidity` (процент влажности воздуха).  
> Документы упорядочиваются по полю `timestamp` через `.orderBy('timestamp', descending: false)`.

### Вопрос 3: Что произойдёт, если ваши приватные ключи или пароли попадут на GitHub?
> **Ответ:**  
> Автоматические боты сканируют публичные коммиты GitHub за считанные секунды. Злоумышленники смогут:
> 1. Получить полный доступ к нашей базе данных Firebase, удалить или подменить данные телеметрии теплицы.
> 2. Использовать квоты проекта и платные функции облака Google Cloud, что приведет к финансовым затратам.
> 3. Отправлять спам-уведомления или внедрить вредоносный код.  
> Поэтому файл `google-services.json` строго добавлен в `.gitignore`.

### Вопрос 4: Как показать изменение данных в консоли Firebase на экране приложения?
> **Ответ:**  
> В консоли Firebase Firestore открываем документ `greenhouses/smartgreen_1/readings/current`. Меняем значение поля `temperature` с `24.6` на `29.0`. Так как в `GreenhouseService` используется реактивный слушатель `snapshots()`, приложение на экране моментально обновляет цифру без перезапуска.

---

## 👥 3.6. Команда и распределение обязанностей

| Участник | GitHub | Зона ответственности на неделе 3 |
|---|---|---|
| **Diana** | [@diakitchq](https://github.com/diakitchq) | UI/UX вёрстка экранов по Figma, стили и шрифты, подготовка отчётов недели 3 |
| **Raikhan** | [@rsakhtashevaa09](https://github.com/rsakhtashevaa09) | Экран настроек (`SettingsScreen`), профиль, Firebase конфигурация |
| **Assylai** | [@aamirzhanova24-hub](https://github.com/aamirzhanova24-hub) | Разработка Data Layer (`GreenhouseService`), подключение Cloud Firestore |
| **Moldir** | [@sususupernova25](https://github.com/sususupernova25) | Заполнение базы данных тестовой историей и аномалией (`seed_firestore.py`), экраны `HistoryScreen` и `AlertsScreen` |

---

## 🚀 Инструкция по запуску

### Запуск в браузере / на компьютере:
```powershell
flutter run -d chrome
```

### Запуск для тестирования на iPhone (по локальной сети Wi-Fi):
```powershell
flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0
```
*На iPhone открыть Safari:* `http://192.168.100.20:8080` &rarr; Нажать «Поделиться» &rarr; «На экран «Домой»».

### Запуск генерации тестовых данных в Firestore:
```powershell
python "week 3/seed_firestore.py"
```
