# Project 2: Temperature & Humidity Monitor

**Difficulty:** Beginner
**Estimated Time:** 2-3 hours
**Cost:** $15-25

## Learning Objectives

By completing this project, you will learn:
- Digital sensor protocols (1-Wire for DHT sensors)
- Reading sensor data and publishing to Home Assistant
- Sensor calibration and accuracy
- Update intervals and power consumption
- Creating dashboard visualizations
- Historical data logging with InfluxDB/Grafana

---

## Parts List

| Part | Quantity | Approximate Cost (CAD) | Notes |
|------|----------|------------------------|-------|
| ESP32 Development Board | 1 | $8-12 | From Project 1 |
| DHT22 Sensor (AM2302) | 1 | $8-12 | Temperature & humidity |
| 10kΩ Pull-up Resistor | 1 | $0.10 | Required for DHT22 |
| Breadboard | 1 | Reuse from Project 1 | 400-point or larger |
| Jumper Wires | 3-4 | Reuse from Project 1 | Male-to-male |
| Micro-USB Cable | 1 | Reuse from Project 1 | Power and programming |

**Total Cost:** ~$15-25 (assuming you have ESP32 and breadboard)

**Alternative Sensors:**
- **DHT11** - Cheaper ($3-5), less accurate (±2°C, ±5% humidity)
- **BME280** - More expensive ($12-18), includes barometric pressure, I2C interface
- **SHT30/SHT31** - Best accuracy (±0.3°C, ±2% humidity), I2C interface

---

## Understanding the Parts

### DHT22 Sensor (AM2302)

The DHT22 is a digital temperature and humidity sensor with good accuracy at low cost.

**Specifications:**
- **Temperature Range:** -40°C to 80°C (±0.5°C accuracy)
- **Humidity Range:** 0-100% RH (±2% accuracy)
- **Sampling Rate:** Maximum 0.5Hz (once every 2 seconds)
- **Operating Voltage:** 3.3V - 5V
- **Protocol:** Single-wire digital (1-Wire-like, proprietary)

**Pin Layout (DHT22 module with 3 pins):**
```
Front view (grid facing you):

  +---+
  | O | ← Pin 1: VCC (Power, 3.3V or 5V)
  | O | ← Pin 2: DATA (Signal, connect to GPIO + pull-up resistor)
  | O | ← Pin 3: GND (Ground)
  +---+
```

**4-Pin DHT22 (raw sensor):** Pin 3 is not connected (NC).

### 10kΩ Pull-up Resistor

**Why is this needed?**
The DHT22 uses an "open-drain" output, meaning it can only pull the signal LOW (to ground). The pull-up resistor pulls the signal HIGH (to 3.3V) when the DHT22 isn't actively sending data.

**Without pull-up:** Signal would float randomly between HIGH/LOW → unreliable readings.

**Pull-up Resistor Value:** 4.7kΩ - 10kΩ (10kΩ is standard and widely available)

**Note:** Some DHT22 breakout boards have a built-in pull-up resistor. Check your module!

---

## Sensor Comparison

| Feature | DHT11 | DHT22 (AM2302) | BME280 | SHT30 |
|---------|-------|----------------|---------|-------|
| **Temperature Accuracy** | ±2°C | ±0.5°C | ±1°C | ±0.3°C |
| **Humidity Accuracy** | ±5% | ±2% | ±3% | ±2% |
| **Sampling Rate** | 1 Hz | 0.5 Hz | Configurable | 10 Hz |
| **Additional Sensors** | None | None | Barometric Pressure | None |
| **Interface** | 1-Wire | 1-Wire | I2C/SPI | I2C |
| **Cost (CAD)** | $3-5 | $8-12 | $12-18 | $15-20 |
| **Best For** | Learning | General use | Weather stations | Precision apps |

**Recommendation for this project:** DHT22 (AM2302) - good balance of cost and accuracy.

---

## Wiring Diagram

### DHT22 Wiring (3-Pin Module)

```
ESP32 Board                     DHT22 Sensor

3V3 (or 5V) --------> VCC (Pin 1)

GPIO4 --------+-------> DATA (Pin 2)
              |
           10kΩ Pull-up
              |
3V3 (or 5V) --+

GND -----------+------> GND (Pin 3)
               |
          [Breadboard Ground Rail]
```

**Step-by-Step Wiring:**
1. Connect DHT22 VCC (Pin 1) to ESP32 **3V3** pin
2. Connect DHT22 GND (Pin 3) to ESP32 **GND** pin
3. Connect DHT22 DATA (Pin 2) to ESP32 **GPIO4** pin
4. Connect 10kΩ resistor between DATA (GPIO4) and VCC (3.3V)
   - One leg of resistor to GPIO4 (same row as DATA on breadboard)
   - Other leg to 3V3 rail

**Breadboard Layout:**
```
Breadboard Rows:

Row 1:  [DHT22 VCC] --- [Jumper to ESP32 3V3]
Row 2:  [DHT22 DATA] --- [Resistor] --- [3V3 Rail]
        [DHT22 DATA] --- [Jumper to ESP32 GPIO4]
Row 3:  [DHT22 GND] --- [Jumper to ESP32 GND]
```

**Important Notes:**
- If your DHT22 module has a built-in pull-up resistor (check the PCB), you can skip the external 10kΩ resistor
- 3.3V or 5V both work - DHT22 is tolerant of both voltages
- Keep wires short (< 20cm) for reliable readings

---

## ESPHome Configuration

Create a new file: `/home/hazzard/home-assistant/esphome/climate-sensor-1.yaml`

### Complete Configuration

```yaml
esphome:
  name: climate-sensor-1
  friendly_name: "Living Room Climate"
  platform: ESP32
  board: esp32dev

# WiFi configuration
wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password

  manual_ip:
    static_ip: 192.168.40.151  # Choose an unused IP
    gateway: 192.168.40.1
    subnet: 255.255.255.0
    dns1: 8.8.8.8

  # Fallback hotspot
  ap:
    ssid: "Climate-Sensor-Fallback"
    password: "12345678"

# Enable logging
logger:

# Enable Home Assistant API
api:
  encryption:
    key: !secret api_key_climate_sensor

# Enable OTA updates
ota:
  - platform: esphome
    password: !secret ota_password

# DHT22 Sensor Configuration
sensor:
  # Temperature Sensor
  - platform: dht
    pin: GPIO4
    model: DHT22  # or DHT11, AM2302
    temperature:
      name: "Temperature"
      id: climate_temp
      unit_of_measurement: "°C"
      accuracy_decimals: 1
      filters:
        # Remove outlier readings (spikes)
        - filter_out: nan
        # Smooth readings (moving average of last 3 values)
        - sliding_window_moving_average:
            window_size: 3
            send_every: 1
        # Optional: Calibration offset (adjust after testing)
        # - offset: -0.5  # Subtract 0.5°C if sensor reads high

    humidity:
      name: "Humidity"
      id: climate_humidity
      unit_of_measurement: "%"
      accuracy_decimals: 1
      filters:
        - filter_out: nan
        - sliding_window_moving_average:
            window_size: 3
            send_every: 1
        # Optional: Calibration offset
        # - offset: 2.0  # Add 2% if sensor reads low

    # Update interval (DHT22 max: 0.5Hz = every 2 seconds)
    update_interval: 30s  # Update every 30 seconds (saves power)

  # WiFi Signal Strength (RSSI)
  - platform: wifi_signal
    name: "WiFi Signal"
    update_interval: 60s

  # Device Uptime
  - platform: uptime
    name: "Uptime"
    update_interval: 60s

# Text Sensor for Device Info
text_sensor:
  # Device IP Address
  - platform: wifi_info
    ip_address:
      name: "IP Address"
    ssid:
      name: "Connected SSID"
    mac_address:
      name: "MAC Address"

# Restart button (useful for troubleshooting)
button:
  - platform: restart
    name: "Restart Device"
```

---

## Step-by-Step Build Guide

### Step 1: Hardware Assembly

1. **Prepare Breadboard:**
   - Insert DHT22 sensor into breadboard (pins in separate rows)
   - Leave space for pull-up resistor and jumper wires

2. **Power Connections:**
   - Red jumper: DHT22 VCC (Pin 1) → ESP32 **3V3**
   - Black jumper: DHT22 GND (Pin 3) → ESP32 **GND**

3. **Data Connection:**
   - Yellow jumper: DHT22 DATA (Pin 2) → ESP32 **GPIO4**

4. **Pull-up Resistor:**
   - Place 10kΩ resistor between DATA and VCC
   - One leg in same breadboard row as DATA
   - Other leg in same row as VCC

5. **Double-Check:**
   - Verify polarity (VCC, DATA, GND in correct order)
   - Ensure pull-up resistor is between DATA and VCC (not DATA and GND!)
   - Check for shorts or loose connections

6. **Connect USB:**
   - Plug ESP32 into computer via Micro-USB cable

### Step 2: Create ESPHome Configuration

1. Access ESPHome dashboard: http://192.168.40.201:6052
2. Click "**+ NEW DEVICE**"
3. Name: `climate-sensor-1`
4. Device Type: `ESP32`, Board: `esp32dev`
5. Click "**EDIT**" and replace contents with the YAML above
6. Click "**SAVE**"

### Step 3: First Flash (USB)

1. Click "**INSTALL**" → "**Plug into this computer**"
2. Select ESP32 serial port
3. Click "**Connect**" and wait for upload (2-5 minutes)
4. Watch logs for successful connection

### Step 4: Verify Sensor Readings

After flashing, check the logs (click "**LOGS**" button):

```
[15:23:45][D][dht:048]: Got Temperature=22.3°C Humidity=45.2%
[15:24:15][D][dht:048]: Got Temperature=22.4°C Humidity=45.1%
```

**Good signs:**
- Temperature readings in a reasonable range (15-30°C indoors)
- Humidity readings 30-70% (typical indoor range)
- Readings update every 30 seconds

**Bad signs:**
- `[W][dht:169]: Requesting data from DHT failed!` → Wiring issue
- `Temperature=nan` or `Humidity=nan` → Sensor not responding
- Readings jump wildly (10°C → 25°C → 15°C) → Bad connections or faulty sensor

### Step 5: Add to Home Assistant

1. Home Assistant should auto-discover the device
2. Go to **Settings → Integrations**
3. Click "**CONFIGURE**" on ESPHome notification
4. Your device appears with 2 sensors:
   - `sensor.temperature`
   - `sensor.humidity`

### Step 6: Create Dashboard Card

1. Go to Home Assistant **Overview** (dashboard)
2. Click **Edit Dashboard** (top-right)
3. Click **+ ADD CARD**
4. Search for "**Sensor**" card
5. Add both Temperature and Humidity sensors
6. Customize:
   - Name: "Living Room Climate"
   - Icon: `mdi:thermometer` and `mdi:water-percent`
   - Show graph: Enable
7. Click **SAVE**

---

## Understanding the Code

### DHT Sensor Platform

```yaml
sensor:
  - platform: dht         # DHT sensor family (DHT11, DHT22, AM2302)
    pin: GPIO4            # Data pin
    model: DHT22          # Sensor model (affects timing and accuracy)
    update_interval: 30s  # Read sensor every 30 seconds
```

**Update Interval Explained:**
- **2s minimum** - DHT22 hardware limit (0.5Hz max sampling rate)
- **30s recommended** - Balances responsiveness and power consumption
- **60s or longer** - For battery-powered applications

### Filters: Data Smoothing

```yaml
filters:
  - filter_out: nan       # Remove invalid readings (sensor errors)
  - sliding_window_moving_average:
      window_size: 3      # Average last 3 readings
      send_every: 1       # Send every reading (after averaging)
```

**Why averaging?**
DHT22 readings can fluctuate ±0.5°C due to:
- Air currents
- Heat from the ESP32 itself
- Electrical noise

**Moving Average Example:**
- Reading 1: 22.1°C
- Reading 2: 22.5°C (average of 22.1, 22.5 = 22.3°C)
- Reading 3: 22.3°C (average of 22.1, 22.5, 22.3 = 22.3°C) ← Sent to HA
- Reading 4: 22.4°C (average of 22.5, 22.3, 22.4 = 22.4°C) ← Sent to HA

Result: Smoother graph, less noise!

### Calibration Offset

```yaml
filters:
  - offset: -0.5  # Subtract 0.5°C from all readings
```

**When to use:**
- Compare ESP32 readings to a known-accurate thermometer
- If ESP32 reads 22.5°C and thermometer reads 22.0°C, use `offset: -0.5`
- Common for DHT22 to be off by ±0.5-1°C

**Calibration Procedure:**
1. Place DHT22 and reference thermometer side-by-side
2. Wait 10 minutes for readings to stabilize
3. Compare values
4. Calculate offset: `offset = reference_value - dht22_value`
5. Add offset to configuration and re-flash

---

## Troubleshooting

### "Requesting data from DHT failed!"

**Cause:** Sensor not responding (wiring issue).

**Fix:**
1. Check power: DHT22 VCC connected to 3V3, GND to GND
2. Check data pin: DATA connected to GPIO4
3. Check pull-up resistor: One leg to DATA, other to VCC
4. Try different GPIO pin (GPIO5, GPIO16, GPIO17)
5. Reduce wire length (< 20cm)
6. Try 5V instead of 3.3V for VCC (ESP32 can output 5V from VIN pin)

### Readings show "nan" or "unknown"

**Cause:** Sensor initialization failure.

**Fix:**
1. Ensure 10kΩ pull-up resistor is installed (even if module has one, add another)
2. Check update interval (must be ≥ 2 seconds)
3. Power cycle ESP32 (unplug and replug USB)
4. Try a different DHT22 sensor (could be faulty)

### Temperature reads too high (+2-5°C above room temp)

**Cause:** ESP32 self-heating. The ESP32 chip generates heat, warming the sensor.

**Fix:**
1. **Move sensor away from ESP32:**
   - Use longer jumper wires (10-20cm)
   - Mount DHT22 away from ESP32 heat source
2. **Add heat shield:**
   - Place cardboard or foam between ESP32 and sensor
3. **Use calibration offset:**
   - `offset: -3.0` (subtract self-heating amount)
4. **Add airflow:**
   - Small fan or ventilation holes in enclosure

### Humidity reads low (< 20%) in dry winter

**Cause:** This is normal! Indoor humidity can drop below 20% in winter with heating.

**Fix (if desired):**
- Add humidifier to room
- Verify with another humidity sensor
- If consistently off, apply calibration offset

### WiFi disconnects frequently

**Cause:** Weak WiFi signal or interference.

**Fix:**
1. Check WiFi signal strength in logs: `[D][wifi_signal:099]: 'WiFi Signal': Got WiFi Signal=-65dB`
   - **-50 to -60 dBm:** Excellent
   - **-60 to -70 dBm:** Good
   - **-70 to -80 dBm:** Fair (may disconnect)
   - **< -80 dBm:** Poor (frequent disconnects)
2. Move ESP32 closer to router
3. Use WiFi extender
4. Switch to 2.4GHz WiFi (not 5GHz)

---

## Creating Automations

### Automation 1: High Humidity Alert

Trigger exhaust fan or send notification when humidity > 70%.

```yaml
# In Home Assistant: Settings → Automations → Create Automation

alias: "High Humidity Alert"
trigger:
  - platform: numeric_state
    entity_id: sensor.humidity
    above: 70  # 70% humidity threshold
    for:
      minutes: 5  # Stay above 70% for 5 minutes
action:
  # Send notification
  - service: notify.mobile_app
    data:
      title: "High Humidity Detected"
      message: "Humidity is {{ states('sensor.humidity') }}% in Living Room"

  # Turn on exhaust fan (if you have one)
  # - service: switch.turn_on
  #   target:
  #     entity_id: switch.exhaust_fan
```

### Automation 2: Morning Temperature Report

Announce temperature every morning at 7 AM.

```yaml
alias: "Morning Temperature Report"
trigger:
  - platform: time
    at: "07:00:00"
action:
  - service: tts.google_translate_say
    data:
      entity_id: media_player.living_room_speaker
      message: >
        Good morning! The temperature is {{ states('sensor.temperature') }} degrees,
        and humidity is {{ states('sensor.humidity') }} percent.
```

### Automation 3: Climate-Based Fan Control

Turn on fan when temperature > 25°C.

```yaml
alias: "Auto Fan Control"
trigger:
  - platform: numeric_state
    entity_id: sensor.temperature
    above: 25  # 25°C threshold
action:
  - service: switch.turn_on
    target:
      entity_id: switch.smart_plug_fan  # Your fan's smart plug

# Turn off when temp drops below 24°C
- alias: "Auto Fan Off"
  trigger:
    - platform: numeric_state
      entity_id: sensor.temperature
      below: 24
  action:
    - service: switch.turn_off
      target:
        entity_id: switch.smart_plug_fan
```

---

## Data Visualization with Grafana

### Step 1: Configure InfluxDB Integration

1. Home Assistant: **Settings → Integrations → Add Integration**
2. Search "**InfluxDB**"
3. Configure:
   - Host: `influxdb` (container name)
   - Port: `8086`
   - Database: `homeassistant`
   - Username/Password: (from your InfluxDB setup)
4. Select entities to send to InfluxDB:
   - ✅ `sensor.temperature`
   - ✅ `sensor.humidity`

### Step 2: Create Grafana Dashboard

1. Access Grafana: http://192.168.40.201:3001
2. Login: `admin` / `admin`
3. Click **+ → Create Dashboard → Add New Panel**
4. Query:
   ```sql
   SELECT mean("value")
   FROM "sensor.temperature"
   WHERE $timeFilter
   GROUP BY time(5m) fill(linear)
   ```
5. Panel Settings:
   - Title: "Living Room Temperature (24h)"
   - Unit: Celsius (°C)
   - Min: 15, Max: 30
   - Line style: Smooth
6. Add second query for humidity
7. Save dashboard: "Climate Monitoring"

---

## Next Steps & Enhancements

### Enhancement 1: Add Multiple Sensors

Monitor multiple rooms:

```yaml
# Add a second DHT22 on GPIO5
sensor:
  - platform: dht
    pin: GPIO4
    model: DHT22
    temperature:
      name: "Living Room Temperature"
    humidity:
      name: "Living Room Humidity"
    update_interval: 30s

  - platform: dht
    pin: GPIO5
    model: DHT22
    temperature:
      name: "Bedroom Temperature"
    humidity:
      name: "Bedroom Humidity"
    update_interval: 30s
```

### Enhancement 2: Calculate Dew Point

Dew point helps determine condensation risk:

```yaml
sensor:
  # Dew Point Calculation
  - platform: template
    name: "Dew Point"
    unit_of_measurement: "°C"
    lambda: |-
      float temp = id(climate_temp).state;
      float humidity = id(climate_humidity).state;
      float a = 17.27;
      float b = 237.7;
      float alpha = ((a * temp) / (b + temp)) + log(humidity / 100.0);
      float dew_point = (b * alpha) / (a - alpha);
      return dew_point;
    update_interval: 60s
```

### Enhancement 3: Add BME280 (Pressure Sensor)

Upgrade to BME280 for barometric pressure:

```yaml
# BME280 uses I2C interface
i2c:
  sda: GPIO21
  scl: GPIO22
  scan: true

sensor:
  - platform: bme280
    temperature:
      name: "Temperature"
      oversampling: 16x
    humidity:
      name: "Humidity"
      oversampling: 16x
    pressure:
      name: "Pressure"
      oversampling: 16x
    address: 0x76
    update_interval: 60s
```

### Enhancement 4: Heat Index Calculation

Calculate "feels like" temperature:

```yaml
sensor:
  - platform: template
    name: "Heat Index"
    unit_of_measurement: "°C"
    lambda: |-
      float temp = id(climate_temp).state;
      float humidity = id(climate_humidity).state;
      // Heat index formula (simplified)
      if (temp < 27) {
        return temp;  // Heat index only applies above 27°C
      }
      float hi = -8.78469475556
               + 1.61139411 * temp
               + 2.33854883889 * humidity
               - 0.14611605 * temp * humidity;
      return hi;
    update_interval: 60s
```

---

## Project Ideas Using This Sensor

1. **Bathroom Humidity Monitor**
   - Trigger exhaust fan when humidity > 70%
   - Auto-shutoff when humidity < 60%

2. **Plant Care Monitor**
   - Alert if humidity too low for tropical plants (< 50%)
   - Track daily min/max humidity

3. **Wine Cellar Monitor**
   - Ideal conditions: 12-15°C, 60-70% humidity
   - Alert if outside range

4. **Greenhouse Controller**
   - Maintain optimal temperature (20-25°C) and humidity (60-80%)
   - Control heaters, misters, vents

5. **Sleep Quality Tracker**
   - Monitor bedroom climate (ideal: 18-20°C, 40-60% humidity)
   - Correlate with sleep quality data

---

## What You've Learned

By completing this project, you now understand:

✅ **Digital Sensors:**
- 1-Wire protocol (DHT22 communication)
- Pull-up resistors and open-drain outputs
- Sensor sampling rates and timing

✅ **Data Processing:**
- Filtering noise (moving averages)
- Calibration offsets
- Outlier removal

✅ **Home Assistant Integration:**
- Sensor entities
- Dashboard visualizations
- Historical data logging

✅ **Environmental Monitoring:**
- Temperature and humidity measurement
- Self-heating effects and mitigation
- Data accuracy and calibration

✅ **Automation Triggers:**
- Numeric state conditions
- Threshold-based actions
- Climate control automations

**Ready for the next project?** Try [Project 3: Smart Lamp](03-smart-lamp.md) to learn about relay control and AC safety!
