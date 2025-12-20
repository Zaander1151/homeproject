# Voice Satellite with LED Ring (Home Assistant Voice Pipeline)

**Difficulty:** Advanced
**Estimated Time:** 6-10 hours
**Cost:** $40-70

## Project Overview

Build a professional voice assistant satellite with visual feedback, similar to commercial devices like Amazon Echo or Google Home. This project features a 12-LED NeoPixel ring for status indication, high-quality I2S audio, and seamless integration with Home Assistant's Wyoming voice pipeline.

**Key Features:**
- 12-LED RGB ring for visual feedback (listening, processing, speaking, errors)
- I2S digital microphone for crystal-clear voice capture
- I2S amplifier with 3W speaker for natural-sounding responses
- Push-to-talk button for manual activation (bypass wake word)
- Wyoming protocol integration (Whisper STT, Piper TTS, OpenWakeWord)
- Wake word detection (always listening mode)
- Compact design suitable for desk or wall mounting

---

## Learning Objectives

By completing this project, you will learn:
- NeoPixel LED ring control and animations
- I2S audio interfacing (microphone and speaker on shared bus)
- Multi-input button handling with debouncing
- Wyoming protocol voice pipeline integration
- Audio routing and mixing
- State machine design for voice assistant feedback
- Real-time LED animations synchronized with voice events

---

## Parts List

| Part | Quantity | Approximate Cost (CAD) | Notes |
|------|----------|------------------------|-------|
| ESP32-S3 Development Board | 1 | $15-20 | Must be ESP32-S3 for I2S support |
| INMP441 I2S Microphone | 1 | $5-8 | MEMS digital microphone |
| MAX98357A I2S Amplifier | 1 | $5-8 | 3W Class D amp |
| Speaker (4Ω, 3W) | 1 | $5-10 | 40mm-50mm diameter |
| NeoPixel Ring (12 LEDs) | 1 | $8-12 | WS2812B, 37mm or 44mm diameter |
| Push Button (Momentary) | 1 | $1-2 | Tactile switch, normally open |
| 1000μF Capacitor | 1 | $1-2 | Power smoothing for LEDs |
| 470Ω Resistor | 1 | $0.10 | LED data line protection |
| 10kΩ Resistor | 1 | $0.10 | Button pull-up |
| Breadboard (or custom PCB) | 1 | $5-8 | 400-point for prototyping |
| Jumper Wires | 20-30 | $3-5 | Various lengths |
| Project Enclosure (optional) | 1 | $10-20 | 3D printed or purchased |

**Total Cost:** ~$40-70

**Recommended Upgrades:**
- **Better Speaker:** 8Ω 5W full-range driver ($15-25) for richer sound
- **Larger LED Ring:** 16 or 24 LEDs ($12-18) for more detailed animations
- **ESP32-S3-DevKitC-1-N8R8:** Official board with 8MB PSRAM ($20-25)
- **Custom PCB:** Design and order from JLCPCB ($15-30 for 5 boards)

---

## Understanding the Parts

### NeoPixel Ring (WS2812B)

**Why a ring?**
- **360° visibility:** See status from any angle
- **Echo-like appearance:** Professional look, familiar to users
- **Animation potential:** Rotating patterns, progress bars, rainbow effects
- **Size options:**
  - 12 LEDs (37mm) - Compact, suitable for small enclosures
  - 16 LEDs (44mm) - Better animation resolution
  - 24 LEDs (66mm) - Smooth effects, larger presence

**Pinout:**
| Pin | Function | Connection |
|-----|----------|------------|
| DIN | Data Input | ESP32 GPIO (via 470Ω resistor) |
| 5V | Power | 5V supply |
| GND | Ground | Common GND |

**Power Consumption:**
- Per LED: ~60mA at full white (100% brightness)
- 12 LEDs × 60mA = **720mA maximum**
- Typical usage (50% brightness, colored): ~200-300mA

**Important:** NeoPixel rings need **5V** power. ESP32 is **3.3V** logic. Use 470Ω resistor on data line to protect first LED, or use level shifter for reliability.

### INMP441 I2S Microphone

**Advantages over analog microphones:**
- **No ADC noise:** Digital output, immune to electrical interference
- **Better SNR:** 61 dB (good for voice recognition)
- **I2S protocol:** Shares bus with speaker amp (fewer GPIO pins)
- **Frequency response:** Optimized for human voice (60 Hz - 15 kHz)

**Pinout:**
| Pin | Function | ESP32-S3 Connection |
|-----|----------|---------------------|
| VDD | Power (3.3V) | 3.3V |
| GND | Ground | GND |
| SD | Serial Data Out | GPIO4 (I2S_DIN) |
| WS | Word Select (L/R) | GPIO5 (I2S_WS) |
| SCK | Serial Clock | GPIO6 (I2S_BCLK) |
| L/R | Channel Select | GND (left channel) |

**L/R Pin Configuration:**
- **GND:** Microphone outputs on LEFT channel
- **3.3V:** Microphone outputs on RIGHT channel
- ESPHome config must match: `channel: left` or `channel: right`

### MAX98357A I2S Amplifier

**Why I2S amplifier (not analog)?**
- **Matched with I2S mic:** Shared clock signals (BCLK, WS)
- **Class D efficiency:** 90% efficient (cool operation, low power)
- **High SNR:** 92 dB (very clean audio)
- **No hiss:** Digital input eliminates ground loop noise

**Pinout:**
| Pin | Function | ESP32-S3 Connection |
|-----|----------|---------------------|
| VIN | Power (5V) | 5V (2A supply recommended) |
| GND | Ground | GND |
| DIN | I2S Data In | GPIO7 (I2S_DOUT) |
| BCLK | Bit Clock | GPIO6 (shared with mic) |
| LRC | Left/Right Clock | GPIO5 (shared with mic) |
| SD | Shutdown/Enable | 3.3V (always on) |
| GAIN | Volume Gain | GND (9dB) or 3.3V (12dB) |
| + / - | Speaker Output | Speaker terminals |

**Gain Selection:**
| GAIN Pin | Gain (dB) | Use Case |
|----------|-----------|----------|
| GND | 9 dB | Default (recommended) |
| 3.3V | 12 dB | Quiet speakers (+3dB louder) |
| 100kΩ to GND | 15 dB | Maximum volume (+6dB) |

### Push Button Functionality

**Operating Modes:**

1. **Wake Word Disabled (Push-to-Talk Only):**
   - Press and hold button → start listening
   - Speak command
   - Release button → process command

2. **Wake Word Enabled (Hybrid Mode):**
   - Automatic: Say "OK Nabu" → listening starts
   - Manual: Press button → bypass wake word, immediate listening
   - Long press: Toggle wake word on/off

3. **Advanced (Multi-Click):**
   - Single click: Manual trigger
   - Double click: Toggle wake word
   - Long press (3s): Mute/unmute

**Wiring:**
```
Button Pin 1 ──────> ESP32 GPIO9
Button Pin 2 ──────> GND

Internal pull-up enabled in ESPHome (no external resistor needed)
```

---

## Wiring Diagram

### Complete Voice Satellite Circuit

```
ESP32-S3 DevKit          INMP441 Mic        MAX98357A Amp       NeoPixel Ring

        Microphone I2S Bus
GPIO4 (DIN) <---------- SD (Data Out)
GPIO5 (WS)  <---------- WS
GPIO6 (BCLK)<---------- SCK
3.3V ----------------> VDD
GND -----------------> GND
                       L/R ──> GND (left channel)

        Speaker I2S Bus
GPIO7 (DOUT)--------> DIN
GPIO5 (WS) ---------> LRC (shared with mic)
GPIO6 (BCLK)--------> BCLK (shared with mic)
5V -----------------> VIN
GND ----------------> GND
3.3V ---------------> SD (enable)
GND ----------------> GAIN (9dB default)
                      + ──> Speaker (+)
                      - ──> Speaker (-)

        NeoPixel LED Ring
GPIO8 ──[470Ω]────> DIN
5V ───[1000μF]────> 5V (capacitor across power)
                    |
GND ───────────────> GND

        Push Button
GPIO9 ────────────> Button Pin 1 (normally open)
                    Button Pin 2 ──> GND
(Internal pull-up enabled in software)

        Power Supply (5V 2A minimum)
5V ───────┬────────> ESP32-S3 5V
          ├────────> MAX98357A VIN
          ├────────> NeoPixel 5V
          └────────> (all 5V connections)

GND ──────┴────────> Common ground (all components)
```

### Pin Connections Table

| ESP32-S3 Pin | INMP441 | MAX98357A | NeoPixel Ring | Button | Notes |
|--------------|---------|-----------|---------------|--------|-------|
| GPIO4 | SD | - | - | - | Mic data in |
| GPIO5 | WS | LRC | - | - | I2S word select (shared) |
| GPIO6 | SCK | BCLK | - | - | I2S bit clock (shared) |
| GPIO7 | - | DIN | - | - | Speaker data out |
| GPIO8 | - | - | DIN (via 470Ω) | - | LED ring data |
| GPIO9 | - | - | - | Pin 1 | Button input |
| 3.3V | VDD | SD (enable) | - | - | Microphone power, amp enable |
| 5V | - | VIN | 5V | - | Speaker amp, LEDs |
| GND | GND, L/R | GND, GAIN | GND | Pin 2 | Common ground |

**Critical Notes:**
- **Shared I2S bus:** BCLK (GPIO6) and WS (GPIO5) shared between mic and speaker
- **Separate data lines:** Microphone DIN (GPIO4), Speaker DOUT (GPIO7)
- **Power separation:** Microphone uses 3.3V, speaker amp and LEDs use 5V
- **Capacitor placement:** 1000μF electrolytic across NeoPixel 5V/GND (as close as possible)

---

## ESPHome Configuration

Create a new file: `/home/hazzard/home-assistant/esphome/voice-satellite-ring.yaml`

### Complete Configuration

```yaml
esphome:
  name: voice-satellite-ring
  friendly_name: "Voice Satellite"
  platformio_options:
    board_build.flash_mode: dio
  on_boot:
    - priority: -100
      then:
        # Initialize LED ring on boot
        - light.turn_on:
            id: led_ring
            effect: "Boot Animation"
            brightness: 50%
        - delay: 2s
        - light.turn_off: led_ring
        # Wait for API connection
        - wait_until: api.connected
        - delay: 1s
        # Start wake word detection if enabled
        - if:
            condition:
              switch.is_on: use_wake_word
            then:
              - voice_assistant.start_continuous:

esp32:
  board: esp32-s3-devkitc-1
  framework:
    type: esp-idf

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password

  manual_ip:
    static_ip: 192.168.40.180
    gateway: 192.168.40.1
    subnet: 255.255.255.0
    dns1: 8.8.8.8

  ap:
    ssid: "Voice-Satellite-FB"
    password: "12345678"

logger:
  level: INFO

api:
  encryption:
    key: !secret api_key_voice_satellite

ota:
  - platform: esphome
    password: !secret ota_password

# I2S Audio Bus (Shared by Microphone and Speaker)
i2s_audio:
  - id: i2s_audio_bus
    i2s_lrclk_pin: GPIO5   # WS (Word Select) - shared
    i2s_bclk_pin: GPIO6    # BCLK (Bit Clock) - shared

# Microphone
microphone:
  - platform: i2s_audio
    id: satellite_microphone
    i2s_audio_id: i2s_audio_bus
    i2s_din_pin: GPIO4     # Microphone data output
    adc_type: external
    pdm: false
    channel: left          # INMP441 L/R pin connected to GND

# Speaker
speaker:
  - platform: i2s_audio
    id: satellite_speaker
    i2s_audio_id: i2s_audio_bus
    i2s_dout_pin: GPIO7    # Speaker data input
    dac_type: external

# Voice Assistant Pipeline
voice_assistant:
  id: va
  microphone: satellite_microphone
  speaker: satellite_speaker

  # Audio processing
  noise_suppression_level: 2       # 0-4 (2 = balanced)
  auto_gain: 31dBFS                # Automatic gain control
  volume_multiplier: 2.0           # Speaker volume boost

  # Wake word configuration
  use_wake_word: true

  # Event handlers with LED feedback
  on_wake_word_detected:
    - light.turn_on:
        id: led_ring
        effect: "Wake Word"
        brightness: 80%

  on_listening:
    - light.turn_on:
        id: led_ring
        effect: "Listening Pulse"
        brightness: 100%

  on_stt_vad_start:
    - light.turn_on:
        id: led_ring
        effect: "Processing Spin"
        brightness: 80%

  on_stt_vad_end:
    - light.turn_on:
        id: led_ring
        effect: "Thinking"
        brightness: 60%

  on_tts_start:
    - light.turn_on:
        id: led_ring
        effect: "Speaking"
        brightness: 100%

  on_tts_end:
    - light.turn_off: led_ring

  on_end:
    - delay: 1s
    - light.turn_off: led_ring
    - if:
        condition:
          switch.is_on: use_wake_word
        then:
          - voice_assistant.start_continuous:

  on_error:
    - light.turn_on:
        id: led_ring
        effect: "Error Flash"
        brightness: 100%
    - delay: 3s
    - light.turn_off: led_ring
    - if:
        condition:
          switch.is_on: use_wake_word
        then:
          - voice_assistant.start_continuous:

  on_client_connected:
    - light.turn_on:
        id: led_ring
        effect: "Connected"
        brightness: 50%
    - delay: 2s
    - light.turn_off: led_ring

  on_client_disconnected:
    - light.turn_on:
        id: led_ring
        effect: "Disconnected"
        brightness: 50%

# NeoPixel LED Ring (12 LEDs)
light:
  - platform: neopixelbus
    type: GRB
    variant: WS2812
    pin: GPIO8
    num_leds: 12
    name: "LED Ring"
    id: led_ring
    default_transition_length: 0.3s

    effects:
      # Boot animation
      - addressable_scan:
          name: "Boot Animation"
          move_interval: 50ms
          scan_width: 2

      # Wake word detected (quick flash)
      - strobe:
          name: "Wake Word"
          colors:
            - state: true
              brightness: 100%
              red: 0%
              green: 100%
              blue: 0%
              duration: 100ms
            - state: false
              duration: 100ms

      # Listening (blue pulse)
      - addressable_lambda:
          name: "Listening Pulse"
          update_interval: 50ms
          lambda: |-
            static uint8_t brightness = 0;
            static int8_t direction = 1;

            brightness += direction * 5;
            if (brightness >= 255 || brightness <= 50) {
              direction = -direction;
            }

            // Blue pulsing ring
            auto color = Color(0, 0, brightness);
            it.all() = color;

      # Processing (green spinner)
      - addressable_scan:
          name: "Processing Spin"
          move_interval: 50ms
          scan_width: 3

      # Thinking (orange dots)
      - addressable_lambda:
          name: "Thinking"
          update_interval: 100ms
          lambda: |-
            static int position = 0;
            it.all() = Color(0, 0, 0);  // Clear

            // Three rotating dots
            it[position % it.size()] = Color(255, 128, 0);  // Orange
            it[(position + 4) % it.size()] = Color(255, 128, 0);
            it[(position + 8) % it.size()] = Color(255, 128, 0);

            position++;

      # Speaking (cyan wave)
      - addressable_lambda:
          name: "Speaking"
          update_interval: 50ms
          lambda: |-
            static float phase = 0;
            phase += 0.15;

            for (int i = 0; i < it.size(); i++) {
              float brightness = (sin(phase + i * 0.5) + 1) / 2;
              it[i] = Color(0, 255 * brightness, 255 * brightness);  // Cyan
            }

      # Error (red flash)
      - strobe:
          name: "Error Flash"
          colors:
            - state: true
              brightness: 100%
              red: 100%
              green: 0%
              blue: 0%
              duration: 200ms
            - state: false
              duration: 200ms

      # Connected (green wipe)
      - addressable_color_wipe:
          name: "Connected"
          colors:
            - red: 0%
              green: 100%
              blue: 0%
              num_leds: 12
          add_led_interval: 50ms

      # Disconnected (red wipe)
      - addressable_color_wipe:
          name: "Disconnected"
          colors:
            - red: 100%
              green: 0%
              blue: 0%
              num_leds: 12
          add_led_interval: 50ms

      # Manual effects (accessible from HA)
      - addressable_rainbow:
          name: "Rainbow"
          speed: 10
          width: 12

      - pulse:
          name: "Slow Pulse"
          transition_length: 2s
          update_interval: 2s

# Push-to-Talk Button
binary_sensor:
  - platform: gpio
    pin:
      number: GPIO9
      inverted: true
      mode:
        input: true
        pullup: true
    name: "Push to Talk Button"
    id: push_button
    filters:
      - delayed_on: 50ms  # Debounce
      - delayed_off: 50ms

    # Button press actions
    on_press:
      - if:
          condition:
            switch.is_off: use_wake_word
          then:
            # Push-to-talk mode: start listening
            - voice_assistant.start:
          else:
            # Wake word active: manual trigger (bypass wake word)
            - voice_assistant.start:

    on_release:
      - if:
          condition:
            switch.is_off: use_wake_word
          then:
            # Push-to-talk mode: stop listening on release
            - voice_assistant.stop:

    # Long press (3 seconds) to toggle wake word
    on_click:
      - min_length: 3000ms
        max_length: 10000ms
        then:
          - switch.toggle: use_wake_word
          - if:
              condition:
                switch.is_on: use_wake_word
              then:
                - light.turn_on:
                    id: led_ring
                    effect: "Connected"
                    brightness: 50%
                - delay: 1s
                - light.turn_off: led_ring
              else:
                - light.turn_on:
                    id: led_ring
                    effect: "Disconnected"
                    brightness: 50%
                - delay: 1s
                - light.turn_off: led_ring

# Wake Word Toggle Switch
switch:
  - platform: template
    name: "Use Wake Word"
    id: use_wake_word
    optimistic: true
    restore_mode: RESTORE_DEFAULT_ON
    on_turn_on:
      - voice_assistant.start_continuous:
      - light.turn_on:
          id: led_ring
          effect: "Connected"
          brightness: 30%
      - delay: 1s
      - light.turn_off: led_ring
    on_turn_off:
      - voice_assistant.stop:
      - light.turn_on:
          id: led_ring
          effect: "Disconnected"
          brightness: 30%
      - delay: 1s
      - light.turn_off: led_ring

# Mute Switch (disables microphone)
  - platform: template
    name: "Mute Microphone"
    id: mute_mic
    optimistic: true
    restore_mode: RESTORE_DEFAULT_OFF
    on_turn_on:
      - voice_assistant.stop:
      - light.turn_on:
          id: led_ring
          red: 100%
          green: 0%
          blue: 0%
          brightness: 20%
    on_turn_off:
      - if:
          condition:
            switch.is_on: use_wake_word
          then:
            - voice_assistant.start_continuous:
      - light.turn_off: led_ring

# Sensors
sensor:
  - platform: wifi_signal
    name: "WiFi Signal"
    update_interval: 60s

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

## Step-by-Step Build Guide

### Step 1: Hardware Assembly

**Wiring Order:**

1. **Power Rails (Breadboard):**
   - Connect ESP32-S3 **5V** to breadboard + rail (red)
   - Connect ESP32-S3 **GND** to breadboard - rail (black)
   - Connect ESP32-S3 **3.3V** to a separate breadboard rail (for microphone)

2. **NeoPixel Ring:**
   - Ring **5V** → breadboard + rail (5V)
   - Ring **GND** → breadboard - rail (GND)
   - Ring **DIN** → 470Ω resistor → ESP32-S3 **GPIO8**
   - **1000μF capacitor** across 5V and GND rails (+ to 5V, - to GND)

3. **Microphone (INMP441):**
   - **VDD** → 3.3V rail
   - **GND** → GND rail
   - **SD** → ESP32-S3 **GPIO4**
   - **WS** → ESP32-S3 **GPIO5**
   - **SCK** → ESP32-S3 **GPIO6**
   - **L/R** → GND (left channel)

4. **Speaker Amplifier (MAX98357A):**
   - **VIN** → 5V rail
   - **GND** → GND rail
   - **DIN** → ESP32-S3 **GPIO7**
   - **BCLK** → ESP32-S3 **GPIO6** (shared with mic)
   - **LRC** → ESP32-S3 **GPIO5** (shared with mic)
   - **SD** → 3.3V (enable amplifier)
   - **GAIN** → GND (9dB default)
   - **+ / -** → Speaker terminals

5. **Push Button:**
   - One side → ESP32-S3 **GPIO9**
   - Other side → GND

**Double-Check:**
- ✅ NeoPixel ring and speaker amp powered by 5V
- ✅ Microphone powered by 3.3V
- ✅ 1000μF capacitor across NeoPixel power (prevents voltage spikes)
- ✅ BCLK and WS shared between mic and speaker
- ✅ Separate data lines (GPIO4 for mic, GPIO7 for speaker)

### Step 2: Test LED Ring

**Create minimal test config:** `led-ring-test.yaml`
```yaml
esphome:
  name: led-ring-test

esp32:
  board: esp32-s3-devkitc-1

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
    pin: GPIO8
    num_leds: 12
    name: "Test Ring"
```

**Test procedure:**
1. Flash via USB
2. Turn on light in Home Assistant
3. **Expected:** All 12 LEDs light up white
4. Try different colors (red, green, blue)
5. Verify all LEDs work (no dead pixels)

**If LEDs don't light:**
- Check 5V power to ring
- Verify GND connection
- Test DIN connection (GPIO8 → 470Ω → DIN)
- Check capacitor polarity (+ to 5V, - to GND)

### Step 3: Test Audio (Microphone + Speaker)

**Add audio to test config:**
```yaml
i2s_audio:
  - id: i2s_bus
    i2s_lrclk_pin: GPIO5
    i2s_bclk_pin: GPIO6

microphone:
  - platform: i2s_audio
    id: mic
    i2s_audio_id: i2s_bus
    i2s_din_pin: GPIO4
    adc_type: external
    pdm: false
    channel: left

speaker:
  - platform: i2s_audio
    id: spk
    i2s_audio_id: i2s_bus
    i2s_dout_pin: GPIO7
    dac_type: external

voice_assistant:
  microphone: mic
  speaker: spk
```

**Test procedure:**
1. Flash updated config
2. In Home Assistant: Go to voice assistant settings
3. Speak into microphone: "What time is it?"
4. **Expected:** Speaker plays response

**If no audio input:**
- Check microphone wiring (SD, WS, SCK)
- Verify L/R pin connected to GND
- Monitor logs for audio level indicators

**If no audio output:**
- Check speaker amp wiring (DIN, BCLK, LRC)
- Verify SD pin connected to 3.3V (enables amp)
- Test speaker polarity (swap + and - if distorted)

### Step 4: Test Push Button

**Add button handler:**
```yaml
binary_sensor:
  - platform: gpio
    pin:
      number: GPIO9
      inverted: true
      mode:
        input: true
        pullup: true
    name: "Test Button"
    on_press:
      - logger.log: "Button pressed!"
```

**Test procedure:**
1. Flash config
2. Press button
3. **Expected:** Log message appears
4. If no response: check wiring, verify pull-up enabled

### Step 5: Configure Home Assistant Voice Pipeline

**In Home Assistant:**

1. **Settings → Voice Assistants → Add Assistant**
2. Configure:
   - **Name:** "Voice Satellite Ring"
   - **Conversation Agent:** Home Assistant
   - **Speech-to-Text:** Whisper (faster-whisper)
   - **Text-to-Speech:** Piper (en_US-amy-medium)
   - **Wake Word:** OpenWakeWord (ok_nabu)
3. **Save**

**Assign to Device:**
1. **Settings → Devices → voice-satellite-ring**
2. **Configure → Voice Assistant**
3. Select "Voice Satellite Ring" pipeline
4. **Save**

### Step 6: Flash Complete Configuration and Test

1. Flash `voice-satellite-ring.yaml`
2. Power on device
3. **Expected boot sequence:**
   - LEDs animate (boot animation)
   - LEDs turn off
   - Device connects to WiFi and Home Assistant

**Test wake word:**
1. Say "OK Nabu"
2. **Expected:**
   - Green flash (wake word detected)
   - Blue pulsing ring (listening)
   - Speak command: "Turn on living room lights"
   - Orange dots (processing)
   - Cyan wave (speaking response)
   - LEDs turn off

**Test push-to-talk:**
1. Turn off wake word: `switch.use_wake_word` → OFF in HA
2. Press and hold button
3. **Expected:** Blue pulsing (listening)
4. Speak command while holding
5. Release button
6. **Expected:** Processing and response

### Step 7: Enclosure Design (Optional)

**3D Printable Enclosure:**

**Design requirements:**
- **LED ring visible:** Clear/translucent top or ring cutout
- **Speaker facing forward:** 45-50mm circular opening
- **Microphone access:** Small holes for sound input (top surface)
- **Button access:** Recessed tactile button on top or side
- **Cable management:** Rear USB-C opening for power
- **Ventilation:** Small slots for speaker amp heat dissipation

**Recommended dimensions:**
- **Diameter:** 80-100mm (fits 44mm LED ring with margin)
- **Height:** 60-80mm (speaker depth + ESP32 clearance)
- **Material:** PLA or PETG (PETG for better heat resistance)

**Assembly:**
- Mount ESP32 on standoffs inside base
- Mount speaker facing forward opening
- Mount LED ring in top recess (diffused with frosted acrylic)
- Route microphone to top (facing upward)
- Button extends through top plate

---

## LED Animation Customization

### Custom Color Schemes

**Change listening color (blue → purple):**
```yaml
- addressable_lambda:
    name: "Listening Pulse"
    update_interval: 50ms
    lambda: |-
      static uint8_t brightness = 0;
      static int8_t direction = 1;

      brightness += direction * 5;
      if (brightness >= 255 || brightness <= 50) {
        direction = -direction;
      }

      // Purple pulsing ring
      auto color = Color(brightness, 0, brightness);  // R + B = Purple
      it.all() = color;
```

### Progress Bar Effect

**Show processing progress (0-100%):**
```yaml
- addressable_lambda:
    name: "Progress Bar"
    update_interval: 100ms
    lambda: |-
      static int progress = 0;
      progress = (progress + 1) % (it.size() + 1);

      it.all() = Color(0, 0, 0);  // Clear
      for (int i = 0; i < progress; i++) {
        it[i] = Color(0, 255, 0);  // Green progress
      }
```

### VU Meter (Audio Level Visualization)

**Show microphone input level:**
```yaml
sensor:
  - platform: template
    name: "Audio Level"
    id: audio_level
    # Note: Requires custom component to read mic amplitude

- addressable_lambda:
    name: "VU Meter"
    update_interval: 50ms
    lambda: |-
      float level = id(audio_level).state;  // 0.0 to 1.0
      int lit_leds = (int)(level * it.size());

      it.all() = Color(0, 0, 0);  // Clear
      for (int i = 0; i < lit_leds; i++) {
        // Green → Yellow → Red gradient
        uint8_t red = (i * 255) / it.size();
        uint8_t green = 255 - red;
        it[i] = Color(red, green, 0);
      }
```

---

## Troubleshooting

### LED Ring Issues

**Problem: LEDs show wrong colors (red displays as green)**

**Fix:**
- Change `type: GRB` to `type: RGB` in YAML
- Common variants: GRB, RGB, BRG (WS2812B typically uses GRB)

**Problem: First few LEDs work, rest are off**

**Fix:**
- Data corruption: Add level shifter (3.3V → 5V)
- Increase data line resistor: 470Ω → 1kΩ
- Check DIN connection integrity

**Problem: LEDs flicker or show random colors**

**Fix:**
- Insufficient power: Upgrade to 5V 3A supply
- Add larger capacitor: 1000μF → 2200μF
- Shorter wires from power supply to LEDs (<20cm)

### Audio Issues

**Problem: Microphone not detecting voice**

**Fix:**
- Check L/R pin: Should be GND for left channel
- Verify `channel: left` in YAML matches hardware
- Increase `auto_gain:` value (try 35dBFS)

**Problem: Speaker output distorted or quiet**

**Fix:**
- Increase `volume_multiplier:` (try 3.0 or 4.0)
- Change GAIN pin: GND → 3.3V (12dB gain)
- Check speaker impedance (4Ω recommended, 8Ω is quieter)

**Problem: Audio cuts out or stutters**

**Fix:**
- WiFi interference: Use 5 GHz band if available
- Lower `update_interval` on LED effects (100ms → 200ms)
- Reduce LED brightness (<50% during voice activity)

### Wake Word Issues

**Problem: Wake word not detected**

**Fix:**
- Verify Wyoming OpenWakeWord running: `docker logs wyoming-openwakeword`
- Test microphone with button (bypass wake word)
- Speak louder and closer (within 2 meters)
- Try different wake word model in HA pipeline settings

**Problem: False wake word triggers**

**Fix:**
- Increase wake word threshold in Wyoming settings
- Enable `noise_suppression_level: 3` or `4`
- Move device away from TV/radio noise sources

### Button Issues

**Problem: Button presses not detected**

**Fix:**
- Check `inverted: true` in pin config
- Verify `pullup: true` enabled
- Test button continuity with multimeter
- Add debounce filter: `delayed_on: 100ms`

**Problem: Button triggers multiple times per press**

**Fix:**
- Increase debounce delay: `delayed_on: 100ms`
- Check button quality (cheap tactile switches bounce more)
- Replace with better quality switch

---

## Advanced Features

### Multi-Click Button Actions

**Single click, double click, long press:**
```yaml
binary_sensor:
  - platform: gpio
    pin:
      number: GPIO9
      inverted: true
      mode:
        input: true
        pullup: true
    name: "Smart Button"
    on_multi_click:
      # Single click: Manual trigger
      - timing:
          - ON for at most 500ms
          - OFF for at least 100ms
        then:
          - voice_assistant.start:

      # Double click: Toggle wake word
      - timing:
          - ON for at most 500ms
          - OFF for at most 300ms
          - ON for at most 500ms
          - OFF for at least 100ms
        then:
          - switch.toggle: use_wake_word

      # Long press (3s): Mute/unmute
      - timing:
          - ON for at least 3000ms
        then:
          - switch.toggle: mute_mic
```

### Volume Control via Rotary Encoder

**Add rotary encoder for speaker volume:**
```yaml
sensor:
  - platform: rotary_encoder
    name: "Volume Encoder"
    id: volume_encoder
    pin_a:
      number: GPIO10
      mode:
        input: true
        pullup: true
    pin_b:
      number: GPIO11
      mode:
        input: true
        pullup: true
    on_clockwise:
      - lambda: |-
          float vol = id(va).get_volume_multiplier();
          id(va).set_volume_multiplier(vol + 0.1);
    on_anticlockwise:
      - lambda: |-
          float vol = id(va).get_volume_multiplier();
          id(va).set_volume_multiplier(max(0.1f, vol - 0.1));
```

### Privacy LED (Hardware Mute Indicator)

**Add red LED that lights when muted:**
```yaml
output:
  - platform: gpio
    pin: GPIO12
    id: privacy_led_output

light:
  - platform: binary
    output: privacy_led_output
    name: "Privacy LED"
    id: privacy_led

switch:
  - platform: template
    name: "Mute Microphone"
    id: mute_mic
    on_turn_on:
      - light.turn_on: privacy_led  # Red LED on
      - light.turn_on:
          id: led_ring
          red: 100%
          green: 0%
          blue: 0%
          brightness: 20%
    on_turn_off:
      - light.turn_off: privacy_led  # Red LED off
      - light.turn_off: led_ring
```

### Time-Based LED Brightness

**Dim LEDs at night (after 10 PM):**
```yaml
time:
  - platform: homeassistant
    id: homeassistant_time

# Modify LED turn_on calls:
on_listening:
  - light.turn_on:
      id: led_ring
      effect: "Listening Pulse"
      brightness: !lambda |-
        auto time = id(homeassistant_time).now();
        if (time.hour >= 22 || time.hour < 7) {
          return 30;  // 30% brightness at night
        } else {
          return 100;  // 100% brightness during day
        }
```

---

## What You've Learned

By completing this project, you now understand:

✅ **NeoPixel LED Control:**
- Addressable LED ring wiring and power management
- Custom animations and effects
- Synchronized visual feedback with voice events

✅ **I2S Audio System:**
- Shared I2S bus architecture (microphone + speaker)
- Digital audio advantages over analog
- Speaker amplification and impedance matching

✅ **Wyoming Voice Pipeline:**
- Integration with Home Assistant voice services
- Wake word detection (cloud and on-device)
- Speech-to-text and text-to-speech flow

✅ **Button Input Handling:**
- Pull-up resistors and debouncing
- Multi-click detection
- Push-to-talk vs always-listening modes

✅ **State Machine Design:**
- Event-driven programming
- Visual feedback for user experience
- Error handling and recovery

✅ **Enclosure Design:**
- Acoustic considerations for microphone and speaker
- LED diffusion and visibility
- Thermal management for electronics

**You've built a professional-grade voice assistant satellite comparable to commercial products!** 🎉

**Next Steps:**
- Design and 3D print a custom enclosure
- Add multiple satellites throughout your home
- Integrate with complex Home Assistant automations
- Experiment with custom wake words
- Build a multi-room voice assistant network

---

## Comparison with M5Stack Atom Echo

| Feature | This Project | M5Stack Atom Echo |
|---------|-------------|-------------------|
| **LED Feedback** | 12 LED ring (360° visibility) | 1 LED (limited visibility) |
| **Visual Effects** | Custom animations, progress bars | Single color only |
| **Speaker Quality** | 3W external speaker (rich sound) | 0.5W internal (tinny) |
| **Microphone** | INMP441 (61dB SNR) | SPM1423 PDM (similar quality) |
| **Button** | Accessible tactile switch | Top button (requires assembly) |
| **Cost** | $40-70 DIY | $25-35 pre-made |
| **Customization** | Full control (PCB, enclosure) | Limited (fixed form factor) |
| **Expandability** | Add sensors, displays, etc. | Minimal GPIO available |

**When to use M5Stack Atom Echo:**
- Quick deployment (no soldering)
- Compact footprint required
- Budget-conscious

**When to use this project:**
- Professional appearance desired
- Better audio quality needed
- Learning experience valued
- Custom enclosure/features required

Happy building! 🚀
