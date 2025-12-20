# Project 12: Custom HVAC Controller (Smart Thermostat)

**Difficulty:** Advanced
**Estimated Time:** 6-10 hours
**Cost:** $50-80

## Learning Objectives

By completing this project, you will learn:
- Climate control entity integration
- PID (Proportional-Integral-Derivative) control loops
- IR remote code learning and transmission
- Multi-zone temperature balancing
- Thermostat logic and hysteresis
- HVAC safety interlocks
- Schedule-based temperature management

---

## Parts List

| Part | Quantity | Approximate Cost (CAD) | Notes |
|------|----------|------------------------|-------|
| ESP32 Development Board | 1 | $8-12 | Reuse from previous projects |
| DHT22 Temperature/Humidity | 2-3 | $10-15 | One per zone |
| IR LED (950nm) | 1 | $1-2 | For IR transmission |
| IR Receiver (TSOP38238) | 1 | $2-3 | For learning remote codes |
| Relay Module (2-channel) | 1 | $5-8 | Heat + Cool control |
| 2N2222 Transistor | 1 | $0.50 | IR LED driver |
| 100Ω Resistor | 1 | $0.10 | IR LED current limiting |
| 10kΩ Resistor | 1 | $0.10 | Transistor base resistor |

**Total Cost:** ~$50-80

**HVAC Types Supported:**
- **Central HVAC:** Forced air with 24V thermostat control
- **Mini-Split:** IR-controlled ductless systems
- **Baseboard Heaters:** Line voltage (requires SSR, not mechanical relay!)
- **Window AC:** 120V control with relay

---

## Understanding the Parts

### IR Communication

**How IR remotes work:**
- **IR LED:** Emits 38 kHz modulated infrared light (invisible to human eye)
- **Carrier frequency:** 38 kHz typical (some devices use 36-40 kHz)
- **Protocol:** NEC, RC5, Samsung, etc. (device-specific)
- **Range:** 5-10 meters typical

**IR Receiver (TSOP38238):**
- **Demodulates:** Removes 38 kHz carrier, outputs digital pulses
- **Pinout:** GND, VCC (3.3V), OUT (data to ESP32)
- **Use:** Learn codes from existing remote

**IR Transmitter Circuit:**
```
GPIO4 ──[10kΩ]──┬── 2N2222 Base
                │
               GND

     3.3V ──[100Ω]── IR LED Anode ── 2N2222 Collector
                                      │
                                     GND
```

**Why transistor?**
- ESP32 GPIO: max 40mA
- IR LED needs: 100-200mA for good range
- Transistor amplifies current

### PID Control Theory

**PID = Proportional + Integral + Derivative**

**Purpose:** Maintain target temperature with minimal overshoot and fast response

**Components:**
1. **Proportional (P):** Error × Gain
   - Larger error → stronger correction
   - Example: 5°C too cold → max heating

2. **Integral (I):** Sum of past errors
   - Eliminates steady-state error
   - Example: Persistent 0.5°C offset → gradually increase heat

3. **Derivative (D):** Rate of change
   - Dampens oscillation
   - Example: Temperature rising fast → reduce heat early

**PID Formula:**
```
Output = Kp × Error + Ki × ∫Error dt + Kd × dError/dt
```

**Tuning Parameters:**
- **Kp (Proportional gain):** 10-50 typical
- **Ki (Integral gain):** 0.01-0.1 typical
- **Kd (Derivative gain):** 1-10 typical

**Simpler Alternative: Bang-Bang Control**
```
If temp < target - 0.5°C: Heat ON
If temp > target + 0.5°C: Heat OFF
```
- Easier to implement
- More temperature swing (±0.5°C)
- Sufficient for most home HVAC

---

## Wiring Diagram

### IR Blaster + Temperature Sensors

```
ESP32 Board        IR Receiver    IR LED Circuit      DHT22 Sensors

                  [TSOP38238]
GPIO5 <----------- OUT
3.3V ------------> VCC
GND -------------> GND

GPIO4 ─┬─[10kΩ]─> 2N2222 Base
       │
      GND
                              3.3V ─[100Ω]─┬─ IR LED (+)
                                            │
                              2N2222 Collector
                                            │
                                   2N2222 Emitter ─── GND

GPIO14 <--------> DHT22 Zone 1 Data
GPIO15 <--------> DHT22 Zone 2 Data
GPIO16 <--------> DHT22 Zone 3 Data
3.3V -----------> DHT22 VCC (all zones)
GND ------------> DHT22 GND (all zones)
```

### Central HVAC Relay Control (24V Thermostat)

```
ESP32          Relay Module         24V HVAC Transformer

GPIO12 -------> Relay 1 IN (Heat)
GPIO13 -------> Relay 2 IN (Cool)
5V -----------> VCC
GND ----------> GND

               Relay 1 NO ────────> R (Heat wire - Red)
               Relay 1 COM ───────> RC (24V Common - Red)

               Relay 2 NO ────────> Y (Cool wire - Yellow)
               Relay 2 COM ───────> RC (24V Common)

24V HVAC:
  RC (Red) - Common 24V
  R (Red/Orange) - Heat call
  Y (Yellow) - Cool call
  G (Green) - Fan
  W (White) - Aux heat
```

**CRITICAL SAFETY:**
- **NEVER energize heat + cool simultaneously!** (damages compressor)
- Add software interlock (if heat ON, cool must be OFF)
- Add minimum cycle time (don't short-cycle compressor)

---

## ESPHome Configuration

Create a new file: `/home/hazzard/home-assistant/esphome/hvac-controller.yaml`

### Complete Configuration

```yaml
esphome:
  name: hvac-controller
  friendly_name: "Smart Thermostat"
  platform: ESP32
  board: esp32dev

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password

  manual_ip:
    static_ip: 192.168.40.175
    gateway: 192.168.40.1
    subnet: 255.255.255.0
    dns1: 8.8.8.8

logger:

api:
  encryption:
    key: !secret api_key_hvac

ota:
  - platform: esphome
    password: !secret ota_password

# IR Receiver (for learning codes)
remote_receiver:
  pin:
    number: GPIO5
    inverted: true
    mode:
      input: true
      pullup: true
  dump: all  # Log received IR codes
  tolerance: 25%
  filter: 50us
  idle: 4ms

# IR Transmitter (for controlling mini-split)
remote_transmitter:
  pin: GPIO4
  carrier_duty_percent: 50%

# Temperature Sensors (Multi-Zone)
sensor:
  # Zone 1: Living Room
  - platform: dht
    pin: GPIO14
    model: DHT22
    temperature:
      name: "Living Room Temperature"
      id: temp_zone1
      filters:
        - sliding_window_moving_average:
            window_size: 3
            send_every: 1
    humidity:
      name: "Living Room Humidity"
    update_interval: 30s

  # Zone 2: Bedroom
  - platform: dht
    pin: GPIO15
    model: DHT22
    temperature:
      name: "Bedroom Temperature"
      id: temp_zone2
      filters:
        - sliding_window_moving_average:
            window_size: 3
            send_every: 1
    humidity:
      name: "Bedroom Humidity"
    update_interval: 30s

  # Average Temperature (for control logic)
  - platform: template
    name: "Average Temperature"
    id: avg_temp
    unit_of_measurement: "°C"
    device_class: temperature
    accuracy_decimals: 1
    lambda: |-
      float sum = 0;
      int count = 0;
      if (!isnan(id(temp_zone1).state)) { sum += id(temp_zone1).state; count++; }
      if (!isnan(id(temp_zone2).state)) { sum += id(temp_zone2).state; count++; }
      if (count == 0) return {};
      return sum / count;
    update_interval: 30s

# Climate Entity (Thermostat)
climate:
  - platform: thermostat
    name: "Smart Thermostat"
    id: smart_thermostat
    sensor: avg_temp

    # Heating configuration
    default_preset: Home
    on_boot_restore_from: memory

    visual:
      min_temperature: 15°C
      max_temperature: 30°C
      temperature_step: 0.5°C

    # Heat control (relay or IR)
    heat_action:
      - if:
          condition:
            switch.is_off: use_ir_control
          then:
            # Relay control (central HVAC)
            - switch.turn_on: heat_relay
          else:
            # IR control (mini-split)
            - remote_transmitter.transmit_raw:
                carrier_frequency: 38kHz
                code: !lambda |-
                  // Replace with learned heat ON code
                  return {3000, -1500, 500, -500, /* ... */};

    # Cool control
    cool_action:
      - if:
          condition:
            switch.is_off: use_ir_control
          then:
            - switch.turn_on: cool_relay
          else:
            - remote_transmitter.transmit_raw:
                carrier_frequency: 38kHz
                code: !lambda |-
                  // Replace with learned cool ON code
                  return {3000, -1500, 500, -500, /* ... */};

    # Idle (turn off HVAC)
    idle_action:
      - switch.turn_off: heat_relay
      - switch.turn_off: cool_relay
      - if:
          condition:
            switch.is_on: use_ir_control
          then:
            - remote_transmitter.transmit_raw:
                carrier_frequency: 38kHz
                code: !lambda |-
                  // Replace with learned OFF code
                  return {3000, -1500, 500, -500, /* ... */};

    # Control parameters
    default_target_temperature_low: 20°C
    default_target_temperature_high: 24°C

    heat_deadband: 0.5°C  # Hysteresis: turn on when 0.5°C below target
    heat_overrun: 0.5°C   # Turn off when 0.5°C above target
    cool_deadband: 0.5°C
    cool_overrun: 0.5°C

    min_heating_off_time: 300s  # Minimum 5 min off (protect compressor)
    min_heating_run_time: 300s  # Minimum 5 min run
    min_cooling_off_time: 300s
    min_cooling_run_time: 300s

    # Presets
    preset:
      - name: Home
        default_target_temperature_low: 20°C
        default_target_temperature_high: 24°C
      - name: Away
        default_target_temperature_low: 17°C
        default_target_temperature_high: 27°C
      - name: Sleep
        default_target_temperature_low: 18°C
        default_target_temperature_high: 22°C

# Relay Switches (for central HVAC)
switch:
  - platform: gpio
    pin: GPIO12
    name: "Heat Relay"
    id: heat_relay
    interlock: &interlock_group [heat_relay, cool_relay]
    interlock_wait_time: 30s  # 30s delay between heat/cool switch

  - platform: gpio
    pin: GPIO13
    name: "Cool Relay"
    id: cool_relay
    interlock: *interlock_group
    interlock_wait_time: 30s

  # Mode switch (relay vs IR)
  - platform: template
    name: "Use IR Control"
    id: use_ir_control
    optimistic: true
    restore_mode: RESTORE_DEFAULT_OFF

# Safety interlocks
binary_sensor:
  # Emergency override switch
  - platform: gpio
    pin:
      number: GPIO18
      mode:
        input: true
        pullup: true
      inverted: true
    name: "Emergency Off Switch"
    on_press:
      - climate.control:
          id: smart_thermostat
          mode: "OFF"
      - switch.turn_off: heat_relay
      - switch.turn_off: cool_relay
```

---

## Step-by-Step Build Guide

### Step 1: Learn IR Codes from Existing Remote

**If using mini-split with IR remote:**

1. Wire IR receiver to ESP32 (GPIO5)
2. Flash minimal config with `remote_receiver` only
3. Point remote at receiver, press buttons
4. **Monitor logs:**
   ```
   [remote.raw] Received Raw: 3000, -1500, 500, -500, ...
   ```
5. **Copy code arrays** for: Heat ON, Cool ON, OFF, Temperature UP/DOWN
6. Save codes for use in climate actions

**Common IR protocols:**
- **NEC:** Most common (Samsung, LG)
- **Pronto HEX:** Universal format
- **Raw:** Timing array (most reliable)

### Step 2: Test IR Transmission

**Create test button:**
```yaml
button:
  - platform: template
    name: "Test AC Power On"
    on_press:
      - remote_transmitter.transmit_raw:
          carrier_frequency: 38kHz
          code: [3000, -1500, 500, -500, /* your learned code */]
```

**Verification:**
1. Press button in Home Assistant
2. **Expected:** Mini-split turns on
3. If no response: check IR LED polarity, increase current (reduce 100Ω resistor to 47Ω)

### Step 3: Multi-Zone Temperature Testing

**Verify sensor readings:**
1. Place DHT22 sensors in different rooms
2. Check Home Assistant for temperature entities
3. **Expected:** Temperatures differ by 1-3°C between zones
4. Verify average temperature calculation

### Step 4: Thermostat Logic Testing

**Test heating cycle:**
1. Set target temperature 5°C above current
2. **Expected:** Heat turns ON after deadband delay
3. Temperature rises to target + overrun
4. Heat turns OFF
5. **Monitor cycle times:** Should respect minimum on/off times (5 min)

**Test cooling cycle:**
- Same procedure, but set target below current temperature

### Step 5: Safety Interlock Verification

**Critical test - prevent heat + cool simultaneously:**
1. Turn on heat
2. Try to turn on cool
3. **Expected:** Heat turns OFF, 30s delay, then cool turns ON
4. Check logs for interlock messages

---

## Advanced Features

### PID Control (Instead of Bang-Bang)

```yaml
climate:
  - platform: pid
    name: "PID Thermostat"
    sensor: avg_temp
    default_target_temperature: 21°C

    heat_output: heat_pwm_output  # PWM modulation (variable speed)

    control_parameters:
      kp: 0.3
      ki: 0.01
      kd: 0.1

    deadband_parameters:
      threshold_high: 0.2°C
      threshold_low: -0.2°C

output:
  - platform: slow_pwm
    pin: GPIO12
    id: heat_pwm_output
    period: 600s  # 10 min cycle (for slow HVAC systems)
```

**When to use PID:**
- Radiant floor heating (slow response)
- Variable-speed heat pumps
- Precise temperature control (±0.2°C)

### Occupancy-Based Scheduling

```yaml
# In Home Assistant automations:
automation:
  - alias: "Away Mode When Nobody Home"
    trigger:
      - platform: state
        entity_id: group.all_persons
        to: 'not_home'
        for:
          minutes: 30
    action:
      - service: climate.set_preset_mode
        target:
          entity_id: climate.smart_thermostat
        data:
          preset_mode: 'away'

  - alias: "Home Mode When Someone Arrives"
    trigger:
      - platform: state
        entity_id: group.all_persons
        to: 'home'
    action:
      - service: climate.set_preset_mode
        target:
          entity_id: climate.smart_thermostat
        data:
          preset_mode: 'home'
```

---

## What You've Learned

✅ **Climate Control:**
- Thermostat logic and hysteresis
- PID vs bang-bang control
- Multi-zone temperature management

✅ **IR Communication:**
- Learning and transmitting remote codes
- IR protocols and carrier frequencies
- Transistor-driven IR LEDs

✅ **HVAC Safety:**
- Heat/cool interlocks
- Minimum cycle times
- Emergency shutoff systems

✅ **Home Automation:**
- Climate entity integration
- Presence-based scheduling
- Energy-saving presets

**Ready for Project 13?** Build an [Outdoor Weather Station](13-outdoor-weather-station.md)!
