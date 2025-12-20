# Project 13: Outdoor Weather Station

**Difficulty:** Advanced
**Estimated Time:** 8-12 hours
**Cost:** $60-100

## Learning Objectives

By completing this project, you will learn:
- Pulse counting for rain gauge and anemometer
- Analog reading for wind direction (resistor ladder)
- Deep sleep optimization for solar/battery operation
- Weatherproof enclosure design (IP67 rating)
- Solar charging circuit with battery management
- Interrupt-based wake-up systems
- Long-term outdoor sensor reliability
- Weather forecasting from barometric pressure trends

---

## Parts List

| Part | Quantity | Approximate Cost (CAD) | Notes |
|------|----------|------------------------|-------|
| ESP32 Development Board | 1 | $8-12 | Deep sleep capable |
| BME280 Sensor (I2C) | 1 | $12-18 | Temp, humidity, pressure |
| Tipping Bucket Rain Gauge | 1 | $25-35 | 0.2794mm per tip standard |
| Anemometer (Cup Type) | 1 | $15-25 | Reed switch, pulse output |
| Wind Vane (8-direction) | 1 | $10-15 | Resistor ladder output |
| Solar Panel (6V 1W) | 1 | $10-15 | Battery charging |
| 18650 Li-ion Battery Holder | 1 | $5-8 | 2× 18650 cells (parallel) |
| 18650 Batteries (3000mAh) | 2 | $15-20 | Samsung or Panasonic |
| TP4056 Charging Module | 1 | $2-3 | With battery protection |
| Schottky Diode (1N5819) | 1 | $0.50 | Reverse current protection |
| Weatherproof Enclosure (IP67) | 1 | $15-25 | ABS plastic, 150×100×70mm |
| Cable Glands (PG7) | 4-6 | $5-8 | Waterproof cable entry |
| Silicone Sealant | 1 | $5-8 | Marine-grade RTV |

**Total Cost:** ~$60-100

**Optional Upgrades:**
- **UV Sensor (VEML6075):** $8-12 - UV index measurement
- **Light Sensor (BH1750):** $3-5 - Lux measurement
- **Larger Solar Panel (6V 2W):** $15-20 - Faster charging
- **Larger Battery (3× 18650):** +$10 - Extended runtime

---

## Understanding the Parts

### Tipping Bucket Rain Gauge

**How it works:**
- **Funnel:** Collects rainwater into calibrated bucket
- **Seesaw mechanism:** Bucket tips when filled (typically 0.2794mm rainfall)
- **Reed switch:** Magnet on bucket triggers switch each tip
- **Debounce:** Each tip = 1 pulse (count pulses = rainfall)

**Specifications:**
- **Resolution:** 0.2794mm (0.011 inches) per tip
- **Accuracy:** ±4% at 25mm/hr rainfall rate
- **Max rate:** 200mm/hr (heavy storm)
- **Pulses per hour:** Rainfall (mm/hr) ÷ 0.2794

**Calibration:**
- Pour known volume: 100ml water
- Count tips (should be ~128 tips for 100ml in 200cm² funnel)
- Adjust multiplier in ESPHome if needed

**Installation:**
- Mount level (use bubble level - critical for accuracy!)
- Clear 2m radius (no obstructions overhead)
- Height: 1-1.5m above ground (standard)
- Secure against wind (stakes or mounting bracket)

### Anemometer (Wind Speed)

**How it works:**
- **Rotating cups:** Wind spins 3-cup assembly
- **Magnets:** Permanent magnets on shaft
- **Reed switch:** Closes once per revolution
- **Frequency → Speed:** Pulses per second × calibration factor = wind speed

**Typical Calibration:**
- **1 pulse = 2.4 km/h** (common cheap anemometers)
- **Formula:** Wind Speed (km/h) = Pulses/second × 2.4
- **Better models:** 1 revolution = 1.492 mph (2.4 km/h)

**Installation Requirements:**
- **Height:** 10m (33 ft) standard, minimum 2-3m for home use
- **Clearance:** 10m radius free of obstructions (trees, buildings)
- **Mounting:** Secure pole, vertical alignment critical
- **Wind direction:** Anemometer should be omnidirectional (cups work from any angle)

**Calibration Method:**
1. Drive car at known speed (50 km/h) with anemometer out window
2. Count pulses per second
3. Calculate: Calibration = 50 km/h ÷ (pulses/sec)

### Wind Vane (Direction Sensor)

**How it works:**
- **Resistor ladder:** 8 positions (N, NE, E, SE, S, SW, W, NW)
- **Each direction:** Different resistance → different voltage
- **ADC reading:** ESP32 measures voltage, maps to direction

**Typical Resistance Values (varies by model):**
| Direction | Resistance (Ω) | Voltage (3.3V, 10kΩ pullup) |
|-----------|----------------|------------------------------|
| N (0°) | 33kΩ | 2.53V |
| NE (45°) | 6.57kΩ | 1.31V |
| E (90°) | 8.2kΩ | 1.56V |
| SE (135°) | 891Ω | 0.22V |
| S (180°) | 1kΩ | 0.24V |
| SW (225°) | 688Ω | 0.18V |
| W (270°) | 2.2kΩ | 0.51V |
| NW (315°) | 1.41kΩ | 0.34V |

**Circuit:**
```
3.3V ──[10kΩ]──┬──> ESP32 GPIO34 (ADC)
               │
          Wind Vane (variable resistor)
               │
              GND
```

**Calibration Procedure:**
1. Point vane to magnetic north (use compass)
2. Read ADC voltage in ESPHome logs
3. Record voltage for all 8 directions
4. Create lookup table in lambda function

### Solar Power System

**System Architecture:**
```
Solar Panel (6V 1W)
    |
    [1N5819 Diode] ──> Prevents reverse current at night
    |
TP4056 Charging Module
    |
    ├──> 18650 Batteries (2× 3000mAh parallel = 6000mAh)
    |
    └──> ESP32 5V input (via LDO regulator on TP4056)
```

**Power Budget:**
| Mode | Current | Duration | Daily Energy |
|------|---------|----------|--------------|
| Deep Sleep | 10μA | 23h 55m | 0.24 mAh |
| Wake + Measure | 150mA | 5 min/day | 12.5 mAh |
| WiFi Transmit | 200mA | 30s × 12/day | 2 mAh |
| **Total Daily** | | | **~15 mAh/day** |

**Battery Life:**
- 6000 mAh ÷ 15 mAh/day = **400 days** (no solar)
- With solar (4 hrs sun/day): **Indefinite**

**Solar Charging:**
- 1W panel ÷ 6V = 167 mA charging current
- 4 hours sun × 167 mA = **668 mAh/day** (far exceeds consumption)

### Weatherproof Enclosure Design

**IP Rating Explained:**
- **IP67:** Dust-tight (6) + Submersion to 1m (7)
- **IP65:** Dust-tight (6) + Water jets (5) - acceptable
- **IP55:** Dust-protected (5) + Water jets (5) - minimum

**Weatherproofing Steps:**

1. **Cable Glands:** PG7 or PG9 for all wire entries
2. **Silicone Sealant:** Marine-grade RTV around all openings
3. **Sensor Mounting:**
   - BME280: Inside enclosure, with ventilation holes (1-2mm, facing down)
   - Rain gauge: External, connected via cable gland
   - Anemometer/vane: Mounted on top of pole, wires down to enclosure
4. **Ventilation:** Small (1-2mm) holes at bottom for pressure equalization (prevents condensation)
5. **Desiccant Pack:** Silica gel inside enclosure (absorbs moisture)

**Mounting:**
- **Pole mount:** 2-3m PVC or metal pole
- **Bracket:** U-bolts or pole clamps
- **Grounding:** Optional lightning protection (ground rod + wire)

---

## Wiring Diagram

### Complete Weather Station Circuit

```
ESP32 Board         BME280      Rain Gauge    Anemometer    Wind Vane

        I2C Bus (BME280)
GPIO21 (SDA) ──────> SDA
GPIO22 (SCL) ──────> SCL
3.3V ──────────────> VCC
GND ───────────────> GND

        Rain Gauge (Pulse Counter)
GPIO12 ────────────────────────> Reed Switch Pin 1
                                  Reed Switch Pin 2 ──> GND
(Internal pull-up enabled)

        Anemometer (Pulse Counter)
GPIO14 ────────────────────────> Reed Switch Pin 1
                                  Reed Switch Pin 2 ──> GND
(Internal pull-up enabled)

        Wind Vane (ADC + Resistor Ladder)
GPIO34 (ADC) ──┬─[10kΩ]─── 3.3V
               │
               └──────────────> Wind Vane (variable R)
                                  Wind Vane GND ──> GND

        Solar Power System
Solar Panel (+) ──[1N5819]──> TP4056 IN+
Solar Panel (-) ────────────> TP4056 IN-

TP4056 BAT+ ────────────────> 18650 Battery (+)
TP4056 BAT- ────────────────> 18650 Battery (-)

TP4056 OUT+ ────────────────> ESP32 5V
TP4056 OUT- ────────────────> ESP32 GND

        Battery Voltage Monitor (ADC)
GPIO35 (ADC) ──┬─[10kΩ]─── Battery (+)
               │
               └─[10kΩ]─── GND
(Voltage divider: reads battery voltage ÷ 2)
```

---

## ESPHome Configuration

Create a new file: `/home/hazzard/home-assistant/esphome/weather-station.yaml`

### Complete Configuration

```yaml
esphome:
  name: weather-station
  friendly_name: "Outdoor Weather Station"
  platform: ESP32
  board: esp32dev
  on_boot:
    - priority: 200
      then:
        - delay: 30s  # Allow sensors to stabilize
        - logger.log: "Weather station online"

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  fast_connect: true  # Skip channel scan (faster wake)

  manual_ip:
    static_ip: 192.168.40.185
    gateway: 192.168.40.1
    subnet: 255.255.255.0
    dns1: 8.8.8.8

  ap:
    ssid: "Weather-Station-FB"
    password: "12345678"

logger:
  level: INFO

api:
  encryption:
    key: !secret api_key_weather_station

ota:
  - platform: esphome
    password: !secret ota_password

# Deep Sleep Configuration (Optional - for battery operation)
deep_sleep:
  id: deep_sleep_control
  run_duration: 60s       # Wake for 60 seconds
  sleep_duration: 5min    # Sleep for 5 minutes
  wakeup_pin: GPIO33      # Wake on rain (optional)
  wakeup_pin_mode: KEEP_AWAKE

# I2C Bus for BME280
i2c:
  sda: GPIO21
  scl: GPIO22
  scan: true
  frequency: 100kHz

# BME280 Sensor (Temperature, Humidity, Pressure)
sensor:
  - platform: bme280
    temperature:
      name: "Outdoor Temperature"
      id: outdoor_temp
      oversampling: 16x
      filters:
        - filter_out: nan
        - sliding_window_moving_average:
            window_size: 5
            send_every: 1
    humidity:
      name: "Outdoor Humidity"
      id: outdoor_humidity
      oversampling: 16x
      filters:
        - filter_out: nan
        - sliding_window_moving_average:
            window_size: 5
            send_every: 1
    pressure:
      name: "Atmospheric Pressure"
      id: atm_pressure
      oversampling: 16x
      filters:
        - filter_out: nan
        - sliding_window_moving_average:
            window_size: 5
            send_every: 1
    address: 0x76
    update_interval: 60s

  # Rain Gauge (Tipping Bucket - Pulse Counter)
  - platform: pulse_counter
    pin:
      number: GPIO12
      mode:
        input: true
        pullup: true
    name: "Rainfall Rate"
    id: rainfall_rate
    unit_of_measurement: "mm/h"
    icon: "mdi:weather-rainy"
    count_mode:
      rising_edge: INCREMENT
      falling_edge: DISABLE
    update_interval: 60s
    filters:
      # Convert pulses/min to mm/h
      # Each tip = 0.2794mm, so pulses/min × 0.2794 × 60 = mm/h
      - multiply: 16.764  # (0.2794 × 60)

    # Total rainfall accumulation
    total:
      name: "Total Rainfall"
      id: total_rainfall
      unit_of_measurement: "mm"
      icon: "mdi:weather-pouring"
      filters:
        - multiply: 0.2794  # Each pulse = 0.2794mm

  # Anemometer (Wind Speed - Pulse Counter)
  - platform: pulse_counter
    pin:
      number: GPIO14
      mode:
        input: true
        pullup: true
    name: "Wind Speed"
    id: wind_speed
    unit_of_measurement: "km/h"
    icon: "mdi:weather-windy"
    count_mode:
      rising_edge: INCREMENT
      falling_edge: DISABLE
    update_interval: 10s
    filters:
      # Calibration: pulses/sec × 2.4 = km/h (adjust for your anemometer)
      - multiply: 2.4

  # Wind Gust (Maximum wind speed in update interval)
  - platform: template
    name: "Wind Gust"
    unit_of_measurement: "km/h"
    icon: "mdi:weather-windy-variant"
    lambda: |-
      static float max_wind = 0;
      float current = id(wind_speed).state;
      if (current > max_wind) max_wind = current;
      return max_wind;
    update_interval: 60s

  # Wind Direction (ADC + Resistor Ladder)
  - platform: adc
    pin: GPIO34
    name: "Wind Direction Raw"
    id: wind_dir_raw
    update_interval: 10s
    attenuation: 11db
    filters:
      - sliding_window_moving_average:
          window_size: 5
          send_every: 1

  # Wind Direction (Degrees)
  - platform: template
    name: "Wind Direction"
    id: wind_direction
    unit_of_measurement: "°"
    icon: "mdi:compass"
    accuracy_decimals: 0
    lambda: |-
      float voltage = id(wind_dir_raw).state;

      // Voltage-to-direction mapping (calibrate for your vane!)
      // These are example values - YOU MUST CALIBRATE YOUR VANE
      if (voltage < 0.2) return 315;   // NW
      if (voltage < 0.3) return 270;   // W
      if (voltage < 0.5) return 225;   // SW
      if (voltage < 0.7) return 180;   // S
      if (voltage < 1.0) return 135;   // SE
      if (voltage < 1.5) return 90;    // E
      if (voltage < 2.0) return 45;    // NE
      return 0;                        // N
    update_interval: 10s

  # Wind Direction (Cardinal - N, NE, E, etc.)
  - platform: template
    name: "Wind Direction Cardinal"
    lambda: |-
      int degrees = (int)id(wind_direction).state;
      const char* directions[] = {"N", "NE", "E", "SE", "S", "SW", "W", "NW"};
      int index = ((degrees + 22) / 45) % 8;
      return {directions[index]};
    update_interval: 10s

  # Battery Voltage Monitoring (Voltage Divider)
  - platform: adc
    pin: GPIO35
    name: "Battery Voltage"
    id: battery_voltage
    update_interval: 60s
    attenuation: 11db
    filters:
      - multiply: 2.0  # Voltage divider (10kΩ + 10kΩ)
      - sliding_window_moving_average:
          window_size: 3
          send_every: 1

  # Battery Percentage
  - platform: template
    name: "Battery Percentage"
    unit_of_measurement: "%"
    icon: "mdi:battery"
    accuracy_decimals: 0
    lambda: |-
      // Li-ion voltage range: 3.0V (empty) to 4.2V (full)
      float voltage = id(battery_voltage).state;
      if (voltage < 3.0) return 0;
      if (voltage > 4.2) return 100;
      return ((voltage - 3.0) / 1.2) * 100;
    update_interval: 60s

  # Calculated: Dew Point
  - platform: template
    name: "Dew Point"
    unit_of_measurement: "°C"
    icon: "mdi:water"
    accuracy_decimals: 1
    lambda: |-
      float temp = id(outdoor_temp).state;
      float humidity = id(outdoor_humidity).state;
      if (isnan(temp) || isnan(humidity)) return {};

      // Magnus formula
      float a = 17.27;
      float b = 237.7;
      float alpha = ((a * temp) / (b + temp)) + log(humidity / 100.0);
      return (b * alpha) / (a - alpha);
    update_interval: 60s

  # Calculated: Heat Index (feels like temperature)
  - platform: template
    name: "Heat Index"
    unit_of_measurement: "°C"
    icon: "mdi:thermometer-alert"
    accuracy_decimals: 1
    lambda: |-
      float T = id(outdoor_temp).state;
      float RH = id(outdoor_humidity).state;
      if (isnan(T) || isnan(RH)) return {};

      // Heat index formula (valid for T > 27°C)
      if (T < 27) return T;

      float HI = -8.78469475556 +
                  1.61139411 * T +
                  2.33854883889 * RH +
                  -0.14611605 * T * RH +
                  -0.012308094 * T * T +
                  -0.0164248277778 * RH * RH +
                  0.002211732 * T * T * RH +
                  0.00072546 * T * RH * RH +
                  -0.000003582 * T * T * RH * RH;

      return HI;
    update_interval: 60s

  # WiFi Signal Strength
  - platform: wifi_signal
    name: "WiFi Signal"
    update_interval: 60s

  # Uptime
  - platform: uptime
    name: "Uptime"
    update_interval: 300s

# Binary Sensors
binary_sensor:
  # Rain Detection (based on rainfall rate)
  - platform: template
    name: "Raining"
    id: is_raining
    device_class: moisture
    lambda: |-
      return id(rainfall_rate).state > 0.5;  // > 0.5 mm/h

  # Battery Charging Status (optional, if TP4056 has CHG pin)
  - platform: gpio
    pin:
      number: GPIO25
      mode:
        input: true
        pullup: true
    name: "Solar Charging"
    device_class: battery_charging

# Text Sensors
text_sensor:
  - platform: wifi_info
    ip_address:
      name: "IP Address"

  # Weather Condition (based on sensors)
  - platform: template
    name: "Weather Condition"
    lambda: |-
      bool raining = id(is_raining).state;
      float wind = id(wind_speed).state;

      if (raining && wind > 30) return {"Stormy"};
      if (raining) return {"Rainy"};
      if (wind > 30) return {"Windy"};
      return {"Clear"};
    update_interval: 60s

# Buttons
button:
  - platform: restart
    name: "Restart Device"

  # Reset rainfall counter (daily reset automation)
  - platform: template
    name: "Reset Rainfall Counter"
    on_press:
      - sensor.pulse_counter.set_total_pulses:
          id: rainfall_rate
          value: 0

# Time (for daily rainfall reset)
time:
  - platform: homeassistant
    id: homeassistant_time
    on_time:
      # Reset daily rainfall at midnight
      - hours: 0
        minutes: 0
        seconds: 0
        then:
          - sensor.pulse_counter.set_total_pulses:
              id: rainfall_rate
              value: 0
          - logger.log: "Daily rainfall counter reset"
```

---

## Step-by-Step Build Guide

### Step 1: Calibrate Wind Vane (Indoors)

**Before outdoor installation, map voltage to direction:**

1. Wire wind vane to ESP32 (GPIO34 + voltage divider)
2. Flash minimal config with `adc` sensor only
3. Point vane to each direction, record voltages:
   ```
   North:     ___V
   Northeast: ___V
   East:      ___V
   Southeast: ___V
   South:     ___V
   Southwest: ___V
   West:      ___V
   Northwest: ___V
   ```
4. Update lambda in `wind_direction` sensor with your voltages

### Step 2: Test Rain Gauge (Indoors)

**Pour measured water, count tips:**

1. Wire rain gauge to GPIO12
2. Flash config with `pulse_counter` for rainfall
3. Pour 100ml water slowly into funnel
4. Count total tips in logs
5. **Expected:** ~128 tips for 100ml (varies by funnel size)
6. Verify `multiply: 0.2794` gives correct total mm

### Step 3: Test Anemometer (Hand Spin)

**Manual rotation test:**

1. Wire anemometer to GPIO14
2. Flash config with `pulse_counter` for wind speed
3. Spin cups by hand (count rotations)
4. **Expected:** Pulses = rotations (1 pulse per revolution)
5. Verify calibration: `multiply: 2.4` (adjust if needed)

### Step 4: Assemble Solar Power System

**Battery + Charging Circuit:**

1. **Wire TP4056:**
   - Solar panel (+) → Diode anode
   - Diode cathode → TP4056 IN+
   - Solar panel (-) → TP4056 IN-
   - 18650 batteries (+) → TP4056 BAT+
   - 18650 batteries (-) → TP4056 BAT-

2. **Test charging:**
   - Place solar panel in sun
   - TP4056 LED should light (red = charging, blue = charged)

3. **Connect to ESP32:**
   - TP4056 OUT+ → ESP32 5V
   - TP4056 OUT- → ESP32 GND

4. **Test battery monitoring:**
   - Read `sensor.battery_voltage` in HA
   - Should show 3.7-4.2V (Li-ion range)

### Step 5: Weatherproof Enclosure Assembly

**Enclosure preparation:**

1. **Drill holes:**
   - 4× cable gland holes (PG7 size: 12-13mm)
   - 2-3× ventilation holes (1-2mm, bottom of enclosure, facing down)

2. **Install cable glands:**
   - Insert glands through holes
   - Tighten lock nuts from inside
   - Apply silicone sealant around threads

3. **Mount components inside:**
   - ESP32 on standoffs (M3 screws)
   - TP4056 module secured
   - Batteries in holder
   - Desiccant pack in corner

4. **Route cables:**
   - BME280: Short cable, stays inside (sensor near vent holes)
   - Rain gauge: Through cable gland
   - Anemometer: Through cable gland
   - Wind vane: Through cable gland
   - Solar panel: Through cable gland

5. **Seal:**
   - Apply silicone around all cable gland entries
   - Seal enclosure lid with gasket or silicone bead

### Step 6: Outdoor Installation

**Mounting location selection:**

- **Sun exposure:** 4+ hours direct sun for solar panel
- **Wind clearance:** 10m radius free of obstructions (or as clear as possible)
- **Rain clearance:** 2m radius above rain gauge (no tree branches)
- **WiFi range:** Within reach of home WiFi (or use external antenna)

**Mounting procedure:**

1. **Pole installation:**
   - 2-3m PVC pipe or metal pole
   - Dig 50cm hole, cement base
   - Pole vertical (use level)

2. **Sensor mounting:**
   - Anemometer: Top of pole (highest point)
   - Wind vane: Below anemometer (10cm clearance)
   - Rain gauge: Bracket on side (level!)
   - Enclosure: Mid-pole (U-bolt clamps)
   - Solar panel: Facing south, angled ~45° (latitude angle)

3. **Cable routing:**
   - Run all sensor cables down pole
   - Zip-tie or spiral wrap
   - Enter enclosure through cable glands

4. **Alignment:**
   - Wind vane: Point north using compass
   - Rain gauge: Level (use bubble level)
   - Solar panel: South-facing, tilted

### Step 7: Testing and Verification

**Complete system test:**

1. **Power on:** Verify battery voltage, solar charging
2. **BME280:** Check temperature, humidity, pressure (reasonable values)
3. **Rain gauge:** Pour water, verify tips counted
4. **Anemometer:** Blow on cups, verify wind speed increases
5. **Wind vane:** Rotate, verify direction changes
6. **WiFi:** Confirm connection, data in Home Assistant

**Long-term monitoring:**
- Check battery voltage daily for first week
- Verify solar charging during sunny days
- Monitor rain gauge accuracy vs local weather station
- Calibrate wind speed vs Weather Underground data

---

## Troubleshooting

### Rain Gauge Not Counting

**Cause:** Wiring, magnet alignment, or debris in bucket

**Fix:**
1. Manually tip bucket, check for switch click
2. Verify GPIO12 pull-up enabled
3. Clean debris from funnel/bucket
4. Check magnet proximity to reed switch

### Anemometer Reads Zero in Wind

**Cause:** Reed switch failure or wiring issue

**Fix:**
1. Manually spin cups, check pulse count in logs
2. Verify GPIO14 connection
3. Test reed switch with multimeter (continuity test)
4. Replace anemometer if switch failed

### Wind Direction Stuck or Random

**Cause:** ADC noise or resistor ladder fault

**Fix:**
1. Check voltage divider (10kΩ resistor in place)
2. Add capacitor (0.1μF) across ADC input to GND (filters noise)
3. Recalibrate voltage-to-direction mapping
4. Test vane continuity (should vary with rotation)

### Battery Drains Overnight

**Cause:** Solar not charging or deep sleep disabled

**Fix:**
1. Verify solar panel voltage (6V in sun)
2. Check diode orientation (cathode to TP4056 IN+)
3. Enable deep sleep if not already
4. Increase sleep duration: `sleep_duration: 10min`

### BME280 Reads Incorrect (Too Hot/Humid)

**Cause:** Enclosure heat or poor ventilation

**Fix:**
1. Add more ventilation holes (facing down to prevent rain entry)
2. Paint enclosure white (reflects heat)
3. Add sun shield over enclosure
4. Calibration offset in filters: `offset: -2.0` (for temperature)

---

## Advanced Features

### Weather Forecasting from Pressure Trends

**3-hour pressure change:**
```yaml
sensor:
  - platform: template
    name: "Pressure Trend (3h)"
    unit_of_measurement: "hPa"
    lambda: |-
      static float pressure_3h_ago = 0;
      static unsigned long last_save = 0;
      unsigned long now = millis();

      if (now - last_save > 10800000) {  // 3 hours
        pressure_3h_ago = id(atm_pressure).state;
        last_save = now;
      }

      return id(atm_pressure).state - pressure_3h_ago;

text_sensor:
  - platform: template
    name: "Weather Forecast"
    lambda: |-
      float trend = id(pressure_trend_3h).state;
      if (trend > 2.0) return {"Improving (Rising pressure)"};
      if (trend < -2.0) return {"Deteriorating (Storm likely)"};
      return {"Stable"};
```

### Lightning Detection (Optional: AS3935)

**Add lightning sensor module:**
```yaml
sensor:
  - platform: as3935
    lightning_energy:
      name: "Lightning Energy"
    distance:
      name: "Lightning Distance"
```

### Soil Moisture Integration

**Add to garden monitoring:**
```yaml
sensor:
  - platform: adc
    pin: GPIO36
    name: "Soil Moisture"
    filters:
      - calibrate_linear:
          - 2.8 -> 0    # Dry
          - 1.2 -> 100  # Wet
```

---

## What You've Learned

By completing this project, you now understand:

✅ **Pulse Counting:**
- Rain gauge and anemometer pulse measurement
- Interrupt-based counting for accuracy
- Calibration and conversion formulas

✅ **Analog Sensing:**
- Resistor ladder for wind direction
- ADC noise filtering
- Voltage-to-value mapping

✅ **Solar Power:**
- Li-ion charging with TP4056
- Battery capacity calculation
- Power budget optimization

✅ **Deep Sleep:**
- Ultra-low power operation
- Wake-up strategies
- Battery life maximization

✅ **Weatherproofing:**
- IP67 enclosure design
- Cable gland installation
- Moisture prevention

✅ **Weather Science:**
- Dew point and heat index calculations
- Barometric pressure forecasting
- Wind chill and apparent temperature

**Ready for Project 14?** Build a [Mailbox Notification System](14-mailbox-notification.md) with ultra-low power!
