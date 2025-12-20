# Project 6: Smart Plant Monitor

**Difficulty:** Intermediate
**Estimated Time:** 3-4 hours
**Cost:** $20-35

## Learning Objectives

- Analog sensor reading with ADC (Analog-to-Digital Converter)
- Capacitive soil moisture sensors vs resistive
- Sensor calibration (dry/wet values)
- Pump control with safety timers
- Water level detection
- Plant care automations

---

## Parts List

| Part | Quantity | Cost (CAD) | Notes |
|------|----------|-----------|-------|
| ESP32 Development Board | 1 | $8-12 | Reuse from previous projects |
| Capacitive Soil Moisture Sensor v1.2 | 1-3 | $5-8 each | Better than resistive (no corrosion) |
| 5V Water Pump (submersible) | 1 | $5-8 | Small aquarium pump |
| Relay Module (5V, 1-channel) | 1 | $3-5 | To control pump |
| Water Level Sensor (float switch) | 1 | $3-5 | Optional: detect empty reservoir |
| Silicone Tubing (1m) | 1 | $3 | For water delivery |
| Jumper Wires | 6-8 | Reuse | Male-to-male and female-to-female |

**Total Cost:** ~$20-35

---

## Understanding the Parts

### Capacitive Soil Moisture Sensor

**How it works:**
- Measures soil moisture by detecting changes in capacitance
- Water increases soil's dielectric constant → higher capacitance
- No direct soil contact with electrodes → no corrosion!

**Specifications:**
- **Input:** 3.3V - 5V
- **Output:** 0-3V analog voltage (via ADC pin)
- **Measurement Range:** 0-100% volumetric water content
- **Response Time:** ~1 second

**vs Resistive Sensors:**
| Feature | Capacitive | Resistive |
|---------|-----------|-----------|
| Corrosion | None (coated) | High (exposed metal) |
| Lifespan | 2-5 years | 6-12 months |
| Accuracy | ±3% | ±10% |
| Cost | $5-8 | $2-3 |

**Winner:** Capacitive (worth the extra cost!)

### ESP32 ADC (Analog-to-Digital Converter)

**What is ADC?**
- Converts analog voltage (0-3.3V) to digital number (0-4095)
- 12-bit resolution: 4096 possible values
- Formula: `value = (voltage / 3.3V) * 4095`

**ESP32 ADC Pins:**
- **ADC1:** GPIO32-39 (8 channels) - **Use these!**
- **ADC2:** GPIO0,2,4,12-15,25-27 (10 channels) - Avoid (conflicts with WiFi)

**Important:** Always use ADC1 pins (GPIO32-39) for sensors. ADC2 doesn't work when WiFi is active!

**Recommended pins:**
- **GPIO34** - Soil moisture sensor 1
- **GPIO35** - Soil moisture sensor 2 (if multiple plants)
- **GPIO36 (VP)** - Soil moisture sensor 3
- **GPIO39 (VN)** - Water level sensor (analog)

### 5V Submersible Pump

**Specifications:**
- **Voltage:** 5V DC (USB power compatible)
- **Current:** 100-200mA
- **Flow Rate:** 1-2 L/min (more than enough for plant watering!)
- **Max Lift Height:** 40-80cm

**Safety Considerations:**
- **Never run dry** - pump needs water to stay cool
- **Use relay** - ESP32 GPIO can't supply 200mA directly
- **Add timeout** - max run time to prevent overflow (30 seconds typical)

---

## Wiring Diagram

### Complete System Wiring

```
ESP32 Board                Components

GPIO34 (ADC) --------> AOUT (Soil Moisture Sensor)
3.3V ----------------> VCC (Soil Moisture Sensor)
GND -----------------> GND (Soil Moisture Sensor)

GPIO4 ---------------> IN (Relay Module - pump control)
5V ------------------> VCC (Relay Module)
GND -----------------> GND (Relay Module)

Relay Module           Water Pump

COM <--- 5V (from USB power adapter)
NO  ----> + (Pump positive)
GND ----> - (Pump negative)
```

**Power Setup:**
- **ESP32:** Powered via Micro-USB from computer or 5V adapter
- **Pump:** Powered through relay from separate 5V power source (USB adapter works!)
- **Soil Sensor:** Powered from ESP32 3.3V pin (low current)

---

## ESPHome Configuration

Create: `/home/hazzard/home-assistant/esphome/plant-monitor-1.yaml`

```yaml
esphome:
  name: plant-monitor-1
  friendly_name: "Fiddle Leaf Fig Monitor"
  platform: ESP32
  board: esp32dev

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  manual_ip:
    static_ip: 192.168.40.156
    gateway: 192.168.40.1
    subnet: 255.255.255.0

logger:

api:
  encryption:
    key: !secret api_key_plant_monitor

ota:
  - platform: esphome
    password: !secret ota_password

# Soil Moisture Sensor (Capacitive)
sensor:
  - platform: adc
    pin: GPIO34
    name: "Soil Moisture"
    id: soil_moisture_raw
    update_interval: 60s
    attenuation: 11db  # Measure up to 3.3V
    filters:
      # Calibration: Map sensor voltage to 0-100% moisture
      - calibrate_linear:
          # Measure these values with your sensor:
          - 2.80 -> 0.0   # Dry (sensor in air)
          - 1.20 -> 100.0 # Wet (sensor in glass of water)
      - lambda: return max(0.0f, min(100.0f, x));  # Clamp 0-100%
    unit_of_measurement: "%"
    accuracy_decimals: 0
    icon: "mdi:water-percent"

  # WiFi Signal
  - platform: wifi_signal
    name: "WiFi Signal"
    update_interval: 60s

# Binary Sensor: Is soil dry? (below 30%)
binary_sensor:
  - platform: template
    name: "Needs Watering"
    id: needs_watering
    device_class: problem
    lambda: |-
      return id(soil_moisture_raw).state < 30.0;

# Water Pump Control
switch:
  - platform: gpio
    pin: GPIO4
    name: "Water Pump"
    id: water_pump
    icon: "mdi:water-pump"
    restore_mode: ALWAYS_OFF  # Safety: never auto-start pump!

    # Safety: Auto-shutoff after 10 seconds
    on_turn_on:
      - delay: 10s
      - switch.turn_off: water_pump
      - logger.log: "Pump auto-shutoff after 10 seconds"

# Manual Watering Button (via Home Assistant)
button:
  - platform: template
    name: "Water Plant Now"
    icon: "mdi:watering-can"
    on_press:
      - logger.log: "Manual watering started"
      - switch.turn_on: water_pump
      - delay: 5s  # Run pump for 5 seconds
      - switch.turn_off: water_pump
      - logger.log: "Manual watering complete"

# Watering History Counter
sensor:
  - platform: template
    name: "Watering Count Today"
    id: watering_count
    unit_of_measurement: "times"
    accuracy_decimals: 0
    lambda: |-
      static int count = 0;
      return count;

# Reset counter at midnight
time:
  - platform: homeassistant
    id: homeassistant_time
    on_time:
      - seconds: 0
        minutes: 0
        hours: 0
        then:
          - lambda: id(watering_count).publish_state(0);

# Automation: Water when soil is dry (optional, enable if desired)
# interval:
#   - interval: 12h  # Check every 12 hours
#     then:
#       - if:
#           condition:
#             lambda: return id(soil_moisture_raw).state < 25.0;  # Very dry
#           then:
#             - logger.log: "Auto-watering triggered (soil < 25%)"
#             - switch.turn_on: water_pump
#             - delay: 5s
#             - switch.turn_off: water_pump
#             - lambda: |-
#                 auto count = id(watering_count);
#                 count.publish_state(count.state + 1);
```

---

## Step-by-Step Build Guide

### Step 1: Calibrate Soil Moisture Sensor

**Before wiring, get calibration values:**

1. **Dry Reading (Sensor in Air):**
   - Create test config with just ADC sensor:
   ```yaml
   sensor:
     - platform: adc
       pin: GPIO34
       name: "Raw Sensor Value"
       update_interval: 5s
       attenuation: 11db
   ```
   - Flash ESP32, check logs
   - Hold sensor in air (completely dry)
   - Note voltage: e.g., `2.80V`

2. **Wet Reading (Sensor in Water):**
   - Place sensor in glass of water (don't submerge electronics!)
   - Note voltage: e.g., `1.20V`

3. **Update Calibration:**
   ```yaml
   calibrate_linear:
     - 2.80 -> 0.0   # Your dry voltage
     - 1.20 -> 100.0 # Your wet voltage
   ```

### Step 2: Wire Soil Moisture Sensor

1. **Power:**
   - Sensor VCC → ESP32 3.3V
   - Sensor GND → ESP32 GND

2. **Analog Output:**
   - Sensor AOUT → ESP32 GPIO34

3. **Test:**
   - Flash config, check logs
   - Should read ~0% in air, ~100% in water

### Step 3: Wire Relay and Pump

1. **Relay Control:**
   - Relay IN → ESP32 GPIO4
   - Relay VCC → ESP32 5V
   - Relay GND → ESP32 GND

2. **Pump Power:**
   - 5V USB adapter + wire → Relay COM
   - Relay NO → Pump + (positive)
   - USB adapter GND → Pump - (negative)

3. **Test Relay:**
   - Turn on pump in Home Assistant
   - Relay should click, pump should run
   - **Important:** Pump must be submerged in water!

### Step 4: Insert Sensor in Soil

1. **Watering first:** Water plant thoroughly, wait 1 hour
2. **Insert sensor:** Push 2/3 into soil, near roots (not touching pot edge)
3. **Check reading:** Should read 60-80% (moist soil)
4. **Verify position:** Ensure sensor vertical, good soil contact

### Step 5: Set Up Watering System

1. **Reservoir:** Use cup, bottle, or small container for water
2. **Pump placement:** Submerge pump in reservoir
3. **Tubing:** Connect tubing to pump outlet
4. **Delivery:** Position tubing end near plant base
5. **Test:** Run pump for 5 seconds, check water flow

---

## Troubleshooting

### Moisture Reading Always 0% or 100%

**Cause:** Wrong calibration values or wiring issue.

**Fix:**
1. Verify GPIO34 connection (AOUT pin)
2. Re-calibrate (dry/wet values)
3. Check attenuation setting (`11db` for 0-3.3V range)
4. Try different ADC pin (GPIO35, GPIO36)

### Moisture Reading Fluctuates Wildly

**Cause:** Electrical noise or loose connection.

**Fix:**
1. Add filter in YAML:
   ```yaml
   filters:
     - sliding_window_moving_average:
         window_size: 5
   ```
2. Ensure sensor fully inserted in soil
3. Keep sensor wires away from power wires
4. Check for loose breadboard connections

### Pump Doesn't Turn On

**Cause:** Relay wiring or insufficient power.

**Fix:**
1. Verify relay clicks when switched on (listen carefully)
2. Check GPIO4 → Relay IN connection
3. Verify relay powered (VCC, GND)
4. Test relay with multimeter (COM-NO should be closed when ON)
5. Check pump power supply (separate 5V source, not ESP32!)

---

## Home Assistant Automations

### Automation 1: Notify When Plant Needs Water

```yaml
alias: "Plant Needs Watering Alert"
trigger:
  - platform: state
    entity_id: binary_sensor.needs_watering
    to: "on"
    for:
      hours: 6  # Only alert if dry for 6 hours
action:
  - service: notify.mobile_app
    data:
      title: "🌱 Plant Needs Water"
      message: "Soil moisture is {{ states('sensor.soil_moisture') }}%"
```

### Automation 2: Auto-Water on Schedule (Optional)

```yaml
alias: "Auto-Water Plant (Daily)"
trigger:
  - platform: time
    at: "08:00:00"  # Every morning at 8 AM
condition:
  - condition: numeric_state
    entity_id: sensor.soil_moisture
    below: 30  # Only water if soil is dry
action:
  - service: button.press
    target:
      entity_id: button.water_plant_now
  - service: notify.mobile_app
    data:
      message: "Plant auto-watered (moisture was {{ states('sensor.soil_moisture') }}%)"
```

### Automation 3: Watering History Log

```yaml
alias: "Log Plant Watering"
trigger:
  - platform: state
    entity_id: switch.water_pump
    to: "on"
action:
  - service: logbook.log
    data:
      name: "Plant Care"
      message: "Plant watered (soil moisture: {{ states('sensor.soil_moisture') }}%)"
```

---

## Enhancements

### 1. Multiple Plant Monitoring

Add more sensors:

```yaml
sensor:
  - platform: adc
    pin: GPIO34
    name: "Fiddle Leaf Fig Moisture"

  - platform: adc
    pin: GPIO35
    name: "Snake Plant Moisture"

  - platform: adc
    pin: GPIO36
    name: "Monstera Moisture"
```

### 2. Water Level Detection

Prevent pump running dry:

```yaml
binary_sensor:
  - platform: gpio
    pin:
      number: GPIO39
      mode:
        input: true
        pullup: true
    name: "Water Reservoir Empty"
    device_class: problem

# Prevent watering if reservoir empty
on_...:
  then:
    - if:
        condition:
          binary_sensor.is_on: water_reservoir_empty
        then:
          - logger.log: "Cannot water - reservoir empty!"
        else:
          - switch.turn_on: water_pump
```

### 3. Light Sensor Integration

Monitor sunlight exposure:

```yaml
sensor:
  - platform: adc
    pin: GPIO32
    name: "Light Level"
    filters:
      - calibrate_linear:
          - 0.0 -> 0
          - 3.3 -> 100
    unit_of_measurement: "%"
```

### 4. Plant Care Dashboard

Custom Lovelace card:

```yaml
type: vertical-stack
cards:
  - type: entity
    entity: sensor.soil_moisture
    name: Fiddle Leaf Fig
    icon: mdi:leaf

  - type: gauge
    entity: sensor.soil_moisture
    min: 0
    max: 100
    severity:
      red: 0
      yellow: 30
      green: 50

  - type: button
    entity: button.water_plant_now
    icon: mdi:watering-can
    tap_action:
      action: call-service
      service: button.press

  - type: history-graph
    hours_to_show: 168  # 7 days
    entities:
      - sensor.soil_moisture
```

---

## What You've Learned

✅ **Analog Sensors:** ADC operation, voltage measurement, calibration
✅ **Capacitive Sensing:** How capacitive sensors work, advantages over resistive
✅ **Automation Safety:** Timeouts, fail-safes, always-off restore modes
✅ **Pump Control:** Relay switching, current considerations, water delivery
✅ **Template Sensors:** Binary thresholds, state tracking, counters

**Next:** [Project 7: Door/Window Sensor Network](07-door-window-sensors.md)
