# ESP32-C6 Temperature Sensor - Session Notes 2025-12-19

## Summary
AHT10/AHT20 sensor **works perfectly** on ESP32 DevKitC, but **no I2C devices found** when switched to XIAO ESP32-C6.

## CRITICAL: This is NOT a wiring or sensor issue
- Same physical wiring
- Same sensor (confirmed working on DevKitC)
- Just swapped the board
- Problem is XIAO ESP32-C6 pin mapping

## Working Configuration (ESP32 DevKitC)
- File: `/home/hazzard/home-assistant/esphome/esp32-temp-test.yaml`
- Pins: SDA=GPIO21, SCL=GPIO22
- IP: 192.168.40.181
- Status: ✅ WORKING

## NOT Working Configuration (XIAO ESP32-C6)
- File: `/home/hazzard/home-assistant/esphome/esp32c6-temp-test.yaml`
- IP: 192.168.40.161
- Encryption Key: `XfbpEXL6kV5DX7oo0pgzT+YzuJJAQkbu5Dz/d7Zprkk=`

### Tested Pin Combinations (ALL FAILED)
1. GPIO4/GPIO5 - I2C scan: "no devices found"
2. GPIO22/GPIO23 (from pinout: D4=GPIO22, D5=GPIO23) - I2C scan: "no devices found"

## NEXT SESSION: Try GPIO6/GPIO7
- Config file already updated to GPIO6/GPIO7
- **Problem:** User reports difficulty physically accessing GPIO6/GPIO7 pins on breadboard
- May need to find which physical pins on XIAO correspond to GPIO6/GPIO7
