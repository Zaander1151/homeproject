# XIAO ESP32-C6 RGB LED Strip Test Project

## Overview

A simple test project to learn RGB LED strip (WS2812B/NeoPixel) wiring and control using a Seeed Studio XIAO ESP32-C6 development board. This project is USB-powered and perfect for learning the basics before building more complex LED projects.

**Status:** Ready to build
**Device IP:** 192.168.40.185
**ESPHome Config:** `/home/hazzard/home-assistant/esphome/xiao-c6-rgb-strip-test.yaml`

---

## Bill of Materials

### Required Components

- **1 x Seeed Studio XIAO ESP32-C6** development board
- **1 x WS2812B RGB LED Strip** (10 LEDs recommended for USB power)
- **1 x 470Ω Resistor** (data line protection)
- **1 x 1000µF Capacitor** (16V or higher, electrolytic, optional but recommended)
- **1 x Breadboard** (for prototyping)
- **Jumper wires** (male-to-male, male-to-female)
- **USB-C cable** (for power and programming)

### Optional Components

- **5V 2A Power Supply** (if using more than 10 LEDs)
- **Level Shifter (74AHCT125)** (for better signal reliability, converts 3.3V to 5V)

---

## Power Considerations

### USB Power Limits

- **USB 2.0:** 500mA maximum
- **USB 3.0:** 900mA maximum
- **Each WS2812B LED:** Up to 60mA at full brightness (white color)

### Safe LED Count Calculations

**USB 2.0 (500mA):**
- **XIAO ESP32-C6:** ~100mA (Wi-Fi active)
- **Available for LEDs:** 400mA
- **Safe LED count:** 6-8 LEDs at full brightness
- **Practical with animations:** 10-12 LEDs (not all white at once)

**USB 3.0 (900mA):**
- **Available for LEDs:** 800mA
- **Safe LED count:** 12-15 LEDs at full brightness
- **Practical with animations:** 15-20 LEDs

**With External 5V Power Supply:**
- **5V 2A supply:** Up to 30 LEDs safely
- **5V 5A supply:** Up to 75 LEDs safely

### Configuration Adjustment

The default configuration is set to **10 LEDs** for safe USB operation. To change the number of LEDs:

```yaml
light:
  - platform: neopixelbus
    num_leds: 10  # Change this value
```

---

## Wiring Guide

### XIAO ESP32-C6 Pin Reference

**Important:** The "D" labels on the board silk screen are NOT the same as GPIO numbers!

| Pin Label | GPIO Number | Default Function |
|-----------|-------------|------------------|
| D0 | GPIO0 | A0 (ADC) |
| D1 | GPIO1 | A1 (ADC) |
| **D2** | **GPIO2** | **A2 (ADC) - Used for LED data** |
| D3 | GPIO21 | SPI SS |
| D4 | GPIO22 | I2C SDA |
| D5 | GPIO23 | I2C SCL |
| D6 | GPIO16 | UART TX |
| D7 | GPIO17 | UART RX |
| D8 | GPIO19 | SPI SCK |
| D9 | GPIO20 | SPI MISO |
| D10 | GPIO18 | SPI MOSI |

**For this project:** Connect the LED strip data wire to **D2** (which is GPIO2, also labeled A2).

### Pin Connections

| Component | Pin | Notes |
|-----------|-----|-------|
| LED Strip Data (DIN) | GPIO2 (D2/A2) | Via 470Ω resistor |
| LED Strip 5V | 5V (from USB) | Power supply positive |
| LED Strip GND | GND | Common ground |
| Capacitor + | 5V rail | Near LED strip connection |
| Capacitor - | GND rail | Common ground |

### Breadboard Wiring Diagram

```
XIAO ESP32-C6                    Breadboard                   LED Strip
┌─────────────┐                                              ┌──────────┐
│             │                                              │          │
│     5V ─────┼──────────────────┬─────── [+] ──────────────┤ 5V       │
│             │                  │                           │          │
│    GND ─────┼──────────────────┼──────── [-] ──────────────┤ GND      │
│             │                  │                           │          │
│  GPIO2 ─────┼──── [470Ω] ──────┼────────────────────────────┤ DIN      │
│   (D2)      │                  │                           │          │
│             │                  │                           │          │
└─────────────┘                  │                           └──────────┘
                                 │
                        [1000µF Capacitor]
                             (+)   (-)
                              │     │
                             5V    GND
```

### Step-by-Step Wiring Instructions

1. **Power Rails Setup:**
   - Connect XIAO 5V pin to breadboard + (positive) rail
   - Connect XIAO GND pin to breadboard - (negative/ground) rail

2. **Capacitor Installation (CRITICAL - Check Polarity!):**
   - **Longer leg (+, positive)** → 5V rail
   - **Shorter leg (-, negative, marked with stripe)** → GND rail
   - **Purpose:** Smooths power supply, prevents voltage spikes

3. **Data Line Connection:**
   - Insert 470Ω resistor into breadboard
   - Connect XIAO **GPIO2 (D2/A2 pin)** to one end of resistor
   - Connect other end of resistor to LED strip DIN (Data In) wire
   - **Purpose:** Protects GPIO pin from current surges

4. **LED Strip Power:**
   - Connect LED strip 5V wire to breadboard + rail
   - Connect LED strip GND wire to breadboard - rail

5. **Verify All Connections:**
   - Double-check capacitor polarity (backwards = damage/explosion risk)
   - Ensure no shorts between 5V and GND
   - Verify resistor is in data line path

### Important Safety Notes

- **NEVER reverse the capacitor polarity** - it can explode!
- The capacitor should be **as close to the LED strip connection as possible**
- Keep wires short to minimize voltage drop
- If using external power supply, ensure GND is connected to XIAO GND (common ground)

---

## LED Strip Types & Color Order

### Common LED Strip Types

- **WS2812B** (most common) - Color order: **GRB**
- **SK6812** - Color order: **GRB**
- **APA102** - Different protocol (not compatible with this config)
- **WS2811** - External driver IC version of WS2812B

### Identifying Your LED Strip

Look for markings on the strip or packaging:
- "WS2812B", "5050 RGB", or "NeoPixel" → Use **GRB**
- If colors appear wrong, try changing the `type:` in config:
  - `type: GRB` (default)
  - `type: RGB`
  - `type: GRBW` (for RGBW strips with white LED)

---

## Flashing the Firmware

### Method 1: ESPHome Web Interface (Easiest)

1. **Access ESPHome Dashboard:**
   ```
   http://192.168.40.201:6052
   ```

2. **First-Time Flash (USB Required):**
   - Click "INSTALL" on the RGB Strip Test card
   - Select "Plug into this computer"
   - Connect XIAO to USB
   - Select the serial port (usually `/dev/ttyACM0`)
   - Wait for compilation and upload (~3-5 minutes)

3. **Subsequent Updates (OTA - Over The Air):**
   - Click "INSTALL"
   - Select "Wirelessly"
   - Firmware updates over Wi-Fi

### Method 2: Command Line

```bash
# Compile firmware
docker exec -it esphome esphome compile xiao-c6-rgb-strip-test.yaml

# Upload via USB (first time)
docker exec -it esphome esphome upload xiao-c6-rgb-strip-test.yaml

# View logs
docker exec -it esphome esphome logs xiao-c6-rgb-strip-test.yaml
```

---

## Testing the LED Strip

### Step 1: Power-On Test

1. Connect XIAO to USB power
2. Check if built-in LED on XIAO lights up (GPIO15)
3. Device should connect to Wi-Fi and appear in ESPHome dashboard

### Step 2: Basic Color Test

1. **Access Web Interface:**
   ```
   http://192.168.40.185
   ```

2. **Turn On Strip:**
   - Toggle "RGB Strip" switch to ON
   - All LEDs should light up (default color: white)

3. **Test Primary Colors:**
   - Set brightness to 50% (to save power)
   - Select RED → All LEDs should be red
   - Select GREEN → All LEDs should be green
   - Select BLUE → All LEDs should be blue

### Step 3: Effects Testing

Try each effect to verify functionality:

1. **Rainbow** - Smooth rainbow animation across strip
2. **Color Wipe** - LEDs fill one by one (red→green→blue)
3. **Scan** - Scanner/Cylon effect
4. **Twinkle** - Random twinkling stars
5. **Fireworks** - Burst effects
6. **Strobe** - Fast flashing (warning: may be uncomfortable)
7. **Flicker** - Candle-like flicker
8. **Random** - Random color changes

### Troubleshooting

| Problem | Possible Cause | Solution |
|---------|---------------|----------|
| No LEDs light up | No power to strip | Check 5V and GND connections |
| | Wrong data pin | Verify GPIO2 (D2) is connected to DIN |
| | Bad LED strip | Test strip with different controller |
| First LED works, others don't | Insufficient power | Reduce brightness or LED count |
| | Broken LED in chain | Check continuity between LEDs |
| Wrong colors | Incorrect color order | Change `type:` in YAML (GRB/RGB/GRBW) |
| Flickering/glitching | Power supply issue | Add/check capacitor, use external power |
| | Long wires | Shorten data line wire, add level shifter |
| Device won't connect to Wi-Fi | Wrong credentials | Check secrets.yaml |
| | Signal interference | Move away from other 2.4GHz devices |

---

## Home Assistant Integration

Once the device is running, it will automatically appear in Home Assistant.

### Adding to Dashboard

1. **Navigate to Home Assistant:**
   ```
   http://192.168.40.201:8123
   ```

2. **Go to Settings → Devices & Services → ESPHome**

3. **Find "RGB Strip Test" device**

4. **Add to Dashboard:**
   - Create new card or add to existing
   - Use "Light" card type for full control
   - Brightness, color, and effects are controllable

### Automation Examples

**Turn on rainbow effect at sunset:**
```yaml
automation:
  - alias: "RGB Strip Sunset Rainbow"
    trigger:
      - platform: sun
        event: sunset
    action:
      - service: light.turn_on
        target:
          entity_id: light.rgb_strip
        data:
          effect: "Rainbow"
          brightness_pct: 75
```

**Turn off at midnight:**
```yaml
automation:
  - alias: "RGB Strip Off at Midnight"
    trigger:
      - platform: time
        at: "00:00:00"
    action:
      - service: light.turn_off
        target:
          entity_id: light.rgb_strip
```

---

## Next Steps & Learning Projects

### Skill Progression

1. **✓ Basic Strip Control** (this project)
   - Power management
   - Wiring fundamentals
   - ESPHome configuration

2. **Intermediate Projects:**
   - **Ambient Lighting:** Behind TV/monitor with brightness automation
   - **Stair Lighting:** Motion-activated with directional effects
   - **Music Visualizer:** React to audio input (requires microphone)

3. **Advanced Projects:**
   - **LED Matrix Display:** 2D animations and text scrolling
   - **Addressable Room Lighting:** Multiple zones with independent control
   - **Voice Satellite Integration:** LED ring for voice assistant (see voice-satellite-led-ring.md)

### Recommended Upgrades

- **Add button control:** GPIO button to cycle through effects
- **Add motion sensor:** Auto-on when motion detected
- **Add light sensor:** Auto-adjust brightness based on ambient light
- **Expand to multiple strips:** Chain multiple strips together

---

## Configuration Reference

### Full YAML Configuration

See: `/home/hazzard/home-assistant/esphome/xiao-c6-rgb-strip-test.yaml`

### Key Configuration Sections

**LED Platform:**
```yaml
light:
  - platform: esp32_rmt_led_strip  # Required for ESP-IDF framework
    rgb_order: GRB      # Color order (WS2812B standard)
    chipset: WS2812     # LED type
    pin: GPIO2          # Data pin (D2/A2 on board)
    num_leds: 10        # LED count
    name: "RGB Strip"
```

**Note:** The XIAO ESP32-C6 uses ESP-IDF framework, which requires `esp32_rmt_led_strip` platform instead of `neopixelbus`.

**Effects:**
- All standard ESPHome addressable light effects included
- Easily add custom effects via ESPHome lambda

### Adding Custom Effects

Example - Custom breathing effect:
```yaml
effects:
  - addressable_lambda:
      name: "Breathing"
      update_interval: 16ms
      lambda: |-
        static float brightness = 0;
        static bool increasing = true;

        if (increasing) {
          brightness += 0.01;
          if (brightness >= 1.0) increasing = false;
        } else {
          brightness -= 0.01;
          if (brightness <= 0.0) increasing = true;
        }

        it.all() = Color(255 * brightness, 0, 0);
```

---

## Resources

### Documentation

- **ESPHome Lights:** https://esphome.io/components/light/
- **NeoPixelBus:** https://esphome.io/components/light/neopixelbus.html
- **WS2812B Datasheet:** https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf

### XIAO ESP32-C6 Resources

- **Seeed Wiki:** https://wiki.seeedstudio.com/xiao_esp32c6_getting_started/
- **Pinout Diagram:** https://files.seeedstudio.com/wiki/SeeedStudio-XIAO-ESP32C6/img/xiaoc6.jpg

### Related Home Assistant Projects

- **Voice Satellite LED Ring:** `/home/hazzard/homeproject/docs-web/projects/voice-satellite-led-ring.md`
- **XIAO C6 Climate Sensor:** `/home/hazzard/homeproject/docs-web/projects/xiao-c6-aht20-build.md`

---

## Change Log

- **2025-01-04:**
  - Fixed GPIO pin - corrected from non-existent GPIO8 to GPIO2 (D2/A2)
  - Added complete XIAO ESP32-C6 pinout reference table
  - Changed LED platform from `neopixelbus` to `esp32_rmt_led_strip` (ESP-IDF compatibility)
  - Identified LED strip as SK6812 RGBW (not WS2812B RGB)
  - Configured `is_rgbw: true` and `chipset: SK6812` for proper color support
  - Disabled web_server due to httpd errors (control via Home Assistant)
  - Soldered connections for reliability (breadboard caused power issues)
  - Successfully deployed with 10 LEDs, fully functional
- **2025-12-30:** Initial project creation, USB-powered configuration for learning
