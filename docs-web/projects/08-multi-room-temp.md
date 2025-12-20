# Project 8: Multi-Room Temperature Display

**Difficulty:** Intermediate
**Estimated Time:** 4-6 hours
**Cost:** $30-50

## Learning Objectives

By completing this project, you will learn:

- ESP-NOW wireless protocol for ESP32 mesh networking
- Distributed sensor networks without Wi-Fi infrastructure
- One-to-many and many-to-one communication patterns
- Data aggregation and display from multiple sources
- MAC address management for device pairing
- Low-power wireless sensor design
- Central coordinator vs edge node architecture

## What You'll Build

A multi-room temperature monitoring system with:

- **3+ ESP32 sensor nodes** in different rooms (bedroom, living room, office, etc.)
- **1 central display ESP32** that aggregates and shows all temperatures
- **ESP-NOW mesh network** for fast, low-latency communication (no Wi-Fi required on sensor nodes)
- **Home Assistant integration** via central coordinator
- **Battery-powered sensor nodes** with deep sleep for 6+ month battery life
- **Real-time temperature comparison** across all rooms
- **OLED display** showing min/max/average temperatures

## Why ESP-NOW?

**ESP-NOW vs Wi-Fi:**

| Feature | ESP-NOW | Wi-Fi |
|---------|---------|-------|
| **Power consumption** | Ultra-low (µW in sleep) | High (mW continuous) |
| **Latency** | <10ms | 50-200ms |
| **Range** | Up to 200m outdoors | Depends on router |
| **Setup complexity** | MAC address pairing | SSID/password/DHCP |
| **Battery life** | 6-12 months | Days to weeks |
| **Infrastructure** | None (peer-to-peer) | Requires Wi-Fi router |

**Best Use Cases:**
- Battery-powered sensors (motion, temperature, door/window)
- Low-latency control (light switches, remotes)
- Mesh networks in areas without Wi-Fi coverage
- Projects with many sensors (MAC address limit: 20 peers)

## Components Needed

### For Each Sensor Node (x3)

| Component | Quantity | Estimated Cost | Notes |
|-----------|----------|----------------|-------|
| ESP32 Development Board | 1 | $8-12 | Deep sleep capable |
| DHT22 Temperature Sensor | 1 | $4-6 | Or BME280 (I2C) |
| 18650 Li-Ion Battery | 1 | $5-8 | 3.7V, 3000mAh |
| TP4056 Battery Charger Module | 1 | $1-2 | USB charging |
| Slide Switch | 1 | $0.50 | Power on/off |
| Project Enclosure | 1 | $3-5 | Small plastic box |

**Cost per sensor node:** ~$25-35

### For Central Coordinator (x1)

| Component | Quantity | Estimated Cost | Notes |
|-----------|----------|----------------|-------|
| ESP32 Development Board | 1 | $8-12 | Always-powered |
| OLED Display (0.96" I2C) | 1 | $5-8 | SSD1306 chipset |
| USB Power Supply | 1 | $5-8 | 5V 1A minimum |
| Project Enclosure | 1 | $5-10 | For wall mounting |

**Total Project Cost:** ~$100-150 (for 3 sensor nodes + coordinator)

### Optional Enhancements

- Larger OLED display (1.3" or 2.4") for better visibility ($10-20)
- Solar panel + charging module for outdoor sensors ($15-25)
- Humidity/pressure sensors (BME280 instead of DHT22) (+$3-5 per node)
- LED status indicators ($0.50 each)

## System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                   ESP-NOW Mesh Network                  │
└─────────────────────────────────────────────────────────┘

┌──────────────┐       ┌──────────────┐       ┌──────────────┐
│ Bedroom Node │       │Living Rm Node│       │ Office Node  │
│              │       │              │       │              │
│ ESP32 + DHT22│       │ ESP32 + DHT22│       │ ESP32 + DHT22│
│ (Battery)    │       │ (Battery)    │       │ (Battery)    │
│              │       │              │       │              │
│ Wakes every  │       │ Wakes every  │       │ Wakes every  │
│ 5 minutes    │       │ 5 minutes    │       │ 5 minutes    │
└──────┬───────┘       └──────┬───────┘       └──────┬───────┘
       │                      │                      │
       │    ESP-NOW Packets   │                      │
       │    (MAC addressed)   │                      │
       └──────────────────────┼──────────────────────┘
                              │
                              ▼
                    ┌─────────────────┐
                    │ Central Display │
                    │   Coordinator   │
                    │                 │
                    │ ESP32 + OLED    │
                    │ (Always On)     │
                    │                 │
                    │ • Receives data │
                    │ • Updates OLED  │
                    │ • Sends to HA   │
                    └────────┬────────┘
                             │
                             │ Wi-Fi
                             ▼
                    ┌─────────────────┐
                    │ Home Assistant  │
                    │                 │
                    │ ESPHome API     │
                    │ 192.168.40.201  │
                    └─────────────────┘
```

**Communication Flow:**
1. Sensor node wakes from deep sleep (every 5 minutes)
2. Reads temperature from DHT22
3. Broadcasts data via ESP-NOW to coordinator's MAC address
4. Goes back to deep sleep (consumes ~10µA)
5. Coordinator receives data, updates OLED display
6. Coordinator forwards data to Home Assistant via Wi-Fi

## Hardware Setup

### Sensor Node Wiring

```
DHT22 Temperature Sensor:
  Pin 1 (VCC) -----> 3.3V (ESP32)
  Pin 2 (DATA) ----> GPIO 4 (ESP32) + 10kΩ pull-up to 3.3V
  Pin 4 (GND) -----> GND

Battery Power Circuit:
  18650 Battery (+) -----> TP4056 BAT+
  18650 Battery (-) -----> TP4056 BAT-
  TP4056 OUT+ -----> Slide Switch
  Slide Switch -----> ESP32 VIN (or 5V pin)
  TP4056 OUT- -----> ESP32 GND
  USB Charging Port -----> TP4056 IN+ / IN-

Optional - LED Status Indicator:
  GPIO 2 -----> 220Ω Resistor -----> LED (+)
  LED (-) -----> GND
```

### Central Coordinator Wiring

```
OLED Display (I2C, 0.96" SSD1306):
  VCC -----> 3.3V (ESP32)
  GND -----> GND
  SDA -----> GPIO 21 (ESP32)
  SCL -----> GPIO 22 (ESP32)

Power:
  USB Power Supply -----> ESP32 USB port
```

### MAC Address Discovery

Before programming, record each ESP32's MAC address:

```cpp
// Upload this sketch to each ESP32 to get MAC address
#include <WiFi.h>

void setup() {
  Serial.begin(115200);
  WiFi.mode(WIFI_STA);
  Serial.print("MAC Address: ");
  Serial.println(WiFi.macAddress());
}

void loop() {}
```

**Record MAC addresses:**
- Bedroom Node: `XX:XX:XX:XX:XX:XX`
- Living Room Node: `XX:XX:XX:XX:XX:XX`
- Office Node: `XX:XX:XX:XX:XX:XX`
- **Coordinator Node:** `XX:XX:XX:XX:XX:XX` (important!)

## ESPHome Configuration

### Sensor Node Configuration

Create `/home/hazzard/home-assistant/esphome/temp-sensor-bedroom.yaml`:

```yaml
substitutions:
  device_name: temp-sensor-bedroom
  friendly_name: "Bedroom Temperature Sensor"
  # Replace with YOUR coordinator's MAC address
  coordinator_mac: "XX:XX:XX:XX:XX:XX"

esphome:
  name: ${device_name}
  friendly_name: ${friendly_name}
  platform: ESP32
  board: esp32dev

# NO Wi-Fi configuration needed (ESP-NOW only)
# This saves power and simplifies setup

logger:
  level: INFO

# ESP-NOW Configuration
esp32:
  board: esp32dev
  framework:
    type: esp-idf

esp_now:
  # Sensor node only SENDS data
  on_send:
    then:
      - logger.log: "Data sent successfully"

# DHT22 Temperature Sensor
sensor:
  - platform: dht
    pin: GPIO4
    model: DHT22
    temperature:
      name: "${friendly_name} Temperature"
      id: room_temperature
    humidity:
      name: "${friendly_name} Humidity"
      id: room_humidity
    update_interval: never  # We'll trigger manually before sleep

# Deep Sleep Management
deep_sleep:
  id: deep_sleep_control
  sleep_duration: 5min  # Wake every 5 minutes

# Main Script: Read sensor, send data, sleep
script:
  - id: send_and_sleep
    then:
      - logger.log: "Waking up..."
      - delay: 2s  # Let sensor stabilize
      - component.update: room_temperature
      - delay: 1s  # Wait for reading
      - lambda: |-
          // Prepare ESP-NOW message
          struct __attribute__((packed)) SensorData {
            float temperature;
            float humidity;
            uint8_t battery_level;
          } data;

          data.temperature = id(room_temperature).state;
          data.humidity = id(room_humidity).state;
          data.battery_level = 100;  // TODO: Add battery monitoring

          // Send to coordinator
          uint8_t mac[] = {0xXX, 0xXX, 0xXX, 0xXX, 0xXX, 0xXX};  // Coordinator MAC
          esp_now_send(mac, (uint8_t*)&data, sizeof(data));
      - delay: 100ms  # Ensure transmission completes
      - logger.log: "Entering deep sleep..."
      - deep_sleep.enter: deep_sleep_control

# Trigger script on boot
on_boot:
  priority: -100
  then:
    - script.execute: send_and_sleep
```

**Important Notes:**
- Replace `coordinator_mac` with your actual coordinator MAC address
- No Wi-Fi credentials needed (ESP-NOW is peer-to-peer)
- Battery life: ~6 months with 3000mAh battery at 5-minute intervals

### Central Coordinator Configuration

Create `/home/hazzard/home-assistant/esphome/temp-display-coordinator.yaml`:

```yaml
substitutions:
  device_name: temp-display-coordinator
  friendly_name: "Temperature Display"

esphome:
  name: ${device_name}
  friendly_name: ${friendly_name}
  platform: ESP32
  board: esp32dev

# Wi-Fi for Home Assistant connection
wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  manual_ip:
    static_ip: 192.168.40.111
    gateway: 192.168.40.1
    subnet: 255.255.255.0
    dns1: 8.8.8.8

logger:
  level: INFO

api:
  encryption:
    key: !secret api_encryption_key

ota:
  - platform: esphome
    password: !secret ota_password

# ESP-NOW Configuration (receive mode)
esp_now:
  on_receive:
    then:
      - lambda: |-
          ESP_LOGI("espnow", "Received data from %02x:%02x:%02x:%02x:%02x:%02x",
                   x[0], x[1], x[2], x[3], x[4], x[5]);

          // Parse received data
          struct __attribute__((packed)) SensorData {
            float temperature;
            float humidity;
            uint8_t battery_level;
          };

          SensorData* data = (SensorData*)data_ptr;

          // Identify sender by MAC address and update corresponding sensor
          if (memcmp(x, bedroom_mac, 6) == 0) {
            id(bedroom_temp).publish_state(data->temperature);
            id(bedroom_humidity).publish_state(data->humidity);
          } else if (memcmp(x, living_room_mac, 6) == 0) {
            id(living_room_temp).publish_state(data->temperature);
            id(living_room_humidity).publish_state(data->humidity);
          } else if (memcmp(x, office_mac, 6) == 0) {
            id(office_temp).publish_state(data->temperature);
            id(office_humidity).publish_state(data->humidity);
          }

# I2C for OLED Display
i2c:
  sda: GPIO21
  scl: GPIO22
  scan: true

# OLED Display (0.96" SSD1306)
display:
  - platform: ssd1306_i2c
    model: "SSD1306 128x64"
    address: 0x3C
    update_interval: 5s
    lambda: |-
      // Title
      it.print(0, 0, id(font_small), "Multi-Room Temp");
      it.line(0, 10, 127, 10);

      // Bedroom
      it.printf(0, 15, id(font_medium), "Bed: %.1f°C", id(bedroom_temp).state);

      // Living Room
      it.printf(0, 30, id(font_medium), "Living: %.1f°C", id(living_room_temp).state);

      // Office
      it.printf(0, 45, id(font_medium), "Office: %.1f°C", id(office_temp).state);

# Fonts for OLED
font:
  - file: "fonts/Arial.ttf"
    id: font_small
    size: 10
  - file: "fonts/Arial.ttf"
    id: font_medium
    size: 14

# Template sensors to store received data
sensor:
  - platform: template
    name: "Bedroom Temperature"
    id: bedroom_temp
    unit_of_measurement: "°C"
    accuracy_decimals: 1

  - platform: template
    name: "Bedroom Humidity"
    id: bedroom_humidity
    unit_of_measurement: "%"
    accuracy_decimals: 0

  - platform: template
    name: "Living Room Temperature"
    id: living_room_temp
    unit_of_measurement: "°C"
    accuracy_decimals: 1

  - platform: template
    name: "Living Room Humidity"
    id: living_room_humidity
    unit_of_measurement: "%"
    accuracy_decimals: 0

  - platform: template
    name: "Office Temperature"
    id: office_temp
    unit_of_measurement: "°C"
    accuracy_decimals: 1

  - platform: template
    name: "Office Humidity"
    id: office_humidity
    unit_of_measurement: "%"
    accuracy_decimals: 0

  # Calculated statistics
  - platform: template
    name: "Average Temperature"
    lambda: |-
      float avg = (id(bedroom_temp).state +
                   id(living_room_temp).state +
                   id(office_temp).state) / 3.0;
      return avg;
    unit_of_measurement: "°C"
    update_interval: 10s

# Globals for MAC address storage
globals:
  - id: bedroom_mac
    type: uint8_t[6]
    initial_value: '{0xXX, 0xXX, 0xXX, 0xXX, 0xXX, 0xXX}'  # Replace with bedroom MAC

  - id: living_room_mac
    type: uint8_t[6]
    initial_value: '{0xXX, 0xXX, 0xXX, 0xXX, 0xXX, 0xXX}'  # Replace with living room MAC

  - id: office_mac
    type: uint8_t[6]
    initial_value: '{0xXX, 0xXX, 0xXX, 0xXX, 0xXX, 0xXX}'  # Replace with office MAC
```

## Step-by-Step Build Process

### Step 1: Get MAC Addresses

1. Flash MAC address discovery sketch to each ESP32
2. Open serial monitor (115200 baud)
3. Record MAC address for each device
4. Label each ESP32 physically (e.g., "Bedroom Node - AA:BB:CC:DD:EE:FF")

### Step 2: Build and Test Coordinator First

1. Wire OLED display to coordinator ESP32
2. Update `temp-display-coordinator.yaml` with sensor node MAC addresses
3. Flash coordinator: `docker exec -it esphome esphome run temp-display-coordinator.yaml`
4. Verify OLED displays "Multi-Room Temp" title
5. Confirm device appears in Home Assistant

### Step 3: Build First Sensor Node

1. Wire DHT22 to sensor ESP32
2. Update `temp-sensor-bedroom.yaml` with coordinator's MAC address
3. Flash sensor node: `docker exec -it esphome esphome run temp-sensor-bedroom.yaml`
4. Watch coordinator logs: `docker exec -it esphome esphome logs temp-display-coordinator.yaml`
5. Verify "Received data from..." message appears
6. Check OLED display updates with bedroom temperature

### Step 4: Add Battery Power to Sensor Node

1. Connect TP4056 charger module to 18650 battery
2. Wire TP4056 output to ESP32 VIN via slide switch
3. Test: Toggle switch ON → ESP32 boots → sends data → sleeps
4. Verify current draw in deep sleep (<100µA with multimeter)

### Step 5: Deploy Remaining Sensor Nodes

1. Repeat Steps 3-4 for living room and office nodes
2. Update YAML files with appropriate names and MAC addresses
3. Flash and test each node individually
4. Verify all temperatures appear on OLED display

### Step 6: Final Integration

1. Place sensor nodes in desired locations
2. Verify signal strength (ESP-NOW range up to 200m outdoors, less indoors)
3. Monitor Home Assistant for all temperature entities
4. Create dashboard card to visualize all rooms

## Battery Life Optimization

### Deep Sleep Current Draw

**Target:** <50µA in deep sleep for 6+ month battery life

**Power-Hungry Components:**
- ESP32 active: ~160mA (80mA with Wi-Fi off)
- ESP32 deep sleep: ~10µA
- DHT22 standby: ~50µA
- TP4056 quiescent: ~2mA ⚠️ **Problem!**

**Solution:** Use MT3608 boost converter or dedicated battery protection board

### Battery Life Calculation

```
Battery capacity: 3000mAh
Sleep current: 50µA (0.05mA)
Wake time: 3 seconds every 5 minutes
Wake current: 80mA (Wi-Fi off, ESP-NOW only)

Sleep power: 0.05mA × (300 - 3) seconds = 0.05mA × 297s = 14.85mAs
Wake power: 80mA × 3s = 240mAs
Total per cycle: 14.85 + 240 = 254.85mAs = 0.0708mAh

Battery life: 3000mAh ÷ 0.0708mAh = 42,372 cycles
42,372 cycles × 5 minutes = 211,860 minutes = 147 days ≈ 5 months
```

**Improvement Strategies:**
1. Increase sleep interval to 10 minutes → 10 months
2. Use 6000mAh battery → 10 months
3. Add solar panel → indefinite
4. Optimize wake time to 2 seconds → 7 months

### Battery Voltage Monitoring

Add battery level reporting:

```yaml
sensor:
  - platform: adc
    pin: GPIO35
    name: "Battery Voltage"
    id: battery_voltage
    attenuation: 11db
    filters:
      - multiply: 2.0  # Voltage divider (2x)
    update_interval: never  # Only read before sleep

  - platform: template
    name: "Battery Level"
    id: battery_level
    unit_of_measurement: "%"
    lambda: |-
      float voltage = id(battery_voltage).state;
      // Li-Ion: 4.2V = 100%, 3.0V = 0%
      float percent = (voltage - 3.0) / 1.2 * 100.0;
      if (percent > 100) return 100;
      if (percent < 0) return 0;
      return percent;
```

## Home Assistant Integration

### Automatic Discovery

After flashing coordinator, all sensors appear in Home Assistant:

- `sensor.bedroom_temperature`
- `sensor.bedroom_humidity`
- `sensor.living_room_temperature`
- `sensor.living_room_humidity`
- `sensor.office_temperature`
- `sensor.office_humidity`
- `sensor.average_temperature`

### Dashboard Card Example

```yaml
type: vertical-stack
cards:
  - type: markdown
    content: |
      # Multi-Room Temperature

  - type: entities
    title: Individual Rooms
    entities:
      - entity: sensor.bedroom_temperature
        name: Bedroom
        icon: mdi:bed
      - entity: sensor.living_room_temperature
        name: Living Room
        icon: mdi:sofa
      - entity: sensor.office_temperature
        name: Office
        icon: mdi:desk
      - entity: sensor.average_temperature
        name: Average
        icon: mdi:thermometer

  - type: history-graph
    title: Temperature History (24h)
    entities:
      - entity: sensor.bedroom_temperature
      - entity: sensor.living_room_temperature
      - entity: sensor.office_temperature
    hours_to_show: 24
    refresh_interval: 60

  - type: gauge
    entity: sensor.average_temperature
    name: Average Temperature
    min: 15
    max: 30
    severity:
      green: 20
      yellow: 18
      red: 16
```

### Automation Example: Temperature Alerts

```yaml
automation:
  - alias: "Temperature Alert - Too Cold"
    trigger:
      - platform: numeric_state
        entity_id:
          - sensor.bedroom_temperature
          - sensor.living_room_temperature
          - sensor.office_temperature
        below: 18
        for:
          minutes: 15
    action:
      - service: notify.mobile_app
        data:
          title: "Low Temperature Alert"
          message: "{{ trigger.to_state.attributes.friendly_name }} is {{ trigger.to_state.state }}°C"

  - alias: "Temperature Alert - Too Hot"
    trigger:
      - platform: numeric_state
        entity_id:
          - sensor.bedroom_temperature
          - sensor.living_room_temperature
          - sensor.office_temperature
        above: 26
        for:
          minutes: 15
    action:
      - service: notify.mobile_app
        data:
          title: "High Temperature Alert"
          message: "{{ trigger.to_state.attributes.friendly_name }} is {{ trigger.to_state.state }}°C"
```

## Troubleshooting

### ESP-NOW Communication Issues

| Problem | Solution |
|---------|----------|
| **Coordinator not receiving data** | • Verify MAC addresses in YAML files (use `WiFi.macAddress()`)<br>• Check ESP-NOW is enabled on both devices<br>• Reduce distance between devices (start at 1m)<br>• Verify sensor node is actually waking up (add LED indicator) |
| **Data received but wrong values** | • Check struct packing (`__attribute__((packed))`)<br>• Verify data types match (float vs int)<br>• Add `ESP_LOGI` debug statements to print received values |
| **Intermittent connectivity** | • Check for Wi-Fi interference (change channels)<br>• Verify sensor node doesn't sleep before transmission completes<br>• Add `delay(100ms)` after `esp_now_send()` |

### OLED Display Issues

| Problem | Solution |
|---------|----------|
| **Display not detected** | • Check I2C address with `i2c.scan: true` in logs<br>• Verify SDA/SCL wiring (GPIO21/GPIO22)<br>• Try different address (0x3C or 0x3D) |
| **Garbled display** | • Verify display model (`SSD1306 128x64` vs `SSD1306 128x32`)<br>• Check font file paths<br>• Reduce update frequency |
| **Display flickers** | • Increase `update_interval` (try 10s)<br>• Simplify lambda (fewer graphics operations) |

### Battery/Power Issues

| Problem | Solution |
|---------|----------|
| **Short battery life (<1 month)** | • Measure deep sleep current (should be <100µA)<br>• Check for LED always-on (disable power LEDs on dev board)<br>• Verify deep sleep actually activates (`logger.log` before sleep)<br>• TP4056 may have high quiescent current, use better regulator |
| **Sensor node not waking up** | • Check battery voltage (Li-Ion: 3.0V minimum, 4.2V full)<br>• Verify deep sleep duration is set correctly<br>• Use EN pin pull-up resistor (10kΩ to 3.3V) |
| **Battery not charging** | • Check TP4056 LED indicators (red=charging, blue=full)<br>• Verify USB cable provides data + power<br>• Test battery with multimeter (should be 3.7V nominal) |

### Debugging Commands

```bash
# View coordinator logs (see ESP-NOW packets)
docker exec -it esphome esphome logs temp-display-coordinator.yaml

# Flash sensor node over USB (for initial setup)
docker exec -it esphome esphome run temp-sensor-bedroom.yaml

# Check Home Assistant device status
# Settings → Devices & Services → ESPHome → Temperature Display
```

## Project Extensions

### 1. Add More Sensor Types

Expand to environmental monitoring:

```yaml
sensor:
  - platform: bme280
    address: 0x76
    temperature:
      name: "Temperature"
    humidity:
      name: "Humidity"
    pressure:
      name: "Pressure"
```

### 2. Outdoor Sensor with Solar Panel

For weather monitoring:

```yaml
# Add solar panel charging
# 6V 1W solar panel → TP4056 → 3000mAh battery

sensor:
  - platform: adc
    pin: GPIO36
    name: "Solar Voltage"
    attenuation: 11db
```

### 3. Two-Way Communication

Send commands back to sensor nodes:

```yaml
# On coordinator, send control message
esp_now:
  on_send:
    then:
      - logger.log: "Command sent to sensor"

# On sensor node, receive commands
esp_now:
  on_receive:
    then:
      - lambda: |-
          // Parse command and take action
          if (data[0] == 0x01) {
            // Force immediate reading
            id(send_and_sleep).execute();
          }
```

### 4. Motion-Triggered Wake

Ultra-low power motion detection:

```yaml
# Add PIR sensor with hardware interrupt
deep_sleep:
  wakeup_pin: GPIO33  # PIR sensor output
  wakeup_pin_mode: KEEP_AWAKE

# Device only wakes when motion detected
```

### 5. Mesh Relay Network

Extend range by relaying through intermediate nodes:

```yaml
# Intermediate relay node
esp_now:
  on_receive:
    then:
      - lambda: |-
          // Re-broadcast to coordinator
          esp_now_send(coordinator_mac, data, data_len);
```

### 6. Historical Data Logging

Store readings locally on SD card:

```yaml
# Add SD card module (SPI)
spi:
  clk_pin: GPIO18
  mosi_pin: GPIO23
  miso_pin: GPIO19

# Log data to CSV file
```

## Best Practices

### Power Management

- **Always test deep sleep current** with multimeter before deployment
- **Remove unnecessary LEDs** (power indicator LEDs waste 2-5mA continuously)
- **Use ESP32-PICO-D4** for lower sleep current (~5µA vs ~10µA)
- **Disable Wi-Fi completely** on sensor nodes (ESP-NOW doesn't need it)

### Reliability

- **Add watchdog timer** to reset if sensor node hangs
- **Implement retry logic** for failed ESP-NOW transmissions
- **Store MAC addresses in globals** for easier management
- **Use battery voltage monitoring** to warn before depletion

### Scalability

- **MAC address limit:** ESP-NOW supports 20 paired devices maximum
- **Packet size limit:** 250 bytes per ESP-NOW message
- **Use unique identifiers** in payload (room ID) instead of relying on MAC matching

### Security

- **ESP-NOW supports encryption** (optional, reduces battery life slightly)
- **No authentication by default** (anyone can send data to your MAC)
- **Use Wi-Fi channel 1** for maximum compatibility

## Next Steps

After completing this project, consider:

1. **Advanced Projects:** 3D printer monitoring, greenhouse automation, smart mailbox
2. **ESP-NOW Mesh Networks:** Multi-hop relay for extended range
3. **BLE + ESP-NOW Hybrid:** Use BLE for config, ESP-NOW for data
4. **LoRa for Long Range:** Switch to LoRa (up to 10km) for farm/ranch applications
5. **Commercial Sensor Networks:** Zigbee, Thread, Matter protocols

## Resources

- [ESP-NOW Official Documentation](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/network/esp_now.html)
- [ESPHome ESP-NOW Component](https://esphome.io/components/esp_now.html)
- [ESP32 Deep Sleep Tutorial](https://randomnerdtutorials.com/esp32-deep-sleep-arduino-ide-wake-up-sources/)
- [Battery Life Calculator](https://www.digikey.com/en/resources/conversion-calculators/conversion-calculator-battery-life)
- [OLED Display Guide](https://randomnerdtutorials.com/esp32-ssd1306-oled-display-arduino-ide/)

---

**Congratulations!** You've built a distributed sensor network using ESP-NOW mesh networking. This project demonstrates advanced concepts: wireless protocols, power optimization, data aggregation, and multi-device coordination. The skills learned here apply to countless IoT applications from home automation to industrial monitoring.
