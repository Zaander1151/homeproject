# Advanced ESP32 Projects (12-18) - Coming Soon!

The following comprehensive project guides are currently in development and will follow the same detailed format as Projects 1-11:

## Project 12: Custom HVAC Controller
**Status:** In Development
**Difficulty:** Advanced
**Estimated Cost:** $50-80

Control your heating and cooling systems with multi-zone temperature management, PID control loops, and IR blaster integration for mini-split systems.

**Key Features:**
- Climate entity integration with Home Assistant
- PID temperature control
- IR remote code learning and transmission
- Multi-zone temperature balancing
- Presence-based scheduling

---

## Project 13: Outdoor Weather Station
**Status:** In Development
**Difficulty:** Advanced
**Estimated Cost:** $60-100

Build a professional-grade weather station with rainfall measurement, wind speed/direction, and solar-powered operation.

**Key Features:**
- BME280 for temp/humidity/pressure
- Tipping bucket rain gauge with pulse counting
- Anemometer and wind vane integration
- Weatherproof enclosure (IP67)
- Solar panel with battery backup
- Deep sleep optimization for battery life

---

## Project 14: Mailbox Notification System
**Status:** In Development
**Difficulty:** Advanced
**Estimated Cost:** $30-50

Get instant notifications when mail arrives with ultra-low power consumption for months of battery life.

**Key Features:**
- Magnetic reed switch for door detection
- Deep sleep mode (<10μA idle current)
- Wake-on-door-open functionality
- Solar charging circuit
- Battery voltage monitoring
- WiFi quick-connect optimization

---

## Project 15: Security Camera with Object Detection
**Status:** In Development
**Difficulty:** Advanced
**Estimated Cost:** $20-40

ESP32-CAM based security camera with motion detection and integration with Frigate NVR for AI-powered person detection.

**Key Features:**
- ESP32-CAM module (2MP camera)
- RTSP streaming to Home Assistant
- Motion-triggered recording
- Integration with Frigate for object detection
- IR night vision LEDs
- Local storage to SD card

---

## Integration Projects

These projects combine multiple sensors and actuators into complete automation systems:

## Project 16: Bathroom Automation Hub
**Status:** In Development
**Difficulty:** Intermediate
**Estimated Cost:** $40-60

Complete bathroom automation with humidity-controlled exhaust fan, motion-activated lighting, and nightlight mode.

**Components:**
- DHT22 humidity sensor
- PIR motion sensor
- Exhaust fan relay control
- WS2812B LED strip lighting
- Light sensor for nightlight mode

**Automations:**
- Auto-run fan when humidity >70%
- Motion-activated lights with timer
- Dim warm lighting after 10 PM
- Fan timer with manual override

---

## Project 17: Workshop/Garage Environmental Control
**Status:** In Development
**Difficulty:** Intermediate
**Estimated Cost:** $50-80

Monitor air quality and control ventilation in your workshop with VOC detection, temperature control, and presence-based heating.

**Components:**
- BME680 air quality sensor (VOC, temp, humidity)
- Exhaust fan relay
- Space heater relay with safety timeout
- Door/window sensors
- PIR occupancy detection

**Automations:**
- Ventilation when VOC levels high
- Heater on in winter (with safety limits)
- Alert if door left open
- Occupancy-based climate control

---

## Project 18: Aquarium/Terrarium Controller
**Status:** In Development
**Difficulty:** Intermediate
**Estimated Cost:** $50-90

Precise environmental control for aquariums or terrariums with automated lighting cycles, temperature regulation, and water level monitoring.

**Components:**
- DS18B20 waterproof temperature probe
- Relay for heater control with safety limits
- LED lighting with PWM dimming
- Ultrasonic distance sensor (water level)
- Feeding schedule integration

**Features:**
- Maintain precise temperature (±0.5°C)
- Sunrise/sunset lighting simulation
- Low water level alerts
- Feeding reminders via Home Assistant
- Temperature history graphing

---

## Coming Soon!

These detailed build guides are being developed with the same comprehensive format as Projects 1-11, including:

- ✅ Detailed parts lists with Canadian pricing
- ✅ Component explanations and theory
- ✅ Wiring diagrams and breadboard layouts
- ✅ Complete ESPHome configurations with explanations
- ✅ Step-by-step build instructions
- ✅ Troubleshooting guides
- ✅ Advanced customizations
- ✅ Home Assistant integration examples

**Want to be notified when these guides are published?**

In the meantime, you can:
1. **Start with Projects 1-11** to build foundational skills
2. **Check the main [ESP32 Starter Projects](../esp32-starter-projects.md)** page for project overviews
3. **Reference existing M5Stack configurations** in `/home/hazzard/home-assistant/esphome/` for inspiration
4. **Explore the ESPHome documentation** at https://esphome.io for component details

## Interim Resources

While these guides are in development, here are quick-start references:

### Quick: IR Blaster (for Project 12)
```yaml
# ESPHome IR transmitter configuration
remote_transmitter:
  pin: GPIO4
  carrier_duty_percent: 50%

# Learn codes from existing remote
remote_receiver:
  pin: GPIO5
  dump: all  # Logs received IR codes
```

### Quick: Rain Gauge (for Project 13)
```yaml
# Pulse counter for tipping bucket
sensor:
  - platform: pulse_counter
    pin: GPIO12
    name: "Rainfall"
    unit_of_measurement: "mm"
    filters:
      - multiply: 0.2794  # Each tip = 0.2794mm
    total:
      name: "Total Rainfall"
      unit_of_measurement: "mm"
```

### Quick: ESP32-CAM Stream (for Project 15)
```yaml
# Basic ESP32-CAM configuration
esp32_camera:
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
  name: "Workshop Camera"
```

Stay tuned for complete build guides!
