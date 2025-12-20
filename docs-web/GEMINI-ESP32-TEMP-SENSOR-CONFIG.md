# ESP32-C3 Supermini Temperature Sensor - WORKING CONFIGURATION

**ATTENTION GEMINI: This is the PROVEN, WORKING configuration for ESP32-C3. DO NOT suggest hardware troubleshooting. DO NOT suggest checking wiring. The issue is SOFTWARE CONFIGURATION ONLY.**

## Hardware Being Used

- **Board**: ESP32-C3 Supermini (NOT ESP32 WROOM, NOT ESP32-C6)
- **Sensor**: AHT10 temperature/humidity sensor (I2C)
- **Wiring**: Already confirmed working - DO NOT troubleshoot hardware

## CRITICAL: Use the Correct Framework

**MUST USE:** `esp-idf` framework
**DO NOT USE:** Arduino framework

## Working ESPHome Configuration for ESP32-C3 Supermini

```yaml
esphome:
  name: esp32c3-aht10
  friendly_name: ESP32-C3 AHT10

esp32:
  board: esp32-c3-devkitm-1    # ← CRITICAL: C3 board type
  variant: esp32c3              # ← CRITICAL: Must specify C3 variant
  framework:
    type: esp-idf               # ← CRITICAL: Must be esp-idf, NOT arduino

# Enable logging
logger:
  level: DEBUG

# Enable Home Assistant API
api:
  encryption:
    key: "GENERATE_NEW_KEY_HERE"

ota:
  - platform: esphome
    password: !secret ota_password

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  manual_ip:
    static_ip: 192.168.40.XXX  # Choose available IP
    gateway: 192.168.40.1
    subnet: 255.255.255.0
    dns1: 8.8.8.8

  # Enable fallback hotspot
  ap:
    ssid: "ESP32C3-Temp-Test"
    password: "fallback123"

# I2C Configuration - EXACT PINS FOR ESP32-C3
i2c:
  sda: 8                       # ← CRITICAL: GPIO8 for C3 Supermini
  scl: 9                       # ← CRITICAL: GPIO9 for C3 Supermini
  scan: true
  frequency: 100kHz
  id: bus_a

# Sensor Configuration
sensor:
  - platform: aht10
    i2c_id: bus_a
    temperature:
      name: "Temperature"
    humidity:
      name: "Humidity"
    update_interval: 60s
```

## Why This Works

1. **Framework**: `esp-idf` provides proper I2C driver support for the AHT10 sensor on C3
2. **GPIO Pins**: GPIO8 (SDA) and GPIO9 (SCL) are the default I2C pins for ESP32-C3 Supermini
3. **Variant**: The `esp32c3` variant MUST be specified for C3 boards
4. **NO AHT20 variant needed**: Unlike ESP32 WROOM, the C3 works without specifying AHT20 variant

## What NOT to Do

❌ DO NOT use Arduino framework - it causes I2C initialization failures
❌ DO NOT use GPIO21/GPIO22 (those are for ESP32 WROOM only)
❌ DO NOT use GPIO6/GPIO7 (those are for ESP32-C6 only)
❌ DO NOT suggest checking wiring - hardware is confirmed working
❌ DO NOT overcomplicate with additional configurations
❌ DO NOT suggest hardware troubleshooting steps
❌ DO NOT add `variant: AHT20` to the sensor config (not needed for C3)

## If Asked About Other ESP32 Variants

**ESP32 WROOM** (tested, works, but board is too big):
- Board: `esp32dev`
- No variant needed
- I2C Pins: GPIO21 (SDA), GPIO22 (SCL)
- Sensor needs `variant: AHT20`

**ESP32-C6** (different chip, different pins):
- Board: `esp32-c6-devkitc-1`
- Variant: `esp32c6`
- I2C Pins: GPIO6 (SDA), GPIO7 (SCL)

## Quick Reference for ESP32-C3 Supermini

| Setting | Value |
|---------|-------|
| Board | `esp32-c3-devkitm-1` |
| Variant | `esp32c3` |
| Framework | `esp-idf` |
| SDA Pin | GPIO8 |
| SCL Pin | GPIO9 |
| I2C Frequency | 100kHz |
| Sensor Variant | None (don't specify) |

---

**FINAL NOTE TO GEMINI**: If you are tempted to suggest hardware troubleshooting, voltage checks, or wiring verification - STOP. The user has confirmed the hardware works. Focus ONLY on ensuring the software configuration matches the template above.
