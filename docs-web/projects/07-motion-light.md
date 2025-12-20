# Project 7: Motion-Activated Smart Light

**Difficulty:** Intermediate
**Estimated Time:** 3-4 hours
**Cost:** $15-30

## Learning Objectives

By completing this project, you will learn:

- PIR (Passive Infrared) motion sensor integration
- PWM (Pulse Width Modulation) for LED dimming
- State machine programming for automation logic
- Timer-based control and debouncing
- Home Assistant motion detection integration
- Energy-efficient lighting automation

## What You'll Build

A smart lighting system that:

- Detects motion with PIR sensor
- Gradually fades lights on when motion detected
- Maintains brightness while motion continues
- Fades out after configurable timeout
- Supports manual override via Home Assistant
- Reports motion events to Home Assistant
- Implements adjustable sensitivity and timing

## Components Needed

### Required Components

| Component | Quantity | Estimated Cost | Notes |
|-----------|----------|----------------|-------|
| ESP32 Development Board | 1 | $8-12 | Any ESP32 board |
| PIR Motion Sensor (HC-SR501) | 1 | $2-4 | Adjustable sensitivity |
| LED Strip (12V) | 1m | $5-10 | WS2812B or similar |
| MOSFET (IRLZ44N) | 1 | $1-2 | For high-power LED control |
| Resistors (10kΩ) | 2 | $0.50 | Pull-down resistors |
| Breadboard | 1 | $3-5 | For prototyping |
| Jumper Wires | 10+ | $2-3 | Male-to-male and male-to-female |
| 12V Power Supply | 1 | $8-12 | For LED strip (2A minimum) |

**Total Cost:** ~$30-50

### Optional Enhancements

- LDR (Light Dependent Resistor) for ambient light detection ($1-2)
- Ultrasonic sensor (HC-SR04) for distance-based triggering ($3-5)
- Enclosure for permanent installation ($5-10)

## Hardware Setup

### Wiring Diagram

```
PIR Sensor (HC-SR501):
  VCC -----> 5V (ESP32)
  GND -----> GND
  OUT -----> GPIO 25 (ESP32)

LED Strip Control (via MOSFET):
  ESP32 GPIO 26 -----> 10kΩ Resistor -----> MOSFET Gate
  MOSFET Source -----> GND (common ground with 12V supply)
  MOSFET Drain -----> LED Strip Negative (-)
  12V Supply (+) -----> LED Strip Positive (+)
  12V Supply GND -----> ESP32 GND (IMPORTANT: common ground!)

Optional - Ambient Light Sensor:
  LDR -----> 3.3V (ESP32)
  LDR -----> GPIO 34 (ESP32, ADC pin)
  GPIO 34 -----> 10kΩ Resistor -----> GND
```

### PIR Sensor Configuration

The HC-SR501 has two adjustment potentiometers:

1. **Sensitivity (Sx):** Distance range (3-7 meters)
   - Turn clockwise for longer range
   - Turn counter-clockwise for shorter range

2. **Time Delay (Tx):** Output hold time (0.3-200 seconds)
   - Set to MINIMUM for this project (we'll control timing in software)

3. **Trigger Mode Jumper:**
   - **H Position (Repeatable Trigger):** Recommended for continuous motion detection
   - **L Position (Single Trigger):** Triggers once, waits for timeout

### Safety Considerations

⚠️ **IMPORTANT SAFETY NOTES:**

- **Common Ground:** ESP32 and 12V power supply MUST share common ground
- **Voltage Isolation:** Never connect 12V directly to ESP32 GPIO pins
- **MOSFET Rating:** Ensure MOSFET can handle LED strip current (calculate: Watts ÷ 12V)
- **Heat Management:** MOSFET may need heatsink for high-power LED strips (>20W)
- **Polarity:** Double-check LED strip polarity before powering on

## ESPHome Configuration

### Basic Motion Light Configuration

Create `/home/hazzard/home-assistant/esphome/motion-light.yaml`:

```yaml
substitutions:
  device_name: motion-light
  friendly_name: "Motion Light"

esphome:
  name: ${device_name}
  friendly_name: ${friendly_name}
  platform: ESP32
  board: esp32dev

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  manual_ip:
    static_ip: 192.168.40.110
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

# PIR Motion Sensor
binary_sensor:
  - platform: gpio
    pin: GPIO25
    name: "${friendly_name} Motion"
    id: motion_sensor
    device_class: motion
    filters:
      - delayed_off: 200ms  # Debounce
    on_press:
      then:
        - logger.log: "Motion detected!"
        - light.turn_on:
            id: motion_light
            brightness: 100%
            transition_length: 1s
        - script.execute: motion_timeout
    on_release:
      then:
        - logger.log: "Motion cleared"

# LED Light Control
output:
  - platform: ledc
    pin: GPIO26
    id: light_output
    frequency: 1000Hz

light:
  - platform: monochromatic
    name: "${friendly_name} LED"
    id: motion_light
    output: light_output
    default_transition_length: 1s
    restore_mode: RESTORE_DEFAULT_OFF

# Motion Timeout Script
script:
  - id: motion_timeout
    mode: restart  # Restart timer if motion detected again
    then:
      - delay: 30s  # Wait 30 seconds after last motion
      - light.turn_off:
          id: motion_light
          transition_length: 2s

# Manual override switch
switch:
  - platform: template
    name: "${friendly_name} Auto Mode"
    id: auto_mode
    optimistic: true
    restore_mode: RESTORE_DEFAULT_ON
    on_turn_off:
      then:
        - logger.log: "Auto mode disabled - manual control only"
    on_turn_on:
      then:
        - logger.log: "Auto mode enabled"

# Restart button
button:
  - platform: restart
    name: "${friendly_name} Restart"
```

### Advanced Configuration with Ambient Light Detection

Add this to include light-level awareness:

```yaml
# Ambient Light Sensor (LDR)
sensor:
  - platform: adc
    pin: GPIO34
    name: "${friendly_name} Ambient Light"
    id: ambient_light
    update_interval: 5s
    attenuation: 11db
    filters:
      - sliding_window_moving_average:
          window_size: 10
          send_every: 5
    unit_of_measurement: "lux"

# Number input for light threshold
number:
  - platform: template
    name: "${friendly_name} Light Threshold"
    id: light_threshold
    min_value: 0
    max_value: 100
    step: 5
    initial_value: 30
    optimistic: true
    restore_value: true
    unit_of_measurement: "%"

  - platform: template
    name: "${friendly_name} Motion Timeout"
    id: motion_timeout_setting
    min_value: 5
    max_value: 300
    step: 5
    initial_value: 30
    optimistic: true
    restore_value: true
    unit_of_measurement: "s"

  - platform: template
    name: "${friendly_name} Brightness"
    id: brightness_setting
    min_value: 10
    max_value: 100
    step: 5
    initial_value: 100
    optimistic: true
    restore_value: true
    unit_of_measurement: "%"

# Updated motion sensor with light-level check
binary_sensor:
  - platform: gpio
    pin: GPIO25
    name: "${friendly_name} Motion"
    id: motion_sensor
    device_class: motion
    filters:
      - delayed_off: 200ms
    on_press:
      then:
        - if:
            condition:
              and:
                - switch.is_on: auto_mode
                - lambda: 'return id(ambient_light).state < (id(light_threshold).state);'
            then:
              - logger.log: "Motion detected in low light - turning on"
              - light.turn_on:
                  id: motion_light
                  brightness: !lambda 'return id(brightness_setting).state / 100.0;'
                  transition_length: 1s
              - script.execute: motion_timeout_script
            else:
              - logger.log: "Motion detected but light level sufficient or auto mode off"

# Updated timeout script
script:
  - id: motion_timeout_script
    mode: restart
    then:
      - delay: !lambda 'return id(motion_timeout_setting).state * 1000;'
      - light.turn_off:
          id: motion_light
          transition_length: 2s
```

## Step-by-Step Build Process

### Step 1: Test PIR Sensor

Before full integration, verify the PIR sensor works:

```yaml
# Minimal test configuration
esphome:
  name: pir-test
  platform: ESP32
  board: esp32dev

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password

logger:
  level: DEBUG

api:

binary_sensor:
  - platform: gpio
    pin: GPIO25
    name: "PIR Test"
    device_class: motion
    on_press:
      then:
        - logger.log: "MOTION DETECTED!"
    on_release:
      then:
        - logger.log: "Motion cleared"
```

**Testing:**
1. Flash this configuration to ESP32
2. Watch logs: `docker exec -it esphome esphome logs motion-light.yaml`
3. Walk in front of PIR sensor
4. Verify "MOTION DETECTED!" appears in logs
5. Adjust sensitivity potentiometer if needed

### Step 2: Test LED Control

Verify MOSFET switching and PWM dimming:

```yaml
# LED test configuration
output:
  - platform: ledc
    pin: GPIO26
    id: test_output
    frequency: 1000Hz

light:
  - platform: monochromatic
    name: "LED Test"
    output: test_output

button:
  - platform: template
    name: "Test Fade"
    on_press:
      then:
        - light.turn_on:
            id: test_output
            brightness: 0%
        - delay: 500ms
        - light.turn_on:
            id: test_output
            brightness: 25%
        - delay: 500ms
        - light.turn_on:
            id: test_output
            brightness: 50%
        - delay: 500ms
        - light.turn_on:
            id: test_output
            brightness: 75%
        - delay: 500ms
        - light.turn_on:
            id: test_output
            brightness: 100%
```

**Testing:**
1. Flash configuration
2. Press "Test Fade" button in Home Assistant
3. Verify LED strip gradually increases brightness
4. If LED doesn't respond, check MOSFET wiring and common ground

### Step 3: Integrate Motion + Light

Use the basic configuration from above. Flash and test:

1. Flash full configuration to ESP32
2. Walk in front of sensor → light should turn on
3. Stand still → light should turn off after 30 seconds
4. Test manual override in Home Assistant

### Step 4: Add Ambient Light Detection (Optional)

If using LDR sensor:

1. Wire LDR as shown in diagram
2. Flash advanced configuration
3. Cover LDR (simulate darkness) → motion should trigger light
4. Shine flashlight on LDR (simulate daylight) → motion should NOT trigger light
5. Adjust threshold in Home Assistant

### Step 5: Fine-Tune Settings

Optimize for your environment:

1. **Motion Timeout:** Adjust based on room usage (hallway: 10s, bedroom: 60s)
2. **Brightness:** Set comfortable level (100% may be too bright)
3. **Light Threshold:** Calibrate based on room ambient light levels
4. **PIR Sensitivity:** Adjust potentiometer for desired detection range

## Home Assistant Integration

### Automatic Discovery

After flashing, the device appears in Home Assistant automatically:

- **Binary Sensor:** `binary_sensor.motion_light_motion`
- **Light:** `light.motion_light_led`
- **Switch:** `switch.motion_light_auto_mode`
- **Number Inputs:** Timeout, brightness, light threshold settings

### Dashboard Card Example

```yaml
type: entities
title: Motion Light Control
entities:
  - entity: binary_sensor.motion_light_motion
    name: Motion Detected
  - entity: light.motion_light_led
    name: LED Strip
  - entity: switch.motion_light_auto_mode
    name: Auto Mode
  - entity: number.motion_light_brightness
    name: Brightness
  - entity: number.motion_light_motion_timeout
    name: Timeout (seconds)
  - entity: number.motion_light_light_threshold
    name: Light Threshold
  - entity: sensor.motion_light_ambient_light
    name: Current Light Level
```

### Automation Example: Disable at Sunrise

```yaml
automation:
  - alias: "Motion Light - Disable at Sunrise"
    trigger:
      - platform: sun
        event: sunrise
        offset: "+00:30:00"  # 30 minutes after sunrise
    action:
      - service: switch.turn_off
        target:
          entity_id: switch.motion_light_auto_mode

  - alias: "Motion Light - Enable at Sunset"
    trigger:
      - platform: sun
        event: sunset
        offset: "-00:30:00"  # 30 minutes before sunset
    action:
      - service: switch.turn_on
        target:
          entity_id: switch.motion_light_auto_mode
```

## Troubleshooting

### PIR Sensor Issues

| Problem | Solution |
|---------|----------|
| **No motion detection** | • Check wiring (VCC, GND, OUT)<br>• Verify GPIO pin number<br>• Adjust sensitivity potentiometer<br>• Check PIR sensor LED indicator |
| **Constant triggering** | • Reduce sensitivity<br>• Move sensor away from heat sources (heaters, sunlight)<br>• Increase `delayed_off` filter duration<br>• Ensure sensor is stable (not vibrating) |
| **Short detection range** | • Increase sensitivity potentiometer<br>• Remove obstructions in front of sensor<br>• Verify sensor is positioned correctly (dome facing outward) |
| **Delayed response** | • Set time delay potentiometer to minimum<br>• Reduce `delayed_off` filter in ESPHome |

### LED Control Issues

| Problem | Solution |
|---------|----------|
| **LED doesn't turn on** | • Check common ground between ESP32 and 12V supply<br>• Verify MOSFET wiring (Gate, Drain, Source)<br>• Test LED strip with 12V supply directly<br>• Check GPIO pin number |
| **LED stuck at full brightness** | • Verify PWM output configuration<br>• Check MOSFET gate resistor (10kΩ)<br>• Test with simple on/off (not PWM) first |
| **LED flickers** | • Increase PWM frequency (try 5000Hz)<br>• Add capacitor (100µF) across LED strip power |
| **MOSFET gets hot** | • Reduce LED strip power (fewer LEDs)<br>• Add heatsink to MOSFET<br>• Verify MOSFET rating matches load |

### Logic Issues

| Problem | Solution |
|---------|----------|
| **Light doesn't turn off** | • Check script mode (should be `restart`)<br>• Verify motion sensor `on_release` trigger<br>• Check auto mode is enabled<br>• Review logs for script execution |
| **Too sensitive to light** | • Increase light threshold value<br>• Check LDR wiring and ADC pin<br>• Verify `lambda` condition logic |
| **Manual control doesn't work** | • Disable auto mode switch<br>• Check light entity in Home Assistant<br>• Verify API connection |

### Debugging Commands

```bash
# View real-time logs
docker exec -it esphome esphome logs motion-light.yaml

# Check device status in Home Assistant
# Settings → Devices & Services → ESPHome → motion-light

# Test MOSFET with multimeter
# Measure voltage at Gate pin when GPIO is HIGH (should be ~3.3V)
# Measure resistance Drain-Source when Gate is HIGH (should be <1Ω)
```

## Project Extensions

### 1. Multi-Zone Motion Detection

Use multiple PIR sensors for different areas:

```yaml
binary_sensor:
  - platform: gpio
    pin: GPIO25
    name: "Motion Zone 1"
    id: motion_zone_1

  - platform: gpio
    pin: GPIO33
    name: "Motion Zone 2"
    id: motion_zone_2

  - platform: template
    name: "Motion Any Zone"
    lambda: |-
      return id(motion_zone_1).state || id(motion_zone_2).state;
    on_press:
      then:
        - light.turn_on: motion_light
```

### 2. Color-Changing LED Strip

Upgrade to RGB/RGBW LED strip:

```yaml
output:
  - platform: ledc
    pin: GPIO26
    id: output_red
  - platform: ledc
    pin: GPIO27
    id: output_green
  - platform: ledc
    pin: GPIO14
    id: output_blue

light:
  - platform: rgb
    name: "RGB Motion Light"
    red: output_red
    green: output_green
    blue: output_blue
    effects:
      - strobe:
      - pulse:
```

### 3. Presence Detection vs Motion

Combine PIR with mmWave radar for true presence:

```yaml
# Add HLK-LD2410 mmWave sensor
uart:
  tx_pin: GPIO17
  rx_pin: GPIO16
  baud_rate: 256000

ld2410:

binary_sensor:
  - platform: ld2410
    has_target:
      name: "Presence Detected"
    has_moving_target:
      name: "Moving Target"
    has_still_target:
      name: "Still Target"
```

### 4. Energy Monitoring

Track power consumption:

```yaml
sensor:
  - platform: total_daily_energy
    name: "Motion Light Daily Energy"
    power_id: light_power

  - platform: template
    name: "Motion Light Power"
    id: light_power
    lambda: |-
      if (id(motion_light).current_values.is_on()) {
        return id(motion_light).current_values.get_brightness() * 10.0;  // Watts
      } else {
        return 0.0;
      }
    unit_of_measurement: "W"
```

### 5. Notification on Motion (Security)

Send alerts when motion detected:

```yaml
binary_sensor:
  - platform: gpio
    pin: GPIO25
    name: "Motion Detected"
    on_press:
      then:
        - homeassistant.event:
            event: esphome.motion_detected
            data:
              device: motion-light
              timestamp: !lambda 'return id(sntp_time).now().timestamp;'
```

Then in Home Assistant:

```yaml
automation:
  - alias: "Motion Alert"
    trigger:
      - platform: event
        event_type: esphome.motion_detected
    action:
      - service: notify.mobile_app
        data:
          title: "Motion Detected"
          message: "Motion detected in hallway at {{ now().strftime('%H:%M') }}"
```

## Best Practices

### Power Efficiency

- Use motion timeout (don't leave lights on indefinitely)
- Implement ambient light detection (don't trigger in daylight)
- Use LED strips with appropriate wattage (not oversized)
- Consider lower brightness levels (50% often sufficient)

### Reliability

- Use `delayed_off` filter to prevent false triggers
- Implement `script.restart` mode for smooth timeout handling
- Add manual override for maintenance/special occasions
- Use `restore_mode` to maintain settings across reboots

### User Experience

- Gradual fade-in/fade-out (not abrupt on/off)
- Configurable settings via Home Assistant (no re-flashing needed)
- Appropriate timeout for room type (hallway: short, bedroom: long)
- Visual/audio feedback when auto mode disabled

## Next Steps

After completing this project, consider:

1. **Project 8: Multi-Room Temperature Display** - Learn ESP-NOW mesh networking
2. **Advanced PIR Tuning** - Experiment with multiple sensors and zones
3. **Smart Home Integration** - Combine with door sensors, timers, presence detection
4. **Power Monitoring** - Add current sensor (ACS712) for precise energy tracking
5. **Security System** - Expand to full motion-based security with cameras

## Resources

- [ESPHome Light Component](https://esphome.io/components/light/index.html)
- [ESPHome Binary Sensor](https://esphome.io/components/binary_sensor/index.html)
- [HC-SR501 PIR Sensor Datasheet](https://www.epitran.it/ebayDrive/datasheet/44.pdf)
- [MOSFET Switching Tutorial](https://www.electronics-tutorials.ws/transistor/tran_7.html)
- [PWM Explained](https://learn.sparkfun.com/tutorials/pulse-width-modulation)

---

**Congratulations!** You've built a smart motion-activated lighting system with ESPHome and Home Assistant. This project teaches fundamental automation concepts: sensor input, PWM output, state machines, and user-configurable parameters.
