# Bedside Smart Button Panel - Soldering Project

**Difficulty:** Beginner (First Soldering Project)
**Estimated Time:** 2-3 hours (including testing)
**Soldering Joints:** ~25-30 total

## Project Overview

Build a wall-mounted or nightstand smart button panel with 6 capacitive touch buttons and RGB LED feedback that controls your bedroom automation.

### What It Does

**Button Functions:**
1. **Bedroom Fan** - Toggle on/off
2. **Coffee Machine** - Toggle on/off (warm up for morning)
3. **Morning Briefing** - Trigger n8n workflow to send briefing to Telegram
4. **Goodnight Scene** - Turn off all lights, arm security, set thermostat
5. **Reserved** - Future automation
6. **Reserved** - Future automation

**Visual Feedback:**
- WS2812B RGB LED ring provides status indication
- Each button lights up when pressed
- Different colors for different states (on/off/processing)

### Why This is a Great First Soldering Project

✅ **All through-hole soldering** - No tiny SMD components
✅ **Large pads** - Easy to see and work with
✅ **Forgiving** - Mistakes can be fixed easily
✅ **Modular** - Test each part as you build
✅ **Actually useful** - Daily use in your bedroom
✅ **Good practice variety** - Wires, headers, and components

---

## Components Needed

### From Your Inventory

| Component | Quantity | Purpose |
|-----------|----------|---------|
| ESP32 Development Board (Generic or DevKitC) | 1 | Main controller |
| TTP223 Capacitive Touch Button | 6 | Touch inputs |
| WS2812B RGB LED Ring (12 LEDs) | 1 | Visual feedback |
| Jumper Wires (M-F) | 20+ | Connections |
| Double-Sided PCB Prototype Board | 1 | Mounting base (5x7cm or 4x6cm) |
| Resistor 10kΩ | 1 | Optional pull-down for stability |
| USB Power Supply (5V 1A) | 1 | Power source |

### Need to Acquire (Optional)

| Component | Quantity | Estimated Cost | Purpose |
|-----------|----------|----------------|---------|
| Micro USB Cable (right-angle) | 1 | $3-5 | Clean power connection |
| Project Enclosure | 1 | $5-10 | 3D print or buy plastic box |
| Header Pins (male, 2.54mm) | 1 strip | $1-2 | If ESP32 not pre-soldered |

**Total Cost:** $0-15 (most components from inventory)

---

## Tools Required

From your workbench:
- ✅ Weller WLSK3012A Soldering Station
- ✅ Electrisol 60/40 Solder
- ✅ Flush Cutters
- ✅ Wire Strippers
- ✅ Tweezers
- ✅ Digital Multimeter (for testing continuity)

**Recommended temperature:** 350°C (662°F) for 60/40 solder

---

## Circuit Design

### Wiring Diagram

```
ESP32 (30-pin DevKitC)           Components
┌─────────────────────┐
│                     │
│ 3V3 ────────────────┼──→ TTP223 VCC (all 6 buttons in parallel)
│                     │
│ GND ────────────────┼──→ TTP223 GND (all 6 buttons)
│                     │   └──→ WS2812B GND
│                     │
│ GPIO 13 ────────────┼──→ TTP223 #1 OUT (Bedroom Fan)
│ GPIO 12 ────────────┼──→ TTP223 #2 OUT (Coffee Machine)
│ GPIO 14 ────────────┼──→ TTP223 #3 OUT (Morning Briefing)
│ GPIO 27 ────────────┼──→ TTP223 #4 OUT (Goodnight Scene)
│ GPIO 26 ────────────┼──→ TTP223 #5 OUT (Reserved)
│ GPIO 25 ────────────┼──→ TTP223 #6 OUT (Reserved)
│                     │
│ GPIO 33 ────────────┼──→ WS2812B DIN (data input)
│                     │
│ 5V ─────────────────┼──→ WS2812B VCC (power)
│                     │
│ USB ────────────────┼──→ 5V Power Supply
│                     │
└─────────────────────┘
```

### GPIO Pin Selection Rationale

**Touch Button GPIOs (13, 12, 14, 27, 26, 25):**
- Input-safe pins (don't affect boot)
- Support internal pull-ups
- Not used by flash/PSRAM

**LED Ring GPIO (33):**
- Output-safe pin
- Supports fast bit-banging for WS2812B protocol

---

## Step-by-Step Build Guide

### Phase 1: Preparation (10 minutes)

**Before you start soldering:**

1. **Organize components** on your workbench
2. **Test ESP32** - Plug into USB, verify it powers on (LED lights up)
3. **Test TTP223 buttons** - Touch the sensor pad, onboard LED should light up
4. **Test WS2812B ring** - We'll test after soldering
5. **Clean soldering iron tip** - Tin with fresh solder

**Safety Check:**
- ✅ Soldering station on stable surface
- ✅ Good ventilation (open window or fan)
- ✅ Safety glasses (optional but recommended)
- ✅ No flammable materials nearby

---

### Phase 2: Solder Header Pins to ESP32 (If Needed)

**Skip this if your ESP32 already has header pins soldered.**

**Time:** 15-20 minutes

**Steps:**

1. **Insert header pins into breadboard** (pins pointing up)
   - This holds them perfectly straight while soldering

2. **Place ESP32 on top** of header pins
   - Component side facing up
   - Pins go through holes in PCB

3. **Check alignment** - All pins should be perpendicular to board

4. **Solder ONE pin** at each end first
   - Heat pad + pin for 2-3 seconds
   - Apply solder until it flows around pin
   - Remove solder, then remove iron
   - Let cool 5 seconds

5. **Check alignment again** - If crooked, reheat and adjust

6. **Solder remaining pins**
   - Work from one end to the other
   - Each joint should be shiny, smooth, cone-shaped

7. **Inspect joints** with magnifier
   - No cold solder joints (dull, grainy appearance)
   - No solder bridges between pins

**Common Mistakes:**
- ❌ Too much solder (creates bridges)
- ❌ Too little heat (cold joint)
- ❌ Moving part while cooling (cracked joint)

**Good solder joint looks like:** 🌋 Small volcano/cone shape

---

### Phase 3: Prepare Wires (10 minutes)

You'll need:
- **6x wires** for TTP223 VCC (red, ~10cm each)
- **6x wires** for TTP223 GND (black, ~10cm each)
- **6x wires** for TTP223 OUT (yellow/green, ~10cm each)
- **3x wires** for WS2812B (red/black/green, ~15cm each)

**Wire Preparation:**

1. **Cut wires to length**
   - Use flush cutters for clean cuts
   - Add 2cm extra for strain relief

2. **Strip 5mm from each end**
   - Use wire strippers at correct gauge
   - Don't nick the copper strands

3. **Tin wire ends** (optional but helpful)
   - Heat wire end with iron
   - Apply small amount of solder
   - Creates solid tip, easier to insert into holes

4. **Label wires** (optional)
   - Use heat shrink or tape
   - Write button number (1-6)

---

### Phase 4: Solder TTP223 Buttons (30 minutes)

**You'll solder 18 wires total (3 per button × 6 buttons)**

**For EACH of the 6 TTP223 modules:**

1. **Identify pads** on TTP223 board
   - VCC (or +, or 3.3V)
   - GND (or -, or G)
   - OUT (or I/O, or SIG)

2. **Solder VCC wire** (red)
   - Insert wire through VCC hole
   - Heat pad + wire for 2 seconds
   - Feed solder until it flows
   - Remove solder, remove iron
   - Wire should be mechanically secure

3. **Solder GND wire** (black)
   - Same process as VCC

4. **Solder OUT wire** (yellow/green)
   - Same process

5. **Test mechanical strength**
   - Gently tug each wire
   - Should not pull out

6. **Repeat for all 6 buttons**

**Soldering Tips for Beginners:**
- 🔥 **Heat the PAD first**, not the wire
- ⏱️ **2-3 seconds** of heating before applying solder
- 🌊 **Solder flows to heat** - if pad is hot enough, solder will flow smoothly
- 🚫 **Don't blob** - Use just enough solder to fill the joint
- ❄️ **Let cool naturally** - Don't blow on it or move it

**Take a break after every 2 buttons!** Soldering takes focus.

---

### Phase 5: Test TTP223 Buttons (10 minutes)

**Before soldering everything together, test each button individually.**

**Test Setup:**
1. Connect button VCC → ESP32 3V3
2. Connect button GND → ESP32 GND
3. Connect button OUT → ESP32 GPIO 13
4. Power ESP32 via USB

**Test Method:**
1. Touch button sensor pad
2. TTP223 onboard LED should light up
3. Use multimeter:
   - Measure voltage at OUT pin
   - Should be ~3.3V when touched
   - Should be ~0V when not touched

**Repeat for all 6 buttons** - Label any that don't work

**Common Issues:**
- ❌ **No LED light:** Check VCC/GND connections
- ❌ **LED stuck on:** Button may be in self-locking mode (toggle jumper on back)
- ❌ **Intermittent:** Cold solder joint, reheat

---

### Phase 6: Solder WS2812B LED Ring (15 minutes)

**The LED ring has 3 connections: VCC, GND, DIN**

**Identify pads on LED ring:**
- **5V or VCC** - Power positive
- **GND** - Ground
- **DIN or IN** - Data input (arrows point AWAY from this pad)

**Soldering Steps:**

1. **Solder VCC wire** (red, ~15cm)
   - Ring may have large power pads
   - More solder needed than buttons
   - May take 5-10 seconds to heat

2. **Solder GND wire** (black, ~15cm)
   - Same as VCC

3. **Solder DIN wire** (green, ~15cm)
   - This is the data line
   - Make sure to use the INPUT side (arrows point away)
   - ⚠️ **CRITICAL:** Wrong direction = won't work

4. **Add strain relief** (optional)
   - Dab of hot glue where wires exit PCB
   - Or wrap with electrical tape

**Test (Optional but Recommended):**
1. Connect VCC → ESP32 5V
2. Connect GND → ESP32 GND
3. Connect DIN → ESP32 GPIO 33
4. Flash test code (we'll do this later)
5. LEDs should light up

---

### Phase 7: Assemble on Prototype Board (20 minutes)

**Now we'll solder everything to a single PCB for clean assembly.**

**Layout Planning:**

```
Prototype PCB (5x7cm) Layout:

┌─────────────────────────────────┐
│  [ESP32 Board]                  │
│                                 │
│  [Button 1] [Button 2] [Button 3]│
│  [Button 4] [Button 5] [Button 6]│
│                                 │
│           [LED Ring]            │
└─────────────────────────────────┘
```

**Assembly Steps:**

1. **Plan component placement**
   - Arrange buttons in 2 rows of 3
   - ESP32 at top
   - LED ring at bottom center
   - Leave space for wire routing

2. **Mark holes** with pencil for component mounting

3. **Solder ESP32 to board** (if not using headers)
   - Or use female headers to make it removable

4. **Create power bus**
   - Solder a wire along one edge for 3V3
   - Solder a wire along other edge for GND
   - This is your "power rail"

5. **Connect all TTP223 VCC wires** to 3V3 rail
   - Twist all 6 red wires together
   - Solder to 3V3 rail

6. **Connect all TTP223 GND wires** to GND rail
   - Twist all 6 black wires together
   - Solder to GND rail

7. **Connect each TTP223 OUT wire** to respective ESP32 GPIO
   - Button 1 OUT → GPIO 13
   - Button 2 OUT → GPIO 12
   - Button 3 OUT → GPIO 14
   - Button 4 OUT → GPIO 27
   - Button 5 OUT → GPIO 26
   - Button 6 OUT → GPIO 25

8. **Connect WS2812B**
   - VCC → ESP32 5V pin
   - GND → GND rail
   - DIN → GPIO 33

9. **Inspect all joints** with multimeter (continuity mode)
   - Check for shorts between adjacent pins
   - Verify connections match diagram

---

### Phase 8: First Power-On Test (10 minutes)

**CRITICAL: Test BEFORE putting in enclosure**

**Visual Inspection:**
1. ✅ All solder joints shiny and smooth
2. ✅ No solder bridges between pins
3. ✅ All wires connected to correct pins
4. ✅ LED ring DIN connected to INPUT side

**Power-On Test:**
1. **Plug ESP32 into USB power**
2. **Watch for:**
   - ✅ ESP32 LED lights up
   - ✅ No smoke or burning smell
   - ✅ No components getting hot
3. **If anything wrong:** UNPLUG IMMEDIATELY

**Multimeter Tests:**
1. **Measure voltage at 3V3 rail** - Should be ~3.3V
2. **Measure voltage at 5V pin** - Should be ~5.0V
3. **Touch each button** - Check TTP223 LED lights up
4. **Measure OUT voltage** when touched - Should be ~3.3V

**If all tests pass:** Ready for firmware! 🎉

---

## ESPHome Configuration

### Configuration File

Create `/home/hazzard/home-assistant/esphome/bedside-button-panel.yaml`:

```yaml
substitutions:
  device_name: bedside-button-panel
  friendly_name: "Bedside Button Panel"

esphome:
  name: ${device_name}
  friendly_name: ${friendly_name}
  platform: ESP32
  board: esp32dev

# Wi-Fi Configuration
wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  manual_ip:
    static_ip: 192.168.40.112
    gateway: 192.168.40.1
    subnet: 255.255.255.0
    dns1: 8.8.8.8

# Enable logging
logger:
  level: INFO

# Home Assistant API
api:
  encryption:
    key: !secret api_encryption_key

# OTA Updates
ota:
  - platform: esphome
    password: !secret ota_password

# Restart button
button:
  - platform: restart
    name: "${friendly_name} Restart"

# WS2812B LED Ring (12 LEDs)
light:
  - platform: neopixel
    pin: GPIO33
    num_leds: 12
    name: "${friendly_name} Status Ring"
    id: status_ring
    restore_mode: ALWAYS_OFF
    default_transition_length: 0.3s
    effects:
      - pulse:
          name: "Pulse"
          transition_length: 1s
          update_interval: 1s
      - strobe:
          name: "Strobe"
      - random:
          name: "Random"
      - addressable_rainbow:
          name: "Rainbow"
          speed: 10
          width: 12

# Touch Button 1: Bedroom Fan
binary_sensor:
  - platform: gpio
    pin:
      number: GPIO13
      mode: INPUT_PULLDOWN
    name: "${friendly_name} Button 1 - Fan"
    id: button_fan
    filters:
      - delayed_on: 50ms
      - delayed_off: 50ms
    on_press:
      then:
        - logger.log: "Button 1 (Fan) pressed"
        - light.turn_on:
            id: status_ring
            brightness: 100%
            red: 0%
            green: 100%
            blue: 0%
        - delay: 300ms
        - light.turn_off: status_ring
        - homeassistant.service:
            service: switch.toggle
            data:
              entity_id: switch.bedroom_fan  # Adjust to your fan entity

  # Touch Button 2: Coffee Machine
  - platform: gpio
    pin:
      number: GPIO12
      mode: INPUT_PULLDOWN
    name: "${friendly_name} Button 2 - Coffee"
    id: button_coffee
    filters:
      - delayed_on: 50ms
      - delayed_off: 50ms
    on_press:
      then:
        - logger.log: "Button 2 (Coffee) pressed"
        - light.turn_on:
            id: status_ring
            brightness: 100%
            red: 100%
            green: 50%
            blue: 0%
        - delay: 300ms
        - light.turn_off: status_ring
        - homeassistant.service:
            service: switch.toggle
            data:
              entity_id: switch.coffee_machine_plug  # Your coffee machine entity

  # Touch Button 3: Morning Briefing
  - platform: gpio
    pin:
      number: GPIO14
      mode: INPUT_PULLDOWN
    name: "${friendly_name} Button 3 - Briefing"
    id: button_briefing
    filters:
      - delayed_on: 50ms
      - delayed_off: 50ms
    on_press:
      then:
        - logger.log: "Button 3 (Morning Briefing) pressed"
        - light.turn_on:
            id: status_ring
            brightness: 100%
            red: 0%
            green: 0%
            blue: 100%
            effect: "Pulse"
        - delay: 2s
        - light.turn_off: status_ring
        - homeassistant.service:
            service: rest_command.trigger_morning_briefing
            # This calls the n8n webhook you already configured

  # Touch Button 4: Goodnight Scene
  - platform: gpio
    pin:
      number: GPIO27
      mode: INPUT_PULLDOWN
    name: "${friendly_name} Button 4 - Goodnight"
    id: button_goodnight
    filters:
      - delayed_on: 50ms
      - delayed_off: 50ms
    on_press:
      then:
        - logger.log: "Button 4 (Goodnight) pressed"
        - light.turn_on:
            id: status_ring
            brightness: 100%
            red: 100%
            green: 0%
            blue: 100%
        - delay: 300ms
        - light.turn_off: status_ring
        - homeassistant.service:
            service: scene.turn_on
            data:
              entity_id: scene.goodnight  # Create this scene in HA

  # Touch Button 5: Reserved
  - platform: gpio
    pin:
      number: GPIO26
      mode: INPUT_PULLDOWN
    name: "${friendly_name} Button 5 - Reserved"
    id: button_reserved_1
    filters:
      - delayed_on: 50ms
      - delayed_off: 50ms
    on_press:
      then:
        - logger.log: "Button 5 (Reserved) pressed"
        - light.turn_on:
            id: status_ring
            brightness: 50%
            red: 100%
            green: 100%
            blue: 100%
        - delay: 200ms
        - light.turn_off: status_ring

  # Touch Button 6: Reserved
  - platform: gpio
    pin:
      number: GPIO25
      mode: INPUT_PULLDOWN
    name: "${friendly_name} Button 6 - Reserved"
    id: button_reserved_2
    filters:
      - delayed_on: 50ms
      - delayed_off: 50ms
    on_press:
      then:
        - logger.log: "Button 6 (Reserved) pressed"
        - light.turn_on:
            id: status_ring
            brightness: 50%
            red: 100%
            green: 100%
            blue: 100%
        - delay: 200ms
        - light.turn_off: status_ring
```

### Flash the ESP32

**From your server:**

```bash
cd /home/hazzard/home-assistant/esphome

# Compile and upload (first time via USB)
docker exec -it esphome esphome run bedside-button-panel.yaml

# Future updates via OTA (wireless)
docker exec -it esphome esphome upload bedside-button-panel.yaml --device 192.168.40.112
```

### Test Each Button

**After flashing:**

1. **Watch logs:**
   ```bash
   docker exec -it esphome esphome logs bedside-button-panel.yaml
   ```

2. **Press each button** and verify:
   - Log message appears
   - LED ring lights up with correct color
   - Home Assistant entity changes state

3. **Verify LED ring:**
   - Go to Home Assistant → Devices
   - Find "Bedside Button Panel"
   - Turn on "Status Ring" light
   - Try different colors and effects

---

## Home Assistant Integration

### Automatic Discovery

After flashing, the device will appear in Home Assistant automatically:

**Entities created:**
- `binary_sensor.bedside_button_panel_button_1_fan`
- `binary_sensor.bedside_button_panel_button_2_coffee`
- `binary_sensor.bedside_button_panel_button_3_briefing`
- `binary_sensor.bedside_button_panel_button_4_goodnight`
- `binary_sensor.bedside_button_panel_button_5_reserved`
- `binary_sensor.bedside_button_panel_button_6_reserved`
- `light.bedside_button_panel_status_ring`

### Create Goodnight Scene

**In Home Assistant:**

```yaml
# configuration.yaml or scenes.yaml
scene:
  - name: Goodnight
    entities:
      light.bedroom_ceiling:
        state: off
      light.living_room_light:
        state: off
      switch.bedroom_fan:
        state: on
      climate.thermostat:
        temperature: 20
```

### Verify Bedroom Fan Entity

Make sure you have a fan entity. If not, create one:

**Option 1: Smart Plug**
- Already integrated (TP-Link Tapo)
- Create helper switch if needed

**Option 2: Create Template Switch**

```yaml
# configuration.yaml
switch:
  - platform: template
    switches:
      bedroom_fan:
        friendly_name: "Bedroom Fan"
        value_template: "{{ is_state('switch.tapo_plug_3', 'on') }}"
        turn_on:
          service: switch.turn_on
          target:
            entity_id: switch.tapo_plug_3
        turn_off:
          service: switch.turn_off
          target:
            entity_id: switch.tapo_plug_3
```

### Dashboard Card

```yaml
type: entities
title: Bedside Button Panel
entities:
  - entity: binary_sensor.bedside_button_panel_button_1_fan
    name: Fan Button
    icon: mdi:fan
  - entity: binary_sensor.bedside_button_panel_button_2_coffee
    name: Coffee Button
    icon: mdi:coffee
  - entity: binary_sensor.bedside_button_panel_button_3_briefing
    name: Briefing Button
    icon: mdi:newspaper
  - entity: binary_sensor.bedside_button_panel_button_4_goodnight
    name: Goodnight Button
    icon: mdi:sleep
  - entity: light.bedside_button_panel_status_ring
    name: Status Ring
```

---

## Enclosure Design

### Option 1: 3D Print Custom Enclosure

**Design Requirements:**
- 6 circular cutouts for TTP223 sensor pads (12mm diameter)
- Central cutout for LED ring
- Mounting holes for prototype PCB
- Cable management for USB power
- Optional: Wall-mount holes or desk stand

**Print Settings:**
- Material: PLA (Hyper-PAL Grey filament)
- Layer height: 0.2mm
- Infill: 20%
- Supports: Yes (for cable channel)

**I can generate an STL file if you provide dimensions you'd like**

### Option 2: Modify Plastic Project Box

**If you order a project box:**
1. Mark button positions on lid
2. Drill 12mm holes for TTP223 pads
3. Drill 30mm hole for LED ring (center)
4. Mount PCB with standoffs inside
5. Route USB cable through side

### Mounting Options

**Nightstand:**
- Adhesive velcro strips
- Rubber feet (prevent sliding)
- Weighted base (add washers inside)

**Wall-mount:**
- 3D print bracket
- Keyhole slots in enclosure
- Command strips (damage-free)

---

## Troubleshooting

### Soldering Issues

| Problem | Cause | Solution |
|---------|-------|----------|
| **Cold solder joint** (dull, grainy) | Not enough heat or moved while cooling | Reheat joint, add flux if needed |
| **Solder won't stick** | Dirty pad or oxidized tip | Clean with brass sponge, add flux |
| **Solder bridge** | Too much solder | Use solder wick to remove excess |
| **Wire pulls out easily** | Insufficient solder | Add more solder to joint |
| **Component damaged** | Too much heat for too long | Replace component, use lower temp |

### Button Issues

| Problem | Solution |
|---------|----------|
| **Button doesn't respond** | • Check solder joints (VCC, GND, OUT)<br>• Verify GPIO pin in config<br>• Check for shorts with multimeter |
| **Button stuck "on"** | • TTP223 in self-locking mode (toggle jumper)<br>• Check for solder bridge on OUT pin |
| **Intermittent triggering** | • Add `delayed_on/off` filter (already in config)<br>• Check wire connections<br>• Move away from power wires (interference) |
| **Multiple buttons trigger** | • Solder bridge between GPIO pins<br>• Wires crossed |

### LED Ring Issues

| Problem | Solution |
|---------|----------|
| **No LEDs light up** | • Check VCC/GND connections<br>• Verify DIN connected to GPIO 33<br>• Check if using INPUT side of ring (arrows point away) |
| **Wrong colors** | • Check RGB values in config<br>• WS2812B vs WS2812 (different chip orders) |
| **LEDs flicker** | • Insufficient power (use 5V pin, not 3.3V)<br>• Add 100µF capacitor across power<br>• Add 470Ω resistor on DIN line |
| **Only first LED works** | • Data line broken between LEDs<br>• Damaged LED in chain |

### Home Assistant Integration Issues

| Problem | Solution |
|---------|----------|
| **Device not discovered** | • Check Wi-Fi credentials in config<br>• Verify static IP is available<br>• Check API encryption key matches |
| **Button press doesn't trigger action** | • Verify entity_id in config matches HA<br>• Check HA logs for errors<br>• Test manually in Developer Tools |
| **Morning briefing doesn't trigger** | • Verify `rest_command.trigger_morning_briefing` exists in HA<br>• Test n8n webhook manually with curl<br>• Check n8n workflow is active |

### General Debugging

**View logs:**
```bash
docker exec -it esphome esphome logs bedside-button-panel.yaml
```

**Check connections with multimeter:**
1. **Continuity mode** - Verify connections between components
2. **Voltage mode** - Check power rails (3.3V, 5V, GND)
3. **Diode mode** - Check LED ring polarity

**Common fixes:**
- 🔄 Reflow (reheat) suspicious solder joints
- 🔍 Inspect for hairline cracks in joints
- 🧹 Clean flux residue with isopropyl alcohol
- 🔌 Verify USB power supply provides stable 5V

---

## Next Steps & Enhancements

### Button Function Ideas

**Reserved Button 5 & 6 options:**
- 📚 "Reading mode" - Dim bedroom lights to warm white
- 🎵 Play relaxation music on Bedroom Speaker
- 🌡️ Trigger HVAC to "Sleep" mode (cooler temp)
- 🔒 Arm/disarm alarm system
- 📺 Turn off all media devices
- ⏰ Set wake-up alarm for tomorrow
- 🧘 Trigger meditation/focus timer

### Advanced Features

**Visual feedback enhancements:**
```yaml
# Show fan status on LED ring
- interval: 5s
  then:
    - if:
        condition:
          lambda: 'return id(bedroom_fan).state;'
        then:
          - light.turn_on:
              id: status_ring
              brightness: 20%
              red: 0%
              green: 100%
              blue: 0%
        else:
          - light.turn_off: status_ring
```

**Add OLED display:**
- Show current time
- Display button labels
- Show device status (fan on/off, coffee ready, etc.)

**Battery backup:**
- Add 18650 battery with TP4056 charger
- Works during power outages
- Wake ESP32 on button press (deep sleep between)

**Haptic feedback:**
- Add small vibration motor
- Confirm button presses with buzz

### Iteration 2.0

After you've mastered this build, consider:
- **Smaller form factor** - Use ESP32 XIAO C6 (ultra-compact)
- **Custom PCB** - Design and order professional PCB
- **Capacitive touch pads** - Create your own touch sensors (no TTP223 modules)
- **E-ink display** - Always-visible button labels (no power when idle)

---

## Bill of Materials Summary

### From Inventory (Reserved)

- [x] 1x ESP32 Development Board (Generic) - **Reserved**
- [x] 6x TTP223 Capacitive Touch Button - **Reserved**
- [x] 1x WS2812B RGB LED Ring (12 LEDs) - **Reserved**
- [x] 1x Double-Sided PCB Prototype Board (5x7cm) - **Reserved**
- [x] 20x Jumper Wires (M-F) - **Reserved**
- [x] 1x USB Power Supply (5V 1A) - **Reserved**

### Tools Used

- Weller WLSK3012A Soldering Station
- Electrisol 60/40 Solder
- Flush Cutters
- Wire Strippers
- Tweezers
- Digital Multimeter (recommended)

### Optional to Purchase

- [ ] Micro USB Cable (right-angle) - $3-5
- [ ] Project Enclosure or 3D print - $0-10

**Total Cost:** $0-15 (mostly from inventory)

---

## Learning Outcomes

By completing this project, you will have learned:

✅ **Soldering Fundamentals:**
- Through-hole soldering technique
- Wire preparation and tinning
- Identifying good vs bad solder joints
- Using flux and cleaning techniques

✅ **Circuit Assembly:**
- Reading wiring diagrams
- Power rail distribution
- GPIO pin selection
- Component integration

✅ **Testing & Debugging:**
- Multimeter usage (voltage, continuity)
- Systematic troubleshooting
- Component testing before integration

✅ **ESP32 Development:**
- ESPHome configuration
- GPIO programming
- Home Assistant integration
- Wireless OTA updates

✅ **Home Automation:**
- Scene creation
- Service calls
- Template switches
- Dashboard customization

---

## Safety Reminders

⚠️ **Soldering Safety:**
- Work in ventilated area (solder fumes)
- Don't touch soldering iron tip (350°C!)
- Unplug iron when not in use
- Keep flammable materials away
- Wash hands after soldering (lead exposure)

⚠️ **Electrical Safety:**
- Don't work on powered circuits
- Check for shorts before powering on
- Use appropriate power supply (5V 1A max)
- Don't exceed component ratings

⚠️ **Component Safety:**
- Don't reverse polarity on LED ring (can damage)
- Don't short power to ground (can damage ESP32)
- Handle ESP32 by edges (ESD sensitive)

---

## Project Timeline

| Phase | Time | Cumulative |
|-------|------|------------|
| Preparation & component check | 10 min | 10 min |
| Solder header pins (if needed) | 20 min | 30 min |
| Prepare wires | 10 min | 40 min |
| Solder TTP223 buttons | 30 min | 1h 10m |
| Test buttons | 10 min | 1h 20m |
| Solder LED ring | 15 min | 1h 35m |
| Assemble on PCB | 20 min | 1h 55m |
| First power-on test | 10 min | 2h 5m |
| Flash ESPHome firmware | 15 min | 2h 20m |
| Configure Home Assistant | 10 min | 2h 30m |
| Test & debug | 15 min | 2h 45m |
| Enclosure (optional) | 30 min | 3h 15m |

**Total:** 2h 45m - 3h 15m (depending on soldering experience)

---

## Documentation & Resources

**ESPHome References:**
- [Binary Sensor Component](https://esphome.io/components/binary_sensor/gpio.html)
- [NeoPixel Light](https://esphome.io/components/light/neopixelbus.html)
- [Home Assistant Service Calls](https://esphome.io/components/api.html#homeassistant-service-action)

**Soldering Tutorials:**
- [Adafruit Soldering Guide](https://learn.adafruit.com/adafruit-guide-excellent-soldering)
- [SparkFun How to Solder](https://learn.sparkfun.com/tutorials/how-to-solder-through-hole-soldering)

**Your Project Files:**
- ESPHome Config: `/home/hazzard/home-assistant/esphome/bedside-button-panel.yaml`
- This Guide: http://192.168.40.201:8888/projects/bedside-button-panel/

---

**Ready to start soldering?** 🎉

Take your time, work methodically, and don't rush. This is a beginner-friendly project designed to teach soldering fundamentals while creating something genuinely useful for your smart home.

**Good luck, and enjoy building your first soldered ESP32 project!**
