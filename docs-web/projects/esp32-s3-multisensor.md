# ESP32-S3 N16R8 Multisensor

A comprehensive room sensor combining presence detection, climate monitoring, and ambient light sensing for home automation.

## Overview

| Attribute | Value |
|-----------|-------|
| **MCU** | ESP32-S3 N16R8 (16MB Flash, 8MB PSRAM) |
| **Framework** | ESP-IDF |
| **IP Address** | 192.168.40.197 (prototype) |
| **Config** | `/home/hazzard/home-assistant/esphome/multisensor-prototype.yaml` |

## Sensors

| Sensor | Type | Interface | Purpose |
|--------|------|-----------|---------|
| **LD2410C** | mmWave Radar | UART @ 256000 | Presence detection (stationary + moving) |
| **BME280** | Climate | I2C @ 0x76 | Temperature, humidity, pressure |
| **VEML7700** | Light | I2C @ 0x10 | Ambient light (0-120k lux) |
| **HC-SR602** | PIR | Digital | Fast motion trigger (~100ms response) |

## Why These Sensors?

### LD2410C mmWave Radar
- Detects stationary people (PIR cannot)
- Provides distance and energy readings
- Configurable detection zones
- Built-in light sensor (bonus)

### VEML7700 vs BH1750
- Wider dynamic range (0-120,000 lux vs 1-65,535 lux)
- Better low-light sensitivity
- 16-bit resolution
- Built-in flicker rejection

### HC-SR602 vs M5Stack PIR
- Smaller form factor (10mm x 10mm)
- Faster initial response
- Lower power consumption
- Simpler integration (3 pins)

### Sensor Synergy
- **PIR** triggers instantly on motion (fast response)
- **mmWave** maintains presence when stationary (no false-offs)
- **Light sensor** prevents unnecessary light automation
- **Climate** enables comfort-based automations

## Wiring

### Pin Assignments

| GPIO | Function | Connected To |
|------|----------|--------------|
| GPIO4 | Digital Input | HC-SR602 OUT |
| GPIO8 | I2C SDA | BME280 SDA, VEML7700 SDA |
| GPIO9 | I2C SCL | BME280 SCL, VEML7700 SCL |
| GPIO17 | UART RX | LD2410C TX |
| GPIO18 | UART TX | LD2410C RX |
| GPIO48 | LED | Onboard WS2812 (status) |

### Wiring Diagram

```
                    ESP32-S3 N16R8
                   ┌──────────────────┐
                   │                  │
    ┌──────────────┤ 3.3V        GND ├──────────────┐
    │              │                  │              │
    │   ┌──────────┤ GPIO8 (SDA)     │              │
    │   │          │                  │              │
    │   │   ┌──────┤ GPIO9 (SCL)     │              │
    │   │   │      │                  │              │
    │   │   │   ┌──┤ GPIO17 (RX)     │              │
    │   │   │   │  │                  │              │
    │   │   │   │  ├──┐ GPIO18 (TX)  │              │
    │   │   │   │  │  │              │              │
    │   │   │   │  │  │   ┌──────────┤ GPIO4        │
    │   │   │   │  │  │   │          │              │
    │   │   │   │  │  │   │          └──────────────┘
    │   │   │   │  │  │   │
────┴───┴───┴───┴──┴──┴───┴────────────────────────────
    │   │   │   │  │  │   │
    │   │   │   │  │  │   │    ┌─────────────────┐
    │   │   │   │  │  │   └────┤ OUT   HC-SR602  │
    │   │   │   │  │  │        │       (PIR)     │
    ├───┼───┼───┼──┼──┼────────┤ VCC             │
    │   │   │   │  │  │   ┌────┤ GND             │
    │   │   │   │  │  │   │    └─────────────────┘
    │   │   │   │  │  │   │
    │   │   │   │  │  │   │    ┌─────────────────┐
    │   ├───┼───┼──┼──┼───┼────┤ SDA   BME280    │
    │   │   ├───┼──┼──┼───┼────┤ SCL   (0x76)    │
    ├───┼───┼───┼──┼──┼───┼────┤ VCC             │
    │   │   │   │  │  │   ├────┤ GND             │
    │   │   │   │  │  │   │    └─────────────────┘
    │   │   │   │  │  │   │
    │   │   │   │  │  │   │    ┌─────────────────┐
    │   └───┼───┼──┼──┼───┼────┤ SDA   VEML7700  │
    │       └───┼──┼──┼───┼────┤ SCL   (0x10)    │
    ├───────────┼──┼──┼───┼────┤ VCC             │
    │           │  │  │   ├────┤ GND             │
    │           │  │  │   │    └─────────────────┘
    │           │  │  │   │
    │           │  │  │   │    ┌─────────────────┐
    │           │  └──┼───┼────┤ TX    LD2410C   │
    │           └─────┼───┼────┤ RX    (mmWave)  │
    ├─────────────────┼───┼────┤ VCC             │
    │                 │   ├────┤ GND             │
    │                 │   │    └─────────────────┘
    │                 │   │
   3.3V              GND GND
```

### Quick Reference Table

| Sensor | VCC | GND | Data Pins |
|--------|-----|-----|-----------|
| **BME280** | 3.3V | GND | SDA→GPIO8, SCL→GPIO9 |
| **VEML7700** | 3.3V | GND | SDA→GPIO8, SCL→GPIO9 |
| **LD2410C** | 3.3V | GND | TX→GPIO17, RX→GPIO18 |
| **HC-SR602** | 3.3V | GND | OUT→GPIO4 |

## Home Assistant Entities

### Binary Sensors

| Entity | Description |
|--------|-------------|
| `binary_sensor.multisensor_prototype_pir_motion` | Fast motion detection |
| `binary_sensor.multisensor_prototype_presence` | mmWave presence (stationary detection) |
| `binary_sensor.multisensor_prototype_moving_target` | Active movement detected |
| `binary_sensor.multisensor_prototype_still_target` | Stationary person detected |
| `binary_sensor.multisensor_prototype_occupancy` | Combined PIR + radar |

### Climate Sensors

| Entity | Description |
|--------|-------------|
| `sensor.multisensor_prototype_temperature` | Room temperature (°C) |
| `sensor.multisensor_prototype_humidity` | Relative humidity (%) |
| `sensor.multisensor_prototype_pressure` | Barometric pressure (hPa) |
| `sensor.multisensor_prototype_dew_point` | Calculated dew point (°C) |

### Light Sensors

| Entity | Description |
|--------|-------------|
| `sensor.multisensor_prototype_illuminance` | Light level (lux) |
| `sensor.multisensor_prototype_light_level` | Category 0-5 (Dark→Very Bright) |
| `text_sensor.multisensor_prototype_light_condition` | Human-readable light level |

### Radar Sensors

| Entity | Description |
|--------|-------------|
| `sensor.multisensor_prototype_moving_distance` | Distance to moving target (cm) |
| `sensor.multisensor_prototype_still_distance` | Distance to still target (cm) |
| `sensor.multisensor_prototype_moving_energy` | Movement intensity (0-100) |
| `sensor.multisensor_prototype_still_energy` | Presence intensity (0-100) |
| `sensor.multisensor_prototype_detection_distance` | Overall detection distance |

### System Sensors

| Entity | Description |
|--------|-------------|
| `sensor.multisensor_prototype_wifi_signal` | WiFi RSSI (dBm) |
| `sensor.multisensor_prototype_uptime` | Device uptime |
| `sensor.multisensor_prototype_esp32_temperature` | MCU temperature |

## Light Level Scale

The `light_level` sensor provides a numeric scale for automation:

| Value | Name | Lux Range | Example |
|-------|------|-----------|---------|
| 0 | Dark | < 10 | Night, no lights |
| 1 | Dim | 10-50 | Nightlight, moonlight |
| 2 | Low | 50-200 | Evening, dawn/dusk |
| 3 | Medium | 200-500 | Typical indoor lighting |
| 4 | Bright | 500-1000 | Well-lit room, overcast day |
| 5 | Very Bright | > 1000 | Direct sunlight |

## Radar Tuning

The LD2410C can be tuned via Home Assistant:

| Control | Purpose |
|---------|---------|
| `number.multisensor_prototype_radar_timeout` | How long presence holds after last detection |
| `number.multisensor_prototype_radar_max_move_gate` | Max distance for motion detection |
| `number.multisensor_prototype_radar_max_still_gate` | Max distance for presence detection |
| `select.multisensor_prototype_radar_distance_resolution` | 0.75m or 0.2m resolution |

## Deployment Plan

| Room | IP Address | Config File |
|------|------------|-------------|
| Prototype | 192.168.40.197 | `multisensor-prototype.yaml` |
| Bedroom | 192.168.40.180 | `multisensor-bedroom.yaml` |
| Bathroom | 192.168.40.181 | `multisensor-bathroom.yaml` |
| Living Room | 192.168.40.182 | `multisensor-living-room.yaml` |
| Front Hall | 192.168.40.183 | `multisensor-front-hall.yaml` |

## Automation Ideas

### Lighting Control
```yaml
# Turn on lights when:
# - Room is occupied (PIR or radar)
# - Light level is Dark or Dim (< 50 lux)
# Turn off lights when:
# - No presence for 5 minutes (radar timeout)
```

### Climate Integration
```yaml
# Adjust HVAC when:
# - Room is occupied AND temperature outside comfort range
# - Humidity exceeds threshold (bathroom fan)
```

### Energy Saving
```yaml
# Reduce standby power when:
# - No presence for extended period
# - Light level indicates daylight (no need for lights)
```

## Parts List

| Part | Quantity | Approx Cost |
|------|----------|-------------|
| ESP32-S3 N16R8 DevKit | 1 | $8-12 |
| LD2410C mmWave Sensor | 1 | $4-8 |
| BME280 Module | 1 | $3-5 |
| VEML7700 Module | 1 | $3-5 |
| HC-SR602 PIR | 1 | $1-2 |
| Dupont Wires | ~15 | $1 |
| **Total** | | **~$20-33** |

## Troubleshooting

### I2C Devices Not Found
- Check SDA/SCL wiring
- Verify 3.3V power to sensors
- Try reducing I2C frequency to 50kHz
- Check for address conflicts (BME280 can be 0x76 or 0x77)

### LD2410C Not Responding
- Verify TX/RX are crossed (S3 RX → Radar TX)
- Check baud rate is 256000
- Ensure 3.3V power (not 5V)
- Try radar restart button in HA

### PIR Always Triggered
- HC-SR602 has ~2.5s retriggering delay
- Check for heat sources in view
- Adjust delayed_off filter in config

### Light Readings Erratic
- VEML7700 auto-mode handles most cases
- Shield sensor from direct light if saturating
- Check for IR interference from other devices

## References

- [ESPHome LD2410 Documentation](https://esphome.io/components/sensor/ld2410.html)
- [ESPHome BME280 Documentation](https://esphome.io/components/sensor/bme280.html)
- [ESPHome VEML7700 Documentation](https://esphome.io/components/sensor/veml7700.html)
- [ESP32-S3 Datasheet](https://www.espressif.com/sites/default/files/documentation/esp32-s3_datasheet_en.pdf)
