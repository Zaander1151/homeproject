# Kitchen Under-Cabinet LED Lighting

ESP32-controlled under-cabinet lighting for the kitchen, replacing existing track lighting above the stove.

## Project Status

**Status:** Planning
**Priority:** Low
**Blocked By:** Product availability (check Amazon.ca for current stock)

## Requirements

| Requirement | Notes |
|-------------|-------|
| **Primary light source** | Replacing track lighting, not just accent |
| **Bright for cooking/prep** | 100%, cool white (4000K-5000K) |
| **Dim for ambient** | 10-30%, warm white (2700K-3000K) |
| **No rail/channel system** | Direct mount to cabinet underside |
| **ESP32 controlled** | Local control via Home Assistant |
| **12V preferred** | Matches existing ESP32 projects |

## Options Considered

### Option 1: CCT Tunable LED Strip (Recommended)

**Pros:**
- Adjustable color temperature (warm ↔ cool)
- Even, continuous light (no hot spots)
- COB strips have no visible LED dots
- Cut to exact length needed
- Perfect for ESP32 PWM control

**Cons:**
- Two PWM channels needed (warm + cool)
- Slightly more complex wiring

### Option 2: Single Color LED Pucks

**Pros:**
- Simple single-channel control
- Easy to position
- Plug-and-play kits available

**Cons:**
- Fixed color temperature
- Spot lighting vs continuous
- Multiple connection points

### Option 3: Single Color LED Strip (4000K)

**Pros:**
- Simple single-channel control
- Even lighting
- 4000K neutral is a good compromise

**Cons:**
- No warm/cool flexibility
- Can't shift to warm white for evening ambiance

## Recommended Products (Amazon.ca)

> **Note:** Check availability before ordering. Stock changes frequently.

### CCT LED Strips (12V)

| Product | Length | Voltage | Price | Link |
|---------|--------|---------|-------|------|
| BTF-LIGHTING FCOB CCT | 9.84ft (3m) | 12V | ~$35 | [Amazon.ca](https://www.amazon.ca/BTF-LIGHTING-Flexible-Dimmable-Controller-3000K-6000K/dp/B0CY2FH5J4) |
| FCOB CCT Kit | 16.4ft (5m) | 12V | ~$40 | [Amazon.ca](https://www.amazon.ca/FCOB-Flexible-Dimmable-Controller-3000K-6000K/dp/B0C3CWRXHX) |

### CCT LED Strips (24V) - Alternative

| Product | Length | Voltage | Price | Link |
|---------|--------|---------|-------|------|
| PAUTIX COB CCT | 32.8ft (10m) | 24V | ~$55 | [Amazon.ca](https://www.amazon.ca/PAUTIX-UL-Listed-6400LEDs-Dimmable-2700K-6500K/dp/B0C7W7FC74) |
| ALITOVE COB CCT | 16.4ft (5m) | 24V | ~$45 | [Amazon.ca](https://www.amazon.ca/ALITOVE-2700K-6500K-Flexible-High-Density-Lighting/dp/B0CD2BCF16) |
| MIWISE COB CCT | 32.8ft (10m) | 24V | ~$50 | [Amazon.ca](https://www.amazon.ca/MIWISE-Dimmable-2700K-6500K-Compatible-Assistant/dp/B0CTQS96RY) |

### LED Pucks (Single Color)

| Product | Count | Color Temp | Price | Link |
|---------|-------|------------|-------|------|
| AIBOO 10-Pack | 10 | Warm White | ~$60 | [Amazon.ca](https://www.amazon.ca/Linkable-Lighting-Hardwired-Dimmable-Furniture/dp/B07C4W1VJJ) |
| AIBOO 4-Pack | 4 | Warm White | ~$35 | [Amazon.ca](https://www.amazon.ca/Cabinet-Lighting-Dimmable-Wireless-Control/dp/B01LMSYUP4) |
| LAMPAOUS 6-Pack | 6 | 4000K Neutral | ~$35 | [Amazon.ca](https://www.amazon.ca/LAMPAOUS-Lighting-Dimmable-Recessed-Bookshelf/dp/B082SKDXSB) |

### AliExpress Search Terms

For budget options with longer shipping:
- `"12V COB LED strip CCT tunable 3000K 6000K"`
- `"24V COB LED strip warm cool white tunable"`
- `"12V LED puck light 3000K under cabinet"`

## Color Temperature Guide

| Temp | Name | Best For |
|------|------|----------|
| 2700K | Warm White | Evening ambient, relaxing |
| 3000K | Soft White | General kitchen use |
| 4000K | Neutral White | Balanced task/ambient |
| 5000K | Daylight | Cooking, food prep |
| 6000K | Cool Daylight | Maximum visibility, detail work |

### Use Case Mapping

| Activity | Brightness | Color Temp |
|----------|------------|------------|
| Cooking/Prep | 100% | 5000K (cool) |
| Eating/Socializing | 50% | 3000K (warm) |
| Night light | 10% | 2700K (warm) |
| Cleaning | 100% | 4000K (neutral) |

## Hardware Requirements

### For CCT Strip (Recommended)

| Component | Purpose | Qty | Est. Cost |
|-----------|---------|-----|-----------|
| CCT LED Strip (12V) | Light source | 5-10m | $40-80 |
| ESP32 (any variant) | Controller | 1 | $5-10 |
| IRLZ44N MOSFET | Warm white PWM | 1 | $1 |
| IRLZ44N MOSFET | Cool white PWM | 1 | $1 |
| 12V Power Supply | Power | 1 | $15-20 |
| 10K Resistors | Gate pull-down | 2 | $0.10 |
| Wire, connectors | Wiring | - | $5-10 |
| **Total** | | | **~$70-120** |

### For Single Color Pucks/Strip

| Component | Purpose | Qty | Est. Cost |
|-----------|---------|-----|-----------|
| LED Pucks or Strip | Light source | 1 kit | $35-60 |
| ESP32 (any variant) | Controller | 1 | $5-10 |
| IRLZ44N MOSFET | PWM dimming | 1 | $1 |
| 12V Power Supply | Power (if not included) | 1 | $15-20 |
| 10K Resistor | Gate pull-down | 1 | $0.05 |
| **Total** | | | **~$55-90** |

## Wiring Diagram

### CCT Strip (Two Channel)

```
                    ESP32
                 ┌─────────┐
                 │         │
    ┌────────────┤ GPIO18  │ ← Warm White PWM
    │            │         │
    │  ┌─────────┤ GPIO19  │ ← Cool White PWM
    │  │         │         │
    │  │    ┌────┤ GND     │
    │  │    │    │         │
    │  │    │    └─────────┘
    │  │    │
    │  │    │    MOSFET 1 (Warm)     MOSFET 2 (Cool)
    │  │    │    ┌────────┐          ┌────────┐
    │  │    │    │ D    S │          │ D    S │
    │  │    │    │   G    │          │   G    │
    │  │    │    └─┬──┬─┬─┘          └─┬──┬─┬─┘
    │  │    │      │  │ │              │  │ │
    └──┼────┼──────┘  │ │    ┌─────────┘  │ │
       │    │    10K↓ │ │    │       10K↓ │ │
       └────┼────┬────┘ │    │  ┌────┬────┘ │
            │    │      │    │  │    │      │
            └────┴──────┴────┴──┴────┴──────┘
                        │
                       GND
                        │
    ┌───────────────────┴───────────────────┐
    │              12V Power Supply          │
    │  (+)                            (-)    │
    └───┬───────────────────────────────┬───┘
        │                               │
        │    CCT LED Strip              │
        │    ┌────────────────────┐     │
        │    │ 12V  WW   CW   GND │     │
        │    └──┬───┬────┬────┬──┘     │
        │       │   │    │    │        │
        └───────┘   │    │    └────────┘
                    │    │
              From  │    │  From
              MOSFET1    MOSFET2
              Drain      Drain
```

### Single Channel (Pucks or Single-Color Strip)

```
                    ESP32
                 ┌─────────┐
                 │         │
    ┌────────────┤ GPIO18  │ ← PWM
    │            │         │
    │       ┌────┤ GND     │
    │       │    │         │
    │       │    └─────────┘
    │       │
    │       │    MOSFET (IRLZ44N)
    │       │    ┌────────┐
    │       │    │ D    S │
    │       │    │   G    │
    │       │    └─┬──┬─┬─┘
    │       │      │  │ │
    └───────┼──────┘  │ │
            │    10K↓ │ │
            └────┬────┘ │
                 │      │
                GND ────┴─── To LED (-)
                 │
    ┌────────────┴────────────┐
    │      12V Power Supply    │
    │  (+)                (-)  │
    └───┬──────────────────┬──┘
        │                  │
        └──► To LED (+)    └──► To MOSFET Source
```

## ESPHome Configuration

### CCT Strip Config

```yaml
# Kitchen Under-Cabinet Lighting - CCT Version
substitutions:
  name: kitchen-cabinet-lights
  friendly_name: "Kitchen Cabinet Lights"

esphome:
  name: ${name}
  friendly_name: ${friendly_name}

esp32:
  board: esp32dev  # Adjust for your board
  framework:
    type: arduino

logger:

api:
  encryption:
    key: !secret api_key_kitchen_lights

ota:
  - platform: esphome
    password: !secret ota_password

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  manual_ip:
    static_ip: 192.168.40.185  # Adjust as needed
    gateway: 192.168.40.1
    subnet: 255.255.255.0
    dns1: 8.8.8.8

# PWM Outputs for CCT control
output:
  - platform: ledc
    pin: GPIO18
    id: warm_white_pwm
    frequency: 1000Hz

  - platform: ledc
    pin: GPIO19
    id: cool_white_pwm
    frequency: 1000Hz

# CCT Light (combines warm and cool channels)
light:
  - platform: cwww
    name: "Cabinet Lights"
    cold_white: cool_white_pwm
    warm_white: warm_white_pwm
    cold_white_color_temperature: 6000K
    warm_white_color_temperature: 2700K
    constant_brightness: true
    effects:
      - pulse:
          name: "Pulse"
          transition_length: 2s
          update_interval: 2s

# Preset scenes via buttons
button:
  - platform: template
    name: "Cooking Mode"
    icon: "mdi:stove"
    on_press:
      - light.turn_on:
          id: cabinet_lights
          brightness: 100%
          color_temperature: 5000K

  - platform: template
    name: "Evening Mode"
    icon: "mdi:weather-night"
    on_press:
      - light.turn_on:
          id: cabinet_lights
          brightness: 30%
          color_temperature: 2700K

  - platform: template
    name: "Night Light"
    icon: "mdi:lightbulb-night"
    on_press:
      - light.turn_on:
          id: cabinet_lights
          brightness: 10%
          color_temperature: 2700K

  - platform: restart
    name: "Restart"

sensor:
  - platform: wifi_signal
    name: "WiFi Signal"
    update_interval: 60s

  - platform: uptime
    name: "Uptime"
```

### Single Color Config

```yaml
# Kitchen Under-Cabinet Lighting - Single Color Version
substitutions:
  name: kitchen-cabinet-lights
  friendly_name: "Kitchen Cabinet Lights"

esphome:
  name: ${name}
  friendly_name: ${friendly_name}

esp32:
  board: esp32dev
  framework:
    type: arduino

logger:

api:
  encryption:
    key: !secret api_key_kitchen_lights

ota:
  - platform: esphome
    password: !secret ota_password

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  manual_ip:
    static_ip: 192.168.40.185
    gateway: 192.168.40.1
    subnet: 255.255.255.0
    dns1: 8.8.8.8

output:
  - platform: ledc
    pin: GPIO18
    id: light_pwm
    frequency: 1000Hz

light:
  - platform: monochromatic
    name: "Cabinet Lights"
    output: light_pwm
    gamma_correct: 2.8
    default_transition_length: 500ms

button:
  - platform: template
    name: "Bright"
    on_press:
      - light.turn_on:
          id: cabinet_lights
          brightness: 100%

  - platform: template
    name: "Dim"
    on_press:
      - light.turn_on:
          id: cabinet_lights
          brightness: 25%

  - platform: restart
    name: "Restart"

sensor:
  - platform: wifi_signal
    name: "WiFi Signal"
    update_interval: 60s
```

## Installation Notes

### Mounting LED Strips

1. **Clean surface** - Wipe cabinet underside with isopropyl alcohol
2. **Plan wire routing** - Decide where ESP32/PSU will live
3. **Test fit** - Hold strip in place before removing adhesive backing
4. **Cut to length** - Cut only at marked cut points
5. **Peel and stick** - Remove backing, press firmly
6. **Wire connections** - Solder or use connectors at ends

### Mounting Pucks

1. **Mark positions** - Space evenly, avoid cabinet hinges
2. **Choose mounting** - Adhesive (temporary) or screws (permanent)
3. **Route wires** - Daisy-chain between pucks
4. **Connect to controller** - All pucks share common 12V and GND

### Power Supply Placement

- **Inside cabinet** - Hidden, easy access
- **Behind cabinet** - Out of sight, harder to access
- **Under cabinet with ESP32** - Compact, all-in-one

## Home Assistant Automations

### Example: Motion-Activated Cooking Light

```yaml
automation:
  - alias: "Kitchen Lights - Motion Cooking Mode"
    trigger:
      - platform: state
        entity_id: binary_sensor.kitchen_motion
        to: "on"
    condition:
      - condition: time
        after: "06:00:00"
        before: "22:00:00"
    action:
      - service: light.turn_on
        target:
          entity_id: light.cabinet_lights
        data:
          brightness_pct: 100
          color_temp_kelvin: 5000

  - alias: "Kitchen Lights - No Motion Dim"
    trigger:
      - platform: state
        entity_id: binary_sensor.kitchen_motion
        to: "off"
        for:
          minutes: 5
    action:
      - service: light.turn_on
        target:
          entity_id: light.cabinet_lights
        data:
          brightness_pct: 20
          color_temp_kelvin: 2700
```

## Future Enhancements

- **Motion sensor integration** - Auto-on when entering kitchen
- **Time-based color temp** - Cool during day, warm at night
- **Voice control** - "Hey Nabu, cooking mode"
- **Sync with multisensor** - Use ambient light to adjust brightness

## References

- [ESPHome CWWW Light](https://esphome.io/components/light/cwww.html)
- [ESPHome LEDC Output](https://esphome.io/components/output/ledc.html)
- [IRLZ44N Datasheet](https://www.infineon.com/dgdl/irlz44n.pdf)
