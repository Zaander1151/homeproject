# Project: Seeed XIAO ESP32-C6 Temp/Humidity (AHT20)

## Overview
A compact environmental sensor using the **Seeed Studio XIAO ESP32-C6** and an **AHT20** temperature/humidity sensor.

## Hardware Specifications
*   **MCU**: Seeed Studio XIAO ESP32-C6 (RISC-V architecture)
*   **Sensor**: AHT20 (I2C interface) - *Note: Often sold as "AHT10" but requires AHT20 initialization.*
*   **I2C Pins (Verified Working)**:
    *   **SDA**: GPIO 0 (Pin D0)
    *   **SCL**: GPIO 1 (Pin D1)
*   **I2C Address**: `0x38`

## Wiring Guide (Breadboard Friendly)
| XIAO C6 Pin | AHT20 Pin | Function |
|-------------|-----------|----------|
| 3V3 (Right Side) | VIN      | Power    |
| GND (Right Side) | GND      | Ground   |
| **D0** (Left Side) | SDA      | Data     |
| **D1** (Left Side) | SCL      | Clock    |

## ESPHome Configuration
*   **Board ID**: `seeed_xiao_esp32c6`
*   **Framework**: `esp-idf`
*   **Platform**: `aht10`
*   **Variant**: `AHT20` (Critical: AHT10 variant may fail handshake)

```yaml
i2c:
  sda: 0
  scl: 1
  scan: true
  frequency: 50kHz

sensor:
  - platform: aht10
    variant: AHT20
    temperature:
      name: "AHT20 Temperature"
    humidity:
      name: "AHT20 Humidity"
    update_interval: 10s
```

## Status Log
*   **2025-12-20**: Initial attempts with standard AHT10 config failed.
*   **2025-12-20**: Verified wiring on D0/D1 (SDA/SCL) matches BME280 success.
*   **2025-12-20**: Swapped sensor module (suspected hardware defect on first unit).
*   **2025-12-20**: **SUCCESS.** New sensor detected at `0x38`.
*   **2025-12-20**: Configured with `variant: AHT20` to resolve "Communication failed" errors. Reading stable data.
