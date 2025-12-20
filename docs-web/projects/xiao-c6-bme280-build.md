# Project: Seeed XIAO ESP32-C6 Climate Sensor (BME280)

## Overview
A compact environmental sensor using the **Seeed Studio XIAO ESP32-C6** and a **BME280** temperature/humidity/pressure sensor.

## Hardware Specifications
*   **MCU**: Seeed Studio XIAO ESP32-C6 (RISC-V architecture)
*   **Sensor**: Bosch BME280 (I2C interface)
*   **I2C Pins (Verified Working)**:
    *   **SDA**: GPIO 0 (Pin D0)
    *   **SCL**: GPIO 1 (Pin D1)
*   **Default I2C Address**: `0x76` (Found at this address)

## Wiring Guide (Breadboard Friendly)
| XIAO C6 Pin | BME280 Pin | Function |
|-------------|------------|----------|
| 3V3 (Right Side) | VCC        | Power    |
| GND (Right Side) | GND        | Ground   |
| **D0** (Left Side) | SDA        | Data     |
| **D1** (Left Side) | SCL        | Clock    |

## ESPHome Configuration Baseline
*   **Board ID**: `seeed_xiao_esp32c6`
*   **Variant**: `esp32c6`
*   **Framework**: `esp-idf` (Required for C6 support)
*   **I2C Frequency**: 50kHz (Stable)

## Status & Progress Log
*   **2025-12-20**: Switched from C3 SuperMini to XIAO C6. 
*   **2025-12-20**: Validated I2C bus on **GPIO 0 (SDA)** and **GPIO 1 (SCL)** after standard D4/D5 failed to detect sensor.
*   **2025-12-20**: **SUCCESS.** BME280 reading Temperature, Humidity, and Pressure correctly. WiFi stable.
