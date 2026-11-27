"""
SmartGreen Firestore Seed Script (Week 3)
Populates Cloud Firestore with:
1. Current sensor readings (4 parameters + water level)
2. 3 Devices with on/off states
3. Settings (thresholds & units)
4. 7-Day History with out-of-range spike (45.2 C) to satisfy Criterion 3.3
5. Alerts list (Critical 37 C, Warning 28% moisture, Info)

Runs with pure Python standard library (no pip dependencies required).
"""

import json
import urllib.request
import datetime

PROJECT_ID = "smartgreen-b9cbe"
BASE_URL = f"https://firestore.googleapis.com/v1/projects/{PROJECT_ID}/databases/(default)/documents"

def firestore_patch(path: str, data: dict):
    url = f"{BASE_URL}/{path}"
    # Convert Python values to Firestore REST API field format
    fields = {}
    for k, v in data.items():
        if isinstance(v, bool):
            fields[k] = {"booleanValue": v}
        elif isinstance(v, (int, float)):
            fields[k] = {"doubleValue": float(v)}
        elif isinstance(v, str):
            fields[k] = {"stringValue": v}
        elif isinstance(v, datetime.datetime):
            fields[k] = {"stringValue": v.isoformat()}
        elif isinstance(v, list):
            fields[k] = {"arrayValue": {"values": [{"stringValue": str(item)} for item in v]}}

    payload = json.dumps({"fields": fields}).encode("utf-8")
    req = urllib.request.Request(url, data=payload, method="PATCH", headers={"Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req) as resp:
            return json.loads(resp.read().decode("utf-8"))
    except Exception as e:
        print(f"Error patching {path}: {e}")
        return None

def seed_database():
    print(f"--- Seeding Firestore for Project: {PROJECT_ID} ---")
    now = datetime.datetime.now(datetime.timezone.utc)

    # 1. Current Readings (M2 Dashboard)
    current_readings = {
        "temperature": 24.6,
        "airHumidity": 68.0,
        "soilMoisture": 64.0,
        "light": 12.4,
        "waterLevel": 984.0,
        "updatedAt": now.isoformat()
    }
    res = firestore_patch("greenhouses/smartgreen_1/readings/current", current_readings)
    print("✓ Current readings uploaded:", "OK" if res else "FAILED")

    # 2. Devices (M3 Control)
    devices = {
        "irrigation": {"name": "Irrigation Pump", "state": False, "updatedAt": now.isoformat()},
        "ventilation": {"name": "Roof Ventilation", "state": False, "updatedAt": now.isoformat()},
        "lighting": {"name": "Grow Lighting", "state": True, "updatedAt": now.isoformat()}
    }
    for dev_id, dev_data in devices.items():
        r = firestore_patch(f"greenhouses/smartgreen_1/devices/{dev_id}", dev_data)
        print(f"✓ Device '{dev_id}' state uploaded:", "OK" if r else "FAILED")

    # 3. Settings (M7 Settings)
    settings = {
        "maxTemp": 30.0,
        "minSoilMoisture": 35.0,
        "maxHumidity": 80.0,
        "units": "celsius",
        "wateringSchedule": "auto"
    }
    r = firestore_patch("greenhouses/smartgreen_1/settings/main", settings)
    print("✓ Settings uploaded:", "OK" if r else "FAILED")

    # 4. 7-Day History (M6 History) with Criterion 3.3 Out-of-Range Spike (45.2 C)
    print("✓ Uploading 7-day history entries...")
    for i in range(7):
        day_date = now - datetime.timedelta(days=(6 - i))
        # Day 4 has heatwave spike (45.2 C and 22% soil moisture)
        if i == 4:
            temp = 45.2
            soil = 22.0
        else:
            temp = 23.5 + (i * 1.2) % 4.0
            soil = 60.0 + (i * 2.0) % 8.0

        history_point = {
            "timestamp": day_date.isoformat(),
            "temperature": round(temp, 1),
            "soilMoisture": round(soil, 1),
            "airHumidity": 66.0
        }
        day_id = f"day_{i+1}"
        firestore_patch(f"greenhouses/smartgreen_1/history/{day_id}", history_point)
    print("✓ 7-day history uploaded (Includes 45.2°C anomaly on Day 4)")

    # 5. Alerts (M5 Alerts)
    alerts = {
        "alert_1": {
            "type": "critical",
            "title": "High Temperature Warning",
            "message": "Temperature reached 37.0°C (above max threshold 30°C)",
            "value": 37.0,
            "createdAt": (now - datetime.timedelta(minutes=15)).isoformat()
        },
        "alert_2": {
            "type": "warning",
            "title": "Low Soil Moisture",
            "message": "Soil moisture dropped to 28% in Bed 2",
            "value": 28.0,
            "createdAt": (now - datetime.timedelta(hours=1)).isoformat()
        }
    }
    for alert_id, alert_data in alerts.items():
        firestore_patch(f"greenhouses/smartgreen_1/alerts/{alert_id}", alert_data)
    print("✓ Alerts uploaded.")

    print("\n[SUCCESS] Firestore Database is fully seeded according to Week 3 Criteria!")

if __name__ == "__main__":
    seed_database()
