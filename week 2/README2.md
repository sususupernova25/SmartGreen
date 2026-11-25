# Week 2 — Design, Prototype & Data Architecture

**SmartGreen** helps greenhouse owners to monitor their plants and control the greenhouse from a phone, so the plants stay healthy even when the owner is away.

This page is the Week 2 deliverable: the visual identity, the clickable prototype, the app diagram, the data structure and the technology stack. No code yet.

---

## 1. Links

| What | Link |
|---|---|
| 🎨 Clickable prototype (Figma) | [SmartGreen Figma Prototype](https://www.figma.com/design/cvlv7QEPyrq8k96gOdL6Df/SmartGreen-House-DRAM?node-id=0-1&t=jOlUz4dlhIxxs6nY-1) |
| 🎨 Style Guide | [SmartGreen Style Guide](https://www.figma.com/design/cvlv7QEPyrq8k96gOdL6Df/SmartGreen-House-DRAM?node-id=3-6093&t=IPj4AVZUxytpV34P-4) |
| 🎨 Logo | [SmartGreen Logo](https://www.figma.com/design/cvlv7QEPyrq8k96gOdL6Df/SmartGreen-House-DRAM?node-id=3-6235&t=IPj4AVZUxytpV34P-4) |
| 📐 App diagram, data structure, stack | [SmartGreen_Diagram_Data_Stack.pdf](SmartGreen_Diagram_Data_Stack.pdf) |

---

## 2. Our user

**Alex Morgan, 42, Atyrau.** Owns a small tomato and basil greenhouse at the family dacha, works full time in the city and visits only in the evenings and on weekends. Summers are hot and dry, water is expensive, and plants have already been lost after a weekend trip.

Alex needs to: (1) see in 5 seconds whether everything is fine, (2) get a warning in time, (3) let the greenhouse take care of itself.

The design is made for exactly this person: one calm status message on Home, clear warning levels, big readable numbers, and automation that works while Alex is away.

---

## 3. Visual identity (logo, colors, fonts)

**Logo.** A white leaf inside a rounded green square, next to the wordmark "SmartGreen". The leaf stands for plants, the rounded square for a friendly mobile app.

**Colors** (3–5 main colors, chosen to feel natural, calm and fresh):

| Role | Color | Hex |
|---|---|---|
| Main dark (cards, headings) | Forest green | `#1E4330` |
| Primary (buttons, ON toggles, chart lines) | Fresh green | `#2FA555` |
| Highlight (big numbers on dark cards) | Sunny yellow | `#FFE05A` |
| Accent (active tab) | Lime | `#8DC63F` |
| Background | Light mint | `#EEF5EE` |

Status tints: red for critical, amber for warning, green for OK, blue for information. Water is shown in blue, light and energy in yellow.

**Fonts.** Nunito. Bold and extra-bold for headings and big numbers, regular for captions. It is round and friendly, and easy to read on a phone.

**Layout rules.** 8px grid, large rounded cards, one illustration style (flat vector greenhouse, sprouts and sun) and realistic cut-out photos for plants. The same style is used on every screen.

---

## 4. Screens (28 frames in Figma)

| # | Screen | Module |
|---|---|---|
| 1 | Login | M1 |
| 2 | Login, wrong-password error (illustrated) | M1 |
| 3 | Home | M2 |
| 4 | Home with offline banner | M8 |
| 5 | No connection error (illustrated) | M8 |
| 6 | Alerts | M5 |
| 7 | Alert detail | M5 |
| 8 | Plants | Plants |
| 9 | Plant detail | Plants |
| 10 | Control, Manual | M3, M4 |
| 11 | Control, Automatic | M3, M4 |
| 12–14 | Insights: Water, Energy, Harvest | **Extra feature: Resource Savings** |
| 15–16 | History: Day, Week | M6 |
| 17 | Water management | M3 |
| 18 | Water management, watering running | M3 |
| 19 | Energy management | Extra feature |
| 20–21 | AI Plant Health: upload, result | Agro-intelligence |
| 22 | More | Navigation |
| 23–24 | Profile and Profile edit | M1 |
| 25 | Settings & automation | M7 |
| 26 | Settings, invalid threshold error (illustrated) | M7 |
| 27 | Style Guide | Style |
| 28 | Logo | Style |

**Our extra feature: Resource Savings.** The Insights screen shows how many liters of water and how many tenge the automation saved ("Smart watering saved 2,140 L"), because our user pays for water and wants to leave for the weekend without overwatering or losing plants.

---

## 5. The 4 key scenarios (clickable in the prototype)

1. **Everything fine in 5 seconds.** Open the app: Login → Home shows "Everything is growing well" and 4 live values (temperature, air humidity, soil moisture, light).
2. **Overheating alert.** Home → bell → Alerts → critical alert → Alert detail ("What happened", "What SmartGreen did", 2-hour chart) → "Open window" → Control.
3. **Automatic watering before a weekend.** Control → Automatic, Settings → watering schedule and thresholds, More / Home → Away Mode.
4. **Find when plants lacked water.** Insights / History → Week → the soil moisture chart shows the low point on Tuesday.

---

## 6. App diagram

```text
Screens (Flutter)  ->  Data layer (repositories/services)  ->  Firebase
```

Screens call the data layer, and only the data layer talks to Firebase. Data layer files: `AuthService`, `SensorRepository`, `DeviceRepository`, `HistoryRepository`, `SettingsRepository`, `AlertService`, `AutomationService`.

**What happens when the user presses "Water":**
1. The user taps "Water" on the Control screen.
2. `DeviceRepository.setState('irrigation', true)` is called.
3. Firestore saves `state = on` and `updatedAt`.
4. A realtime update reaches the app and the button shows ON.
5. An event is added to the log and soil moisture starts to rise.

The full picture is in [SmartGreen_Diagram_Data_Stack.pdf](SmartGreen_Diagram_Data_Stack.pdf).

---

## 7. Data structure (Cloud Firestore)

```text
users/{userId}               name, email
greenhouses/{greenhouseId}   ownerId, name, mode ("manual" | "auto"), awayMode
  readings/current           temperature, airHumidity, soilMoisture, light,
                             waterLevel, energyKw, updatedAt
  devices/{deviceId}         name (irrigation, ventilation, lighting, heating), state, updatedAt
  settings/main              maxTemp, minSoilMoisture, maxHumidity, minLight,
                             wateringSchedule, units
  history/{timestamp}        readings for at least 7 days
  alerts/{alertId}           type (critical | warning | info), message, parameter, value, createdAt, resolved
  plants/{plantId}           name, bed, health, moisture, harvestInDays
  events/{eventId}           device, action, userId, createdAt, litersUsed
```

**Security rule:** each user can read and write only the greenhouse where `ownerId` equals their own user id. Keys and passwords are never stored in the repository.

**Test data (Week 3):** 4+ parameters, 3+ devices, 7+ days of history, and some out-of-range values (for example 45 °C or soil moisture 20%) to test alerts.

---

## 8. Technology stack

| Part | Tool | Why |
|---|---|---|
| Mobile app | Flutter (Dart) | One code base for Android (and iOS later), fast UI that matches our Figma design, ready charts library for History |
| Login | Firebase Authentication | Ready login and logout, error on a wrong password, every user sees only their own greenhouse |
| Database | Cloud Firestore | Realtime updates without restarting the app, stores 7+ days of history, no own server needed |
| Notifications | Firebase Cloud Messaging | Push alerts when a value leaves its allowed range |
| Simulator | Firebase console or small Python script | No hardware: values are changed by hand to test alerts and automation |
| Design | Figma | Clickable prototype, logo and style guide |
| Code | Git + GitHub | Shared repository, README with roles, commits from every member |

---

## 9. Week 2 checklist

- [x] Style: logo, colors, fonts chosen to suit the target user
- [x] Figma mockups of all screens (login, dashboard, control, history and charts, settings, alerts, extra feature screen)
- [x] Clickable prototype
- [x] Data structure (readings, devices, settings, history, alerts, plants, events)
- [x] App diagram: screens → data layer → database
- [x] Stack with reasons

## 10. Team

| Member | Role |
|---|---|
| Diana | UI/UX design, Figma, documentation |
| Raikhan | Login, settings, Firebase Authentication |
| Assylai | Dashboard, device control, data layer |
| Moldir | Automation rules, alerts, history charts |
