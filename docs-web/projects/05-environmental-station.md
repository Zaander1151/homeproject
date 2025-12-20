# Project 5: Environmental Monitoring Station

**Difficulty:** Intermediate
**Estimated Time:** 3-5 hours
**Cost:** $25-40

## Learning Objectives

By completing this project, you will learn:
- I2C communication protocol (multiple devices on 2 wires)
- BME280/BME680 sensor integration (temperature, humidity, pressure, air quality)
- OLED display control (SSD1306)
- Local data visualization (displaying sensor readings)
- InfluxDB integration for long-term storage
- Grafana dashboard creation
- Sensor fusion (combining multiple data sources)

---

## Parts List

| Part | Quantity | Approximate Cost (CAD) | Notes |
|------|----------|------------------------|-------|
| ESP32 Development Board | 1 | $8-12 | Reuse from previous projects |
| BME280 Sensor (I2C) | 1 | $12-18 | Temperature, humidity, pressure |
| SSD1306 OLED Display (0.96" I2C) | 1 | $8-12 | 128x64 pixels, white or blue |
| Jumper Wires | 4-6 | Reuse | Male-to-male or female-to-female |
| Breadboard | 1 | Reuse | 400-point or larger |

**Total Cost:** ~$25-40

**Sensor Upgrade Options:**
- **BME680** ($20-25) - Adds air quality (VOC/gas sensor)
- **SHT30** ($15-20) - Higher accuracy temp/humidity (±0.3°C, ±2%)
- **BH1750** ($3-5) - Light sensor (lux)
- **CCS811** ($12-15) - eCO2 and TVOC (air quality)

---

## Understanding the Parts

### BME280 Sensor

**What it measures:**
- **Temperature:** -40°C to +85°C (±1°C accuracy)
- **Humidity:** 0-100% RH (±3% accuracy)
- **Barometric Pressure:** 300-1100 hPa (±1 hPa accuracy)

**How it works:**
- All three sensors integrated in one tiny chip (2.5mm × 2.5mm)
- I2C interface (shares 2 wires with other devices)
- Low power consumption (~3.6μA in sleep mode)

**I2C Address:**
- Default: `0x76` (most modules)
- Alternative: `0x77` (some modules have jumper to change)

**Advantages over DHT22:**
- More accurate temperature (±1°C vs ±2°C)
- Adds barometric pressure (weather prediction!)
- Faster sampling (up to 157 Hz vs 0.5 Hz)
- I2C interface (easier wiring, multiple devices on same bus)

**Applications:**
- Weather stations
- Indoor climate monitoring
- Altitude calculation (pressure → altitude)
- Weather trend prediction (rising/falling pressure)

### BME680 Upgrade (Optional)

Same as BME280, plus:
- **Air Quality:** VOC (Volatile Organic Compounds) sensor
- **Gas Resistance:** Detects gases like ethanol, acetone, CO
- **IAQ Index:** Indoor Air Quality score (0-500)

**Use cases:**
- Detect cooking smoke, cleaning products
- Monitor indoor air quality
- Trigger ventilation when air quality degrades

**Note:** BME680 is more expensive ($20-25 vs $12-18) and requires more complex calibration.

### SSD1306 OLED Display

**Specifications:**
- **Size:** 0.96" diagonal (128x64 pixels)
- **Interface:** I2C (4 pins: VCC, GND, SCL, SDA)
- **Colors:** Monochrome (white, blue, or yellow/blue split)
- **Power:** 3.3V or 5V compatible
- **I2C Address:** `0x3C` (default) or `0x3D`

**Why OLED?**
- **High contrast:** Bright, crisp text (unlike LCD)
- **No backlight needed:** Each pixel emits its own light
- **Wide viewing angle:** 160° (vs 60° for LCD)
- **Fast refresh:** 100+ Hz

**What you can display:**
- Sensor readings (temperature, humidity, pressure)
- Graphs (mini charts)
- Icons (WiFi status, battery, weather symbols)
- Multiple fonts and sizes

### I2C Protocol

**I2C = Inter-Integrated Circuit**

A communication protocol that allows multiple devices to share just 2 wires:
- **SDA (Serial Data):** Bidirectional data line
- **SCL (Serial Clock):** Clock signal from master (ESP32)

**Key Concepts:**
- **Master:** ESP32 (controls the bus)
- **Slaves:** Sensors, displays (respond to master)
- **Addresses:** Each device has unique 7-bit address (0x76, 0x3C, etc.)
- **Pull-up resistors:** Required on SDA and SCL lines (4.7kΩ - 10kΩ)

**Advantages:**
- Only 2 wires for multiple devices (vs 3+ per device for SPI)
- Hot-swappable (can add/remove devices)
- Well-supported by libraries

**Maximum devices:**
- Theoretically: 127 devices (7-bit address = 2^7 = 128 addresses, minus 0x00)
- Practically: 10-20 devices (depends on wire length, capacitance)

---

## Wiring Diagram

### I2C Bus Wiring (BME280 + OLED Display)

```
ESP32 Board                 I2C Bus

GPIO21 (SDA) -------+----> SDA (BME280)
                    |
                    +----> SDA (OLED Display)
                    |
                 4.7kΩ Pull-up Resistor
                    |
                   3.3V

GPIO22 (SCL) -------+----> SCL (BME280)
                    |
                    +----> SCL (OLED Display)
                    |
                 4.7kΩ Pull-up Resistor
                    |
                   3.3V

3.3V ---------------+----> VCC (BME280)
                    |
                    +----> VCC (OLED Display)

GND ----------------+----> GND (BME280)
                    |
                    +----> GND (OLED Display)
```

**Important Notes:**
- Both devices share the same SDA and SCL lines
- Pull-up resistors connect SDA and SCL to 3.3V (4.7kΩ typical)
- Many breakout boards have built-in pull-ups, so external resistors may not be needed
- If both boards have pull-ups, you're effectively using parallel resistors (~2.35kΩ total)

### Pin Connections Table

| ESP32 Pin | I2C Function | BME280 Pin | OLED Pin |
|-----------|--------------|------------|----------|
| GPIO21 | SDA (Data) | SDA | SDA |
| GPIO22 | SCL (Clock) | SCL | SCL |
| 3.3V | Power | VCC | VCC |
| GND | Ground | GND | GND |

**Note:** ESP32 I2C pins are configurable in software. GPIO21/GPIO22 are defaults, but you can use any GPIO pins.

### Breadboard Layout

```
Breadboard Layout:

Row 1:  [BME280 VCC] --- [OLED VCC] --- [Jumper to ESP32 3.3V]
Row 2:  [BME280 GND] --- [OLED GND] --- [Jumper to ESP32 GND]
Row 3:  [BME280 SCL] --- [OLED SCL] --- [4.7kΩ to 3.3V] --- [Jumper to ESP32 GPIO22]
Row 4:  [BME280 SDA] --- [OLED SDA] --- [4.7kΩ to 3.3V] --- [Jumper to ESP32 GPIO21]

Power Rails:
  + Rail: ESP32 3.3V
  - Rail: ESP32 GND
```

---

## ESPHome Configuration

Create a new file: `/home/hazzard/home-assistant/esphome/environmental-station-1.yaml`

### Complete Configuration

```yaml
esphome:
  name: environmental-station-1
  friendly_name: "Living Room Environment"
  platform: ESP32
  board: esp32dev

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password

  manual_ip:
    static_ip: 192.168.40.155
    gateway: 192.168.40.1
    subnet: 255.255.255.0
    dns1: 8.8.8.8

  ap:
    ssid: "Environment-Station-FB"
    password: "12345678"

logger:

api:
  encryption:
    key: !secret api_key_env_station

ota:
  - platform: esphome
    password: !secret ota_password

# I2C Bus Configuration
i2c:
  sda: GPIO21
  scl: GPIO22
  scan: true  # Scan for I2C devices on boot (shows addresses in logs)
  frequency: 100kHz  # Standard I2C speed (can go up to 400kHz for "fast mode")

# Fonts for OLED Display
font:
  - file: "gfonts://Roboto"  # Download from Google Fonts
    id: font_small
    size: 12

  - file: "gfonts://Roboto"
    id: font_medium
    size: 16

  - file: "gfonts://Roboto@700"  # Bold variant
    id: font_large
    size: 24

# BME280 Sensor
sensor:
  # Temperature
  - platform: bme280
    temperature:
      name: "Temperature"
      id: bme280_temp
      oversampling: 16x  # Higher = more accurate, slower
      filters:
        - filter_out: nan
        - sliding_window_moving_average:
            window_size: 5
            send_every: 1

    # Humidity
    humidity:
      name: "Humidity"
      id: bme280_humidity
      oversampling: 16x
      filters:
        - filter_out: nan
        - sliding_window_moving_average:
            window_size: 5
            send_every: 1

    # Pressure
    pressure:
      name: "Pressure"
      id: bme280_pressure
      oversampling: 16x
      filters:
        - filter_out: nan
        - sliding_window_moving_average:
            window_size: 5
            send_every: 1

    address: 0x76  # I2C address (0x76 or 0x77)
    update_interval: 60s

  # Calculated: Altitude from Pressure
  - platform: template
    name: "Altitude"
    id: altitude
    unit_of_measurement: "m"
    icon: "mdi:mountain"
    accuracy_decimals: 1
    lambda: |-
      // Sea level pressure in hPa (adjust for your location)
      const float SEALEVELPRESSURE_HPA = 1013.25;
      float pressure = id(bme280_pressure).state;
      if (isnan(pressure)) return {};
      // Altitude formula: h = 44330 * (1 - (P/P0)^(1/5.255))
      return 44330.0 * (1.0 - pow(pressure / SEALEVELPRESSURE_HPA, 0.1903));
    update_interval: 60s

  # Calculated: Dew Point
  - platform: template
    name: "Dew Point"
    id: dew_point
    unit_of_measurement: "°C"
    icon: "mdi:water"
    accuracy_decimals: 1
    lambda: |-
      float temp = id(bme280_temp).state;
      float humidity = id(bme280_humidity).state;
      if (isnan(temp) || isnan(humidity)) return {};
      // Magnus formula for dew point
      float a = 17.27;
      float b = 237.7;
      float alpha = ((a * temp) / (b + temp)) + log(humidity / 100.0);
      return (b * alpha) / (a - alpha);
    update_interval: 60s

  # WiFi Signal Strength
  - platform: wifi_signal
    name: "WiFi Signal"
    update_interval: 60s

  # Device Uptime
  - platform: uptime
    name: "Uptime"
    update_interval: 300s

# OLED Display (SSD1306)
display:
  - platform: ssd1306_i2c
    model: "SSD1306 128x64"  # Or "SH1106 128x64" for SH1106 displays
    address: 0x3C
    rotation: 0  # 0°, 90°, 180°, 270°
    update_interval: 1s

    lambda: |-
      // Header: Device Name
      it.print(64, 0, id(font_small), TextAlign::TOP_CENTER, "Living Room");

      // Large Temperature Display
      it.printf(64, 16, id(font_large), TextAlign::TOP_CENTER, "%.1f°C", id(bme280_temp).state);

      // Bottom Row: Humidity and Pressure
      it.printf(0, 48, id(font_small), TextAlign::BASELINE_LEFT, "H: %.0f%%", id(bme280_humidity).state);
      it.printf(128, 48, id(font_small), TextAlign::BASELINE_RIGHT, "%.0f hPa", id(bme280_pressure).state);

      // WiFi Signal Indicator (bottom right)
      int rssi = id(wifi_signal).state;
      if (rssi > -60) {
        it.print(128, 64, id(font_small), TextAlign::BASELINE_RIGHT, "●●●");
      } else if (rssi > -70) {
        it.print(128, 64, id(font_small), TextAlign::BASELINE_RIGHT, "●●○");
      } else if (rssi > -80) {
        it.print(128, 64, id(font_small), TextAlign::BASELINE_RIGHT, "●○○");
      } else {
        it.print(128, 64, id(font_small), TextAlign::BASELINE_RIGHT, "○○○");
      }

# Text Sensors for Device Info
text_sensor:
  - platform: wifi_info
    ip_address:
      name: "IP Address"

# Restart Button
button:
  - platform: restart
    name: "Restart Device"
```

---

## Understanding the Code

### I2C Bus Configuration

```yaml
i2c:
  sda: GPIO21       # Data line
  scl: GPIO22       # Clock line
  scan: true        # Scan and log all I2C devices found
  frequency: 100kHz # Standard speed (400kHz for fast mode)
```

**Scan Output (in logs):**
```
[I][i2c:028]: I2C Bus:
[I][i2c:029]:   SDA Pin: GPIO21
[I][i2c:030]:   SCL Pin: GPIO22
[I][i2c:031]:   Frequency: 100000 Hz
[I][i2c:074]: Found i2c device at address 0x3C
[I][i2c:074]: Found i2c device at address 0x76
```

This confirms both devices (OLED at 0x3C, BME280 at 0x76) are detected!

### BME280 Oversampling

```yaml
oversampling: 16x  # Options: 1x, 2x, 4x, 8x, 16x
```

**What is oversampling?**
- Sensor takes multiple readings and averages them
- Higher = more accurate, but slower and more power

**Oversampling Levels:**
- **1x:** Fast, low power, less accurate (±2°C)
- **2x-4x:** Balanced (±1°C)
- **8x:** High accuracy (±0.5°C)
- **16x:** Maximum accuracy (±0.25°C), slowest

**Recommendation:** 16x for stationary indoor monitoring, 2x for battery-powered outdoor.

### Fonts for OLED Display

```yaml
font:
  - file: "gfonts://Roboto"  # Download from Google Fonts
    id: font_small
    size: 12
```

**Font Sources:**
- `gfonts://FontName` - Download from Google Fonts (requires internet during compile)
- `fonts/myfont.ttf` - Local TrueFile font file
- Built-in bitmap fonts (limited)

**Font Variants:**
- `Roboto` - Regular
- `Roboto@700` - Bold (700 weight)
- `Roboto:italic` - Italic style

### Display Lambda (Drawing Function)

```yaml
lambda: |-
  it.print(x, y, font, alignment, "text");
  it.printf(x, y, font, alignment, "format %d", variable);
```

**Coordinate System:**
- Origin (0,0) is top-left corner
- X increases to the right (0-128)
- Y increases downward (0-64)

**Text Alignment:**
- `TextAlign::TOP_LEFT` - Anchor at top-left of text
- `TextAlign::TOP_CENTER` - Center horizontally
- `TextAlign::BASELINE_LEFT` - Align baseline (useful for numbers)
- `TextAlign::BASELINE_RIGHT` - Right-align at baseline

**Example:**
```cpp
// Print "25.3°C" centered at x=64, y=16
it.printf(64, 16, id(font_large), TextAlign::TOP_CENTER, "%.1f°C", id(bme280_temp).state);

// %.1f = floating point with 1 decimal place
// id(bme280_temp).state = current temperature value
```

### Calculated Sensors (Templates)

**Dew Point Calculation:**
```yaml
lambda: |-
  float temp = id(bme280_temp).state;
  float humidity = id(bme280_humidity).state;
  // Magnus formula
  float a = 17.27;
  float b = 237.7;
  float alpha = ((a * temp) / (b + temp)) + log(humidity / 100.0);
  return (b * alpha) / (a - alpha);
```

**What is dew point?**
- Temperature at which air becomes saturated (100% humidity)
- Water vapor condenses into liquid (dew, fog, condensation on windows)
- High dew point (> 20°C) = muggy, uncomfortable
- Low dew point (< 10°C) = dry air

**Use cases:**
- Prevent window condensation (keep indoor temp above dew point)
- Comfort monitoring (dew point < 13°C = comfortable)
- Mold prevention (dew point on surfaces = mold growth risk)

---

## Step-by-Step Build Guide

### Step 1: Hardware Assembly

**Wiring Order:**

1. **Power Rails (Breadboard):**
   - Connect ESP32 **3.3V** to breadboard + rail (red)
   - Connect ESP32 **GND** to breadboard - rail (black)

2. **BME280 Power:**
   - BME280 **VCC** → breadboard + rail
   - BME280 **GND** → breadboard - rail

3. **OLED Power:**
   - OLED **VCC** → breadboard + rail
   - OLED **GND** → breadboard - rail

4. **I2C Data Lines:**
   - BME280 **SDA** → same breadboard row
   - OLED **SDA** → same row as BME280 SDA
   - Jumper from this row → ESP32 **GPIO21**
   - *Optional:* 4.7kΩ resistor from this row to + rail (pull-up)

5. **I2C Clock Lines:**
   - BME280 **SCL** → same breadboard row
   - OLED **SCL** → same row as BME280 SCL
   - Jumper from this row → ESP32 **GPIO22**
   - *Optional:* 4.7kΩ resistor from this row to + rail (pull-up)

**Note:** Most BME280 and OLED modules have built-in pull-up resistors. Check your modules before adding external ones!

### Step 2: Verify Wiring with I2C Scan

**Before flashing full config, test I2C bus:**

Create minimal test config: `i2c-scan-test.yaml`
```yaml
esphome:
  name: i2c-scan-test
  platform: ESP32
  board: esp32dev

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password

logger:
  level: DEBUG  # Show detailed logs

api:

ota:

i2c:
  sda: GPIO21
  scl: GPIO22
  scan: true  # This will print found devices
```

**Flash and check logs:**
```
[I][i2c:074]: Found i2c device at address 0x3C  ← OLED Display
[I][i2c:074]: Found i2c device at address 0x76  ← BME280 Sensor
```

**If devices not found:**
- Check wiring (SDA, SCL, VCC, GND)
- Verify modules are powered (OLED might light up dimly)
- Try swapping SDA and SCL (easy mistake!)
- Check I2C address (BME280 might be 0x77, OLED might be 0x3D)

### Step 3: Flash Full Configuration

1. Create `environmental-station-1.yaml` with complete config above
2. Flash via USB (first time):
   ```bash
   docker exec -it esphome esphome upload /config/environmental-station-1.yaml
   ```
3. Or use ESPHome dashboard: http://192.168.40.201:6052

### Step 4: Verify OLED Display

**After flashing, OLED should display:**
```
      Living Room

       23.5°C

H: 45%         1013 hPa
                   ●●●
```

**If OLED is blank:**
- Check address (try changing `0x3C` to `0x3D` in YAML)
- Verify `model:` matches your display (SSD1306 vs SH1106)
- Try different rotation (`rotation: 180` if upside-down)
- Increase I2C frequency (`frequency: 400kHz`)

**If display shows garbage/scrambled:**
- Wrong model (SSD1306 vs SH1106)
- Try changing `reset_pin` (some OLEDs need it)

### Step 5: Verify Sensor Readings

**Check logs:**
```
[D][sensor:094]: 'Temperature': Got value 23.5°C
[D][sensor:094]: 'Humidity': Got value 45.2%
[D][sensor:094]: 'Pressure': Got value 1013.1hPa
```

**Validate readings:**
- **Temperature:** Should be room temp (20-25°C indoors)
- **Humidity:** Typical indoor 30-60%
- **Pressure:** Sea level ~1013 hPa, decreases with altitude (~-12 hPa per 100m)

### Step 6: Add to Home Assistant

1. Auto-discovery: **Settings → Integrations → ESPHome**
2. Configure `environmental-station-1`
3. Entities created:
   - `sensor.temperature`
   - `sensor.humidity`
   - `sensor.pressure`
   - `sensor.altitude`
   - `sensor.dew_point`

### Step 7: Create Dashboard Card

**Method 1: Simple Sensor Card**
1. **Add Card → Entities**
2. Add all 5 sensors
3. Show graph: Enable

**Method 2: Thermostat-Style Card**
```yaml
type: thermostat
entity: climate.environmental_station_1
```

**Method 3: Custom Lovelace Card (Advanced)**
```yaml
type: vertical-stack
cards:
  - type: entity
    entity: sensor.temperature
    name: Temperature
    icon: mdi:thermometer

  - type: horizontal-stack
    cards:
      - type: entity
        entity: sensor.humidity
        name: Humidity
        icon: mdi:water-percent

      - type: entity
        entity: sensor.pressure
        name: Pressure
        icon: mdi:gauge

  - type: history-graph
    hours_to_show: 24
    entities:
      - sensor.temperature
      - sensor.humidity
```

---

## Troubleshooting

### "I2C device not found" Error

**Cause:** Wiring issue or wrong I2C address.

**Fix:**
1. Run I2C scan (set `scan: true`)
2. Check logs for detected addresses
3. Update `address:` in YAML to match found address
4. Verify SDA/SCL not swapped
5. Check power (3.3V to VCC, GND to GND)

### BME280 Reads All Zeros or NaN

**Cause:** Sensor not initializing.

**Fix:**
1. Check I2C address (`0x76` vs `0x77`)
2. Try lower I2C frequency (`frequency: 50kHz`)
3. Power cycle ESP32
4. Try different BME280 module (could be faulty)

### OLED Display Flickers

**Cause:** I2C communication errors or low update rate.

**Fix:**
1. Reduce `update_interval` (try `update_interval: 5s` instead of `1s`)
2. Shorter I2C wires (< 20cm)
3. Add pull-up resistors (4.7kΩ to 3.3V on SDA and SCL)
4. Lower I2C frequency (`frequency: 100kHz`)

### Temperature Reads High (+5°C Offset)

**Cause:** ESP32 self-heating.

**Fix:**
1. Move BME280 away from ESP32 (use longer jumper wires)
2. Add calibration offset in YAML:
   ```yaml
   filters:
     - offset: -5.0  # Subtract 5°C
   ```
3. Improve airflow (ventilation holes in enclosure)
4. Use deep sleep to reduce heat (advanced)

### Pressure Reading Seems Wrong

**Cause:** Altitude affects pressure reading.

**Fix:**
1. Calculate expected pressure for your altitude:
   - Sea level: ~1013 hPa
   - 100m altitude: ~1001 hPa
   - 500m altitude: ~955 hPa
   - 1000m altitude: ~899 hPa
2. Adjust sea level pressure in altitude calculation
3. Compare with local weather station

---

## Creating Advanced Visualizations

### Grafana Dashboard

**Step 1: Configure InfluxDB in Home Assistant**

1. **Settings → Integrations → Add Integration → InfluxDB**
2. Configure:
   - Host: `influxdb` (Docker container name)
   - Port: `8086`
   - Database: `homeassistant`
3. Select entities to send:
   - ✅ `sensor.temperature`
   - ✅ `sensor.humidity`
   - ✅ `sensor.pressure`

**Step 2: Create Grafana Dashboard**

1. Access Grafana: http://192.168.40.201:3001
2. Login: `admin` / `admin`
3. **Create → Dashboard → Add Panel**

**Temperature Panel:**
```sql
SELECT mean("value")
FROM "sensor.temperature"
WHERE $timeFilter
GROUP BY time(5m) fill(linear)
```

Settings:
- Panel Title: "Temperature (24h)"
- Unit: Celsius (°C)
- Min: 15, Max: 30
- Line width: 2
- Fill opacity: 20%

**Humidity Panel (Dual-Axis):**
Add second query in same panel:
```sql
SELECT mean("value")
FROM "sensor.humidity"
WHERE $timeFilter
GROUP BY time(5m) fill(linear)
```

Right Y-axis: 0-100%

**Pressure Panel with Trend Arrow:**
```sql
SELECT mean("value")
FROM "sensor.pressure"
WHERE $timeFilter
GROUP BY time(5m) fill(linear)
```

Add Stat visualization:
- Show: Last value
- Add field override for color thresholds:
  - < 1008 hPa: Red (storm coming)
  - 1008-1018 hPa: Yellow (normal)
  - > 1018 hPa: Green (fair weather)

### Weather Trend Prediction

**Add pressure trend sensor:**
```yaml
sensor:
  - platform: template
    name: "Pressure Trend (3h)"
    unit_of_measurement: "hPa"
    lambda: |-
      static float pressure_3h_ago = 0;
      static unsigned long last_save = 0;
      unsigned long now = millis();

      // Save pressure every 3 hours
      if (now - last_save > 10800000) {  // 3 hours in ms
        pressure_3h_ago = id(bme280_pressure).state;
        last_save = now;
      }

      // Return change since 3 hours ago
      return id(bme280_pressure).state - pressure_3h_ago;
    update_interval: 60s

text_sensor:
  - platform: template
    name: "Weather Forecast"
    lambda: |-
      float trend = id(pressure_trend_3h).state;
      if (trend > 2.0) {
        return {"Improving (Rising pressure)"};
      } else if (trend < -2.0) {
        return {"Deteriorating (Falling pressure)"};
      } else {
        return {"Stable"};
      }
    update_interval: 60s
```

**Pressure Change Meanings:**
- **Rising (> +2 hPa/3h):** Weather improving, skies clearing
- **Falling (< -2 hPa/3h):** Storm approaching, clouds forming
- **Stable (±2 hPa):** No significant change

---

## Next Steps & Enhancements

### Enhancement 1: Add BME680 (Air Quality)

Upgrade to BME680 for VOC sensor:

```yaml
sensor:
  - platform: bme680
    temperature:
      name: "Temperature"
    humidity:
      name: "Humidity"
    pressure:
      name: "Pressure"
    gas_resistance:
      name: "Gas Resistance"
    indoor_air_quality:
      name: "Indoor Air Quality"
      # IAQ Index: 0-50 excellent, 51-100 good, 101-150 lightly polluted
    address: 0x76
    update_interval: 60s
```

**Gas Resistance:**
- High resistance (> 200kΩ) = clean air
- Low resistance (< 50kΩ) = polluted air (cooking, cleaning, smoke)

### Enhancement 2: Multi-Room Monitoring

Deploy multiple stations:

**Living Room:** `environmental-station-1` (192.168.40.155)
**Bedroom:** `environmental-station-2` (192.168.40.156)
**Kitchen:** `environmental-station-3` (192.168.40.157)

**Grafana Dashboard:**
- Compare temperatures across rooms
- Identify cold/hot spots
- Monitor humidity differences (bathroom vs bedroom)

### Enhancement 3: Add Light Sensor (BH1750)

Measure ambient light:

```yaml
sensor:
  - platform: bh1750
    name: "Illuminance"
    address: 0x23
    update_interval: 10s
```

**Use cases:**
- Auto-adjust display brightness
- Detect sunrise/sunset
- Correlate light levels with temperature (solar heating)

### Enhancement 4: Historical Graphs on OLED

Display mini graphs on OLED:

```yaml
display:
  lambda: |-
    // Draw mini temperature graph (last 60 readings)
    static float temp_history[60] = {0};
    static int index = 0;

    // Store current reading
    temp_history[index] = id(bme280_temp).state;
    index = (index + 1) % 60;

    // Draw graph
    for (int i = 0; i < 60; i++) {
      int x = i * 2;  // 2 pixels per point
      int y = 64 - (temp_history[i] - 15) * 2;  // Scale: 15-30°C
      it.draw_pixel_at(x, y);
    }
```

### Enhancement 5: Comfort Index

Calculate PMV (Predicted Mean Vote) comfort index:

```yaml
sensor:
  - platform: template
    name: "Comfort Index"
    lambda: |-
      float temp = id(bme280_temp).state;
      float humidity = id(bme280_humidity).state;

      // Simplified comfort formula
      float comfort = 100 - abs(temp - 22.5) * 5 - abs(humidity - 50) * 0.5;
      return max(0.0f, min(100.0f, comfort));
    update_interval: 60s
```

**Comfort Index:**
- 100: Perfect comfort
- 80-100: Comfortable
- 60-80: Acceptable
- < 60: Uncomfortable

---

## What You've Learned

By completing this project, you now understand:

✅ **I2C Communication:**
- Multi-device bus (2 wires, multiple devices)
- Addressing (0x76, 0x3C, etc.)
- Pull-up resistors and their purpose

✅ **Advanced Sensors:**
- BME280/BME680 operation
- Oversampling for accuracy
- Barometric pressure measurement

✅ **Display Control:**
- SSD1306 OLED programming
- Drawing text, fonts, graphics
- Coordinate systems and alignment

✅ **Data Visualization:**
- Local display on OLED
- Home Assistant dashboard cards
- InfluxDB + Grafana integration

✅ **Calculated Sensors:**
- Dew point calculation
- Altitude from pressure
- Weather trend prediction

✅ **Template Sensors:**
- Lambda functions in ESPHome
- C++ basics for calculations
- Combining multiple sensor inputs

**Ready for the next project?** Try [Project 6: Smart Plant Monitor](06-smart-plant-monitor.md) to learn about analog sensors and automation!
