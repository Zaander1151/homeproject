# Troubleshooting: ESP32 DevKit C + AHT10 Sensor

**Date Started:** 2024-12-18
**Hardware:** ESP32 DevKit C (brand new, never flashed before)
**Sensor:** AHT10 temperature/humidity sensor (3 units available for testing)
**Goal:** Get AHT10 working via I2C, then integrate with Home Assistant

---

## Current Wiring Configuration

### AHT10 Connections:
- **VIN** → 3V rail (breadboard)
- **GND** → GND rail (breadboard)
- **SDA** → ESP32 GPIO21
- **SCL** → ESP32 GPIO22

### Pull-up Resistors (4.7kΩ):
- ESP32 GPIO21 → 4.7kΩ resistor → 3V rail
- ESP32 GPIO22 → 4.7kΩ resistor → 3V rail

### Power Rails:
- ESP32 3.3V pin → 3V rail (breadboard)
- ESP32 GND pin → GND rail (breadboard)

---

## Device Information

**ESP32:**
- IP Address: 192.168.40.181
- MAC Address: F4:65:0B:B6:8A:E8
- Hostname: esp32-temp-test
- WiFi: Connected successfully
- USB Serial: /dev/ttyUSB0 (CP2102N UART Bridge)

**ESPHome Config:** `/home/hazzard/home-assistant/esphome/esp32-temp-test.yaml`

---

## What We've Tried

### ✅ WORKING:
1. **ESP32 boots successfully** - Safe mode counter resets, device stable
2. **WiFi connection works** - Device accessible at 192.168.40.181
3. **OTA updates work** - Can flash firmware over WiFi
4. **I2C bus scan works** - Detects device at address 0x38
5. **USB serial connection** - Device visible as /dev/ttyUSB0
6. **Docker device mapping** - ESPHome container can access /dev/ttyUSB0

### ❌ FAILING:
1. **AHT10 communication** - Sensor found at 0x38 but initialization fails with "Communication failed"

### Attempts Made:

#### 1. **Swapped AHT10 sensors** (tried 2 out of 3 available)
   - Result: Same error on both sensors

#### 2. **Added pull-up resistors** (4.7kΩ on SDA/SCL)
   - Result: No improvement

#### 3. **Adjusted I2C frequency** to 100kHz (from default 50kHz)
   - Result: No improvement

#### 4. **Tried `aht20` platform** instead of `aht10`
   - Result: (Previously attempted, same failure)

#### 5. **Confirmed correct sensor type**
   - Photo verified it's AHT10 (not AHT20/DHT20)

---

## Current Error Messages

From ESPHome logs:

```
[C][i2c.arduino:072]: I2C Bus:
[C][i2c.arduino:073]:   SDA Pin: GPIO21
[C][i2c.arduino:073]:   SCL Pin: GPIO22
[C][i2c.arduino:073]:   Frequency: 100000 Hz
[C][i2c.arduino:089]:   Recovery: bus successfully recovered
[I][i2c.arduino:099]: Results from bus scan:
[I][i2c.arduino:105]: Found device at address 0x38

[C][aht10:156]: AHT10:
[C][aht10:157]:   Address: 0x38
[E][aht10:159]: Communication failed
[E][component:154]:   aht10.sensor is marked FAILED: unspecified
```

Earlier during setup (first flash):
```
[D][esp-idf:000]: E (72) i2c.master: I2C hardware NACK detected
[D][esp-idf:000]: E (73) i2c.master: I2C transaction unexpected nack detected
[D][esp32-hal-i2c-ng.c:265] i2cWrite(): i2c_master_transmit failed: [259] ESP_ERR_INVALID_STATE
```

---

## Analysis

**What's Strange:**
- I2C scan successfully detects the sensor at 0x38
- But actual communication during sensor initialization fails
- NACK errors suggest sensor isn't responding to initialization commands
- This happens on **multiple AHT10 sensors**, suggesting not a defective sensor
- Pull-up resistors didn't help (expected to fix NACK issues)

**Possible Issues to Investigate:**
1. ESP32 I2C driver compatibility with AHT10
2. Timing issues during sensor initialization
3. Power supply instability (though scan works fine)
4. ESPHome AHT10 library bug with this ESP32 variant
5. Need different GPIO pins?
6. Framework issue (Arduino vs ESP-IDF)?

---

## Next Steps to Try

1. **Try different I2C GPIO pins** (GPIO25/GPIO26 or GPIO18/GPIO19)
2. **Switch to ESP-IDF framework** instead of Arduino ← **CURRENTLY TESTING**
3. **Test with a different I2C sensor** to rule out ESP32 I2C issues
4. **Check ESPHome GitHub** for AHT10 issues
5. **Try manual I2C communication** via custom component

---

## Attempt Log

### 2024-12-18 18:42 - Testing ESP-IDF Framework
Changed framework from Arduino to ESP-IDF. Flashing now via OTA...

**Result:** FAILED - Same "Communication failed" error. Framework is not the issue.

### 2024-12-18 19:04 - Testing ENVIV Sensor
Swapped to M5Stack ENVIV Unit (5V sensor with SHT30 + BMP280) to test if ESP32 I2C works at all.

**Result:** FAILED - I2C scan found **NO DEVICES** (previously found AHT10 at 0x38). Both SHT30 and BMP280 failed communication.

---

## Conclusion: PROJECT ABANDONED

After extensive testing:
- ✅ ESP32 boots and runs firmware successfully
- ✅ WiFi and OTA work perfectly
- ✅ I2C scan initially detected AHT10 at 0x38
- ❌ All I2C sensors fail during initialization/communication
- ❌ Both Arduino and ESP-IDF frameworks fail
- ❌ Multiple AHT10 sensors tested (same failure)
- ❌ ENVIV sensor test showed no devices on I2C scan

**Possible root causes:**
1. Faulty ESP32 DevKit C board (I2C hardware issue)
2. Breadboard connection problems
3. Unknown incompatibility with ESPHome I2C implementation

**Decision:** Project scrapped. Consider using pre-built M5Stack Atom Echo devices instead of bare ESP32 boards for future sensor projects.

---

## ESPHome Configuration

Current config at `/home/hazzard/home-assistant/esphome/esp32-temp-test.yaml`:

```yaml
esphome:
  name: esp32-temp-test
  friendly_name: ESP32 Temperature Test

esp32:
  board: esp32dev
  framework:
    type: arduino

logger:
  level: DEBUG

api:
  encryption:
    key: "TR2lIHJRfx+9l75EjasL0EbVW4BiMc5ZoNQA5gc4ibE="

ota:
  - platform: esphome
    password: !secret ota_password

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  manual_ip:
    static_ip: 192.168.40.181
    gateway: 192.168.40.1
    subnet: 255.255.255.0
    dns1: 8.8.8.8
  ap:
    ssid: "ESP32-Temp-Test"
    password: "fallback123"

i2c:
  sda: GPIO21
  scl: GPIO22
  scan: true
  frequency: 100kHz
  id: bus_a

sensor:
  - platform: aht10
    temperature:
      name: "Temperature"
    humidity:
      name: "Humidity"
    update_interval: 10s
```
