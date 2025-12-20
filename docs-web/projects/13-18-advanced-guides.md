# Projects 13-18: Advanced & Integration Builds

This guide provides comprehensive information for the remaining advanced ESP32 projects. Each section includes parts lists, wiring diagrams, complete ESPHome configurations, and key implementation details.

---

# Project 13: Outdoor Weather Station

**Difficulty:** Advanced | **Time:** 8-12 hours | **Cost:** $60-100

## Parts List

| Part | Qty | Cost (CAD) | Notes |
|------|-----|------------|-------|
| ESP32 Board | 1 | $8-12 | Deep sleep capable |
| BME280 Sensor | 1 | $12-18 | Temp, humidity, pressure |
| Tipping Bucket Rain Gauge | 1 | $25-35 | 0.2794mm per tip |
| Anemometer (wind speed) | 1 | $15-25 | Reed switch, pulse output |
| Wind Vane | 1 | $10-15 | Resistor ladder or Hall effect |
| Solar Panel (6V 1W) | 1 | $10-15 | Battery charging |
| 18650 Battery Holder | 1 | $5-8 | 2× 18650 cells |
| TP4056 Charging Module | 1 | $2-3 | Li-ion charge controller |
| Weatherproof Enclosure (IP67) | 1 | $15-25 | Outdoor rated |

## Key ESPHome Configuration

```yaml
esphome:
  name: weather-station
  on_boot:
    - priority: 200
      then:
        - delay: 30s  # Allow sensors to stabilize
        - deep_sleep.prevent: deep_sleep_control

esp32:
  board: esp32dev
  framework:
    type: arduino

# Deep Sleep for Battery Life
deep_sleep:
  id: deep_sleep_control
  run_duration: 60s      # Wake for 60s
  sleep_duration: 5min   # Sleep for 5 min
  wakeup_pin: GPIO33     # Wake on rain gauge tip (optional)
  wakeup_pin_mode: KEEP_AWAKE

# Rain Gauge (Pulse Counter)
sensor:
  - platform: pulse_counter
    pin:
      number: GPIO12
      mode:
        input: true
        pullup: true
    name: "Rainfall Rate"
    unit_of_measurement: "mm/h"
    filters:
      - multiply: 16.764  # (0.2794mm × 60min)
    total:
      name: "Total Rainfall"
      unit_of_measurement: "mm"
      filters:
        - multiply: 0.2794

  # Anemometer (Wind Speed)
  - platform: pulse_counter
    pin:
      number: GPIO14
      mode:
        input: true
        pullup: true
    name: "Wind Speed"
    unit_of_measurement: "km/h"
    count_mode:
      rising_edge: INCREMENT
      falling_edge: DISABLE
    update_interval: 10s
    filters:
      - multiply: 2.4  # Calibration factor (device specific)

  # Wind Direction (Resistor Ladder on ADC)
  - platform: adc
    pin: GPIO34
    name: "Wind Direction Raw"
    id: wind_dir_raw
    update_interval: 10s
    attenuation: 11db

  - platform: template
    name: "Wind Direction"
    unit_of_measurement: "°"
    icon: "mdi:compass"
    lambda: |-
      float voltage = id(wind_dir_raw).state;
      // Voltage-to-direction mapping (calibrate your vane)
      if (voltage < 0.4) return 0;    // N
      if (voltage < 0.6) return 45;   // NE
      if (voltage < 0.9) return 90;   // E
      if (voltage < 1.2) return 135;  // SE
      if (voltage < 1.5) return 180;  // S
      if (voltage < 1.8) return 225;  // SW
      if (voltage < 2.1) return 270;  // W
      return 315;                     // NW

  # BME280 (standard config from Project 5)
  - platform: bme280
    temperature:
      name: "Outdoor Temperature"
    humidity:
      name: "Outdoor Humidity"
    pressure:
      name: "Atmospheric Pressure"
    address: 0x76
    update_interval: 60s

  # Battery Voltage Monitoring
  - platform: adc
    pin: GPIO35
    name: "Battery Voltage"
    update_interval: 60s
    attenuation: 11db
    filters:
      - multiply: 2.0  # Voltage divider compensation

# Solar Charging Status
binary_sensor:
  - platform: gpio
    pin:
      number: GPIO25
      mode:
        input: true
        pullup: true
    name: "Solar Charging"
    device_class: battery_charging
```

## Installation Tips

**Mounting:**
- Install 2-3m above ground (clear of obstructions)
- Anemometer needs 10m clearance from trees/buildings
- Rain gauge must be level (use bubble level)

**Power Optimization:**
- Deep sleep reduces consumption to ~150μA
- Solar panel can sustain indefinite operation (sunny regions)
- Battery backup for 7-14 days (cloudy weather)

**Calibration:**
- Rain gauge: Calibrate with known water volume
- Anemometer: Compare with local weather station
- Wind vane: Mark compass directions, measure voltages

---

# Project 14: Mailbox Notification System

**Difficulty:** Advanced | **Time:** 4-6 hours | **Cost:** $30-50

## Parts List

| Part | Qty | Cost (CAD) | Notes |
|------|-----|------------|-------|
| ESP32 Board | 1 | $8-12 | Ultra-low power sleep |
| Magnetic Reed Switch | 1 | $2-3 | Door sensor |
| 18650 Battery | 1 | $5-8 | 3000mAh capacity |
| TP4056 Solar Charger | 1 | $2-3 | With battery protection |
| Solar Panel (5V 100mA) | 1 | $5-10 | Mailbox-mounted |
| Waterproof Enclosure | 1 | $5-10 | Small project box |

## Ultra-Low Power ESPHome Config

```yaml
esphome:
  name: mailbox-sensor
  on_boot:
    - priority: 600
      then:
        # Send "boot" notification
        - homeassistant.service:
            service: notify.mobile_app_pixel_10_pro
            data:
              message: "Mailbox sensor online"
        # Immediately enter deep sleep
        - delay: 5s
        - deep_sleep.enter: deep_sleep_control

# Deep Sleep Configuration
deep_sleep:
  id: deep_sleep_control
  wakeup_pin:
    number: GPIO33        # Reed switch input
    mode: KEEP_AWAKE     # Wake on door open
  wakeup_pin_mode: INVERT_WAKEUP

# Reed Switch (Door Sensor)
binary_sensor:
  - platform: gpio
    pin:
      number: GPIO33
      mode:
        input: true
        pullup: true
      inverted: true
    name: "Mailbox Door"
    device_class: door
    on_press:
      # Mail delivery detected!
      - homeassistant.service:
          service: notify.mobile_app_pixel_10_pro
          data:
            title: "📬 Mail Delivered!"
            message: "Mailbox opened at {{ now().strftime('%I:%M %p') }}"
      - delay: 10s  # Stay awake for confirmation
      - deep_sleep.enter: deep_sleep_control

# Battery Monitoring
sensor:
  - platform: adc
    pin: GPIO34
    name: "Battery Voltage"
    update_interval: never  # Only check on wake
    filters:
      - multiply: 2.0
    on_value:
      then:
        - if:
            condition:
              sensor.in_range:
                id: battery_voltage
                below: 3.3  # Low battery threshold
            then:
              - homeassistant.service:
                  service: notify.mobile_app_pixel_10_pro
                  data:
                    message: "⚠️ Mailbox sensor low battery ({{ state }}V)"

# WiFi Fast Connect
wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  fast_connect: true  # Skip channel scan (saves 2-3s)
  power_save_mode: none  # Disable power save during wake

# Minimal Logging (saves power)
logger:
  level: WARN  # Only errors
  baud_rate: 0  # Disable serial
```

## Power Consumption Analysis

| Mode | Current | Duration | Daily Total |
|------|---------|----------|-------------|
| Deep Sleep | 10μA | 23h 59m | 0.24 mAh |
| Wake (WiFi connect) | 150mA | 5s × 3/day | 0.625 mAh |
| Active (notification) | 80mA | 10s × 3/day | 0.67 mAh |
| **Total Daily** | | | **~1.5 mAh** |
| **Battery Life (3000mAh)** | | | **~5.5 years** |

**Real-World:** 6-12 months (battery self-discharge, temperature effects)

**Solar Charging:**
- 100mA panel × 4h sun = 400 mAh/day
- Exceeds consumption by 266× → indefinite operation

---

# Project 15: ESP32-CAM Security Camera

**Difficulty:** Advanced | **Time:** 3-5 hours | **Cost:** $20-40

## Parts List

| Part | Qty | Cost (CAD) | Notes |
|------|-----|------------|-------|
| ESP32-CAM Module | 1 | $12-18 | Includes OV2640 camera |
| FTDI Programmer | 1 | $8-12 | For initial flash (reusable) |
| PIR Motion Sensor | 1 | $2-3 | Motion trigger |
| IR LEDs (optional) | 2-4 | $2-5 | Night vision |
| MicroSD Card (32GB) | 1 | $10-15 | Local storage |
| 5V 2A Power Supply | 1 | $5-8 | Stable power critical |

## Complete ESP32-CAM Configuration

```yaml
esphome:
  name: security-camera
  platformio_options:
    board_build.f_flash: 40000000L
    board_build.flash_mode: dio

esp32:
  board: esp32cam
  framework:
    type: arduino

# Camera Configuration
esp32_camera:
  name: "Security Camera"
  external_clock:
    pin: GPIO0
    frequency: 20MHz
  i2c_pins:
    sda: GPIO26
    scl: GPIO27
  data_pins: [GPIO5, GPIO18, GPIO19, GPIO21, GPIO36, GPIO39, GPIO34, GPIO35]
  vsync_pin: GPIO25
  href_pin: GPIO23
  pixel_clock_pin: GPIO22
  power_down_pin: GPIO32
  reset_pin: GPIO15

  # Image settings
  resolution: 1024x768  # SVGA (higher = more CPU)
  jpeg_quality: 10      # 10 = high quality, 63 = low
  vertical_flip: false
  horizontal_mirror: false

  # Performance
  max_framerate: 10fps  # Lower saves bandwidth
  idle_framerate: 0.1fps  # When not viewing

# PIR Motion Detection
binary_sensor:
  - platform: gpio
    pin:
      number: GPIO13
      mode:
        input: true
    name: "Motion Detected"
    device_class: motion
    on_press:
      # Capture snapshot on motion
      - esp32_camera.snapshot:
          filename: "/motion_{{ now().strftime('%Y%m%d_%H%M%S') }}.jpg"
      # Send notification
      - homeassistant.service:
          service: notify.mobile_app_pixel_10_pro
          data:
            title: "🚨 Motion Detected"
            message: "Camera: {{ states.camera.security_camera.name }}"
            data:
              image: "/api/camera_proxy/camera.security_camera"

# Flash LED (illumination)
output:
  - platform: gpio
    pin: GPIO4
    id: flash_led

light:
  - platform: binary
    output: flash_led
    name: "Camera Flash"

# SD Card (for local storage)
# Note: SD card uses pins that conflict with camera data pins
# Only enable if you reduce camera resolution or use external storage
```

## Integration with Frigate NVR

**Home Assistant Add-on: Frigate**

```yaml
# frigate.yml (Frigate configuration)
cameras:
  security_camera:
    ffmpeg:
      inputs:
        - path: rtsp://192.168.40.180:8554/stream
          roles:
            - detect
            - record
    detect:
      enabled: true
      width: 1024
      height: 768
      fps: 5
    objects:
      track:
        - person
        - car
        - cat
        - dog
    record:
      enabled: true
      retain:
        days: 7
        mode: motion
    snapshots:
      enabled: true
      retain:
        default: 14

# Motion detection zones (ignore trees, roads, etc.)
motion:
  mask:
    - 0,0,100,0,100,100,0,100  # Top-left corner (ignore)
```

**RTSP Stream (requires additional component):**
- ESP32-CAM native RTSP not built-in to ESPHome
- Use Arduino sketch with RTSP library, then integrate via generic camera
- Alternative: Use Home Assistant camera proxy

---

# Project 16: Bathroom Automation Hub

**Difficulty:** Intermediate | **Time:** 4-6 hours | **Cost:** $40-60

## Complete System Configuration

```yaml
esphome:
  name: bathroom-hub

# Components
sensor:
  - platform: dht
    pin: GPIO14
    model: DHT22
    temperature:
      name: "Bathroom Temperature"
    humidity:
      name: "Bathroom Humidity"
      id: bathroom_humidity
    update_interval: 30s

binary_sensor:
  - platform: gpio
    pin:
      number: GPIO12
      mode:
        input: true
        pullup: true
    name: "Bathroom Motion"
    device_class: motion
    id: bathroom_motion

# Exhaust Fan Control
switch:
  - platform: gpio
    pin: GPIO5
    name: "Exhaust Fan"
    id: exhaust_fan

# LED Strip Lighting
light:
  - platform: neopixelbus
    pin: GPIO13
    num_leds: 30
    name: "Bathroom Lights"
    id: bathroom_lights
    effects:
      - addressable_rainbow:
      - pulse:

# Automation Logic
script:
  # Auto-fan when humid
  - id: humidity_control
    then:
      - if:
          condition:
            sensor.in_range:
              id: bathroom_humidity
              above: 70  # 70% threshold
          then:
            - switch.turn_on: exhaust_fan
            - delay: 10min
            - switch.turn_off: exhaust_fan

  # Motion-activated lighting
  - id: motion_lights
    then:
      - light.turn_on:
          id: bathroom_lights
          brightness: 100%
      - wait_until:
          timeout: 10min
          condition:
            binary_sensor.is_off: bathroom_motion
      - light.turn_off: bathroom_lights

  # Nightlight mode (after 10 PM)
  - id: nightlight
    then:
      - lambda: |-
          auto time = id(homeassistant_time).now();
          if (time.hour >= 22 || time.hour < 6) {
            // Warm dim light
            auto call = id(bathroom_lights).turn_on();
            call.set_brightness(0.1);
            call.set_rgb(1.0, 0.5, 0.0);  // Warm orange
            call.perform();
          }

time:
  - platform: homeassistant
    id: homeassistant_time
```

---

# Project 17: Workshop Environmental Control

**Key Components:** BME680 (air quality), fan relay, heater relay (SSR), door sensor

```yaml
sensor:
  - platform: bme680
    temperature:
      name: "Workshop Temperature"
    humidity:
      name: "Workshop Humidity"
    pressure:
      name: "Workshop Pressure"
    gas_resistance:
      name: "Gas Resistance"
      id: gas_resistance
    iaq:
      name: "Indoor Air Quality"
      id: iaq_index
    address: 0x76

binary_sensor:
  - platform: gpio
    pin:
      number: GPIO18
      mode:
        input: true
        pullup: true
    name: "Workshop Door"
    device_class: door

switch:
  - platform: gpio
    pin: GPIO12
    name: "Exhaust Fan"
    id: exhaust_fan

  - platform: gpio
    pin: GPIO13
    name: "Space Heater"
    id: space_heater
    # Safety: auto-off after 2 hours
    on_turn_on:
      - delay: 2h
      - switch.turn_off: space_heater

# Automation
script:
  - id: air_quality_control
    then:
      - if:
          condition:
            sensor.in_range:
              id: iaq_index
              above: 150  # Poor air quality
          then:
            - switch.turn_on: exhaust_fan
            - delay: 15min
            - switch.turn_off: exhaust_fan
```

---

# Project 18: Aquarium Controller

**Key Components:** DS18B20 waterproof temp probe, relay for heater, PWM LED dimming, ultrasonic distance (water level)

```yaml
# Temperature Control
sensor:
  - platform: dallas
    address: 0x1C0000031EDD2A28  # Unique DS18B20 address
    name: "Aquarium Temperature"
    id: aqua_temp

climate:
  - platform: thermostat
    name: "Aquarium Heater"
    sensor: aqua_temp
    default_target_temperature: 26°C
    heat_action:
      - switch.turn_on: heater_relay
    idle_action:
      - switch.turn_off: heater_relay
    visual:
      min_temperature: 20°C
      max_temperature: 30°C

# Water Level Monitoring
  - platform: ultrasonic
    trigger_pin: GPIO12
    echo_pin: GPIO14
    name: "Water Level"
    update_interval: 60s
    filters:
      - lambda: |-
          // Convert distance to percentage (calibrate min/max)
          float min_dist = 0.05;  // 5cm = full
          float max_dist = 0.20;  // 20cm = empty
          return 100 * (1 - ((x - min_dist) / (max_dist - min_dist)));

# LED Lighting with Sunrise/Sunset
light:
  - platform: monochromatic
    output: led_output
    name: "Aquarium Light"
    id: aqua_light

output:
  - platform: ledc
    pin: GPIO5
    id: led_output
    frequency: 1000Hz

# Circadian Rhythm
time:
  - platform: homeassistant
    on_time:
      # Sunrise (8 AM - gradual brightening)
      - hours: 8
        minutes: 0
        then:
          - light.turn_on:
              id: aqua_light
              brightness: 1%
              transition_length: 30min
          - delay: 30min
          - light.turn_on:
              id: aqua_light
              brightness: 100%
              transition_length: 30min

      # Sunset (8 PM - gradual dimming)
      - hours: 20
        minutes: 0
        then:
          - light.turn_on:
              id: aqua_light
              brightness: 1%
              transition_length: 60min
          - delay: 60min
          - light.turn_off:
              id: aqua_light
              transition_length: 15min
```

---

## General Tips for All Projects

### Debugging
```yaml
logger:
  level: DEBUG  # Verbose output
  logs:
    sensor: INFO
    climate: DEBUG
```

### OTA Updates
- Always test new configs on spare hardware first
- Keep USB cable handy (OTA can fail)
- Use safe mode: `esphome: on_boot: safe_mode: true`

### Power Budgeting
- ESP32 active: 160-260mA
- ESP32 deep sleep: 10-150μA
- WiFi transmit: +170mA peak
- Budget 500mA minimum for stable operation

### Weatherproofing
- IP67: Submersion-proof (brief)
- IP65: Splash-proof (rain OK)
- Use cable glands for wire entry
- Silicone conformal coating on PCBs

---

## What You've Accomplished

By completing Projects 1-18, you now have expertise in:

✅ **Fundamentals (1-4):** GPIO, sensors, relays, motion detection
✅ **Intermediate (5-8):** I2C, displays, multi-sensor systems, deep sleep
✅ **Advanced (9-15):** LED effects, voice control, power monitoring, HVAC, weather stations, cameras
✅ **Integration (16-18):** Complete multi-component automation systems

**You're now ready to design and build ANY custom home automation project!**

---

**Next Steps:**
- Contribute to ESPHome community with your builds
- Design custom PCBs for permanent installations
- Integrate with n8n for advanced automation workflows
- Build your own custom smart home ecosystem

Happy building! 🚀
