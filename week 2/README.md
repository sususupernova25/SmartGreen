# Week 2 — Design, Prototype & Data Architecture

> **SmartGreen Project** &middot; APEC PetroTechnic &middot; Week 2 Defense Submission  
> **Team:** Diana ([@diakitchq](https://github.com/diakitchq)), Raikhan ([@rsakhtashevaa09](https://github.com/rsakhtashevaa09)), Assylai ([@aamirzhanova24-hub](https://github.com/aamirzhanova24-hub)), Moldir ([@sususupernova25](https://github.com/sususupernova25))

---

## 1. Quick Links to Deliverables

- 🎨 **Figma Clickable Prototype:** [Open in Figma](https://www.figma.com/design/0GuGTdQvUozgvVNpJR3uuv/SmartGreen?node-id=0-1&t=FsqgWzvwUvvMTgS2-1)
- 📐 **Figma Style Guide & Components:** [View Style Guide Frame](https://www.figma.com/design/0GuGTdQvUozgvVNpJR3uuv/SmartGreen?node-id=34-792&t=FsqgWzvwUvvMTgS2-1)
- 📄 **Architecture Diagram & Data Stack (PDF):** [SmartGreen_Diagram_Data_Stack.pdf](SmartGreen_Diagram_Data_Stack.pdf)

---

## 2. Style Guide & Design System

The visual identity is specifically engineered for our target user, **Alex Morgan (42, Atyrau)**, who checks the app outdoors at the dacha under bright sunlight, as well as after work in low-light environments.

### 🎨 Color Palette

| Role | Color Name | HEX Code | Usage & User Justification |
|---|---|---|---|
| **Primary** | Deep Forest Green | `#174C38` | Primary brand color, headers, CTAs, active tab icons. Evokes lush foliage and healthy crops. |
| **Background** | Cream Warm Neutral | `#F7F6EF` | Soft, organic surface background. Avoids the eye strain of harsh `#FFFFFF` outdoors in sunny Atyrau. |
| **Card Surface** | Pure White / Soft Green | `#FFFFFF` / `#E4F0E6` | Sensor cards, grouped containers, input fields for crisp readability. |
| **Accent** | Warm Amber | `#E0AE35` | Lighting metrics, alerts, progress indicators, harvest countdowns. |
| **Status: Critical** | Crimson Tint | `#F8E4DF` (Text: `#C53030`) | Critical alert cards (e.g. Temperature > 35°C, urgent ventilation). |
| **Status: Warning** | Golden Tint | `#FBF2D4` (Text: `#975A16`) | Warning thresholds (e.g. Soil moisture < 30%). |
| **Status: Success** | Sage Green | `#E6F4EA` (Text: `#137333`) | Normal operating parameters, healthy plant status. |

### 🔤 Typography & Grid

- **Font Family:** `DM Sans` (Google Fonts) — modern geometric sans-serif with high x-height, ensuring sharp legibility on mobile displays under direct sunlight.
- **Hierarchy:**
  - `H1`: 28px Medium (Screen titles)
  - `H2`: 20px Bold (Section headings)
  - `Value / KPI`: 24px Bold (Telemetry digits, sensor readouts)
  - `Body`: 14px Regular (Descriptions, cards)
  - `Label`: 12px Medium (Card titles, input labels)
  - `Caption`: 11px Regular (Timestamps, secondary units)
- **Grid & Metrics:**
  - Standard Canvas: `390 × 844 px` (Modern iOS/Android viewport)
  - Side Margin: `24 px`
  - Card Radius: `16 px` &middot; Button Radius: `12 px`
  - Base Spacing Grid: `8 px` / `12 px`

---

## 3. Screen Inventory (20 Mockups & M1–M8 Coverage)

The Figma project contains **20 interactive screens** covering all mandatory modules and extra features:

| Screen Name in Figma | Module Covered | Function & Description |
|---|---|---|
| `Prototype · 01 · Login` | **M1 Login** | Email/Password inputs with password toggle, demo credentials link, validation state. |
| `Prototype · 02 · Home` | **M2 Dashboard** | Live 4-sensor cards (Temp, Humidity, Soil, Light), Away Mode toggle, water reserve widget. |
| `Prototype · 03 · Home · Offline banner` | **M8 Offline** | Home dashboard displaying reactive "No connection" status banner with retry CTA. |
| `Prototype · 04 · No connection` | **M8 Offline** | Full-screen offline state with reconnection guidance and cached data timestamp. |
| `Prototype · 04 · Alerts` | **M5 Alerts** | Filterable notifications list (All / Critical / Warnings) with severity badges. |
| `Prototype · 05 · Alert detail` | **M5 Alerts** | Detailed temperature incident screen (37°C), 2-hour trend graph, "Open window" quick action. |
| `Prototype · 06 · Plants` | **Agro-Track** | Crop directory (Cherry Tomatoes, Roma Tomatoes, Basil) with health scores and harvest days. |
| `Prototype · 07 · Cherry Tomatoes` | **Agro-Track** | Plant detail card: moisture history, care checklist, light intake. |
| `Prototype · 08 · Control · Automatic` | **M4 Modes & M3** | Segmented mode toggle (Manual / Auto), automatic rule confirmation ("Soil moisture is good"). |
| `Prototype · 09 · Control · Manual` | **M3 Control** | Manual device toggles for irrigation pump, ventilation roof vents, grow lights. |
| `Prototype · Manual ventilation · Open` | **M3 Control** | Visual confirmation of ventilation open at 100% with updated status indicator. |
| `Prototype · Manual watering · Running` | **M3 Control** | Active irrigation state showing pump operating with instant "Stop" button. |
| `Prototype · 10 · Insights` | **Extra Feature** | Resource savings dashboard: 486L total used, litres saved, monetary savings in KZT. |
| `Prototype · 11 · History` | **M6 History** | 24-hour and 7-day trend charts for temperature and soil moisture with safe zones. |
| `Prototype · 12 · Water management` | **Extra Feature** | 984L rainwater reserve monitor, smart schedule per bed, manual watering CTA. |
| `Prototype · 13 · Energy management` | **Extra Feature** | Power consumption telemetry (1.24 kW), solar/grid eco-optimization toggle. |
| `Prototype · 14 · AI Plant Health` | **Future Track** | Photo analysis upload screen for leaf disease identification. |
| `Prototype · 15 · AI Plant Health result`| **Future Track** | Diagnostics report: early magnesium deficiency detection + suggested remediation. |
| `Prototype · 16 · More` | **Navigation** | Profile management (Alex Morgan), settings hub, system diagnostics. |
| `Prototype · 17 · Full Settings` | **M7 Settings** | Environmental threshold sliders, watering calendar, units switch (°C/°F, L/gal), logout. |

---

## 4. The 4 Key Defense Scenarios (Walkthrough Guide)

During the 5-minute defense demo, follow these exact 4 click-through flows in Figma:

```
Scenario 1: Daily Monitoring (M1 & M2)
[Login] ──(Tap 'Log in')──> [Home Dashboard] ──(Inspect 4 Live Sensor Cards & Water Reserve)

Scenario 2: Manual Device Control (M3)
[Home] ──(Bottom Nav 'Control')──> [Control Screen] ──(Toggle Ventilation / Water) ──> [Manual Action Running]

Scenario 3: Alert & Resolution (M5 & M3)
[Home] ──(Tap Notification Bell)──> [Alerts] ──(Tap 37°C Alert)──> [Alert Detail] ──(Tap 'Open window')──> [Control · Vents Open]

Scenario 4: Settings & Extra Feature (M4, M6, M7 & Resource Savings)
[Home] ──(Tap 'Insights')──> [Resource Savings Report] ──(Tap 'More' -> 'Settings')──> [Settings Thresholds & Schedules]
```

---

## 5. App Architecture & Data Flow

```text
┌───────────────────────────────┐
│     Screens (Flutter UI)      │
│  Stateful Widgets / Provider  │
└───────────────┬───────────────┘
                │ Calls method
                ▼
┌───────────────────────────────┐
│     Data Layer (Services)     │
│   GreenhouseRepository / API  │
└───────────────┬───────────────┘
                │ Real-time Stream / Write
                ▼
┌───────────────────────────────┐
│   Backend (Cloud Firestore)   │
│  Realtime Database & Auth     │
└───────────────────────────────┘
```

### 💧 Step-by-Step: What happens when the user presses "Water"? (Defense Step 3)
1. **User Action:** The user presses `"Water now"` or `"Start manual watering"` on the Flutter screen.
2. **Local Feedback:** The UI immediately reflects an interactive loading/pending state to provide responsive haptic feedback within 100ms.
3. **Data Layer Call:** The screen invokes `GreenhouseRepository.setDeviceState('irrigation', true)`.
4. **Cloud Write:** The repository issues an asynchronous write to Cloud Firestore at `greenhouses/{greenhouseId}/devices/irrigation` with `{ state: "on", updatedAt: ServerTimestamp() }` and appends a record to `events/{eventId}` with `litersUsed`.
5. **Real-Time Synchronization:** Cloud Firestore pushes the updated snapshot via WebSocket to all subscribed clients.
6. **UI Confirmation:** Within 5 seconds (typically <500ms), the screen listener receives the new document state and displays the active green badge `"Watering running · 100%"`.

---

## 6. Technology Stack Justification (Defense Step 4)

- **Mobile Framework — Flutter (Dart):**
  - Single cross-platform codebase for Android (and future iOS).
  - Pixel-perfect reproduction of our custom Figma design system and soft-toned color palette.
  - Excellent official charts packages (`fl_chart`) for M6 History graphs.
- **Backend & Database — Cloud Firestore & Firebase Auth:**
  - Built-in real-time stream listeners (`snapshots()`), allowing values changed in the Firebase console to update on the dashboard without manual screen refresh (critical for Week 3 & 4 rubric).
  - Out-of-the-box secure authentication with fine-grained security rules enforcing that each user accesses only their own greenhouse document.
- **Push Alerts — Firebase Cloud Messaging (FCM):**
  - Reliable push notifications for critical threshold breaches even when the phone is locked.

---

## 7. Defense Questions & Answers Cheat Sheet

1. **Why these colors for your user?**  
   *Answer:* Our target user Alex works outdoors under intense Atyrau sunshine. We chose Cream (`#F7F6EF`) and Forest Green (`#174C38`) to provide high contrast without the blinding glare of pure white. Amber (`#E0AE35`) is reserved for alerts and sunlight telemetry.
2. **What is written to the database when a device is turned on?**  
   *Answer:* The document `greenhouses/{id}/devices/{deviceId}` is updated with `state: "on"` and the current timestamp `updatedAt`. Simultaneously, an audit log is appended to `events/` recording `action`, `device`, `userId`, and estimated `litersUsed` for the savings report.
3. **Where is login checked?**  
   *Answer:* Authentication credentials are verified securely by Firebase Authentication. In Firestore, security rules check `request.auth.uid == resource.data.ownerId` to ensure total isolation between users.
4. **How does the app know a value changed in the database?**  
   *Answer:* Flutter subscribes to Firestore document streams using Dart Streams (`collection().snapshots()`). When an instructor alters a temperature or moisture value in the Firebase console, the update is pushed via WebSocket and triggers an automatic UI rebuild.
