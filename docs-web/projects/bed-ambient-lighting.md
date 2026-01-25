# Bed Ambient Lighting Project

## Overview

A bedroom ambient lighting system using SK6812 RGBW LED strips in aluminum track around the bed perimeter for indirect room illumination. Provides customizable color temperature, effects, and Home Assistant integration.

**Status:** Ready to Build
**Difficulty:** Intermediate
**Estimated Time:** 4-6 hours
**Cost:** $0 (all hardware on hand)

---

## Project Goals

- Replace overhead bedroom light for most activities (watching TV, getting dressed, general ambient lighting)
- Indirect lighting (floor wash + wall wash) for soft, even illumination
- Adjustable color temperature (warm white for bedtime, cool white for morning)
- RGB effects for mood/entertainment
- Home Assistant integration for scenes and automation

---

## Bill of Materials

### What You Have (All Hardware On Hand)

**Electronics:**
- ✅ **9m SK6812 RGBW LED Strip** (30 LEDs/meter) - using 6m = 180 total LEDs
- ✅ **1 x Seeed Studio XIAO ESP32-C6** development board
- ✅ **1 x 5V 15A (75W) Power Supply** with barrel connector
- ✅ **1 x TXS0108E Level Shifter** (optional, try without first)
- ✅ **1 x 470Ω Resistor** (data line protection)
- ✅ **1000µF Electrolytic Capacitors** (10V+)
- ✅ **10A Inline Fuse + Holder**

**Wiring & Supplies:**
- ✅ **16-18 AWG Wire** (red/black for power distribution)
- ✅ **Heat Shrink Tubing** (assorted sizes)
- ✅ **Wago Lever Connectors** or solder/heat shrink
- ✅ **Weller WLSK3012A Soldering Station** + solder

**Mounting:**
- ✅ **6m Aluminum LED Track** with diffuser
- ✅ **Mounting hardware** (adhesive or clips)

### Tools Available

- ✅ Weller WLSK3012A soldering station
- ✅ Multimeter (GDT-3190)
- ✅ Digital caliper
- ✅ Wire strippers
- ✅ Heat shrink applicator

### Nothing to Buy!

**Total Project Cost:** $0 - All components already in inventory

---

## Technical Specifications

### Power Budget (Your Setup)

**30 LEDs/meter × 6m = 180 total LEDs:**
- **Peak consumption:** 180 LEDs × 60mA = **10.8A @ 5V** (all white, 100% brightness)
- **Realistic usage:** 180 LEDs × 30-35mA = **5-6A @ 5V** (typical scenes at 50% brightness)
- **Your power supply:** 5V 15A (75W) - **Plenty of headroom!**

**Power Safety:**
- **Available:** 15A max
- **Required:** 10.8A peak, 5-6A typical
- **Margin:** 40% overhead at peak, 60% typical
- **Verdict:** ✅ Perfectly sized

### Light Output

**Your Configuration (180 LEDs total):**
- **Brightness:** ~3,200 lumens (full white at 100%)
- **Comparison:** Typical bedroom overhead = 1,500-2,500 lumens
- **Result:** More than adequate for ambient lighting and most bedroom activities

**What You Can Use This For:**
- ✅ Ambient mood lighting
- ✅ Bedtime routine (dimmed warm white)
- ✅ Wake-up lighting (bright cool white)
- ✅ Movie/TV watching (low brightness colors)
- ✅ Reading (50-70% warm white with bedside lamp)
- ✅ General room illumination

**Still Need Overhead For:**
- ❌ Detailed close work (sewing, fine assembly)
- ❌ Deep cleaning tasks

---

## Installation Plan

### Layout Configuration (Your 6m Setup)

**6 meters total in 4 sections:**
- **Left Side:** 2m (60 LEDs)
- **Head (Foot):** 1m (30 LEDs)
- **Headboard:** 2m (60 LEDs)
- **Right Side (Foot):** 1m (30 LEDs)
- **Right Side:** 2m (60 LEDs) - **WAIT, that's 8m. Let me recalculate...**

**Actually for 6m around bed perimeter:**
- **Left Side:** 2m (60 LEDs)
- **Foot Left:** 1m (30 LEDs)
- **Foot Right:** 1m (30 LEDs)
- **Right Side:** 2m (60 LEDs)
- **Total:** 6m / 180 LEDs

**Mounting Diagram:**
```
     [Headboard Wall]
    ┌───────────────┐
    │               │
Left│     [Bed]     │Right
2m  │               │ 2m
    │               │
    └───┬───┴───┬───┘
    Foot L   Foot R
      1m       1m
```

**OR Alternative - Include Headboard:**
```
         [Head 2m]
    ┌────────────────┐
Left│     [Bed]      │Right
1.5m│                │1.5m
    └────┬──────┬────┘
      Foot 1.5m
```

**Mounting Options:**
1. **Under bed perimeter** (floor wash lighting)
2. **Under bed + behind headboard** (mixed floor/wall wash)
3. **Behind headboard only** (wall accent - requires less than 6m)

**Choose Your Layout Before Cutting Strips!**

---

## Wiring Diagram

### Power Distribution (Simplified!)

```
                    [5V 15A Power Supply]
                            |
                    [10A Inline Fuse]
                            |
        +-------------------+-------------------+
        |                   |                   |
    [Start 0m]          [Inject 2m]       [Inject 4m]
     Side 1              Head/Foot          Side 2
    60 LEDs              60 LEDs            60 LEDs
```

**Your Setup - 4 Power Injection Points:**
1. **0m (Start):** Side 1 beginning - Main power + ESP32
2. **2m (60 LEDs):** After first 2m section
3. **4m (120 LEDs):** After head/foot sections
4. **6m (End):** Optional - Only if voltage drops

**Why Multiple Injection Points?**
- Prevents voltage drop (LEDs dim at end)
- Each section sees fresh 5V power
- Consistent brightness across all 180 LEDs

### Complete Wiring Schematic

```
[5V 15A PSU] ----[10A Fuse]----+
                                |
            +-------------------+-------------------+
            |                   |                   |
       [XIAO C6]          [Power Wire]        [Power Wire]
            |                   |                   |
         GPIO8              Inject 2m           Inject 4m
            |                   |                   |
        [470Ω]                  |                   |
            |                   |                   |
    +-------+-------------------+-------------------+
    |       |                   |                   |
  Data    5V/GND              5V/GND              5V/GND
    |       |                   |                   |
    V       V                   V                   V
[LED Strip Start]          [Solder Point]      [Solder Point]
    |                           |                   |
    +---> DIN → DOUT → ... → DIN → DOUT → ... → DOUT
           60 LEDs                60 LEDs            60 LEDs
```

### XIAO ESP32-C6 Connections

```
XIAO C6:
  GPIO8  →  470Ω resistor  →  First LED DIN
  GND    →  Power Supply GND (CRITICAL!)
  5V     →  (Optional) USB or PSU 5V
```

**Critical Grounding Rule:**
- ESP32 GND **MUST** connect to PSU GND
- Provides common reference for data signal
- Most common source of "LEDs not working" issues

### Data Signal Path

```
[Side 1 Start] → [Foot 1] → [Head] → [Foot 2] → [Side 2]
     2m             1m         2m        1m         2m

DIN → DOUT → DIN → DOUT → DIN → DOUT → DIN → DOUT → DIN → DOUT
 60 LEDs      30 LEDs      60 LEDs      30 LEDs      60 LEDs
```

**Important:**
- Data flows ONE direction (follow arrows on strip)
- Cut strips ONLY at designated marks (every 3 LEDs / 10cm)
- Solder jumper wires at each cut: DIN→DOUT, 5V→5V, GND→GND

---

## Step-by-Step Build Guide

### Phase 1: Planning & Measurement (30 minutes)

1. **Measure bed frame dimensions** precisely
2. **Mark mounting locations** on bed frame underside
3. **Plan wire routing** from power supply to bed location
4. **Identify power injection points** (mark with tape)
5. **Calculate exact LED strip lengths** needed (account for corners)

### Phase 2: Electronics Preparation (30 minutes)

1. **Test power supply:**
   - Connect 5V 15A supply to multimeter
   - **Expected:** 4.9-5.2V DC output
   - If outside range, do not use (damaged supply)

2. **Test LED strip section:**
   - Cut 30cm test piece from spare strip
   - Connect to power supply (observe polarity!)
   - All LEDs should light up
   - Test before committing to full installation

3. **Prepare XIAO C6:**
   - Solder header pins if not already installed
   - Prepare 3× jumper wires:
     - GPIO8 wire (for data + 470Ω resistor)
     - GND wire (to PSU GND)
     - 5V wire (optional, for powering C6)

4. **Install capacitor:**
   - 1000µF capacitor across PSU output
   - **⚠️ CRITICAL:** Check polarity!
     - Positive (longer leg) → +5V (red)
     - Negative (shorter leg, stripe) → GND (black)

### Phase 3: LED Strip Preparation (1-2 hours)

1. **Cut LED strips to length (30 LED/m, cut every 3 LEDs / 10cm):**
   - **Option A - 3 Sides + Foot:**
     - Side 1: 2m (60 LEDs)
     - Foot Left: 1m (30 LEDs)
     - Foot Right: 1m (30 LEDs)
     - Side 2: 2m (60 LEDs)
   - **Option B - 3 Sides + Head:**
     - Side 1: 1.5m (45 LEDs)
     - Head: 2m (60 LEDs)
     - Side 2: 1.5m (45 LEDs)
     - Foot: 1m (30 LEDs)

2. **Prepare strip ends for soldering:**
   - Use hobby knife to carefully remove silicone coating (10mm)
   - Expose copper pads: DIN, 5V, GND, DOUT
   - Pre-tin all pads with solder (350°C, quick touch)
   - Don't overheat LEDs (max 3 seconds per pad)

3. **Create corner jumper wires:**
   - Cut 16-18 AWG wire:
     - 3× 10cm for data jumpers (DIN→DOUT)
     - 3× 10cm for 5V jumpers
     - 3× 10cm for GND jumpers
   - Strip 5mm on each end
   - Pre-tin wire ends

4. **Add power injection wires:**
   - At 0m, 2m, and 4m points:
     - Solder red wire (16 AWG) to 5V pad
     - Solder black wire (16 AWG) to GND pad
   - Leave 50cm length to reach PSU distribution point
   - Label each wire (Side 1, Inject 2m, Inject 4m)

### Phase 4: Mounting (1-2 hours)

**Option A: Direct Mount (Adhesive Backing)**

1. **Clean mounting surfaces** with isopropyl alcohol
2. **Peel backing from LED strip**
3. **Press firmly along bed frame** rails (under bed)
4. **Mount headboard strip** on wall or headboard back
5. **Secure loose sections** with cable ties or clips

**Option B: Aluminum Channel Mount (Recommended)**

1. **Cut aluminum channels** to strip lengths
2. **Mount channels to bed frame:**
   - Use 3M VHB tape OR drill and screw mount
   - Under bed: Face channels DOWN toward floor
   - Headboard: Face channels TOWARD wall
3. **Insert LED strips** into channels
4. **Route wiring** inside channels where possible
5. **Snap diffuser covers** into channels

### Phase 5: Wiring Assembly (45 minutes)

1. **Position XIAO C6:**
   - Mount under bed near first LED strip start
   - Use adhesive or small enclosure
   - Ensure USB port accessible for future updates

2. **Connect data line:**
   ```
   XIAO GPIO8 → 470Ω resistor → First LED DIN
   ```
   - Solder resistor to GPIO8 pad or use breadboard
   - Keep wire short (<10cm) for signal integrity

3. **Connect ESP32 ground (CRITICAL!):**
   ```
   XIAO GND → PSU GND (black wire)
   ```
   - Use short, thick wire (18 AWG)
   - **Most common failure point** - double check!

4. **Power injection wiring:**
   - Gather all power injection wires (0m, 2m, 4m)
   - Use Wago connectors to distribute PSU output:
     ```
     PSU +5V (red) → Wago → 3× red wires to LED strips
     PSU GND (black) → Wago → 3× black wires + XIAO GND
     ```
   - Alternative: Solder junction with heat shrink

5. **Install inline fuse:**
   - Add 10A fuse holder on PSU positive wire
   - **Before** power distribution to LED strips

6. **Cable management:**
   - Use zip ties every 30cm along bed frame
   - Keep power wires away from sharp edges
   - Label all connections with tape

### Phase 6: Testing & Commissioning (30 minutes)

1. **Visual inspection:**
   - Check all solder joints
   - Verify polarity (capacitor, power wires)
   - Ensure no shorts between 5V and GND

2. **Power on test:**
   - Stand back on first power-up
   - Check voltage at all injection points: 4.8-5.2V
   - Verify C6 boots and connects to WiFi

3. **LED test:**
   - All LEDs should light up
   - Test primary colors (red, green, blue, white)
   - Verify no flickering or dimming

4. **Configuration:**
   - Add device to Home Assistant
   - Test effects and brightness levels
   - Set up scenes and automations

---

## ESPHome Configuration

**Configuration file:** `/home/hazzard/homeproject/xiao-c6-bed-ambient-lighting.yaml`
(Copy to `/home/hazzard/home-assistant/esphome/` when ready to flash)

```yaml
substitutions:
  name: bed-ambient-lighting
  friendly_name: "Bed Ambient Lighting"

esphome:
  name: ${name}
  friendly_name: ${friendly_name}
  platformio_options:
    board_build.flash_mode: dio

esp32:
  board: seeed_xiao_esp32c6
  variant: esp32c6
  framework:
    type: esp-idf
    version: recommended
    sdkconfig_options:
      CONFIG_ESPTOOLPY_FLASHSIZE_4MB: y

logger:
  level: INFO

api:
  encryption:
    key: !secret bed_lighting_api_key

ota:
  - platform: esphome
    password: !secret ota_password

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  manual_ip:
    static_ip: 192.168.40.186
    gateway: 192.168.40.1
    subnet: 255.255.255.0
    dns1: 8.8.8.8

  ap:
    ssid: "Bed-Lighting-Fallback"
    password: !secret fallback_password

# Status LED
status_led:
  pin:
    number: GPIO15
    inverted: false

# LED Strip Configuration
# SK6812 RGBW - 30 LEDs/meter, 6 meters = 180 LEDs
light:
  - platform: esp32_rmt_led_strip
    rgb_order: GRB
    chipset: SK6812
    is_rgbw: true
    pin: GPIO8
    num_leds: 180
    name: "Bed Lighting"
    id: bed_lighting
    restore_mode: RESTORE_DEFAULT_OFF
    default_transition_length: 1.0s

    effects:
      # Ambient effects
      - pulse:
          name: "Gentle Pulse"
          transition_length: 2s
          update_interval: 2s

      - random:
          name: "Subtle Random"
          transition_length: 5s
          update_interval: 10s

      # Color cycling
      - addressable_rainbow:
          name: "Rainbow Wave"
          speed: 5
          width: 100

      - addressable_color_wipe:
          name: "Color Wipe"
          colors:
            - red: 100%
              green: 0%
              blue: 0%
              num_leds: 10
            - red: 0%
              green: 100%
              blue: 0%
              num_leds: 10
            - red: 0%
              green: 0%
              blue: 100%
              num_leds: 10
          add_led_interval: 100ms

      # Fire/candle effects
      - addressable_flicker:
          name: "Candle Flicker"
          intensity: 5%

      # Scan effects
      - addressable_scan:
          name: "Scanner"
          move_interval: 50ms
          scan_width: 5

      # Twinkle
      - addressable_twinkle:
          name: "Twinkle"
          twinkle_probability: 3%
          progress_interval: 50ms

# Restart button
button:
  - platform: restart
    name: "Restart Bed Lighting"
```

---

## Home Assistant Integration

### Scenes

Add these to Home Assistant `configuration.yaml` or via UI:

```yaml
scene:
  - name: "Bedtime"
    entities:
      light.bed_lighting:
        state: on
        brightness: 20
        rgb_color: [255, 147, 41]  # Warm white 2700K

  - name: "Morning Wake Up"
    entities:
      light.bed_lighting:
        state: on
        brightness: 70
        rgb_color: [255, 244, 229]  # Cool white 5000K

  - name: "Movie Time"
    entities:
      light.bed_lighting:
        state: on
        brightness: 10
        rgb_color: [138, 43, 226]  # Purple ambient

  - name: "Reading Light"
    entities:
      light.bed_lighting:
        state: on
        brightness: 50
        rgb_color: [255, 197, 143]  # Warm white 3000K

  - name: "Romance"
    entities:
      light.bed_lighting:
        state: on
        brightness: 15
        rgb_color: [255, 0, 100]  # Soft pink/red
```

### Automations

**Gradual Bedtime Dimming:**
```yaml
automation:
  - alias: "Bedtime Dim Bed Lights"
    trigger:
      - platform: time
        at: "22:00:00"
    action:
      - service: scene.turn_on
        target:
          entity_id: scene.bedtime
      - delay:
          minutes: 30
      - service: light.turn_on
        target:
          entity_id: light.bed_lighting
        data:
          brightness: 5
          transition: 300  # 5 minute fade
```

**Morning Wake Up:**
```yaml
automation:
  - alias: "Morning Wake Up Lights"
    trigger:
      - platform: time
        at: "07:00:00"
    condition:
      - condition: state
        entity_id: binary_sensor.workday_sensor
        state: 'on'
    action:
      - service: light.turn_on
        target:
          entity_id: light.bed_lighting
        data:
          brightness: 1
      - delay:
          seconds: 2
      - service: light.turn_on
        target:
          entity_id: light.bed_lighting
        data:
          brightness: 70
          rgb_color: [255, 244, 229]
          transition: 600  # 10 minute sunrise
```

**Auto Night Light:**
```yaml
automation:
  - alias: "Bed Night Light Mode"
    trigger:
      - platform: state
        entity_id: binary_sensor.bedroom_motion
        to: 'on'
    condition:
      - condition: time
        after: "23:00:00"
        before: "06:00:00"
      - condition: state
        entity_id: light.bed_lighting
        state: 'off'
    action:
      - service: light.turn_on
        target:
          entity_id: light.bed_lighting
        data:
          brightness: 3
          rgb_color: [255, 100, 0]  # Very dim warm orange
      - delay:
          minutes: 5
      - service: light.turn_off
        target:
          entity_id: light.bed_lighting
        data:
          transition: 60
```

---

## Power Supply Placement

### Option 1: Under Bed (Hidden)

**Location:** Center under bed, mounted to frame bottom

**Pros:**
- All wiring hidden
- Short wire runs to LEDs
- Clean appearance

**Cons:**
- Need extension cord to outlet
- Harder to access for troubleshooting

### Option 2: Behind Nightstand

**Location:** Floor behind nightstand, near wall outlet

**Pros:**
- Easy access to AC power
- Easy to troubleshoot/adjust
- Can use power strip for other devices

**Cons:**
- Longer wire runs to bed
- Visible wires need cable management

**Recommendation:** Option 1 if bed doesn't move often, Option 2 for easier access

---

## Cable Management

### Under Bed
- Use **cable raceways** or **wire channels** along bed frame
- **Zip ties** to secure wires to frame every 30cm
- Keep power and data wires separate where possible

### Wall (Headboard to Power Supply)
- Use **flat adhesive cable channels** (paintable)
- Route along baseboard or behind furniture
- **3M cable clips** for minimal visibility

### Buck Converter Mounting
- Mount all 3 converters to small **project box** or **DIN rail mount**
- Secure box to bed frame with zip ties or velcro
- Label each regulator (Start, Mid, End) with tape

---

## Troubleshooting Guide

### No LEDs Light Up

| Check | Solution |
|-------|----------|
| Voltage at C6 | Should be 5V ± 0.2V |
| Voltage at each injection point | Should be 4.8-5.2V |
| Data line continuity | Test D2 → LED DIN with multimeter continuity mode |
| Strip polarity | Verify 5V/GND not reversed |
| C6 WiFi connection | Check device appears in ESPHome dashboard |

### LEDs Dim or Flickering

| Cause | Solution |
|-------|----------|
| Voltage drop | Add more power injection points, use thicker wire (18 AWG) |
| Insufficient current | Upgrade buck converters to higher amperage (5A each) |
| Loose connection | Re-solder power injection joints |
| Bad capacitor | Replace 1000µF capacitor at C6 |

### Colors Don't Match / Each LED Different Color

| Issue | Fix |
|-------|-----|
| Wrong RGB order | Try `rgb_order: RGB` or `rgb_order: BGR` in config |
| Not RGBW mode | Ensure `is_rgbw: true` in config for SK6812 RGBW |
| Mixed strip types | Don't mix WS2812B and SK6812 on same data line |

### Some LEDs Don't Light (Gap in Strip)

| Cause | Solution |
|-------|----------|
| Cut at wrong location | Only cut at marked cut points (every 3/5/10 LEDs depending on density) |
| Broken data line | Check DOUT → DIN solder joint at that gap |
| Dead LED | Replace that LED or bridge data line around it |

### WiFi Connection Issues

| Problem | Fix |
|-------|-----|
| C6 not appearing in HA | Check static IP, try accessing http://192.168.40.186 directly |
| Frequent disconnects | LEDs drawing too much power, C6 brownout - add larger capacitor (2200µF) |
| Can't flash OTA | Flash via USB if LEDs are on during update |

---

## Safety Considerations

### Electrical Safety
- ⚠️ **Capacitor polarity:** CRITICAL - backwards = explosion risk
- ⚠️ **Short circuits:** Test with multimeter before powering on
- ⚠️ **Wire gauge:** Use proper wire size (18 AWG minimum for power)
- ⚠️ **Heat:** Buck converters can get warm (ensure ventilation)

### Fire Safety
- ✅ Don't exceed LED current ratings (480 LEDs = 28.8A max)
- ✅ Use proper wire insulation (heat-resistant)
- ✅ Secure all connections (no loose wires)
- ✅ Fuse the 12V supply (10A fuse recommended)

### Physical Safety
- ✅ Mount securely (won't fall during normal bed use)
- ✅ No sharp edges on aluminum channels
- ✅ Route wires safely (won't be stepped on or pulled)
- ✅ Test stability before final installation

---

## Upgrade Paths

### Future Enhancements

**Add Motion Sensors:**
- PIR sensor under bed for auto night light
-床边运动 = dim light on for 5 minutes

**Add Smart Switch:**
- Wall switch to manually control without phone
- Integrate with existing light switch location

**Expand Coverage:**
- Add strips behind dresser for more ambient light
- Ceiling perimeter lighting (requires wall mounting)

**Advanced Effects:**
- Music reactive mode (requires microphone)
- Sync with TV (Hyperion/DreamScreen integration)
- Wake-up light therapy (gradual color temperature shift)

---

## Cost Breakdown (Your Actual Setup)

| Item | Quantity | Status | Value |
|------|----------|--------|-------|
| SK6812 RGBW LED Strip (30/m) | 9m (using 6m) | ✅ Owned | $30 |
| Aluminum LED Track + Diffuser | 6m | ✅ Owned | $24 |
| XIAO ESP32-C6 | 1 | ✅ Owned | $5 |
| 5V 15A Power Supply | 1 | ✅ Owned | $20 |
| TXS0108E Level Shifter | 1 | ✅ Owned | $2 |
| 470Ω Resistor | 1 | ✅ Owned | $0.10 |
| 1000µF Capacitor | 1 | ✅ Owned | $0.50 |
| 10A Inline Fuse | 1 | ✅ Owned | $2 |
| Wire (16-18 AWG) | 10m+ | ✅ Owned | $5 |
| Heat Shrink Tubing | Assorted | ✅ Owned | $3 |
| Wago Connectors | Multiple | ✅ Owned | $5 |
| **Total Project Cost** | | | **$0.00** |
| **Total Hardware Value** | | | **~$96** |

**Key Advantages:**
- ✅ No shopping required - build immediately
- ✅ All professional-grade components on hand
- ✅ Spare LED strip for future projects (3m remaining)
- ✅ Proven hardware stack (XIAO C6 + SK6812)

---

## Expected Results

### Light Output
- **Brightness:** Sufficient for all bedroom activities except detailed close work
- **Coverage:** Even, indirect lighting throughout 100 sq ft room
- **Ambiance:** Soft, customizable mood lighting

### Use Cases You Can Replace Overhead Light:
- ✅ Watching TV/movies
- ✅ Getting dressed
- ✅ Walking around room
- ✅ Bedtime routine
- ✅ General ambient lighting
- ✅ Casual reading (with supplemental bedside lamp)

### Still Need Overhead Light For:
- ❌ Detailed work (sewing, electronics)
- ❌ Cleaning (need bright task lighting)
- ❌ Close-up grooming tasks
- ❌ Searching for small items

---

## Resources

### Documentation
- **ESPHome Lights:** https://esphome.io/components/light/
- **ESP32 RMT LED Strip:** https://esphome.io/components/light/esp32_rmt_led_strip.html
- **SK6812 Datasheet:** https://cdn-shop.adafruit.com/product-files/1138/SK6812+LED+datasheet+.pdf

### XIAO ESP32-C6 Resources
- **Seeed Wiki:** https://wiki.seeedstudio.com/xiao_esp32c6_getting_started/
- **Pinout Diagram:** https://files.seeedstudio.com/wiki/SeeedStudio-XIAO-ESP32C6/img/xiaoc6.jpg

### Related Projects
- **RGB Strip Test:** `/home/hazzard/homeproject/docs-web/projects/xiao-c6-rgb-strip-test.md`
- **Voice Satellite LED Ring:** `/home/hazzard/homeproject/docs-web/projects/voice-satellite-led-ring.md`

### Recommended Vendors
- **LED Strips:** BTF-Lighting (Amazon), AliExpress
- **Buck Converters:** Amazon, eBay
- **Aluminum Channels:** Amazon ("LED aluminum channel 16mm")
- **XIAO C6:** Seeed Studio, DigiKey, Mouser

---

## Change Log

- **2025-01-05:** Initial project plan created
