# Project 10: Voice-Controlled Device (Custom Voice Assistant)

**Difficulty:** Advanced
**Estimated Time:** 6-10 hours
**Cost:** $30-50

## Learning Objectives

By completing this project, you will learn:
- I2S audio protocol (high-quality digital audio)
- Wyoming protocol integration (Home Assistant voice pipeline)
- Microphone and speaker interfacing
- Wake word detection (on-device and cloud)
- Audio amplification and filtering
- Voice assistant pipeline (STT, intent processing, TTS)
- Real-time audio streaming
- Acoustic echo cancellation (AEC)

---

## Parts List

| Part | Quantity | Approximate Cost (CAD) | Notes |
|------|----------|------------------------|-------|
| ESP32-S3 Development Board | 1 | $15-20 | Must be ESP32-S3 (has I2S support) |
| INMP441 I2S Microphone | 1 | $5-8 | MEMS microphone, digital output |
| MAX98357A I2S Amplifier | 1 | $5-8 | 3W Class D amplifier |
| Speaker (4Ω, 3W) | 1 | $5-10 | 2-3" diameter, 4-8Ω impedance |
| WS2812B RGB LED | 1-5 | $2-5 | Visual feedback (optional) |
| Push Button | 1 | $0.50 | Manual trigger (optional) |
| Breadboard | 1 | Reuse | 400-point or larger |
| Jumper Wires | 15-20 | Reuse | Male-to-male |

**Total Cost:** ~$30-50

**Why ESP32-S3?**
- **Dual-core:** 240 MHz (better than ESP32 for audio processing)
- **More RAM:** 512 KB SRAM (vs 520 KB ESP32, but faster)
- **Better I2S:** Dedicated I2S peripherals (less glitches)
- **USB-C:** Native USB support (easier debugging)

**Alternative: M5Stack Atom Echo ($25-35 CAD)**
- All-in-one: ESP32 + mic + speaker + LED in compact case
- Reference your existing `living-room-voice.yaml` and `office-voice.yaml`
- This guide focuses on DIY build, but concepts are the same

---

## Understanding the Parts

### I2S Audio Protocol

**I2S = Inter-IC Sound**

A synchronous serial bus for digital audio:
- **3 wires:** BCLK (bit clock), LRC/WS (word select), DIN/DOUT (data)
- **High quality:** 16-bit to 32-bit samples, 8 kHz to 192 kHz sample rate
- **No analog conversion needed:** Digital microphone → digital speaker amp

**Advantages over analog:**
- No ADC noise (analog-to-digital conversion noise)
- No ground loops or interference
- Longer cable runs (digital signals more robust)
- Better dynamic range

**I2S Signals:**
```
BCLK (Bit Clock):     ___┐‾‾‾┐___┐‾‾‾┐___   (clocks each bit)
WS (Word Select):     ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾____   (left/right channel)
DIN/DOUT (Data):      ‾‾‾‾____‾‾‾‾____‾‾‾   (audio samples)
```

**Typical Settings:**
- **Sample rate:** 16 kHz (voice), 44.1 kHz (music), 48 kHz (professional)
- **Bit depth:** 16-bit (standard), 24-bit (high quality), 32-bit (professional)
- **Channels:** Mono (voice assistant), Stereo (music playback)

### INMP441 Microphone

**Specifications:**
- **Type:** MEMS (Micro-Electro-Mechanical Systems) digital microphone
- **Output:** I2S digital audio (no ADC needed!)
- **Frequency:** 60 Hz - 15 kHz (optimized for human voice)
- **SNR (Signal-to-Noise Ratio):** 61 dB (good for voice)
- **Sensitivity:** -26 dBFS (loud enough for normal speech)
- **Power:** 3.3V, ~1.4 mA

**Pinout:**
| Pin | Function | ESP32-S3 Connection |
|-----|----------|---------------------|
| VDD | Power (3.3V) | 3.3V |
| GND | Ground | GND |
| SD (Serial Data) | I2S data output | GPIO4 (I2S_DIN) |
| WS (Word Select) | Left/Right channel | GPIO5 (I2S_WS) |
| SCK (Serial Clock) | Bit clock | GPIO6 (I2S_BCLK) |
| L/R | Channel select | GND (left) or 3.3V (right) |

**L/R Pin:**
- **GND** → Left channel (microphone sends data on left)
- **3.3V** → Right channel (microphone sends data on right)
- Most configs use **GND** (left channel)

### MAX98357A I2S Amplifier

**Specifications:**
- **Type:** Class D amplifier (digital, efficient)
- **Power:** 3W output @ 5V (90% efficiency)
- **Input:** I2S digital audio
- **Output:** Speaker (4Ω, 8Ω compatible)
- **SNR:** 92 dB (very clean audio)
- **Gain:** 3 dB, 6 dB, 9 dB, 12 dB, 15 dB (selectable via jumper/pin)

**Pinout:**
| Pin | Function | ESP32-S3 Connection |
|-----|----------|---------------------|
| VIN | Power (5V) | 5V |
| GND | Ground | GND |
| DIN | I2S data input | GPIO7 (I2S_DOUT) |
| BCLK | Bit clock | GPIO6 (I2S_BCLK, shared with mic) |
| LRC | Left/Right clock | GPIO5 (I2S_WS, shared with mic) |
| SD (Shutdown) | Enable/disable | 3.3V (always on) or GPIO (controllable) |
| GAIN | Gain select | GND (9 dB default) |
| + / - | Speaker output | Speaker terminals |

**Class D Amplifier:**
- **Efficient:** 90% power efficiency (vs 50-60% for analog amps)
- **Cool:** Minimal heat generation
- **Switching:** Uses PWM to drive speaker (not linear amplification)
- **Filter:** Built-in LC filter for smooth audio

**Gain Setting:**
| GAIN Pin | Gain (dB) | Volume Level |
|----------|-----------|--------------|
| GND | 9 dB | Default (recommended) |
| 3.3V | 12 dB | Louder |
| 100kΩ to GND | 15 dB | Maximum |

### Wyoming Protocol

**What is Wyoming?**
- Communication protocol for Home Assistant voice pipeline
- Connects voice satellites (ESP32) to voice services (Whisper, Piper, OpenWakeWord)
- Uses streaming audio over TCP

**Voice Pipeline Flow:**
```
ESP32 Voice Satellite
    ↓
1. Wake word detected (on-device or via OpenWakeWord)
    ↓
2. Audio streaming to Home Assistant
    ↓
3. HA forwards to Wyoming Whisper (speech-to-text)
    ↓
4. HA processes intent ("turn on living room lights")
    ↓
5. HA generates response text ("OK, turning on the lights")
    ↓
6. HA forwards to Wyoming Piper (text-to-speech)
    ↓
7. Audio streamed back to ESP32
    ↓
8. ESP32 plays response through speaker
```

**Wyoming Services (in your setup):**
- **Wyoming Whisper** (192.168.40.201:10300) - Speech-to-text
- **Wyoming Piper** (192.168.40.201:10200) - Text-to-speech
- **Wyoming OpenWakeWord** (192.168.40.201:10400) - Wake word detection

### Wake Word Detection

**What is a wake word?**
- Trigger phrase to activate voice assistant
- Examples: "OK Nabu", "Alexa", "Hey Google", "Hey Jarvis"
- Always listening, but only processes after wake word

**Detection Methods:**

**1. On-Device (ESP32):**
- **Pros:** No network needed, instant response, privacy
- **Cons:** Limited accuracy, CPU intensive, fewer wake word options
- **Implementation:** ESPHome `micro_wake_word` platform

**2. Cloud (Wyoming OpenWakeWord):**
- **Pros:** Better accuracy, more wake word models, less CPU load on ESP32
- **Cons:** Requires network, slight delay
- **Implementation:** ESPHome `voice_assistant` with Wyoming integration

**Available Wake Words:**
- **ok_nabu** - Default (used in your M5Stack configs)
- **hey_jarvis** - Iron Man inspired
- **alexa** - Amazon-style
- **hey_mycroft** - Mycroft AI style
- **Custom:** Train your own with OpenWakeWord

---

## Wiring Diagram

### Complete Audio System

```
ESP32-S3 Board          INMP441 Mic         MAX98357A Amp        Speaker

          Microphone I2S Bus
GPIO4 (DIN) <--------- SD (Data Out)
GPIO5 (WS)  <--------- WS
GPIO6 (BCLK)<--------- SCK
3.3V ----------------> VDD
GND -----------------> GND
                       L/R --> GND

          Speaker I2S Bus
GPIO7 (DOUT)---------> DIN
GPIO5 (WS) ----------> LRC (shared with mic)
GPIO6 (BCLK)---------> BCLK (shared with mic)
5V ------------------> VIN
GND -----------------> GND
                       SD --> 3.3V (always on)
                       GAIN --> GND (9dB)
                       + --> Speaker (+)
                       - --> Speaker (-)

          Optional: LED Indicator
GPIO8 ---------------> WS2812B DIN
3.3V ----------------> WS2812B VCC
GND -----------------> WS2812B GND

          Optional: Manual Button
GPIO9 ---------------> Button --> GND (with internal pull-up)
```

### Pin Connections Table

| ESP32-S3 Pin | INMP441 | MAX98357A | WS2812B LED | Button |
|--------------|---------|-----------|-------------|--------|
| GPIO4 | SD | - | - | - |
| GPIO5 | WS | LRC | - | - |
| GPIO6 | SCK | BCLK | - | - |
| GPIO7 | - | DIN | - | - |
| GPIO8 | - | - | DIN | - |
| GPIO9 | - | - | - | Button → GND |
| 3.3V | VDD | SD (enable) | VCC | - |
| 5V | - | VIN | - | - |
| GND | GND, L/R | GND, GAIN | GND | Button (other side) |

**Important Notes:**
- **Shared pins:** BCLK (GPIO6) and WS (GPIO5) shared between mic and speaker
- **Separate data:** Microphone DIN (GPIO4), Speaker DOUT (GPIO7)
- **Power:** Microphone uses 3.3V, speaker amp uses 5V
- **Button:** Uses internal pull-up (no external resistor needed)

---

## ESPHome Configuration

Create a new file: `/home/hazzard/home-assistant/esphome/custom-voice-assistant.yaml`

### Complete Configuration

```yaml
esphome:
  name: custom-voice-assistant
  friendly_name: "Custom Voice Assistant"
  platformio_options:
    board_build.flash_mode: dio
  on_boot:
    - priority: -100
      then:
        - wait_until: api.connected
        - delay: 1s
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
    static_ip: 192.168.40.165
    gateway: 192.168.40.1
    subnet: 255.255.255.0
    dns1: 8.8.8.8

  ap:
    ssid: "Voice-Assistant-FB"
    password: "12345678"

logger:

api:
  encryption:
    key: !secret api_key_voice_assistant

ota:
  - platform: esphome
    password: !secret ota_password

# I2S Audio Configuration
i2s_audio:
  - id: i2s_audio_bus
    i2s_lrclk_pin: GPIO5   # WS (Word Select) - shared
    i2s_bclk_pin: GPIO6    # BCLK (Bit Clock) - shared

# Microphone
microphone:
  - platform: i2s_audio
    id: external_microphone
    i2s_audio_id: i2s_audio_bus
    i2s_din_pin: GPIO4     # Microphone data output
    adc_type: external
    pdm: false             # Not PDM, standard I2S

# Speaker
speaker:
  - platform: i2s_audio
    id: external_speaker
    i2s_audio_id: i2s_audio_bus
    i2s_dout_pin: GPIO7    # Speaker data input
    dac_type: external

# Voice Assistant
voice_assistant:
  id: va
  microphone: external_microphone
  speaker: external_speaker

  # Use Wyoming services from Home Assistant
  noise_suppression_level: 2
  auto_gain: 31dBFS
  volume_multiplier: 2.0

  # Callbacks for events
  on_listening:
    - light.turn_on:
        id: status_led
        blue: 100%
        red: 0%
        green: 0%
        brightness: 50%
        effect: pulse

  on_stt_vad_end:
    - light.turn_on:
        id: status_led
        blue: 0%
        red: 0%
        green: 100%
        brightness: 50%
        effect: pulse

  on_tts_stream_start:
    - light.turn_on:
        id: status_led
        blue: 0%
        red: 100%
        green: 0%
        brightness: 50%

  on_tts_stream_end:
    - light.turn_off: status_led

  on_error:
    - light.turn_on:
        id: status_led
        red: 100%
        green: 0%
        blue: 0%
        brightness: 100%
        effect: fast_pulse
    - delay: 2s
    - light.turn_off: status_led

  on_idle:
    - light.turn_off: status_led

# LED Status Indicator
light:
  - platform: neopixelbus
    type: GRB
    variant: WS2812
    pin: GPIO8
    num_leds: 1
    name: "Status LED"
    id: status_led
    effects:
      - pulse:
          name: "pulse"
          transition_length: 0.5s
          update_interval: 0.5s
      - pulse:
          name: "fast_pulse"
          transition_length: 0.25s
          update_interval: 0.25s

# Wake Word Switch (Enable/Disable)
switch:
  - platform: template
    name: "Use Wake Word"
    id: use_wake_word
    optimistic: true
    restore_mode: RESTORE_DEFAULT_ON
    on_turn_on:
      - voice_assistant.start_continuous:
    on_turn_off:
      - voice_assistant.stop:

# Manual Trigger Button
binary_sensor:
  - platform: gpio
    pin:
      number: GPIO9
      inverted: true
      mode:
        input: true
        pullup: true
    name: "Assist Button"
    on_press:
      - if:
          condition:
            switch.is_off: use_wake_word
          then:
            - voice_assistant.start:
          else:
            - voice_assistant.stop:
            - delay: 1s
            - voice_assistant.start_continuous:

# Device Info
text_sensor:
  - platform: wifi_info
    ip_address:
      name: "IP Address"

sensor:
  - platform: wifi_signal
    name: "WiFi Signal"
    update_interval: 60s

button:
  - platform: restart
    name: "Restart Device"
```

---

## Understanding the Code

### I2S Audio Bus Configuration

```yaml
i2s_audio:
  - id: i2s_audio_bus
    i2s_lrclk_pin: GPIO5   # WS (Word Select)
    i2s_bclk_pin: GPIO6    # BCLK (Bit Clock)
```

**Why shared bus?**
- Microphone and speaker use same clock signals (BCLK, WS)
- Only data pins differ (DIN vs DOUT)
- Saves GPIO pins and ensures synchronization

**I2S Timing:**
- **Sample Rate:** 16 kHz (voice optimized, lower bandwidth)
- **Bit Depth:** 16-bit (sufficient for voice, not music)
- **Channels:** Mono (voice assistants don't need stereo)

### Microphone Configuration

```yaml
microphone:
  - platform: i2s_audio
    id: external_microphone
    i2s_din_pin: GPIO4     # Data input (from microphone)
    adc_type: external     # Digital microphone (not internal ADC)
    pdm: false             # Standard I2S (not PDM protocol)
```

**PDM vs I2S:**
- **PDM (Pulse Density Modulation):** Single data line, simpler (M5Stack Atom Echo uses this)
- **I2S (Inter-IC Sound):** Separate BCLK + WS, more robust (INMP441 uses this)

### Voice Assistant Configuration

```yaml
voice_assistant:
  noise_suppression_level: 2      # 0 (off) to 4 (max)
  auto_gain: 31dBFS               # Automatic gain control target
  volume_multiplier: 2.0          # Speaker output volume (1.0 = normal)
```

**Noise Suppression:**
- **Level 0:** Off (lowest CPU, raw audio)
- **Level 1-2:** Light (removes background hum, fans)
- **Level 3-4:** Aggressive (removes more noise, may affect voice quality)
- **Recommendation:** Start with 2, increase if noisy environment

**Auto Gain (AGC):**
- **31 dBFS:** Target loudness (decibels relative to full scale)
- **Lower values:** Quieter (e.g., 25 dBFS)
- **Higher values:** Louder, but may clip (distort)
- **Purpose:** Normalizes loud/quiet speakers automatically

**Volume Multiplier:**
- **1.0:** Normal speaker volume
- **2.0:** 2× louder (may distort if speaker underpowered)
- **0.5:** Half volume (quieter)
- **Adjust based on speaker specs**

### Event Callbacks (LED Feedback)

**Listening (Blue Pulse):**
```yaml
on_listening:
  - light.turn_on:
      id: status_led
      blue: 100%
      red: 0%
      green: 0%
      effect: pulse
```
- Triggered when wake word detected
- User speaks command while blue pulsing

**Processing (Green Pulse):**
```yaml
on_stt_vad_end:  # STT = Speech-to-Text, VAD = Voice Activity Detection
  - light.turn_on:
      id: status_led
      green: 100%
```
- Triggered when speech ends (silence detected)
- HA processing command

**Speaking (Red Solid):**
```yaml
on_tts_stream_start:  # TTS = Text-to-Speech
  - light.turn_on:
      id: status_led
      red: 100%
```
- Assistant responding with voice

**Error (Red Fast Pulse):**
```yaml
on_error:
  - light.turn_on:
      id: status_led
      red: 100%
      effect: fast_pulse
```
- Network error, intent not understood, or service failure

---

## Step-by-Step Build Guide

### Step 1: Hardware Assembly

**Wiring Order:**

1. **Power Rails:**
   - Breadboard + rail → ESP32-S3 **3.3V**
   - Breadboard - rail → ESP32-S3 **GND**

2. **Microphone (INMP441):**
   - **VDD** → 3.3V
   - **GND** → GND
   - **SD** → ESP32-S3 **GPIO4**
   - **WS** → ESP32-S3 **GPIO5**
   - **SCK** → ESP32-S3 **GPIO6**
   - **L/R** → GND (left channel)

3. **Speaker Amplifier (MAX98357A):**
   - **VIN** → 5V (from ESP32-S3 or external supply)
   - **GND** → GND
   - **DIN** → ESP32-S3 **GPIO7**
   - **BCLK** → ESP32-S3 **GPIO6** (shared with mic)
   - **LRC** → ESP32-S3 **GPIO5** (shared with mic)
   - **SD** → 3.3V (enable amplifier)
   - **GAIN** → GND (9 dB default)
   - **+ / -** → Speaker terminals

4. **Status LED (optional):**
   - **DIN** → ESP32-S3 **GPIO8**
   - **VCC** → 3.3V
   - **GND** → GND

5. **Button (optional):**
   - One side → ESP32-S3 **GPIO9**
   - Other side → GND

**Double-Check:**
- ✅ Microphone powered by 3.3V (not 5V!)
- ✅ Speaker amp powered by 5V
- ✅ BCLK and WS shared between mic and amp
- ✅ DIN (mic) and DOUT (speaker) on separate pins

### Step 2: Test Microphone (Audio Input)

**Create test config:** `mic-test.yaml`
```yaml
esphome:
  name: mic-test
  platformio_options:
    board_build.flash_mode: dio

esp32:
  board: esp32-s3-devkitc-1
  framework:
    type: esp-idf

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password

logger:
  level: DEBUG

api:
ota:

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

# Test: Stream audio to log
voice_assistant:
  microphone: mic
  on_listening:
    - logger.log: "Microphone is working!"
```

**Flash and test:**
1. Flash via USB
2. Monitor logs: `docker exec -it esphome esphome logs /config/mic-test.yaml`
3. Speak into microphone
4. **Expected:** Log shows audio level changes (dB values)

**If no audio detected:**
- Check wiring (SD, WS, SCK)
- Verify L/R pin connected to GND
- Try swapping WS and SCK pins (easy mistake)

### Step 3: Test Speaker (Audio Output)

**Add speaker to test config:**
```yaml
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

**Test with Home Assistant:**
1. Flash updated config
2. Add device in HA: **Settings → Integrations → ESPHome**
3. Go to **Settings → Voice Assistants → Wyoming Pipeline**
4. Speak: "What time is it?"
5. **Expected:** Assistant responds through speaker

**If no sound:**
- Check amp wiring (DIN, BCLK, LRC)
- Verify SD pin connected to 3.3V (enable amp)
- Verify speaker polarity (+ and - connected correctly)
- Increase `volume_multiplier: 3.0` in YAML

### Step 4: Configure Home Assistant Voice Pipeline

**In Home Assistant:**

1. **Settings → Voice Assistants → Add Assistant**
2. **Name:** "Custom Voice Assistant"
3. **Conversation Agent:** Home Assistant
4. **Speech-to-Text:** Whisper (faster-whisper)
5. **Text-to-Speech:** Piper (en_US-amy-medium)
6. **Wake Word:** OpenWakeWord (ok_nabu)
7. **Save**

**Assign to Device:**
1. **Settings → Devices → custom-voice-assistant**
2. **Configure → Voice Assistant**
3. Select "Custom Voice Assistant" pipeline
4. **Save**

### Step 5: Flash Full Configuration and Test

1. Flash `custom-voice-assistant.yaml`
2. Enable wake word switch in HA: `switch.use_wake_word` → ON
3. Say "OK Nabu" into microphone
4. **Expected:** Blue LED lights up (listening)
5. Say command: "What time is it?"
6. **Expected:** Green LED (processing) → Red LED (speaking) → Response plays

---

## Troubleshooting

### Wake Word Not Detected

**Cause:** Microphone not picking up audio or wake word model not loaded

**Fix:**
1. **Test microphone:** Manually trigger with button (should bypass wake word)
2. **Check Wyoming OpenWakeWord:** Verify running on port 10400
   ```bash
   docker logs wyoming-openwakeword
   ```
3. **Increase microphone sensitivity:** Add to YAML:
   ```yaml
   microphone:
     - platform: i2s_audio
       id: external_microphone
       # ... other settings ...
       on_data:
         - lambda: |-
             ESP_LOGD("mic", "Audio level: %d", (int)x.data[0]);
   ```
4. **Check distance:** Speak within 1-2 meters of microphone
5. **Try different wake word:** Change in HA pipeline settings

### Audio Garbled or Distorted

**Cause:** I2S timing issues or power supply problems

**Fix:**
1. **Lower volume multiplier:** `volume_multiplier: 1.0`
2. **Check power supply:** Speaker amp needs 5V @ 2A+ (USB may not be enough)
3. **Shorter wires:** Use jumpers < 15cm for I2S signals
4. **Add pull-up/down resistors:** 10kΩ on BCLK and WS lines
5. **Try different sample rate:** Add to `i2s_audio:`:
   ```yaml
   i2s_audio:
     - id: i2s_audio_bus
       i2s_lrclk_pin: GPIO5
       i2s_bclk_pin: GPIO6
       sample_rate: 16000  # Explicitly set to 16 kHz
   ```

### ESP32 Crashes or Reboots

**Cause:** Insufficient power or memory issues

**Fix:**
1. **Separate power supply:** Power speaker amp from external 5V, not ESP32 5V pin
2. **Reduce logging:** Set `logger: level: WARN`
3. **Lower noise suppression:** `noise_suppression_level: 0` (uses less CPU)
4. **Disable auto gain:** Remove `auto_gain:` line
5. **Check brownout:** Add to `esphome:`:
   ```yaml
   esphome:
     platformio_options:
       board_build.f_cpu: 240000000L  # Full speed
   ```

### Speaker Too Quiet

**Cause:** Low volume multiplier or gain setting

**Fix:**
1. **Increase volume:** `volume_multiplier: 3.0` (or higher)
2. **Change amp gain:** Connect GAIN pin to 3.3V (12 dB instead of 9 dB)
3. **Check speaker impedance:** 4Ω speaker is louder than 8Ω with same amp
4. **Verify SD pin:** MAX98357A SD pin must be connected to 3.3V (not floating)

### Response Delayed (Slow Wake Word)

**Cause:** Network latency or cloud wake word processing

**Fix:**
1. **Use on-device wake word:** Change to `micro_wake_word` platform (ESP32 processes locally)
   ```yaml
   micro_wake_word:
     model: okay_nabu
     on_wake_word_detected:
       - voice_assistant.start:
   ```
2. **Reduce network hops:** Ensure Wyoming services running locally (not cloud)
3. **Optimize WiFi:** Use 2.4 GHz (better range) or 5 GHz (less interference)

---

## Advanced Customizations

### Custom Wake Words

**Using OpenWakeWord (Cloud):**
1. Train custom model: https://github.com/dscripka/openWakeWord
2. Copy `.tflite` model file to Wyoming container
3. Restart Wyoming OpenWakeWord with new model
4. Update HA voice pipeline to use custom wake word

**Using Micro Wake Word (On-Device):**
```yaml
micro_wake_word:
  models:
    - model: okay_nabu
    - model: hey_jarvis
  on_wake_word_detected:
    - voice_assistant.start:
    - lambda: |-
        ESP_LOGI("wake_word", "Detected: %s", wake_word.c_str());
```

### Multi-Room Audio Sync

**Broadcast announcements to multiple voice assistants:**

Home Assistant automation:
```yaml
automation:
  - alias: "Announce Doorbell"
    trigger:
      - platform: state
        entity_id: binary_sensor.doorbell
        to: 'on'
    action:
      - service: tts.speak
        target:
          entity_id:
            - media_player.living_room_voice
            - media_player.office_voice
            - media_player.custom_voice_assistant
        data:
          message: "Someone is at the front door"
```

### Voice Response Customization

**Personality via Home Assistant Conversation Agent:**
1. **Settings → Voice Assistants → Home Assistant → Configure**
2. **Personality:** "You are a helpful, friendly butler named Alfred"
3. **Response Style:** "Keep responses concise and under 30 seconds"

**Custom Intents:**
```yaml
# configuration.yaml
conversation:
  intents:
    TurnOnPC:
      - "turn on my computer"
      - "start my PC"
      - "wake up my computer"

intent_script:
  TurnOnPC:
    speech:
      text: "Turning on your computer now"
    action:
      - service: switch.turn_on
        target:
          entity_id: switch.pc_smart_plug
```

### Audio Quality Improvements

**Acoustic Echo Cancellation (AEC):**
```yaml
voice_assistant:
  # ... other settings ...
  use_wake_word: true
  noise_suppression_level: 2
  auto_gain: 31dBFS
  volume_multiplier: 2.0

  # Advanced audio processing
  on_tts_stream_start:
    - lambda: |-
        // Mute microphone during playback (prevent echo)
        id(external_microphone).stop();
  on_tts_stream_end:
    - lambda: |-
        // Re-enable microphone after playback
        id(external_microphone).start();
```

---

## What You've Learned

By completing this project, you now understand:

✅ **I2S Audio Protocol:**
- Digital audio transmission (BCLK, WS, DIN/DOUT)
- Microphone and speaker interfacing
- Shared bus architecture

✅ **Voice Assistant Pipeline:**
- Wyoming protocol integration
- Wake word detection (on-device and cloud)
- Speech-to-text and text-to-speech flow

✅ **Audio Processing:**
- Noise suppression and auto gain
- Volume control and amplification
- Acoustic echo cancellation

✅ **Real-Time Streaming:**
- 16 kHz audio sampling
- Low-latency communication
- Event-driven callbacks

✅ **Home Assistant Voice:**
- Voice pipeline configuration
- Custom intents and responses
- Multi-room announcements

✅ **Hardware Integration:**
- MEMS microphones (INMP441)
- Class D amplifiers (MAX98357A)
- Speaker impedance and power management

**Ready for the next project?** Try [Project 11: Energy Monitoring](11-energy-monitoring.md) to track power consumption and save on electricity bills!
