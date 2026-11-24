# SmartGreen

**SmartGreen helps greenhouse owners to monitor their plants and control the greenhouse from a phone, so the plants stay healthy even when the owner is away.**

A mobile app for a simulated smart greenhouse. It shows live conditions, controls virtual devices (irrigation, ventilation, lighting), runs automatic rules, sends alerts and shows history charts. No hardware is used: greenhouse data is stored in a cloud database filled with test values.

Student project, APEC PetroTechnic.

---

## Team and roles

| Member | Role |
|---|---|
| Diana | UI/UX design, Figma, documentation |
| Raikhan | Login, settings, Firebase Authentication |
| Assylai | Dashboard, device control, data layer |
| Moldir | Automation rules, alerts, history charts |

---

## Target user

**Alex Morgan, 42, Atyrau.** Owns a small tomato and basil greenhouse at the family dacha, works full time in the city and visits the greenhouse only in the evenings and on weekends. Summers are hot and dry, plants have already been lost after a weekend trip, and water is expensive. Alex wants to see in a few seconds whether everything is fine, get a warning in time, and let the greenhouse take care of itself.

## Our extra feature

**Resource Savings report:** the app shows how many liters of water and how many tenge the automation saved, because our user pays for water and wants to leave for the weekend without overwatering or losing plants.

**Tracks:** Resource savings, Agro-intelligence (crop profiles with preset thresholds).

---

## Features (M1–M8)

| # | Module | What it does in SmartGreen |
|---|---|---|
| M1 | Login | Email and password login and logout, error on a wrong password, each user sees only their own greenhouse |
| M2 | Dashboard | Temperature, air humidity, soil moisture and light, time of last update, values update live |
| M3 | Control | Irrigation, ventilation and grow lights on/off, state saved to the database within 5 seconds |
| M4 | Modes | Manual / Automatic switch, rules such as soil moisture below 30% starts watering |
| M5 | Alerts | Critical, warning and info alerts when a value leaves its range |
| M6 | History | Temperature and soil moisture charts with Day / Week switch |
| M7 | Settings | Thresholds, watering schedule, units (°C/°F, L/gal), used by the automation |
| M8 | No internet | Clear "No connection to greenhouse" state, no crash, recovers automatically |

---

## Tech stack

- **App:** Flutter (Dart), Android
- **Backend:** Firebase Authentication, Cloud Firestore, Cloud Messaging
- **Design:** Figma
- **Version control:** Git and GitHub

## Design

- **Clickable prototype:** [SmartGreen Figma Prototype](https://www.figma.com/design/0GuGTdQvUozgvVNpJR3uuv/SmartGreen?node-id=0-1&t=WiQwT5ehBCJ7gfUw-1)
- **Style guide (logo, colors, fonts):** [SmartGreen Style Guide](https://www.figma.com/design/0GuGTdQvUozgvVNpJR3uuv/SmartGreen?node-id=34-792&t=WiQwT5ehBCJ7gfUw-1)
- **Screens:** Login, Home, My plants, Plant detail, Control (Manual / Automatic), Insights, History, Alerts, Alert detail, Water management, Energy management, AI Plant Health, More, Full Settings, No connection
- **Diagram and data structure:** `SmartGreen_Diagram_Data_Stack.pdf`

## Architecture

```text
Screens (Flutter)  ->  Data layer (repositories/services)  ->  Firebase
```

The data layer is kept in separate files, not mixed into the screen code.

---

## Data structure (Firestore)

```text
users/{userId}            name, email
greenhouses/{greenhouseId}   ownerId, name, mode ("manual" | "auto"), awayMode
  readings/current        temperature, airHumidity, soilMoisture, light,
                          waterLevel, energyKw, updatedAt
  devices/{deviceId}      name, state, updatedAt
  settings/main           maxTemp, minSoilMoisture, maxHumidity, minLight,
                          wateringSchedule, units
  history/{timestamp}     readings for at least 7 days
  alerts/{alertId}        type, message, parameter, value, createdAt, resolved
  plants/{plantId}        name, bed, health, moisture, harvestInDays
  events/{eventId}        device, action, userId, createdAt, litersUsed
```

Security rule: each user can read and write only the greenhouse where `ownerId` equals their own user id.

---

## How to run (will be updated as the project grows)

1. Install [Flutter](https://docs.flutter.dev/get-started/install) and Android Studio with an emulator.
2. Clone the repository:
   ```bash
   git clone https://github.com/sususupernova25/SmartGreen.git
   cd SmartGreen
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Add your own Firebase config (`google-services.json`) to `android/app/`. **Do not commit keys or passwords to GitHub.**
5. Run the app:
   ```bash
   flutter run
   ```

To test alerts and automation, change values (for example temperature to 45 °C or soil moisture to 20%) in the Firebase console.

---

## Project plan

| Week | Goal | Status |
|---|---|---|
| 1 | Idea and team, project charter, repository | Done |
| 2 | Figma prototype, logo and colors, app diagram | Done |
| 3 | App skeleton and database with test data | In progress |
| 4 | Login, dashboard, device control (M1–M3) | Planned |
| 5 | Automation, alerts, history, settings, no-internet mode (M4–M8) | Planned |
| 6 | Extra feature, APK, demo video, final defense | Planned |
