# Xiao ESP32-C6 Climate Monitor with Display

**Difficulty:** Beginner-Intermediate
**Estimated Time:** 2-4 hours
**Cost:** $25-35 CAD

## Project Overview

Build a compact environmental monitoring station using the Seeed Studio Xiao ESP32-C6, AHT10 temperature/humidity sensor, and a 0.96" OLED display. This project combines local display capabilities with Home Assistant integration, making it perfect for bedside tables, offices, or anywhere you want at-a-glance climate information.

**What makes this special:**
- **Tiny footprint** - Xiao ESP32-C6 is only 21mm x 17.5mm
- **Local display** - See temperature/humidity without opening Home Assistant
- **I2C bus mastery** - Learn to connect multiple devices on the same bus
- **Low power** - Excellent for battery-powered applications (future enhancement)
- **WiFi 6 support** - Faster, more efficient wireless connectivity

---

## Learning Objectives

By completing this project, you will learn:

- **I2C Communication** - Multiple devices on a shared 2-wire bus
- **Xiao ESP32-C6 Platform** - Compact development board with RISC-V architecture
- **OLED Display Control** - Rendering text and graphics
- **Sensor Integration** - Reading environmental data from AHT10
- **Layout Design** - Organizing information on a small screen
- **Home Assistant Integration** - Dual-mode operation (local display + cloud)
- **Power Optimization** - Techniques for battery operation

---

## Parts List

| Part | Quantity | Approximate Cost (CAD) | Notes |
|------|----------|------------------------|-------|
| Seeed Xiao ESP32-C6 | 1 | $12-15 | USB-C, WiFi 6, Thread/Zigbee capable |
| AHT10 Sensor Module | 1 | $5-8 | I2C temperature & humidity sensor |
| 0.96" OLED Display | 1 | $6-10 | SSD1306, 128x64, I2C (white or blue) |
| Breadboard | 1 | $3-5 | 400-point or mini breadboard |
| Jumper Wires | 6-8 | $2-3 | Male-to-male or male-to-female |
| USB-C Cable | 1 | $3-5 | Power and programming |

**Total Cost:** ~$25-35 CAD

**Where to Buy (Canada):**
- **Xiao ESP32-C6:** Seeed Studio, DigiKey, Mouser
- **AHT10:** Amazon.ca, AliExpress
- **OLED Display:** Amazon.ca, AliExpress, Canada Robotix
- **Breadboard/Wires:** Amazon.ca, Creatron (Toronto), Solarbotics (Calgary)

---

## Understanding the Parts

### Seeed Studio Xiao ESP32-C6

The Xiao ESP32-C6 is a compact development board based on the ESP32-C6 chip (RISC-V architecture).

**Key Specifications:**
- **CPU:** RISC-V 32-bit @ 160MHz (dual-core)
- **RAM:** 512KB SRAM
- **Flash:** 4MB
- **Wireless:** WiFi 6 (802.11ax), Bluetooth 5.3, Thread, Zigbee
- **GPIO:** 15 available pins (D0-D10, A0-A4)
- **I2C:** Hardware I2C on GPIO4 (SDA) and GPIO5 (SCL)
- **Power:** 3.3V logic, USB-C connector
- **Size:** 21mm x 17.5mm (tiny!)
- **Deep Sleep Current:** ~15µA (excellent for battery use)

**Pinout (Top View):**
```
        USB-C Connector
           ┌─────┐
           │     │
    ┌──────┴─────┴──────┐
    │                   │
 D0 ● │             │ ● D10
 D1 ● │             │ ● D9
 D2 ● │             │ ● D8
 D3 ● │   XIAO-C6   │ ● D7
 D4 ● │ (SDA)       │ ● D6
 D5 ● │ (SCL)       │ ● RX
 D6 ● │             │ ● TX
    │ └─────────────┘ │
    │  [RST]  [BOOT]  │
    │                 │
    └─────┬───┬───┬───┘
      5V GND 3V3 GND
      (Bottom pads)
```

**Pinout Details:**

| Left Side | GPIO | Function | Right Side | GPIO | Function |
|-----------|------|----------|------------|------|----------|
| D0 | GPIO0 | Digital I/O | D10 | GPIO10 | Digital I/O |
| D1 | GPIO1 | Digital I/O | D9 | GPIO9 | Digital I/O |
| D2 | GPIO2 | Digital I/O | D8 | GPIO8 | Digital I/O |
| D3 | GPIO3 | Digital I/O | D7 | GPIO7 | Digital I/O |
| D4 | GPIO4 | **I2C SDA** | D6 | GPIO6 | Digital I/O |
| D5 | GPIO5 | **I2C SCL** | RX | GPIO17 | UART RX |
| D6 | GPIO23 | Digital I/O | TX | GPIO16 | UART TX |

**Bottom Pads:** 5V, GND, 3V3, GND

**Important Notes:**
- **3.3V Logic:** All GPIO pins operate at 3.3V (NOT 5V tolerant!)
- **I2C Pins:** Hardware I2C is on **D4 (SDA, GPIO4)** and **D5 (SCL, GPIO5)**
- **Only 7 pins per side** - Very compact!
- **Power:** Can be powered via USB-C or 3.3V pin
- **Boot Mode:** Hold BOOT button while connecting USB to enter bootloader mode (usually auto-detected)

### AHT10 Temperature & Humidity Sensor

**Specifications:**
- **Temperature Range:** -40°C to 85°C (±0.3°C accuracy)
- **Humidity Range:** 0-100% RH (±2% accuracy)
- **Interface:** I2C (address 0x38)
- **Operating Voltage:** 2.2V - 5.5V (3.3V compatible)
- **Response Time:** < 5 seconds
- **Power Consumption:** < 1mA (very low!)

**Pin Layout:**
```
AHT10 Module (Front View):

┌─────────────┐
│   AHT10     │
│             │
│  ○ VCC      │ ← 3.3V
│  ○ SDA      │ ← I2C Data
│  ○ GND      │ ← Ground
│  ○ SCL      │ ← I2C Clock
└─────────────┘
```

**Advantages over DHT22:**
- More accurate (±0.3°C vs ±0.5°C)
- Faster response time
- I2C interface (more reliable than 1-wire)
- Lower power consumption
- Can share I2C bus with other devices

### 0.96" OLED Display (SSD1306)

**Specifications:**
- **Resolution:** 128x64 pixels
- **Driver Chip:** SSD1306 (I2C interface)
- **Colors:** Monochrome (white, blue, or yellow/blue dual-color)
- **Interface:** I2C (address 0x3C or 0x3D)
- **Operating Voltage:** 3.3V - 5V
- **Viewing Angle:** > 160°
- **Power Consumption:** ~20mA (display on), ~0.5mA (display off)

**Pin Layout:**
```
OLED Display Module:

┌───────────────────┐
│   ╔═══════════╗   │
│   ║  128x64   ║   │
│   ║   OLED    ║   │
│   ╚═══════════╝   │
│                   │
│  ○ GND            │
│  ○ VCC (3.3V)     │
│  ○ SCL            │
│  ○ SDA            │
└───────────────────┘
```

**Note:** Some displays have GND/VCC order reversed - check your module!

**Display Area:**
- **Full screen:** 128x64 pixels
- **Text mode:** 21 characters wide × 8 lines (using 6x8 font)
- **Text mode (large):** 10 characters wide × 4 lines (using 12x16 font)

---

## I2C Bus Explained

**What is I2C?**
I2C (Inter-Integrated Circuit) is a 2-wire communication protocol that allows multiple devices to share the same bus.

**How it works:**
- **SDA (Serial Data):** Bi-directional data line
- **SCL (Serial Clock):** Clock signal from master (ESP32-C6)
- **Addresses:** Each device has a unique 7-bit address
  - AHT10: `0x38`
  - SSD1306 OLED: `0x3C` or `0x3D`

**Advantages:**
- Only 2 wires needed (plus power and ground)
- Multiple devices on same bus (up to 127 devices!)
- Built-in addressing system
- Reliable communication with error checking

**Why this project is perfect for learning I2C:**
You'll connect TWO devices (AHT10 + OLED) on the SAME I2C bus - a fundamental skill for advanced projects!

---

## Wiring Diagram

### Complete Wiring (All Components)

```
Xiao ESP32-C6              AHT10 Sensor           OLED Display

3V3 ──────────┬──────────> VCC
              └──────────────────────────────────> VCC

GND ──────────┬──────────> GND
              └──────────────────────────────────> GND

D4 (SDA) ─────┬──────────> SDA
              └──────────────────────────────────> SDA

D5 (SCL) ─────┬──────────> SCL
              └──────────────────────────────────> SCL
```

**I2C Bus Sharing:**
Notice how SDA and SCL are connected to BOTH devices! This is the power of I2C - multiple devices, same two wires.

### Breadboard Layout

```
Breadboard Layout (Side View):

Power Rails:
[+3.3V Rail] ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[GND Rail]   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Xiao ESP32-C6:
  3V3 ──> [+3.3V Rail]
  GND ──> [GND Rail]
  D4 (SDA) ──> Row 10
  D5 (SCL) ──> Row 11

AHT10 Sensor (Rows 5-8):
  Row 5: VCC ──> [+3.3V Rail]
  Row 6: SDA ──> Row 10 (connect to D4)
  Row 7: GND ──> [GND Rail]
  Row 8: SCL ──> Row 11 (connect to D5)

OLED Display (Rows 15-18):
  Row 15: GND ──> [GND Rail]
  Row 16: VCC ──> [+3.3V Rail]
  Row 17: SCL ──> Row 11 (connect to D5)
  Row 18: SDA ──> Row 10 (connect to D4)
```

### Step-by-Step Wiring Instructions

**Step 1: Set up power rails**
1. Connect Xiao **3V3** pin to breadboard **+ rail** (red wire)
2. Connect Xiao **GND** pin to breadboard **- rail** (black wire)

**Step 2: Connect AHT10**
1. Insert AHT10 into breadboard (leave space for display)
2. Connect AHT10 **VCC** to **+3.3V rail** (red jumper)
3. Connect AHT10 **GND** to **GND rail** (black jumper)
4. Connect AHT10 **SDA** to Xiao **D4** pin (yellow jumper)
5. Connect AHT10 **SCL** to Xiao **D5** pin (green jumper)

**Step 3: Connect OLED Display**
1. Insert OLED into breadboard (below AHT10)
2. Connect OLED **VCC** to **+3.3V rail** (red jumper)
3. Connect OLED **GND** to **GND rail** (black jumper)
4. Connect OLED **SDA** to **same row as AHT10 SDA** (they share!)
5. Connect OLED **SCL** to **same row as AHT10 SCL** (they share!)

**Step 4: Verify connections**
- [ ] 3.3V rail connected to Xiao 3V3 (bottom pad)
- [ ] GND rail connected to Xiao GND (bottom pad)
- [ ] Both AHT10 and OLED VCC connected to +3.3V rail
- [ ] Both AHT10 and OLED GND connected to GND rail
- [ ] Both AHT10 and OLED SDA connected together to Xiao **D4** (left side, 5th pin)
- [ ] Both AHT10 and OLED SCL connected together to Xiao **D5** (left side, 6th pin)

**Critical:** Do NOT connect 5V to any device! Xiao ESP32-C6 is 3.3V only.

---

## ESPHome Configuration

Create a new file: `/home/hazzard/home-assistant/esphome/xiao-climate-display.yaml`

### Complete Configuration

```yaml
esphome:
  name: xiao-climate-display
  friendly_name: "Climate Monitor"

esp32:
  board: seeed_xiao_esp32c6
  variant: esp32c6
  framework:
    type: esp-idf
    version: recommended
    sdkconfig_options:
      CONFIG_ESPTOOLPY_FLASHSIZE_4MB: y

# WiFi configuration
wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password

  manual_ip:
    static_ip: 192.168.40.152  # Choose an unused IP
    gateway: 192.168.40.1
    subnet: 255.255.255.0
    dns1: 8.8.8.8

  # Fallback hotspot
  ap:
    ssid: "Climate-Display-AP"
    password: "12345678"

# Enable logging
logger:
  level: DEBUG

# Enable Home Assistant API
api:
  encryption:
    key: !secret api_key_xiao_climate

# Enable OTA updates
ota:
  - platform: esphome
    password: !secret ota_password

# I2C Bus Configuration (Hardware I2C on Xiao ESP32-C6)
i2c:
  sda: GPIO4  # D4 pin (left side, 5th pin)
  scl: GPIO5  # D5 pin (left side, 6th pin)
  scan: true  # Scan and log I2C devices at boot
  frequency: 100kHz  # Standard I2C speed (can increase to 400kHz if needed)

# Fonts for OLED display
font:
  - file: "gfonts://Roboto"
    id: font_small
    size: 12

  - file: "gfonts://Roboto"
    id: font_medium
    size: 16

  - file: "gfonts://Roboto@700"  # Bold
    id: font_large
    size: 24

# Display Configuration (SSD1306 OLED)
display:
  - platform: ssd1306_i2c
    model: "SSD1306 128x64"
    address: 0x3C  # Common address (try 0x3D if this doesn't work)
    id: oled_display
    update_interval: 2s  # Refresh display every 2 seconds
    lambda: |-
      // Clear screen
      it.fill(COLOR_OFF);

      // Header bar (top 16 pixels)
      it.rectangle(0, 0, 128, 16, COLOR_ON);
      it.filled_rectangle(0, 0, 128, 16, COLOR_ON);
      it.print(64, 2, id(font_small), COLOR_OFF, TextAlign::TOP_CENTER, "CLIMATE MONITOR");

      // Temperature section
      if (id(aht_temperature).has_state()) {
        it.printf(10, 24, id(font_large), "%.1f°", id(aht_temperature).state);
      } else {
        it.print(10, 24, id(font_large), "--°");
      }

      // Humidity section
      if (id(aht_humidity).has_state()) {
        it.printf(10, 48, id(font_medium), "%.0f%% RH", id(aht_humidity).state);
      } else {
        it.print(10, 48, id(font_medium), "--% RH");
      }

      // WiFi status indicator (top-right)
      if (id(wifi_signal_db).has_state()) {
        int rssi = id(wifi_signal_db).state;
        if (rssi > -60) {
          // Strong signal - 3 bars
          it.filled_rectangle(110, 8, 2, 4, COLOR_OFF);
          it.filled_rectangle(114, 6, 2, 6, COLOR_OFF);
          it.filled_rectangle(118, 4, 2, 8, COLOR_OFF);
        } else if (rssi > -70) {
          // Medium signal - 2 bars
          it.filled_rectangle(110, 8, 2, 4, COLOR_OFF);
          it.filled_rectangle(114, 6, 2, 6, COLOR_OFF);
        } else {
          // Weak signal - 1 bar
          it.filled_rectangle(110, 8, 2, 4, COLOR_OFF);
        }
      }

# Sensors
sensor:
  # AHT10 Temperature & Humidity
  - platform: aht10
    variant: AHT10  # Use AHT10 (not AHT20)
    temperature:
      name: "Temperature"
      id: aht_temperature
      unit_of_measurement: "°C"
      accuracy_decimals: 1
      filters:
        - filter_out: nan
        - sliding_window_moving_average:
            window_size: 5
            send_every: 1
        # Optional calibration offset (adjust after testing)
        # - offset: -0.5

    humidity:
      name: "Humidity"
      id: aht_humidity
      unit_of_measurement: "%"
      accuracy_decimals: 1
      filters:
        - filter_out: nan
        - sliding_window_moving_average:
            window_size: 5
            send_every: 1
        # Optional calibration offset
        # - offset: 2.0

    update_interval: 10s  # Read sensor every 10 seconds

  # WiFi Signal Strength
  - platform: wifi_signal
    name: "WiFi Signal"
    id: wifi_signal_db
    update_interval: 30s
    internal: true  # Don't expose to HA (used only for display)

  # Device Uptime
  - platform: uptime
    name: "Uptime"
    update_interval: 60s

  # Calculated Sensors

  # Dew Point (condensation risk indicator)
  - platform: template
    name: "Dew Point"
    id: dew_point
    unit_of_measurement: "°C"
    accuracy_decimals: 1
    lambda: |-
      if (id(aht_temperature).has_state() && id(aht_humidity).has_state()) {
        float temp = id(aht_temperature).state;
        float humidity = id(aht_humidity).state;
        float a = 17.27;
        float b = 237.7;
        float alpha = ((a * temp) / (b + temp)) + log(humidity / 100.0);
        float dew_point = (b * alpha) / (a - alpha);
        return dew_point;
      } else {
        return NAN;
      }
    update_interval: 30s

  # Absolute Humidity (grams of water per cubic meter)
  - platform: template
    name: "Absolute Humidity"
    id: abs_humidity
    unit_of_measurement: "g/m³"
    accuracy_decimals: 1
    lambda: |-
      if (id(aht_temperature).has_state() && id(aht_humidity).has_state()) {
        float temp = id(aht_temperature).state;
        float rh = id(aht_humidity).state;
        // Absolute humidity formula
        float abs_hum = (6.112 * exp((17.67 * temp) / (temp + 243.5)) * rh * 2.1674) / (273.15 + temp);
        return abs_hum;
      } else {
        return NAN;
      }
    update_interval: 30s

# Text Sensors
text_sensor:
  # Device IP Address
  - platform: wifi_info
    ip_address:
      name: "IP Address"
    ssid:
      name: "Connected SSID"
    mac_address:
      name: "MAC Address"

# Buttons
button:
  - platform: restart
    name: "Restart Device"

# Status LED (onboard RGB LED on Xiao ESP32-C6)
light:
  - platform: status_led
    name: "Status LED"
    id: status_light
    pin:
      number: GPIO15  # Onboard LED on Xiao ESP32-C6
      inverted: false
```

---

## Step-by-Step Build Guide

### Step 1: Install ESPHome (if not already installed)

Your ESPHome dashboard is already running at http://192.168.40.201:6052

### Step 2: Create Configuration File

1. Access ESPHome dashboard: http://192.168.40.201:6052
2. Click "**+ NEW DEVICE**"
3. Enter name: `xiao-climate-display`
4. Select device type: "**ESP32-C6**"
5. Click "**SKIP**" (we'll paste the full config)
6. Click "**EDIT**" on the new device
7. Replace all contents with the YAML configuration above
8. Click "**SAVE**"

### Step 3: Update Secrets File

Add these entries to `/home/hazzard/home-assistant/esphome/secrets.yaml`:

```yaml
# Xiao Climate Display
api_key_xiao_climate: "<generate-new-key>"  # ESPHome will auto-generate
```

### Step 4: First Flash (USB)

1. Connect Xiao ESP32-C6 to computer via USB-C cable
2. In ESPHome dashboard, click "**INSTALL**" on your device
3. Select "**Plug into this computer**"
4. Choose the USB serial port (usually `/dev/ttyACM0` or `/dev/ttyUSB0`)
5. Click "**INSTALL**"
6. Wait for compilation and upload (3-5 minutes first time)

**If upload fails:**
- Try holding the **BOOT** button while connecting USB
- Try a different USB cable (some are charge-only)
- Install drivers: `sudo apt-get install esptool`

### Step 5: Verify I2C Devices

After flashing, click "**LOGS**" button and look for:

```
[I][i2c.arduino:071]: Results from i2c bus scan:
[I][i2c.arduino:077]: Found i2c device at address 0x38
[I][i2c.arduino:077]: Found i2c device at address 0x3C
```

**Expected devices:**
- `0x38` = AHT10 sensor
- `0x3C` = SSD1306 OLED display (or `0x3D` on some modules)

**If devices not found:**
- Check wiring (SDA/SCL connections)
- Verify power connections (3.3V and GND)
- Try swapping SDA and SCL wires
- Check if your OLED is at address `0x3D` instead of `0x3C`

### Step 6: Test Display

The OLED should light up and show:
- Header bar: "CLIMATE MONITOR"
- Temperature: "22.5°" (large font)
- Humidity: "45% RH" (medium font)
- WiFi signal indicator (top-right corner)

### Step 7: Verify Sensor Readings

Check logs for sensor data:

```
[D][aht10:056]: Got temperature=22.3°C humidity=45.2%
[D][sensor:093]: 'Temperature': Sending state 22.30 °C
[D][sensor:093]: 'Humidity': Sending state 45.20 %
```

### Step 8: Add to Home Assistant

1. Home Assistant should auto-discover the device
2. Go to **Settings → Devices & Services → Integrations**
3. Click "**CONFIGURE**" on the ESPHome notification
4. Your device appears with sensors:
   - `sensor.temperature`
   - `sensor.humidity`
   - `sensor.dew_point`
   - `sensor.absolute_humidity`
   - `sensor.wifi_signal`
   - `sensor.uptime`

---

## Display Customization

### Alternative Display Layout 1: Minimalist

```yaml
display:
  - platform: ssd1306_i2c
    # ... (same settings)
    lambda: |-
      it.fill(COLOR_OFF);

      // Large temperature (centered)
      if (id(aht_temperature).has_state()) {
        it.printf(64, 10, id(font_large), TextAlign::TOP_CENTER, "%.1f°C", id(aht_temperature).state);
      }

      // Humidity below
      if (id(aht_humidity).has_state()) {
        it.printf(64, 40, id(font_medium), TextAlign::TOP_CENTER, "%.0f%% RH", id(aht_humidity).state);
      }
```

### Alternative Display Layout 2: Split Screen

```yaml
display:
  - platform: ssd1306_i2c
    # ... (same settings)
    lambda: |-
      it.fill(COLOR_OFF);

      // Vertical divider
      it.line(64, 0, 64, 64, COLOR_ON);

      // Left side: Temperature
      it.print(32, 10, id(font_small), TextAlign::TOP_CENTER, "TEMP");
      if (id(aht_temperature).has_state()) {
        it.printf(32, 28, id(font_large), TextAlign::TOP_CENTER, "%.1f", id(aht_temperature).state);
      }
      it.print(32, 54, id(font_small), TextAlign::TOP_CENTER, "°C");

      // Right side: Humidity
      it.print(96, 10, id(font_small), TextAlign::TOP_CENTER, "HUMID");
      if (id(aht_humidity).has_state()) {
        it.printf(96, 28, id(font_large), TextAlign::TOP_CENTER, "%.0f", id(aht_humidity).state);
      }
      it.print(96, 54, id(font_small), TextAlign::TOP_CENTER, "%");
```

### Alternative Display Layout 3: Graph Mode (Advanced)

```yaml
display:
  - platform: ssd1306_i2c
    # ... (same settings)
    lambda: |-
      // Show temperature history graph (requires history tracking)
      // This is an advanced feature - see ESPHome documentation
      it.fill(COLOR_OFF);
      it.print(0, 0, id(font_small), "Temperature History");
      // Graph implementation here
      // (Requires additional sensor configuration with history tracking)
```

### Alternative Display Layout 4: Dew Point Included

```yaml
display:
  - platform: ssd1306_i2c
    # ... (same settings)
    lambda: |-
      it.fill(COLOR_OFF);

      // Title
      it.print(64, 0, id(font_small), TextAlign::TOP_CENTER, "CLIMATE");

      // Temperature
      if (id(aht_temperature).has_state()) {
        it.printf(10, 16, id(font_medium), "T: %.1f°C", id(aht_temperature).state);
      }

      // Humidity
      if (id(aht_humidity).has_state()) {
        it.printf(10, 32, id(font_medium), "H: %.0f%%", id(aht_humidity).state);
      }

      // Dew Point
      if (id(dew_point).has_state()) {
        it.printf(10, 48, id(font_small), "Dew: %.1f°C", id(dew_point).state);
      }
```

---

## Understanding the Code

### ESP32-C6 Board Configuration

```yaml
esp32:
  board: seeed_xiao_esp32c6
  variant: esp32c6
  framework:
    type: esp-idf  # Use ESP-IDF framework (required for C6)
```

**Why ESP-IDF?**
The ESP32-C6 uses a RISC-V architecture (not Xtensa like older ESP32), so it requires the ESP-IDF framework instead of Arduino framework.

### I2C Bus Setup

```yaml
i2c:
  sda: GPIO4  # D4 pin on Xiao ESP32-C6
  scl: GPIO5  # D5 pin on Xiao ESP32-C6
  scan: true  # Scan bus at boot and log found devices
  frequency: 100kHz  # Standard I2C speed
```

**Frequency Options:**
- **100kHz** (Standard Mode) - Default, most compatible
- **400kHz** (Fast Mode) - Faster refresh, shorter wire runs needed
- **1MHz** (Fast Mode Plus) - Advanced, requires good wiring

### AHT10 Sensor Configuration

```yaml
sensor:
  - platform: aht10
    variant: AHT10  # Specify AHT10 (not AHT20)
    temperature:
      # ... configuration
    humidity:
      # ... configuration
    update_interval: 10s  # Read every 10 seconds
```

**Update Interval Recommendations:**
- **5-10s** - Display applications (responsive)
- **30-60s** - Home automation (battery friendly)
- **300s (5 min)** - Historical logging only

### Display Lambda Function

The `lambda:` section is C++ code that runs every time the display updates.

**Basic Drawing Functions:**

```cpp
// Clear screen
it.fill(COLOR_OFF);

// Draw text
it.print(x, y, id(font_name), "Text");

// Draw text with variable
it.printf(x, y, id(font_name), "Temp: %.1f°C", temperature_value);

// Draw rectangle (outline)
it.rectangle(x, y, width, height, COLOR_ON);

// Draw filled rectangle
it.filled_rectangle(x, y, width, height, COLOR_ON);

// Draw line
it.line(x1, y1, x2, y2, COLOR_ON);

// Text alignment
it.print(x, y, id(font), TextAlign::TOP_CENTER, "Centered Text");
```

**Text Alignment Options:**
- `TOP_LEFT`, `TOP_CENTER`, `TOP_RIGHT`
- `CENTER_LEFT`, `CENTER`, `CENTER_RIGHT`
- `BOTTOM_LEFT`, `BOTTOM_CENTER`, `BOTTOM_RIGHT`

### Checking Sensor States

```cpp
if (id(aht_temperature).has_state()) {
  // Sensor has valid data
  float temp = id(aht_temperature).state;
  it.printf(10, 24, id(font_large), "%.1f°", temp);
} else {
  // Sensor not ready or error
  it.print(10, 24, id(font_large), "--°");
}
```

**Why check `has_state()`?**
On boot, sensors take a few seconds to initialize. Checking prevents displaying garbage values.

---

## Troubleshooting

### OLED Display Not Lighting Up

**Symptom:** Display stays dark/blank.

**Fixes:**
1. **Check power:** Verify VCC connected to 3.3V, GND to GND
2. **Check I2C address:**
   - Look at logs: `Found i2c device at address 0x??`
   - If found at `0x3D` instead of `0x3C`, change config:
     ```yaml
     display:
       - platform: ssd1306_i2c
         address: 0x3D  # Change from 0x3C
     ```
3. **Check wiring:** SDA to D4, SCL to D5
4. **Try contrast adjustment:**
   ```yaml
   display:
     - platform: ssd1306_i2c
       contrast: 100%  # Default is 80%, try 100%
   ```
5. **Verify display model:**
   - Some displays are 128x32 instead of 128x64
   - Change to: `model: "SSD1306 128x32"`

### AHT10 Not Found (Address 0x38 Missing)

**Symptom:** Logs show only `0x3C` found, not `0x38`.

**Fixes:**
1. **Check AHT10 wiring:**
   - VCC to 3.3V
   - GND to GND
   - SDA to D4 (same as OLED)
   - SCL to D5 (same as OLED)
2. **Power cycle:** Unplug and replug USB
3. **Check sensor module:** Some "AHT10" modules are actually AHT20
   - Try changing config to:
     ```yaml
     sensor:
       - platform: aht10
         variant: AHT20  # Try AHT20 instead
     ```
4. **Test sensor alone:** Temporarily remove OLED, test AHT10 by itself

### Temperature Reads Too High

**Symptom:** Temperature 2-3°C above actual room temperature.

**Cause:** Xiao ESP32-C6 self-heating (small board, concentrated heat).

**Fixes:**
1. **Use calibration offset:**
   ```yaml
   sensor:
     - platform: aht10
       temperature:
         filters:
           - offset: -2.5  # Subtract self-heating (adjust to your value)
   ```
2. **Physical separation:**
   - Use longer jumper wires (10-20cm)
   - Mount AHT10 away from Xiao board
3. **Add airflow:** Small ventilation holes or fan

### Display Shows Garbled Text

**Symptom:** Random pixels, corrupted characters.

**Cause:** I2C communication errors (wiring issue or interference).

**Fixes:**
1. **Shorten wires:** Keep I2C wires < 15cm
2. **Reduce I2C speed:**
   ```yaml
   i2c:
     frequency: 50kHz  # Slow down from 100kHz
   ```
3. **Add pull-up resistors:**
   - 4.7kΩ resistor from SDA to 3.3V
   - 4.7kΩ resistor from SCL to 3.3V
   - (Most modules have built-in pull-ups, but external ones can help)
4. **Check power supply:** Use a good quality USB cable and power adapter

### WiFi Disconnects Frequently

**Symptom:** Device goes offline, requires restart.

**Fixes:**
1. **Check WiFi signal:**
   - Look at logs: `WiFi Signal: -XX dBm`
   - Target: -60 dBm or better
   - Move closer to router or use extender
2. **Add reconnection logic:**
   ```yaml
   wifi:
     # ... existing config
     reboot_timeout: 15min
     power_save_mode: none  # Disable power saving
   ```
3. **Use WiFi 6 features:**
   ```yaml
   wifi:
     # ... existing config
     enable_rrm: true  # Enable fast roaming
     enable_btm: true
   ```

### Compilation Fails

**Symptom:** ESPHome compilation errors.

**Common errors and fixes:**

**Error: "board 'seeed_xiao_esp32c6' not found"**
- Update ESPHome to latest version: 2024.6.0 or newer
- Check board name spelling

**Error: "Could not find a board named 'esp32c6'"**
- Ensure `variant: esp32c6` is set
- Use `framework: type: esp-idf`

**Error: Font download failed**
- Check internet connection on ESPHome server
- Use local font file instead:
  ```yaml
  font:
    - file: "fonts/Roboto-Regular.ttf"  # Place .ttf file in /config/esphome/fonts/
      id: font_small
      size: 12
  ```

---

## Home Assistant Dashboard

### Card 1: Gauge Card (Temperature)

```yaml
type: gauge
entity: sensor.temperature
name: Living Room Temperature
unit: °C
min: 15
max: 30
severity:
  green: 18
  yellow: 25
  red: 28
needle: true
```

### Card 2: History Graph

```yaml
type: history-graph
entities:
  - entity: sensor.temperature
    name: Temperature
  - entity: sensor.humidity
    name: Humidity
  - entity: sensor.dew_point
    name: Dew Point
hours_to_show: 24
refresh_interval: 0
```

### Card 3: Entities Card (All Sensors)

```yaml
type: entities
title: Climate Monitor
entities:
  - entity: sensor.temperature
    name: Temperature
    icon: mdi:thermometer
  - entity: sensor.humidity
    name: Humidity
    icon: mdi:water-percent
  - entity: sensor.dew_point
    name: Dew Point
    icon: mdi:water-thermometer
  - entity: sensor.absolute_humidity
    name: Absolute Humidity
    icon: mdi:water
  - entity: sensor.wifi_signal
    name: WiFi Signal
    icon: mdi:wifi
  - entity: sensor.uptime
    name: Uptime
    icon: mdi:clock-outline
```

### Card 4: Picture Elements (Custom Design)

```yaml
type: picture-elements
image: /local/climate-background.png  # Custom background image
elements:
  - type: state-label
    entity: sensor.temperature
    style:
      top: 40%
      left: 30%
      font-size: 48px
      color: white
  - type: state-label
    entity: sensor.humidity
    style:
      top: 60%
      left: 30%
      font-size: 32px
      color: white
```

---

## Automations

### Automation 1: High Humidity Alert with Display Message

```yaml
# In Home Assistant: Settings → Automations → Create Automation

alias: "High Humidity Alert"
trigger:
  - platform: numeric_state
    entity_id: sensor.humidity
    above: 70
    for:
      minutes: 5
action:
  # Send notification
  - service: notify.mobile_app
    data:
      title: "High Humidity"
      message: "Humidity is {{ states('sensor.humidity') }}%"

  # Turn on exhaust fan (if you have one)
  - service: switch.turn_on
    target:
      entity_id: switch.bathroom_fan
```

### Automation 2: Condensation Risk Warning

```yaml
alias: "Condensation Risk Warning"
trigger:
  - platform: template
    value_template: >
      {{ (states('sensor.temperature')|float - states('sensor.dew_point')|float) < 3 }}
action:
  - service: notify.mobile_app
    data:
      title: "Condensation Risk"
      message: "Temperature is {{ (states('sensor.temperature')|float - states('sensor.dew_point')|float)|round(1) }}°C above dew point. Condensation may form!"
```

### Automation 3: Morning Climate Report

```yaml
alias: "Morning Climate Report"
trigger:
  - platform: time
    at: "07:00:00"
action:
  - service: tts.google_translate_say
    data:
      entity_id: media_player.bedroom_speaker
      message: >
        Good morning! The temperature is {{ states('sensor.temperature') }} degrees,
        humidity is {{ states('sensor.humidity') }} percent.
```

---

## Advanced Enhancements

### Enhancement 1: Battery Power Operation

Add battery monitoring and deep sleep for portable operation:

```yaml
# Add to sensor section
sensor:
  # Battery voltage monitoring (if using battery)
  - platform: adc
    pin: GPIO2  # A0 pin
    name: "Battery Voltage"
    attenuation: 11db
    filters:
      - multiply: 2.0  # Voltage divider compensation
    update_interval: 60s

# Deep sleep configuration
deep_sleep:
  id: deep_sleep_control
  run_duration: 30s  # Stay awake for 30 seconds
  sleep_duration: 5min  # Sleep for 5 minutes
```

### Enhancement 2: Multiple Sensors

Add more I2C sensors on the same bus:

```yaml
# Add BME280 for pressure readings
sensor:
  # Existing AHT10 config...

  # BME280 (Pressure sensor)
  - platform: bme280_i2c
    address: 0x76
    temperature:
      name: "BME280 Temperature"
    pressure:
      name: "Atmospheric Pressure"
    humidity:
      name: "BME280 Humidity"
    update_interval: 60s

# Add BH1750 light sensor
sensor:
  - platform: bh1750
    name: "Illuminance"
    address: 0x23
    update_interval: 30s
```

### Enhancement 3: Touch Button Input

Add touch buttons for display mode switching:

```yaml
# Touch sensor configuration
binary_sensor:
  - platform: touchscreen
    id: touch_button
    pin: GPIO3  # D3 pin
    threshold: 500  # Adjust sensitivity

# Switch display modes on touch
globals:
  - id: display_mode
    type: int
    initial_value: '0'

# In display lambda:
lambda: |-
  if (id(display_mode) == 0) {
    // Mode 0: Temperature focus
  } else if (id(display_mode) == 1) {
    // Mode 1: Humidity focus
  } else {
    // Mode 2: Both + dew point
  }
```

### Enhancement 4: Data Logging to SD Card

```yaml
# SD Card configuration (requires SD card module)
spi:
  clk_pin: GPIO8
  mosi_pin: GPIO9
  miso_pin: GPIO10

# Log data to CSV file
logger:
  level: INFO
  logs:
    sensor: DEBUG
```

### Enhancement 5: Motion-Activated Display

Save power by turning off display when nobody is nearby:

```yaml
# PIR motion sensor
binary_sensor:
  - platform: gpio
    pin: GPIO4
    name: "Motion Detected"
    device_class: motion
    on_press:
      - display.turn_on: oled_display
    on_release:
      - delay: 30s
      - display.turn_off: oled_display
```

---

## Enclosure Design

### 3D Printable Case

Design considerations for a custom enclosure:

**Dimensions:**
- Internal space: 60mm x 40mm x 20mm
- Xiao ESP32-C6 mounting holes: 17.5mm apart
- Display cutout: 28mm x 15mm (visible area)
- AHT10 vent holes: 5mm diameter holes for airflow

**Features:**
- USB-C access port
- Ventilation for temperature accuracy
- OLED viewing window
- Wall mount or desk stand options

**Files to create:**
- `climate-monitor-case-top.stl`
- `climate-monitor-case-bottom.stl`
- `climate-monitor-stand.stl`

**Print Settings (Ender-3 V3):**
- Material: PLA or PETG
- Layer height: 0.2mm
- Infill: 20%
- Supports: Only for overhangs > 60°
- Print time: ~2 hours

---

## Power Consumption

**Active Mode (Display On):**
- Xiao ESP32-C6: ~80mA
- AHT10 sensor: ~0.5mA
- OLED display: ~20mA
- **Total:** ~100mA @ 3.3V = 0.33W

**Sleep Mode (Display Off):**
- Xiao ESP32-C6 (deep sleep): ~15µA
- AHT10 (powered down): ~3µA
- **Total:** ~18µA @ 3.3V = 0.00006W

**Battery Life Estimates:**
- **1000mAh battery, active mode:** ~10 hours
- **1000mAh battery, 50% duty cycle:** ~20 hours
- **1000mAh battery, deep sleep 95%:** ~2000 hours (83 days!)

---

## Comparison: This Project vs Alternatives

| Feature | This Project | DHT22 + ESP32 | BME680 + OLED | Commercial Sensor |
|---------|--------------|---------------|---------------|-------------------|
| **Cost** | $25-35 | $15-25 | $40-50 | $50-150 |
| **Accuracy** | ±0.3°C, ±2% | ±0.5°C, ±2% | ±0.5°C, ±3% | ±0.2°C, ±1.5% |
| **Local Display** | ✅ Yes | ❌ No | ✅ Yes | ✅ Yes |
| **Pressure Sensor** | ❌ No | ❌ No | ✅ Yes | Sometimes |
| **Air Quality** | ❌ No | ❌ No | ✅ Yes (VOC) | Sometimes |
| **Size** | Tiny (Xiao) | Medium | Medium | Varies |
| **Customizable** | ✅ Fully | ✅ Fully | ✅ Fully | ❌ No |
| **Battery Friendly** | ✅ Yes (15µA) | ⚠️ Fair | ⚠️ Fair | ✅ Yes |

**This project wins for:**
- Compact size (Xiao ESP32-C6)
- Local display + cloud integration
- Low cost with good accuracy
- Full customization

---

## What You've Learned

By completing this project, you now understand:

✅ **I2C Communication:**
- Shared bus architecture (multiple devices, 2 wires)
- I2C addressing system
- Pull-up resistors and bus speed

✅ **Xiao ESP32-C6 Platform:**
- RISC-V architecture (vs traditional Xtensa)
- ESP-IDF framework
- Ultra-low power capabilities
- WiFi 6 support

✅ **OLED Display Programming:**
- SSD1306 driver
- Drawing functions (text, shapes, lines)
- Display layouts and fonts
- Refresh rates and optimization

✅ **Environmental Sensing:**
- AHT10 sensor operation
- Temperature/humidity accuracy
- Calculated metrics (dew point, absolute humidity)
- Calibration techniques

✅ **Integration Skills:**
- Multiple sensors on one bus
- Local display + cloud reporting
- Power management strategies
- Enclosure design considerations

---

## Next Steps

### Immediate Enhancements
1. **Add BME280** for barometric pressure readings
2. **3D print an enclosure** for a finished look
3. **Add battery power** for portable operation
4. **Create Grafana dashboard** for historical trends

### Related Projects
- [Project 5: Environmental Monitoring Station](05-environmental-station.md) - Multi-sensor weather station
- [Project 6: Smart Plant Monitor](06-smart-plant-monitor.md) - Add soil moisture sensing
- [Project 11: Energy Monitoring](11-energy-monitoring.md) - Track power usage

### Advanced Challenges
- **Multi-room network:** Deploy 3-5 units, compare readings
- **Predictive alerts:** Use historical data to predict when to open windows
- **Weather forecasting:** Combine pressure trends with temperature for local forecasts
- **MQTT gateway:** Publish data to MQTT for integration with other systems

---

## Troubleshooting Quick Reference

| Problem | Quick Fix |
|---------|-----------|
| Display blank | Check address (0x3C vs 0x3D), verify power |
| AHT10 not found | Verify wiring, try variant: AHT20 |
| Temp reads high | Add offset: -2.5°C, improve ventilation |
| WiFi disconnects | Reduce distance to router, disable power save |
| Garbled display | Shorten wires, reduce I2C speed to 50kHz |
| Compilation fails | Update ESPHome to 2024.6.0+, check board name |

---

## Resources

**Datasheets:**
- [Xiao ESP32-C6 Wiki](https://wiki.seeedstudio.com/xiao_esp32c6_getting_started/)
- [AHT10 Datasheet](http://www.aosong.com/en/products-40.html)
- [SSD1306 OLED Datasheet](https://cdn-shop.adafruit.com/datasheets/SSD1306.pdf)

**ESPHome Documentation:**
- [I2C Bus Component](https://esphome.io/components/i2c.html)
- [AHT10 Sensor](https://esphome.io/components/sensor/aht10.html)
- [SSD1306 Display](https://esphome.io/components/display/ssd1306.html)
- [Display Rendering](https://esphome.io/components/display/index.html#rendering-engine)

**Community:**
- [ESPHome Discord](https://discord.gg/KhAMKrd)
- [Home Assistant Forums](https://community.home-assistant.io/)
- [Seeed Studio Forums](https://forum.seeedstudio.com/)

---

**Ready to build?** Gather your parts and let's get started! This project is perfect for learning I2C, displays, and compact sensor design.

If you have questions or run into issues, check the troubleshooting section or reach out to the community!
