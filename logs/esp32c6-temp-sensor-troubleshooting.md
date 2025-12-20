# ESP32-C6 Temperature Sensor Troubleshooting Log

## Session: 2025-12-19

### Working Configuration (ESP32 DevKitC)
- **Board:** ESP32 DevKitC (original Xtensa architecture)
- **Config:** `/home/hazzard/home-assistant/esphome/esp32-temp-test.yaml`
- **Sensor:** AHT10/AHT20 temperature/humidity sensor
- **Status:** ✅ WORKING - sensor detected, reading temps

### Non-Working Configuration (XIAO ESP32-C6)
- **Board:** XIAO ESP32-C6 (RISC-V architecture)
- **Config:** `/home/hazzard/home-assistant/esphome/esp32c6-temp-test.yaml`
- **Sensor:** Same AHT10/AHT20 sensor (confirmed working)
- **Wiring:** Same physical connections, just swapped boards
- **Power:** 3.17V measured (good)
- **Status:** ❌ NOT WORKING - "Found no devices" on I2C bus scan

### Pin Mapping Attempts
1. ❌ GPIO4/GPIO5 (initial guess - incorrect)
2. ❌ GPIO22/GPIO23 (from pinout: D4=GPIO22, D5=GPIO23) - current attempt

### Current Issue
I2C bus scan finds **no devices** at all, even at 50kHz frequency.

### Next Steps
- Check if XIAO ESP32-C6 has different default I2C pins
- Look for ESP32-C6 RISC-V specific I2C configuration requirements
- Check if there's a known issue with ESP-IDF and C6 I2C
- Try alternative GPIO pins that support I2C on ESP32-C6
