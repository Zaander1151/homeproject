# Project 9: RGB Mood Lighting System

**Difficulty:** Advanced
**Estimated Time:** 4-6 hours
**Cost:** $35-60

## Learning Objectives

By completing this project, you will learn:
- Addressable LED protocols (WS2812B, SK6812)
- Power management for high-current devices
- Color theory (RGB, HSV color spaces)
- Effects programming and animations
- Level shifters for 5V data signals
- Power injection techniques for long LED strips
- Integration with Home Assistant light entities

---

## Parts List

| Part | Quantity | Approximate Cost (CAD) | Notes |
|------|----------|------------------------|-------|
| ESP32 Development Board | 1 | $8-12 | Reuse from previous projects |
| WS2812B LED Strip (5m, 60 LEDs/m) | 1 | $20-30 | 300 LEDs total, IP30 (indoor) |
| 5V Power Supply (10A+) | 1 | $15-25 | 50W minimum for 300 LEDs |
| 1000μF Capacitor | 1 | $2-3 | Across power supply (smoothing) |
| 470Ω Resistor | 1 | $0.10 | Data line protection |
| Logic Level Shifter (optional) | 1 | $3-5 | 3.3V to 5V for data signal |
| DC Power Jack | 1 | $2-3 | Barrel jack connector |
| Jumper Wires | 6-10 | Reuse | Various lengths |

**Total Cost:** ~$35-60 (depending on LED strip quality)

**LED Strip Options:**
- **WS2812B** - Most common, 5V, integrated controller
- **SK6812** - Similar to WS2812B, better color accuracy
- **WS2815** - 12V variant, less voltage drop
- **APA102** - SPI-based, faster refresh, more expensive

**IP Ratings:**
- **IP30** - Indoor, no protection (~$20-25/5m)
- **IP65** - Splash-proof, silicone coating (~$25-30/5m)
- **IP67** - Waterproof, silicone tube (~$30-40/5m)

---

## Understanding the Parts

### WS2812B Addressable LEDs

**What makes them "addressable"?**
- Each LED has its own tiny controller chip
- Can set each LED to any color independently
- Data cascades: ESP32 → LED1 → LED2 → LED3 → ...
- Only needs 1 data pin to control hundreds of LEDs

**Specifications:**
- **Voltage:** 5V DC
- **Current per LED:** ~60mA at full white (20mA per color channel)
- **300 LEDs × 60mA = 18A maximum** (full white, 100% brightness)
- **Typical usage:** 30-50% brightness = 5-9A actual draw
- **Protocol:** One-wire serial (timing-based, not I2C/SPI)
- **Refresh Rate:** ~400 Hz typical, ~800 Hz maximum
- **Colors:** 24-bit RGB (16.7 million colors)

**How the protocol works:**
- **Logic 1:** 0.8μs HIGH, 0.45μs LOW
- **Logic 0:** 0.4μs HIGH, 0.85μs LOW
- **Reset:** 50μs+ LOW (latches data to all LEDs)
- Data sends as: GRB (Green-Red-Blue), not RGB!

**Common Issues:**
- **Voltage drop:** Long strips dim at the end (fix: power injection)
- **Data corruption:** Flickers, wrong colors (fix: level shifter, shorter wires)
- **Brownout:** ESP32 resets when LEDs turn on (fix: capacitor, separate power)

### Power Supply Sizing

**Formula:**
```
Power (W) = Voltage (V) × Current (A)
Current (A) = Number of LEDs × Current per LED
```

**Example (300 LEDs):**
- **Worst case:** 300 LEDs × 60mA = 18A (5V × 18A = 90W)
- **Typical (50% brightness):** 9A (5V × 9A = 45W)
- **Recommended:** 10A power supply (50W) for headroom

**Important:** ESP32 cannot power LED strips! Maximum GPIO current is ~40mA. LEDs need separate 5V power supply.

### Level Shifting (3.3V → 5V)

**Why needed?**
- ESP32 GPIO outputs 3.3V logic
- WS2812B expects 5V logic (minimum 0.7 × VDD = 3.5V)
- 3.3V may work for short strips (<1m), but unreliable

**Solutions:**
1. **Level Shifter Module:** 74HCT125 or similar (~$3-5)
2. **Diode + Resistor Trick:** Simple but less reliable
3. **First LED Powered at 4.5V:** Lowers logic threshold
4. **SN74HCT245:** 8-channel bidirectional shifter (overkill but robust)

**Best Practice:** Use 74HCT125 or 74AHCT125 (fast, cheap, reliable)

### Power Injection

**What is power injection?**
- Feeding power at multiple points along the strip
- Prevents voltage drop (dim LEDs at the end)

**When needed?**
- Strips longer than 2-3 meters
- High brightness levels (>70%)
- Noticeable dimming at the far end

**How to inject power:**
- Every 2-3 meters, connect 5V and GND to strip
- Data line runs the entire length (no injection needed)
- Use thicker wire (18 AWG for power, 22 AWG for data)

**Wiring Example (5m strip with injection):**
```
Power Supply (5V 10A)
    ├── [0m]  LED Strip Start (ESP32 data connection here)
    ├── [2.5m] Power Injection Point (5V + GND only)
    └── [5m]  LED Strip End
```

---

## Wiring Diagram

### Basic Setup (Short Strip, No Level Shifter)

```
ESP32 Board              WS2812B LED Strip         5V Power Supply

GPIO5 ------[470Ω]-----> DIN (Data In)

GND ----------------+--> GND --------------------> GND (-)
                    |
                    +-------------------------> GND

                        5V ---------------------> 5V (+)

                     [1000μF Cap]
                        + -
                      5V GND
```

**Pin Connections:**
| ESP32 Pin | LED Strip Pin | Power Supply |
|-----------|---------------|--------------|
| GPIO5 (via 470Ω) | DIN (Data In) | - |
| GND | GND | GND (-) |
| - | 5V | 5V (+) |

**Important Notes:**
- **DO NOT** connect ESP32 5V pin to LED strip power! Use separate 5V supply
- **Capacitor:** 1000μF electrolytic across power supply (+ to 5V, - to GND)
- **Resistor:** 470Ω between ESP32 GPIO and LED DIN (data line protection)
- **Common Ground:** ESP32 GND and LED strip GND must be connected

### Advanced Setup (With Level Shifter)

```
ESP32          Level Shifter (74HCT125)      WS2812B Strip     5V PSU

GPIO5 -------> LV (Input)
               HV (Output) ----[470Ω]------> DIN

3.3V -------> VCC_LV
5V ---------------------------------+-------> VCC_HV
                                     |
GND --------+-> GND                  |
            |                        +-------> 5V ------------> 5V (+)
            +-------------------------------+-> GND -----------> GND (-)
                                            |
                                            +-> GND

                                         [1000μF Cap]
                                            + -
                                          5V GND
```

**74HCT125 Pinout:**
| Pin | Connection |
|-----|------------|
| VCC | 5V (from power supply) |
| GND | Common ground |
| 1A (Input) | ESP32 GPIO5 (3.3V) |
| 1Y (Output) | LED strip DIN (via 470Ω) |

---

## ESPHome Configuration

Create a new file: `/home/hazzard/home-assistant/esphome/rgb-mood-lighting.yaml`

### Complete Configuration

```yaml
esphome:
  name: rgb-mood-lighting
  friendly_name: "Living Room RGB Lighting"
  platform: ESP32
  board: esp32dev

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password

  manual_ip:
    static_ip: 192.168.40.160
    gateway: 192.168.40.1
    subnet: 255.255.255.0
    dns1: 8.8.8.8

  ap:
    ssid: "RGB-Lighting-FB"
    password: "12345678"

logger:

api:
  encryption:
    key: !secret api_key_rgb_lighting

ota:
  - platform: esphome
    password: !secret ota_password

# WS2812B LED Strip Configuration
light:
  - platform: neopixelbus
    type: GRB  # WS2812B uses GRB order (not RGB!)
    variant: WS2812  # Options: WS2812, WS2812X, SK6812, WS2811
    pin: GPIO5
    num_leds: 300  # 5m × 60 LEDs/m = 300 LEDs
    name: "RGB Strip"
    id: rgb_strip

    # Color Correction (adjust for more accurate colors)
    color_correct: [100%, 100%, 100%]  # [Red%, Green%, Blue%]
    # Example: LEDs too blue? Try [100%, 100%, 80%]

    # Gamma Correction (perceptual brightness)
    gamma_correct: 2.8  # Default 2.8 (makes dimming smoother)

    # Default State (on boot)
    restore_mode: RESTORE_DEFAULT_OFF

    # Effects (animations)
    effects:
      # Rainbow Cycle
      - addressable_rainbow:
          name: "Rainbow"
          speed: 10
          width: 50

      # Rainbow with Glitter
      - addressable_rainbow:
          name: "Rainbow Glitter"
          speed: 10
          width: 50
      - addressable_twinkle:
          name: "Glitter"
          twinkle_probability: 5%
          progress_interval: 4ms

      # Color Wipe
      - addressable_color_wipe:
          name: "Color Wipe"
          colors:
            - red: 100%
              green: 0%
              blue: 0%
              num_leds: 50
            - red: 0%
              green: 100%
              blue: 0%
              num_leds: 50
            - red: 0%
              green: 0%
              blue: 100%
              num_leds: 50
          add_led_interval: 10ms
          reverse: true

      # Theater Chase
      - addressable_scan:
          name: "Theater Chase"
          move_interval: 50ms
          scan_width: 5

      # Breathing
      - pulse:
          name: "Breathing"
          transition_length: 2s
          update_interval: 2s

      # Strobe
      - strobe:
          name: "Strobe"
          colors:
            - state: true
              duration: 100ms
            - state: false
              duration: 200ms

      # Fireworks
      - addressable_fireworks:
          name: "Fireworks"
          update_interval: 32ms
          spark_probability: 10%
          use_random_color: true
          fade_out_rate: 120

      # Random Twinkle
      - addressable_twinkle:
          name: "Twinkle"
          twinkle_probability: 5%
          progress_interval: 4ms

      # Lambda Custom Effect (Moving Dot)
      - addressable_lambda:
          name: "Moving Dot"
          update_interval: 16ms
          lambda: |-
            static int position = 0;
            it.all() = Color(0, 0, 0);  // Clear all LEDs
            it[position] = Color(255, 0, 0);  // Red dot
            position = (position + 1) % it.size();

# Sensors
sensor:
  # WiFi Signal
  - platform: wifi_signal
    name: "WiFi Signal"
    update_interval: 60s

  # Uptime
  - platform: uptime
    name: "Uptime"
    update_interval: 300s

# Text Sensors
text_sensor:
  - platform: wifi_info
    ip_address:
      name: "IP Address"

# Buttons
button:
  - platform: restart
    name: "Restart Device"
```

---

## Understanding the Code

### NeoPixelBus Platform

```yaml
light:
  - platform: neopixelbus
    type: GRB      # Color order (WS2812B = GRB, not RGB!)
    variant: WS2812
    pin: GPIO5
    num_leds: 300
```

**Type Options:**
- **GRB** - WS2812B, WS2812, SK6812
- **RGB** - WS2811, some APA102
- **RGBW** - SK6812W (has white channel)
- **GRBW** - SK6812 RGBW variant

**Variant Options:**
- **WS2812** - Standard WS2812B (800 kHz)
- **SK6812** - Similar to WS2812, better color
- **WS2811** - External controller (400 kHz)
- **APA102** - SPI-based (requires MOSI + CLK pins)

**How to determine type?**
- Flash with `GRB`, set to red
- If LED shows **red** → GRB is correct
- If LED shows **green** → Change to `RGB`
- If LED shows **blue** → Change to `BRG` (rare)

### Color Correction

```yaml
color_correct: [100%, 100%, 100%]  # [Red%, Green%, Blue%]
```

**Why needed?**
- LED strips vary in color balance
- Some strips are too blue, some too warm
- Calibrate to match "true white"

**Calibration Process:**
1. Set all to 100%: `[100%, 100%, 100%]`
2. Set strip to white (255, 255, 255)
3. If too blue → reduce blue: `[100%, 100%, 80%]`
4. If too warm → reduce red: `[90%, 100%, 100%]`
5. Adjust until white looks neutral

### Gamma Correction

```yaml
gamma_correct: 2.8  # Default 2.8
```

**What is gamma correction?**
- Human perception of brightness is non-linear
- Doubling LED PWM doesn't look twice as bright
- Gamma correction compensates for this

**Values:**
- **1.0** - No correction (linear brightness, harsh steps)
- **2.8** - Default (smooth dimming, perceptually linear)
- **3.0** - More aggressive (smoother at low brightness)

**Effect:** Makes dimming from 100% → 1% look smooth and natural

### Built-in Effects

**addressable_rainbow:**
```yaml
- addressable_rainbow:
    name: "Rainbow"
    speed: 10      # Higher = faster (1-100)
    width: 50      # LEDs per color cycle (lower = tighter pattern)
```

**addressable_fireworks:**
```yaml
- addressable_fireworks:
    name: "Fireworks"
    update_interval: 32ms  # Refresh rate (lower = smoother)
    spark_probability: 10%  # Chance of new spark per LED
    use_random_color: true
    fade_out_rate: 120      # How fast sparks fade (0-255)
```

**addressable_lambda (Custom Effects):**
```yaml
- addressable_lambda:
    name: "Custom Effect"
    update_interval: 16ms  # 60 FPS
    lambda: |-
      // C++ code to animate LEDs
      it[0] = Color(255, 0, 0);  // Set first LED to red
      it.all() = Color(0, 0, 255);  // Set all LEDs to blue
```

**Lambda Functions:**
- `it.size()` - Number of LEDs
- `it[index]` - Access specific LED
- `it.all()` - All LEDs at once
- `Color(red, green, blue)` - Create RGB color (0-255 each)

---

## Step-by-Step Build Guide

### Step 1: Power Supply Setup

**Safety First!**
1. **Unplug power supply** before any wiring
2. Identify polarity:
   - **Red wire / "+" / center pin** = Positive (5V)
   - **Black wire / "-" / outer barrel** = Negative (GND)
3. Test with multimeter: Set to DC voltage, measure between + and -
   - Should read ~5.0V DC (±0.2V tolerance)

**Add Capacitor (Smoothing):**
1. Identify capacitor polarity:
   - **Longer leg / stripe on body** = Negative (-)
   - **Shorter leg / blank side** = Positive (+)
2. Connect across power supply:
   - Capacitor **+** → Power supply **+** (5V)
   - Capacitor **-** → Power supply **-** (GND)
3. Purpose: Reduces voltage spikes when LEDs turn on (prevents ESP32 brownout)

### Step 2: Wiring LED Strip

**LED Strip Anatomy:**
```
[Start of Strip]        [End of Strip]
DIN  5V  GND           DOUT  5V  GND
 ↑   ↑   ↑              ↑    ↑   ↑
Data In (from ESP32)   Data Out (to next strip)
```

**Connections:**
1. **Data Line:** ESP32 GPIO5 → 470Ω resistor → LED strip **DIN**
2. **Power:** 5V power supply **+** → LED strip **5V**
3. **Ground:** 5V power supply **-** → LED strip **GND**
4. **Common Ground:** ESP32 **GND** → LED strip **GND** (shared with power supply GND)

**Double-Check:**
- ✅ ESP32 and LED strip share **common GND**
- ✅ ESP32 **NOT** connected to LED strip 5V (separate power!)
- ✅ Data line has 470Ω resistor
- ✅ Capacitor across power supply

### Step 3: Test with Minimal Code

**Before flashing full config, test with simple pattern:**

Create `rgb-test.yaml`:
```yaml
esphome:
  name: rgb-test
  platform: ESP32
  board: esp32dev

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password

logger:
api:
ota:

light:
  - platform: neopixelbus
    type: GRB
    variant: WS2812
    pin: GPIO5
    num_leds: 10  # Test with just 10 LEDs first!
    name: "Test Strip"
```

**Flash and Test:**
1. Flash via USB: `docker exec -it esphome esphome upload /config/rgb-test.yaml`
2. Power on 5V supply
3. In Home Assistant: Turn on light entity
4. **Expected:** First 10 LEDs light up white

**If all LEDs are off:**
- Check 5V power supply (measure with multimeter)
- Verify DIN connection (ESP32 GPIO5 → resistor → LED DIN)
- Try different GPIO pin (some boards have restrictions)
- Check common GND connection

**If wrong colors (e.g., red instead of white):**
- Change `type: GRB` to `type: RGB` (or `BRG`, `RBG`, etc.)
- Reflash and test until colors are correct

**If only first few LEDs work:**
- Data corruption (add level shifter)
- Power issue (check 5V supply capacity)
- Faulty LED strip (test with fewer LEDs)

### Step 4: Flash Full Configuration

1. Update `num_leds: 300` (or your actual LED count)
2. Flash `rgb-mood-lighting.yaml`
3. Monitor logs for errors:
   ```
   [I][light:036]: Setting up light 'RGB Strip'...
   [I][light:036]: Restoring state: OFF
   ```

### Step 5: Verify Effects in Home Assistant

**Add to Home Assistant:**
1. **Settings → Integrations → ESPHome**
2. Device: `rgb-mood-lighting`
3. Light entity: `light.rgb_strip`

**Test Effects:**
1. Open light entity
2. Click **Effect** dropdown
3. Select "Rainbow"
4. **Expected:** Smooth rainbow animation cycling through strip

**Try All Effects:**
- ✅ Rainbow
- ✅ Fireworks
- ✅ Twinkle
- ✅ Theater Chase
- ✅ Breathing

### Step 6: Brightness and Color Testing

**Brightness Test:**
1. Set effect to "None" (solid color)
2. Adjust brightness slider: 0% → 100%
3. **Expected:** Smooth dimming with gamma correction (no harsh steps)

**Color Test:**
1. Open color picker
2. Set to pure red (RGB: 255, 0, 0)
3. **Expected:** All LEDs show red (if green appears, check `type:` in YAML)

**White Balance Test:**
1. Set color to white (RGB: 255, 255, 255)
2. Observe color tone
3. If too blue/warm, adjust `color_correct:` in YAML

---

## Troubleshooting

### LEDs Flicker or Show Random Colors

**Cause:** Data signal issues (voltage, noise, timing)

**Fix:**
1. **Add level shifter** (3.3V → 5V for data line)
2. **Shorten wires** (data wire should be < 30cm)
3. **Add 470Ω resistor** on data line (if not already present)
4. **Try different GPIO pin** (GPIO16, GPIO17 sometimes more stable)
5. **Lower brightness** (high current draw can cause noise)

### Only First Few LEDs Work

**Cause:** Faulty LED or data cascade break

**Fix:**
1. **Identify failed LED:** Count how many work (e.g., 37 LEDs work → 38th is faulty)
2. **Cut and splice:** Cut strip at failed LED, solder DOUT of LED 37 to DIN of LED 39
3. **Update `num_leds:`** in YAML (reduce by 1)
4. **Test shorter strip:** Set `num_leds: 50` to verify first section works

### LEDs Dim at the End of Strip

**Cause:** Voltage drop (resistance in power wires)

**Fix:**
1. **Power injection:** Add 5V + GND connection at midpoint (2.5m mark)
   ```
   Power Supply → [0m] LED Start
                  [2.5m] Power Injection (5V + GND only, no data)
   ```
2. **Thicker wires:** Use 18 AWG for power (not 22 AWG)
3. **Shorter strip:** Test with 2m section first
4. **Lower brightness:** 50% brightness reduces current draw

### ESP32 Reboots When LEDs Turn On

**Cause:** Brownout (voltage drop from LED inrush current)

**Fix:**
1. **Verify capacitor:** 1000μF across power supply (prevents spikes)
2. **Separate power:** Ensure ESP32 powered by USB or separate 5V (not LED power supply)
3. **Gradual turn-on:** Add transition in automation:
   ```yaml
   service: light.turn_on
   target:
     entity_id: light.rgb_strip
   data:
     transition: 2  # 2-second fade-in
   ```

### Wrong Colors (e.g., Red Shows Green)

**Cause:** Incorrect color order in YAML

**Fix:**
1. Change `type:` in YAML:
   - Try `RGB`, `GRB`, `BGR`, `RBG`, `BRG`, `GBR`
2. Reflash and test with pure red (255, 0, 0)
3. When LED shows correct red, you've found the right order

### Effects Run Slowly

**Cause:** Update interval too slow or ESP32 overloaded

**Fix:**
1. **Reduce `update_interval:`** (e.g., `32ms` → `16ms`)
2. **Simplify effects:** Disable complex lambda effects
3. **Reduce logging:** Set `logger: level: WARN` (less serial output)
4. **Overclock ESP32:** Add to YAML:
   ```yaml
   esphome:
     platformio_options:
       board_build.f_cpu: 240000000L  # 240 MHz (default 160 MHz)
   ```

---

## Advanced Customizations

### Custom Effect: Fire Simulation

```yaml
effects:
  - addressable_lambda:
      name: "Fire"
      update_interval: 16ms
      lambda: |-
        static int heat[300] = {0};  // Heat array (one per LED)

        // Cool down every LED
        for (int i = 0; i < it.size(); i++) {
          heat[i] = max(0, heat[i] - random(0, ((55 * 10) / it.size()) + 2));
        }

        // Heat from neighbors (drift upward)
        for (int k = it.size() - 1; k >= 2; k--) {
          heat[k] = (heat[k - 1] + heat[k - 2] + heat[k - 2]) / 3;
        }

        // Randomly ignite new sparks at bottom
        if (random(255) < 120) {
          int y = random(7);
          heat[y] = min(255, heat[y] + random(160, 255));
        }

        // Convert heat to LED colors (black → red → orange → yellow)
        for (int j = 0; j < it.size(); j++) {
          int temperature = heat[j];

          // Black to red (0-128)
          if (temperature < 128) {
            it[j] = Color(temperature * 2, 0, 0);
          }
          // Red to orange (128-192)
          else if (temperature < 192) {
            it[j] = Color(255, (temperature - 128) * 4, 0);
          }
          // Orange to yellow (192-255)
          else {
            it[j] = Color(255, 255, (temperature - 192) * 4);
          }
        }
```

### Custom Effect: Matrix Rain

```yaml
effects:
  - addressable_lambda:
      name: "Matrix Rain"
      update_interval: 50ms
      lambda: |-
        static int drops[20] = {0};  // Track 20 "raindrops"

        // Fade all LEDs (trailing effect)
        for (int i = 0; i < it.size(); i++) {
          auto current = it[i].get();
          it[i] = Color(
            max(0, current.r - 10),
            max(0, current.g - 10),
            max(0, current.b - 10)
          );
        }

        // Update drops
        for (int d = 0; d < 20; d++) {
          if (drops[d] == 0) {
            // Start new drop randomly
            if (random(100) < 30) {
              drops[d] = 1;
            }
          } else {
            // Draw drop
            it[drops[d]] = Color(0, 255, 0);  // Bright green
            drops[d]++;

            // Reset when reaching end
            if (drops[d] >= it.size()) {
              drops[d] = 0;
            }
          }
        }
```

### Music Sync (Via Home Assistant)

**Home Assistant Automation (uses microphone sensor):**
```yaml
automation:
  - alias: "Music Reactive Lights"
    trigger:
      - platform: state
        entity_id: sensor.microphone_loudness  # Requires microphone integration
    action:
      - service: light.turn_on
        target:
          entity_id: light.rgb_strip
        data:
          brightness: "{{ (trigger.to_state.state | int * 2.55) | int }}"
          transition: 0.1
```

**External Audio Input (Advanced):**
- Add microphone module (MAX4466, MAX9814)
- Sample audio in ESPHome with ADC
- Perform FFT (Fast Fourier Transform) for frequency analysis
- Map bass/mid/treble to different LED sections

---

## Home Assistant Integrations

### Scene Creation

**Preset Scenes:**
```yaml
# configuration.yaml
scene:
  - name: "Movie Night"
    entities:
      light.rgb_strip:
        state: on
        brightness: 30
        rgb_color: [255, 80, 0]  # Warm orange
        effect: "Breathing"

  - name: "Party Mode"
    entities:
      light.rgb_strip:
        state: on
        brightness: 100
        effect: "Rainbow"

  - name: "Focus Mode"
    entities:
      light.rgb_strip:
        state: on
        brightness: 80
        rgb_color: [255, 255, 200]  # Warm white
        effect: "None"
```

### Time-Based Automation

**Circadian Lighting (Mimic Daylight):**
```yaml
automation:
  - alias: "Circadian RGB Lighting"
    trigger:
      - platform: time_pattern
        minutes: "/5"  # Every 5 minutes
    action:
      - service: light.turn_on
        target:
          entity_id: light.rgb_strip
        data:
          brightness: >
            {% set hour = now().hour %}
            {% if hour < 6 or hour > 22 %}
              10
            {% elif hour < 8 %}
              {{ (hour - 6) * 25 + 10 }}  # Sunrise: 10 → 60
            {% elif hour < 18 %}
              80  # Daytime
            {% else %}
              {{ 80 - ((hour - 18) * 17.5) | int }}  # Sunset: 80 → 10
            {% endif %}
          color_temp: >
            {% set hour = now().hour %}
            {% if hour < 6 or hour > 22 %}
              454  # Warm (2200K) - night
            {% elif hour < 12 %}
              250  # Cool (4000K) - morning
            {% else %}
              350  # Neutral (2850K) - afternoon/evening
            {% endif %}
```

### Voice Control (Alexa/Google Home)

**Example Commands:**
- "Alexa, turn on the RGB strip"
- "Alexa, set RGB strip to blue"
- "Alexa, set RGB strip brightness to 50%"
- "Hey Google, activate party mode" (triggers scene)
- "Hey Google, set RGB strip effect to rainbow"

---

## Power Consumption & Efficiency

### Measuring Power Draw

**Multimeter Method:**
1. Set multimeter to DC current (10A range)
2. Break positive wire from power supply
3. Insert multimeter in series
4. Measure current at different brightness levels

**Typical Measurements (300 LEDs):**
| Brightness | Color | Current (A) | Power (W) |
|------------|-------|-------------|-----------|
| 100% | White | 16-18A | 80-90W |
| 100% | Red | 5-6A | 25-30W |
| 100% | Green | 5-6A | 25-30W |
| 100% | Blue | 5-6A | 25-30W |
| 50% | White | 4-5A | 20-25W |
| 10% | White | 0.8-1A | 4-5W |
| Off | - | 0.5-0.8A | 2.5-4W (ESP32 + idle LEDs) |

**Key Takeaways:**
- White = All 3 colors on = 3× power of single color
- 50% brightness ≠ 50% power (gamma correction reduces consumption further)
- Even "off" LEDs draw 0.5mA each (controller chips powered)

### Energy Saving Tips

**Automation Strategies:**
1. **Auto-dim at night:**
   ```yaml
   automation:
     - alias: "Dim lights after 10 PM"
       trigger:
         - platform: time
           at: "22:00:00"
       action:
         - service: light.turn_on
           target:
             entity_id: light.rgb_strip
           data:
             brightness: 20
   ```

2. **Occupancy-based:**
   - Turn off when no motion for 10 minutes
   - Integrate with PIR sensor from Project 4

3. **Prefer single colors:**
   - Red/green/blue = ~33% power of white
   - Use warm white (red + green) instead of full white

---

## What You've Learned

By completing this project, you now understand:

✅ **Addressable LED Technology:**
- WS2812B protocol and timing
- Color order (GRB vs RGB)
- Data cascading through LED chain

✅ **Power Management:**
- Calculating power requirements
- Power injection techniques
- Capacitor smoothing for inrush current

✅ **Signal Processing:**
- Level shifting (3.3V → 5V)
- Data line protection (resistors)
- Common ground requirements

✅ **Color Theory:**
- RGB and HSV color spaces
- Gamma correction for perceptual brightness
- Color calibration and white balance

✅ **Effects Programming:**
- Built-in ESPHome effects
- Custom lambda animations
- Real-time LED control with C++

✅ **Home Automation Integration:**
- Light entities in Home Assistant
- Scene creation and automation
- Voice control via Alexa/Google Home

**Ready for the next project?** Try [Project 10: Voice-Controlled Device](10-voice-controlled-device.md) to build a custom voice assistant like your M5Stack Atom Echo!
