# ESP32 Starter Projects

Progressive project ideas to build your skills, all designed to integrate with your existing Home Assistant setup.

## Beginner Projects

### 1. Hello World - Blink LED
**Goal:** Get comfortable with flashing and basic GPIO control
**Hardware:** ESP32 + LED + 220Ω resistor (or use onboard LED)
**Skills:** ESPHome basics, GPIO output, compiling, flashing
**Integration:** Switch entity in Home Assistant to control LED

**What You'll Learn:**
- How to create an ESPHome device config
- Flashing via USB and OTA
- Basic GPIO pin configuration
- Home Assistant auto-discovery

**Next Steps:** Add a physical button to toggle the LED

---

### 2. Temperature & Humidity Monitor
**Goal:** Read sensor data and display in Home Assistant
**Hardware:** ESP32 + DHT22 sensor
**Skills:** I/O reading, sensor integration, entity creation
**Integration:** Temperature/humidity sensors appear in HA dashboard

**What You'll Learn:**
- Digital sensor protocols (1-wire for DHT)
- Update intervals and accuracy
- Sensor calibration
- Creating HA dashboard cards

**Project Ideas:**
- Monitor room temperature
- Track bathroom humidity (trigger exhaust fan automation)
- Outdoor weather station (add rain sensor, wind speed)

---

### 3. Smart Lamp/Nightlight
**Goal:** Control a lamp via Home Assistant
**Hardware:** ESP32 + relay module + lamp (or LED strip)
**Skills:** Relay control, electrical safety, automation
**Integration:** Switch entity controllable from HA, Alexa, Google Home

**What You'll Learn:**
- Safe relay wiring for AC loads
- Restore modes (remember state after power loss)
- Creating automations in Home Assistant
- Timer functions

**Safety Note:** Start with low-voltage (12V) LED strips before working with AC mains

---

### 4. Presence Detection Sensor
**Goal:** Detect when someone enters a room
**Hardware:** ESP32 + PIR motion sensor
**Skills:** Binary sensors, filtering, automation triggers
**Integration:** Motion sensor in HA triggers lights, notifications

**What You'll Learn:**
- Debouncing and filtering false triggers
- Delayed-off timers
- Home Assistant zones and presence detection
- Creating motion-activated lighting scenes

**Enhancement Ideas:**
- Add light sensor (only trigger at night)
- Multiple PIR sensors for room coverage
- Person counting (entry vs exit tracking)

---

## Intermediate Projects

### 5. Environmental Monitoring Station
**Goal:** Multi-sensor node with display
**Hardware:** ESP32 + BME280 (I2C) + 0.96" OLED display
**Skills:** I2C communication, multiple sensors, local display
**Integration:** Comprehensive climate monitoring in HA

**What You'll Learn:**
- I2C bus (multiple devices on 2 wires)
- Displaying data on OLED screens
- Graphing historical data in Grafana
- InfluxDB integration for long-term storage

**Data Collected:**
- Temperature, humidity, pressure
- WiFi signal strength
- Uptime, boot counts

**Advanced:** Add air quality sensor (BME680, MQ-135)

---

### 6. Smart Plant Monitor
**Goal:** Automated plant care system
**Hardware:** ESP32 + capacitive soil moisture + water pump relay
**Skills:** Analog reading, ADC, automation logic, pump control
**Integration:** Plant health dashboard, auto-watering automation

**What You'll Learn:**
- ADC (analog to digital conversion)
- Calibrating moisture sensors
- Setting thresholds and alerts
- Pump control timing and safety

**Automation:**
- Water when soil is dry
- Daily moisture notifications
- Track watering history
- Multiple plant monitoring

---

### 7. Door/Window Sensor Network
**Goal:** Monitor all doors and windows in your home
**Hardware:** ESP32 + magnetic reed switches (per door/window)
**Skills:** Multiple binary inputs, battery optimization, deep sleep
**Integration:** Security system, open window alerts, climate control

**What You'll Learn:**
- Deep sleep modes for battery power
- Wake on pin change
- Battery voltage monitoring
- Creating security automations

**Automations:**
- Alert if door open too long
- Don't run AC with windows open
- Nighttime security monitoring
- Entry/exit logging

---

### 8. Smart Garage Door Controller
**Goal:** Open/close garage door remotely with safety features
**Hardware:** ESP32 + relay + magnetic sensor + ultrasonic distance
**Skills:** Safety interlocks, state machines, distance sensing
**Integration:** HA garage door entity, notifications, automations

**What You'll Learn:**
- Cover platform in ESPHome
- Ultrasonic distance sensing (car presence)
- Safety features (don't close if obstructed)
- Position tracking (open/closed/moving)

**Safety Features:**
- Auto-close timer with warning
- Obstruction detection
- Open too long alerts
- Integration with home security modes

---

## Advanced Projects

### 9. RGB Mood Lighting System
**Goal:** Addressable LED strip with effects and scenes
**Hardware:** ESP32 + WS2812B LED strip (5m) + power supply
**Skills:** LED protocols, effects, power management, color theory
**Integration:** Light entity with effects, scenes, music sync

**What You'll Learn:**
- Addressable LED protocols (WS2812B, SK6812)
- Power injection for long strips
- Color temperature and brightness
- Creating custom light effects

**Effects to Implement:**
- Rainbow cycle
- Theater chase
- Music reactive (via Home Assistant)
- Sunrise/sunset simulation
- Holiday themes

**Power Note:** 5m of 60 LED/m = 300 LEDs × 60mA = 18A max (need proper PSU!)

---

### 10. Voice-Controlled Device (Like Your M5Stack)
**Goal:** Build a custom voice assistant endpoint
**Hardware:** ESP32-S3 + I2S microphone + speaker
**Skills:** I2S audio, Wyoming protocol, voice pipeline integration
**Integration:** Full voice assistant with wake word, STT, TTS

**What You'll Learn:**
- I2S audio interfaces
- Integrating with Wyoming Whisper/Piper/OpenWakeWord
- Audio quality troubleshooting
- Custom wake words

**Reference:** Your existing `living-room-voice.yaml` and `office-voice.yaml`

**Custom Features:**
- Room-specific responses
- Different wake words per room
- Visual feedback with LED ring
- Local voice commands (no internet needed)

---

### 11. Energy Monitoring System
**Goal:** Monitor power usage of individual devices
**Hardware:** ESP32 + PZEM-004T (or SCT-013 current clamp)
**Skills:** AC current sensing, power calculations, safety
**Integration:** Real-time power monitoring, cost tracking, alerts

**What You'll Learn:**
- Non-invasive current sensing
- Power factor calculations
- Energy cost tracking
- High-usage alerts

**Safety Warning:** Working with AC mains is dangerous. Use isolated modules.

**Monitored Data:**
- Real-time watts
- Daily kWh consumption
- Cost calculations
- Peak usage times

---

### 12. Custom HVAC Controller
**Goal:** Smart thermostat with multiple zones
**Hardware:** ESP32 + DHT22 + relay for HVAC + IR blaster
**Skills:** Climate control, IR protocols, PID control, thermostats
**Integration:** HA climate entity, schedules, presence-based

**What You'll Learn:**
- Thermostat implementation
- PID control loops
- IR remote codes (for mini-splits)
- Zone-based climate control

**Features:**
- Multiple temperature sensors (zones)
- Smart scheduling (home/away modes)
- Integration with occupancy
- Energy-saving automations

---

### 13. Outdoor Weather Station
**Goal:** Professional-grade weather monitoring
**Hardware:** ESP32 + BME280 + rain gauge + anemometer + wind vane
**Skills:** Pulse counting, interrupts, weatherproofing, solar power
**Integration:** Personal weather station data, forecasting

**What You'll Learn:**
- Interrupt-based pulse counting
- Weatherproof enclosures (IP65+)
- Solar power with battery backup
- Deep sleep optimization

**Measurements:**
- Temperature, humidity, pressure
- Rainfall (tips/hour)
- Wind speed (anemometer pulses)
- Wind direction (analog or digital vane)
- UV index (optional)

---

### 14. Mailbox Notification System
**Goal:** Know when mail arrives (battery-powered, remote)
**Hardware:** ESP32 + magnetic sensor + battery + solar panel
**Skills:** Ultra-low power design, battery management, reliability
**Integration:** Notification when mail arrives, battery monitoring

**What You'll Learn:**
- Deep sleep optimization (<1mA average)
- Wake on door open
- Battery voltage monitoring
- Solar charging management
- WiFi quick-connect strategies

**Challenge:** Run for months on a single charge

---

### 15. Security Camera with Object Detection
**Goal:** ESP32-CAM with AI object detection
**Hardware:** ESP32-CAM module + PIR sensor
**Skills:** Camera streaming, image processing, AI/ML
**Integration:** Camera feed in HA, object detection alerts

**What You'll Learn:**
- Camera streaming protocols
- Motion-triggered snapshots
- Integration with Frigate NVR
- Person detection vs general motion

**Features:**
- Live camera feed in HA
- Motion-triggered recording
- Person detection (reduce false alarms)
- IR night vision
- Two-way audio (advanced)

---

## Integration Projects

These combine multiple sensors/actuators into complete systems:

### 16. Bathroom Automation Hub
**Components:**
- Humidity sensor (DHT22)
- Motion sensor (PIR)
- Exhaust fan relay
- LED strip lighting

**Automations:**
- Turn on lights on motion
- Auto-run fan when humidity high
- Nightlight mode (dim lights after 10pm)
- Fan timer with override button

---

### 17. Workshop/Garage Environmental Control
**Components:**
- Temperature sensor
- Air quality sensor (VOC)
- Exhaust fan relay
- Space heater relay (with safety!)
- Door sensor
- Presence detection

**Automations:**
- Ventilation when VOC levels high
- Heater on in winter (with safety timeout)
- Alert if door left open
- Occupancy-based climate control

---

### 18. Aquarium/Terrarium Controller
**Components:**
- Temperature probe (DS18B20 waterproof)
- Light control (relay or PWM)
- Heater control with safety
- Water level sensor
- Feeding schedule automation

**Features:**
- Maintain precise temperature
- Day/night light cycles
- Low water alerts
- Automated feeding reminders
- Temperature history graphs

---

## Skill Progression Guide

### Beginner (Projects 1-4)
**Focus:** Basic I/O, simple sensors, Home Assistant integration
**Estimated Time:** 2-4 weeks

### Intermediate (Projects 5-8)
**Focus:** Multiple sensors, I2C, power management, safety
**Estimated Time:** 1-2 months

### Advanced (Projects 9-15)
**Focus:** Complex systems, audio/video, power monitoring, weatherproofing
**Estimated Time:** Ongoing projects

---

## Project Selection Tips

**Start Based on Your Needs:**
- **Want to learn basics?** → Temperature monitor or smart lamp
- **Interested in home security?** → Door sensors or presence detection
- **Love gardening?** → Plant monitor
- **Want impressive visuals?** → RGB lighting
- **Energy conscious?** → Power monitoring

**Consider Your Space:**
- **Apartment:** Focus on indoor sensors and lighting
- **House with yard:** Weather station, mailbox sensor
- **Workshop/garage:** Environmental control, tool tracking

**Budget Considerations:**
- **Under $20:** LED blink, temperature sensor, relay switch
- **$20-50:** Multi-sensor nodes, plant monitor, LED strips
- **$50-100+:** Weather station, energy monitoring, camera systems

---

## Next Steps After Each Project

1. **Document your build** - Take photos, note challenges, write in `/home/hazzard/homeproject/docs/`
2. **Create automations** - Don't just collect data, automate with it!
3. **Expand with more sensors** - Add to existing projects
4. **Share your work** - ESPHome community, Home Assistant forums
5. **Integrate with other services** - MQTT, InfluxDB, Grafana, n8n workflows

Happy building!
