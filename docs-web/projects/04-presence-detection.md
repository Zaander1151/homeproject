# Project 4: Presence Detection Sensor

**Difficulty:** Beginner
**Estimated Time:** 2-3 hours
**Cost:** $15-25

## Learning Objectives

- PIR (Passive Infrared) motion sensors
- Binary sensors in ESPHome
- Debouncing and filtering false triggers
- Delayed-off timers
- Zone-based presence detection
- Motion-activated automations
- Integration with lighting scenes

---

## Parts List

| Part | Quantity | Cost (CAD) | Notes |
|------|----------|-----------|-------|
| ESP32 Development Board | 1 | $8-12 | Reuse from previous projects |
| PIR Motion Sensor (HC-SR501 or M5Stack PIR) | 1 | $3-8 | HC-SR501 cheaper, M5Stack easier |
| Jumper Wires | 3 | Reuse | Male-to-male |
| Breadboard (optional) | 1 | Reuse | For HC-SR501 prototyping |

**Total Cost:** ~$15-25

**Sensor Options:**
- **HC-SR501:** Classic PIR module, adjustable sensitivity ($3-5)
- **M5Stack PIR Unit:** Grove connector, plug-and-play ($8-10)
- **AM312:** Smaller, fixed sensitivity ($2-3)

---

## Understanding PIR Sensors

### How PIR Sensors Work

**PIR = Passive Infrared**

PIR sensors detect motion by sensing changes in infrared radiation (heat) from warm objects like humans and pets.

**Detection Method:**
1. Sensor has two IR-sensitive elements
2. When no motion: Both elements detect same IR level → balanced → no trigger
3. When human moves: One element detects more IR than the other → imbalance → motion detected!
4. Fresnel lens focuses IR radiation onto elements (creates detection zones)

**Key Characteristics:**
- **Passive:** Doesn't emit anything, only receives IR
- **Detects:** Movement of warm objects (humans, pets, cars)
- **Doesn't detect:** Stationary objects (even if warm)
- **Range:** 3-7 meters (depends on model and settings)
- **Detection Angle:** ~120° cone
- **Trigger Time:** 2-5 seconds (adjustable on HC-SR501)

**Limitations:**
- Can't detect motion through glass or walls
- Sensitive to temperature changes (HVAC vents, sunlight)
- Can't distinguish between humans and pets
- Won't detect very slow movement

---

## HC-SR501 PIR Sensor Explained

### Pin Layout

```
Top View (looking at component side):

   +-------+
   |  O O  |  ← Sensitivity pot (distance adjustment)
   |       |
   | [Lens]|
   |       |
   |  O O  |  ← Time delay pot (trigger duration)
   +---|---+
       |
   [VCC] [OUT] [GND]  ← Pins (bottom)
```

**Pins:**
- **VCC:** Power (5V - 20V, works with 5V from ESP32)
- **OUT:** Signal output (HIGH when motion detected, LOW when no motion)
- **GND:** Ground

### Adjustment Potentiometers

**Sensitivity Pot (Distance):**
- **Clockwise:** Increase detection range (up to 7m)
- **Counter-clockwise:** Decrease range (down to 3m)
- **Recommended:** Start at mid-position, adjust based on room size

**Time Delay Pot (Trigger Duration):**
- **Clockwise:** Longer delay (up to 300 seconds / 5 minutes)
- **Counter-clockwise:** Shorter delay (down to 3 seconds)
- **Recommended:** Start at minimum (3-5 seconds), adjust in software instead

### Jumper (Trigger Mode)

Some HC-SR501 modules have a jumper for trigger mode:

**H (Repeatable Trigger Mode):**
- Output stays HIGH as long as motion is detected
- Recommended for most applications

**L (Single Trigger Mode):**
- Output goes HIGH once, then LOW after delay
- Ignores further motion during delay
- Less useful for continuous presence detection

**Set jumper to "H" if available.**

---

## Wiring Diagram

### HC-SR501 PIR Sensor

```
ESP32 Board                 HC-SR501 PIR Sensor

  5V   --------> VCC
  GPIO4 -------> OUT (Signal)
  GND  --------> GND
```

**Step-by-Step Wiring:**
1. Connect HC-SR501 **VCC** to ESP32 **5V** pin
2. Connect HC-SR501 **OUT** to ESP32 **GPIO4** pin
3. Connect HC-SR501 **GND** to ESP32 **GND** pin
4. No pull-up resistor needed (HC-SR501 has built-in pull-down)

### M5Stack PIR Unit (Grove Connector)

```
ESP32 Board                 M5Stack PIR Unit (Grove)

  GPIO4 -------> Yellow (Signal)
  GND  --------> Black (GND)
  5V   --------> Red (VCC)
```

M5Stack PIR is easier - just plug into Grove port!

---

## ESPHome Configuration

Create a new file: `/home/hazzard/home-assistant/esphome/motion-sensor-1.yaml`

### Complete Configuration

```yaml
esphome:
  name: motion-sensor-1
  friendly_name: "Living Room Motion"
  platform: ESP32
  board: esp32dev

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password

  manual_ip:
    static_ip: 192.168.40.153
    gateway: 192.168.40.1
    subnet: 255.255.255.0
    dns1: 8.8.8.8

  ap:
    ssid: "Motion-Sensor-Fallback"
    password: "12345678"

logger:

api:
  encryption:
    key: !secret api_key_motion_sensor

ota:
  - platform: esphome
    password: !secret ota_password

# PIR Motion Sensor
binary_sensor:
  - platform: gpio
    pin:
      number: GPIO4
      mode:
        input: true
        pulldown: false  # HC-SR501 has built-in pull-down
    name: "Motion Detected"
    id: motion
    device_class: motion  # Shows as motion icon in Home Assistant

    # Debounce filter: Ignore signals shorter than 50ms (noise rejection)
    filters:
      - delayed_on: 50ms  # Motion must be HIGH for 50ms before triggering ON
      - delayed_off: 10s  # Motion must be LOW for 10s before triggering OFF

    # Automations on motion events
    on_press:
      - logger.log: "Motion detected!"
      # Add actions here (e.g., turn on lights)

    on_release:
      - logger.log: "No motion for 10 seconds"
      # Add actions here (e.g., turn off lights after delay)

# Optional: Count motion events
sensor:
  - platform: template
    name: "Motion Count Today"
    id: motion_count
    unit_of_measurement: "events"
    accuracy_decimals: 0
    lambda: |-
      static int count = 0;
      return count;

  # Reset count at midnight
  - platform: template
    name: "Reset Motion Count"
    lambda: return 0;
    update_interval: never

# Automation: Increment count on motion
binary_sensor:
  # (Add to existing motion sensor above)
  on_press:
    - lambda: |-
        auto count_sensor = id(motion_count);
        count_sensor->publish_state(count_sensor->state + 1);
```

---

## Understanding the Code

### Binary Sensor Platform

```yaml
binary_sensor:
  - platform: gpio       # Read GPIO pin as binary (HIGH/LOW)
    pin: GPIO4           # Pin number
    device_class: motion # Icon and category in Home Assistant
```

**Device Classes:**
- `motion` - Motion sensor icon (person walking)
- `occupancy` - Occupancy icon (person in room)
- `door` - Door icon (open/closed)
- `window` - Window icon
- `safety` - Safety icon (alarm)

### Filters: Debouncing

```yaml
filters:
  - delayed_on: 50ms   # Delay before triggering ON
  - delayed_off: 10s   # Delay before triggering OFF
```

**Why Debouncing?**

**Problem without filters:**
```
PIR Output:  HIGH ↔ LOW ↔ HIGH ↔ LOW (bouncing/flickering)
HA Sensor:   ON → OFF → ON → OFF → ON (annoying, triggers many automations)
```

**With `delayed_on: 50ms`:**
```
PIR Output:  HIGH (for 50ms+) → triggers ON
PIR Output:  HIGH (for 20ms) → ignored (too short, likely noise)
```

**With `delayed_off: 10s`:**
```
PIR Output:  HIGH → LOW (for 5s) → still shows "motion detected" in HA
PIR Output:  HIGH → LOW (for 10s+) → now shows "no motion" in HA
```

**Benefits:**
- Prevents flickering lights (stays on for 10s minimum)
- Ignores false triggers (electrical noise, insects near sensor)
- Smoother automations (fewer state changes)

**Adjusting Delays:**
- **Small room:** `delayed_off: 30s` (bathroom, hallway)
- **Large room:** `delayed_off: 2min` (living room, office)
- **Outdoor:** `delayed_off: 5s` (driveway, mailbox alerts)

### On Press / On Release Actions

```yaml
on_press:   # Triggered when motion detected (LOW → HIGH)
  - logger.log: "Motion detected!"
  - light.turn_on: living_room_lights

on_release: # Triggered when no motion (HIGH → LOW, after delayed_off)
  - logger.log: "No motion"
  - light.turn_off: living_room_lights
```

**Note:** `on_release` respects `delayed_off` filter - won't trigger until 10s of no motion.

---

## Step-by-Step Build Guide

### Step 1: Adjust HC-SR501 Settings (If Using HC-SR501)

Before wiring, configure the sensor:

1. **Sensitivity Pot:** Turn to mid-position (12 o'clock)
2. **Time Delay Pot:** Turn fully counter-clockwise (minimum, ~3s)
   - We'll handle delays in ESPHome, not the sensor
3. **Jumper:** Set to "H" (repeatable trigger mode) if available

### Step 2: Wire the Sensor

1. Connect HC-SR501 **VCC** to ESP32 **5V**
2. Connect HC-SR501 **OUT** to ESP32 **GPIO4**
3. Connect HC-SR501 **GND** to ESP32 **GND**
4. Double-check connections

### Step 3: Flash ESP32

1. Access ESPHome dashboard: http://192.168.40.201:6052
2. Create new device: `motion-sensor-1`
3. Copy configuration above
4. Flash via USB
5. Check logs for successful connection

### Step 4: Test Motion Detection

1. **Watch Logs:**
   - Click "**LOGS**" in ESPHome dashboard
   - Wave hand in front of sensor (10-20cm away)
   - Look for: `[D][binary_sensor:036]: 'Motion Detected': ON`

2. **Verify Delay:**
   - Trigger motion, then stay still
   - After 10 seconds of no motion, should see: `OFF`

3. **Sensitivity Test:**
   - Walk across room at different distances
   - Adjust sensitivity pot if needed (increase range clockwise)

### Step 5: Add to Home Assistant

1. Auto-discovery: **Settings → Integrations → ESPHome**
2. Configure `motion-sensor-1`
3. Find entity: `binary_sensor.motion_detected`

### Step 6: Dashboard Card

1. **Overview → Edit Dashboard → Add Card**
2. Card Type: "**Entity**" or "**Sensor**"
3. Entity: `binary_sensor.motion_detected`
4. Show State: Enable
5. Icon: `mdi:motion-sensor` (auto-set with `device_class: motion`)

---

## Troubleshooting

### Sensor always shows "Detected" (stuck ON)

**Cause 1: Warm-up Period**
- HC-SR501 needs 30-60 seconds after power-on to calibrate
- Wait 1 minute, then test again

**Cause 2: Continuous Motion**
- Air from HVAC vents triggering sensor
- Pets or moving objects (curtains, fans) in detection zone
- Try moving sensor to different location

**Cause 3: Sensitivity Too High**
- Turn sensitivity pot counter-clockwise (reduce range)
- Aim sensor away from windows (sunlight changes IR levels)

**Cause 4: Faulty Sensor**
- Try different PIR sensor
- Check if OUT pin always reads HIGH (use multimeter)

### Sensor never triggers (stuck OFF)

**Cause 1: Wiring**
- Verify VCC connected to 5V (not 3.3V)
- Check OUT connected to GPIO4
- Ensure GND connected

**Cause 2: Power Issue**
- HC-SR501 draws ~50mA, ESP32 5V pin may not supply enough
- Try powering HC-SR501 from external 5V source (share GND)

**Cause 3: Sensitivity Too Low**
- Turn sensitivity pot clockwise (increase range)
- Get closer to sensor (within 1 meter)

**Cause 4: Jumper in Wrong Mode**
- Set jumper to "H" (repeatable trigger) if available

### False Triggers (Random Motion Detections)

**Cause 1: Electrical Noise**
- Add `delayed_on: 100ms` (increase from 50ms)
- Use shorter jumper wires
- Keep PIR sensor away from WiFi router

**Cause 2: Environmental**
- Heating/cooling vents blowing warm air
- Sunlight through windows (IR changes)
- Reflective surfaces (mirrors, glass)

**Fix:**
- Relocate sensor away from vents/windows
- Point sensor at specific area (not whole room)
- Add physical barrier (cardboard) to block unwanted detection zones

### Motion not detected at edges of room

**Cause:** Sensor detection angle is ~120° cone, not full 360°.

**Fix:**
- Adjust sensor orientation (aim toward center of room)
- Increase sensitivity (turn pot clockwise)
- Use multiple PIR sensors for full coverage

---

## Creating Automations

### Automation 1: Motion-Activated Lights

Turn on lights when motion detected (only at night).

```yaml
alias: "Motion Lights - Living Room"
trigger:
  - platform: state
    entity_id: binary_sensor.motion_detected
    to: "on"
condition:
  # Only activate between sunset and sunrise
  - condition: sun
    after: sunset
    before: sunrise
action:
  - service: light.turn_on
    target:
      entity_id: light.living_room_lights
    data:
      brightness_pct: 80  # 80% brightness

# Auto-off when no motion for 5 minutes
- alias: "Motion Lights Off"
  trigger:
    - platform: state
      entity_id: binary_sensor.motion_detected
      to: "off"
      for:
        minutes: 5
  action:
    - service: light.turn_off
      target:
        entity_id: light.living_room_lights
```

### Automation 2: Security Alert (When Away)

Send notification if motion detected while away from home.

```yaml
alias: "Security Alert - Motion While Away"
trigger:
  - platform: state
    entity_id: binary_sensor.motion_detected
    to: "on"
condition:
  # Only trigger when no one is home
  - condition: state
    entity_id: group.family
    state: "not_home"
action:
  # Send notification
  - service: notify.mobile_app
    data:
      title: "⚠️ Motion Detected!"
      message: "Motion in Living Room at {{ now().strftime('%I:%M %p') }}"

  # Optional: Turn on lights (scare intruders)
  - service: light.turn_on
    target:
      entity_id: light.all_lights

  # Optional: Capture camera snapshot (if you have cameras)
  # - service: camera.snapshot
  #   target:
  #     entity_id: camera.living_room
  #   data:
  #     filename: /config/www/snapshots/motion_{{ now().timestamp() }}.jpg
```

### Automation 3: Bathroom Exhaust Fan

Run fan when motion detected, keep running for 10 minutes after.

```yaml
alias: "Bathroom Fan - Motion Triggered"
trigger:
  - platform: state
    entity_id: binary_sensor.motion_detected_bathroom
    to: "on"
action:
  - service: switch.turn_on
    target:
      entity_id: switch.bathroom_exhaust_fan

# Turn off fan 10 minutes after last motion
- alias: "Bathroom Fan Off"
  trigger:
    - platform: state
      entity_id: binary_sensor.motion_detected_bathroom
      to: "off"
      for:
        minutes: 10
  action:
    - service: switch.turn_off
      target:
        entity_id: switch.bathroom_exhaust_fan
```

### Automation 4: Nightlight Mode

Dim lights to 10% between 10 PM - 6 AM (night mode).

```yaml
alias: "Night Mode Motion Lights"
trigger:
  - platform: state
    entity_id: binary_sensor.motion_detected
    to: "on"
condition:
  - condition: time
    after: "22:00:00"  # After 10 PM
    before: "06:00:00"  # Before 6 AM
action:
  - service: light.turn_on
    target:
      entity_id: light.living_room_lights
    data:
      brightness_pct: 10  # Very dim (10%)
      transition: 1       # Fade in over 1 second
```

---

## Next Steps & Enhancements

### Enhancement 1: Multiple PIR Sensors (Room Coverage)

Add 2-3 PIR sensors for full room coverage:

```yaml
binary_sensor:
  - platform: gpio
    pin: GPIO4
    name: "Motion - North Side"
    id: motion_north

  - platform: gpio
    pin: GPIO5
    name: "Motion - South Side"
    id: motion_south

  # Combined sensor: Any motion triggers
  - platform: template
    name: "Motion - Any"
    device_class: motion
    lambda: |-
      return id(motion_north).state || id(motion_south).state;
```

### Enhancement 2: Occupancy Detection (Person Counting)

Track entry/exit to count people in room:

```yaml
binary_sensor:
  - platform: gpio
    pin: GPIO4
    name: "Motion - Entry"
    id: entry_sensor

  - platform: gpio
    pin: GPIO5
    name: "Motion - Exit"
    id: exit_sensor

# Count people entering/exiting
sensor:
  - platform: template
    name: "Room Occupancy"
    unit_of_measurement: "people"
    lambda: |-
      static int count = 0;
      if (id(entry_sensor).state && !id(exit_sensor).state) {
        count++;
      } else if (id(exit_sensor).state && !id(entry_sensor).state) {
        count = max(0, count - 1);
      }
      return count;
```

### Enhancement 3: Light Level Integration

Only activate lights if room is dark (add LDR light sensor):

```yaml
sensor:
  - platform: adc
    pin: GPIO34
    name: "Light Level"
    id: light_level
    unit_of_measurement: "%"
    filters:
      - calibrate_linear:
          - 0.0 -> 0.0    # Dark
          - 3.3 -> 100.0  # Bright

# Automation: Only trigger if room is dark
condition:
  - condition: numeric_state
    entity_id: sensor.light_level
    below: 30  # Less than 30% brightness
```

### Enhancement 4: Radar Sensor (mmWave)

Upgrade to mmWave radar (detects stationary presence):

- **PIR:** Detects motion only (can't detect sitting still)
- **mmWave:** Detects presence even when stationary (breathing, small movements)

**Recommended Modules:**
- LD2410 (UART, ~$15)
- RCWL-0516 (simpler, ~$3)

See [Project 7: Door/Window Sensors](07-door-window-sensors.md) for mmWave radar setup.

---

## What You've Learned

By completing this project, you now understand:

✅ **PIR Sensors:**
- How passive infrared motion detection works
- Detection range and angle limitations
- Sensitivity and delay adjustments

✅ **Binary Sensors:**
- GPIO input reading
- Device classes (motion, occupancy, door, etc.)
- State changes (on_press, on_release)

✅ **Filtering and Debouncing:**
- `delayed_on` and `delayed_off` filters
- Noise rejection strategies
- Smooth automation triggers

✅ **Motion Automations:**
- Motion-activated lighting
- Security alerts when away
- Occupancy-based climate control

✅ **ESPHome Automations:**
- Local on-device automations (faster response)
- Integration with Home Assistant automations
- Combining multiple sensors (AND/OR logic)

**Ready for the next project?** Try [Project 5: Environmental Monitoring Station](05-environmental-station.md) for multi-sensor integration!
