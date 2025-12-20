# Project 1: Hello World - Blink LED

**Difficulty:** Beginner
**Estimated Time:** 1-2 hours
**Cost:** $10-15 (if you have ESP32 already)

## Learning Objectives

By completing this project, you will learn:
- How to set up ESPHome and create your first device configuration
- GPIO (General Purpose Input/Output) pin control
- Compiling and flashing ESP32 firmware
- Home Assistant auto-discovery and entity creation
- Basic YAML configuration syntax
- OTA (Over-The-Air) updates

---

## Parts List

| Part | Quantity | Approximate Cost (CAD) | Notes |
|------|----------|------------------------|-------|
| ESP32 Development Board | 1 | $8-12 | Any ESP32 board works |
| LED (any color) | 1 | $0.25 | 5mm or 3mm, any color |
| 220Ω Resistor | 1 | $0.10 | Current limiting resistor |
| Breadboard | 1 | $5 | Small 400-point is fine |
| Jumper Wires | 2-3 | $3 (for pack) | Male-to-male |
| Micro-USB Cable | 1 | Included with ESP32 | For power and programming |

**Total Cost:** ~$10-15 (assuming you have breadboard and wires)

**Alternative - No External Parts Required:**
Most ESP32 boards have a built-in LED (usually GPIO2 or GPIO5). You can start with this to skip breadboarding!

---

## Understanding the Parts

### ESP32 Development Board
The ESP32 is a low-cost microcontroller with built-in WiFi and Bluetooth. Key features:
- **Dual-core processor** (up to 240MHz)
- **Built-in WiFi** (2.4GHz)
- **30+ GPIO pins** for sensors, LEDs, motors, etc.
- **Low power consumption** with deep sleep modes
- **USB programming** via built-in USB-to-serial chip

**Pin Layout:** Most ESP32 boards have pins labeled on the board. Common pins:
- **GND** - Ground (negative)
- **3V3** - 3.3V power output
- **5V** - 5V power (from USB)
- **GPIO pins** - Numbered (GPIO0, GPIO2, etc.)

### LED (Light Emitting Diode)
LEDs emit light when current flows through them in the correct direction.

**Important LED Facts:**
- **Polarity matters!** LEDs have a positive (anode) and negative (cathode) leg
- **Long leg = positive (anode)**, short leg = negative (cathode)
- **Flat edge** on LED body indicates cathode (negative)
- **Forward voltage:** ~2V for red/yellow, ~3V for blue/white
- **Current requirement:** 10-20mA (milliamps)

### 220Ω Resistor
**Why do we need this?**
LEDs will burn out if too much current flows through them. The resistor limits current to a safe level.

**Calculation:**
- ESP32 GPIO outputs 3.3V
- LED needs ~2V, draws 15mA
- Resistor = (3.3V - 2V) / 0.015A = ~87Ω
- 220Ω is safe and standard (slightly dimmer, but LED won't burn out)

**Color Codes:** 220Ω resistor has bands: Red-Red-Brown (or Red-Red-Black-Black-Brown for 5-band)

---

## Wiring Diagram

### Option 1: External LED on Breadboard

```
ESP32 Board                 Breadboard

GPIO2 ------>  Resistor (220Ω) -----> LED (long leg/anode)
                                       |
                                    LED (short leg/cathode)
                                       |
GND   ---------------------------------+
```

**Step-by-Step Wiring:**
1. Place LED on breadboard (legs in separate rows)
2. Connect 220Ω resistor from GPIO2 to LED's long leg (anode)
3. Connect LED's short leg (cathode) to ESP32 GND pin
4. Double-check polarity before powering on!

### Option 2: Built-in LED (Easier!)

No wiring needed! Most ESP32 boards have a built-in LED on GPIO2 or GPIO5.

**To find your built-in LED pin:**
- Check your ESP32 board's documentation
- Common pins: GPIO2 (ESP32-DevKitC), GPIO5 (some boards)
- Look for a small LED near the USB port

---

## ESPHome Configuration

Create a new file: `/home/hazzard/home-assistant/esphome/blink-led-test.yaml`

### Basic Configuration (Built-in LED)

```yaml
esphome:
  name: blink-led-test
  friendly_name: "Blink LED Test"
  platform: ESP32
  board: esp32dev  # Or your specific board type

# WiFi configuration
wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password

  # Static IP (optional but recommended)
  manual_ip:
    static_ip: 192.168.40.150  # Choose an unused IP
    gateway: 192.168.40.1
    subnet: 255.255.255.0
    dns1: 8.8.8.8

  # Fallback hotspot if WiFi fails
  ap:
    ssid: "Blink-LED-Fallback"
    password: "12345678"

# Enable logging
logger:

# Enable Home Assistant API
api:
  encryption:
    key: !secret api_key_blink_led  # Will be auto-generated

# Enable OTA updates
ota:
  - platform: esphome
    password: !secret ota_password

# Status LED (optional - blinks to show WiFi status)
status_led:
  pin:
    number: GPIO2
    inverted: false

# Define the LED as a light entity
light:
  - platform: binary  # On/off only (no dimming)
    name: "Test LED"
    output: led_output
    id: test_led

# Define the GPIO output
output:
  - platform: gpio
    pin: GPIO2  # Change to GPIO5 if your built-in LED is there
    id: led_output

# Optional: Blink pattern on startup
interval:
  - interval: 1s
    then:
      - light.toggle: test_led
```

### Configuration for External LED

Same as above, but change the pin number:

```yaml
output:
  - platform: gpio
    pin: GPIO2  # Or whichever pin you wired to
    id: led_output
```

### Adding Secrets

Edit `/home/hazzard/home-assistant/esphome/secrets.yaml`:

```yaml
wifi_ssid: "YourWiFiName"
wifi_password: "YourWiFiPassword"
ota_password: "your-ota-password"
api_key_blink_led: ""  # Leave empty, will auto-generate
```

---

## Step-by-Step Build Guide

### Step 1: Hardware Setup

**Option A - Built-in LED (Recommended for first try):**
1. Connect ESP32 to computer via Micro-USB cable
2. No wiring needed!

**Option B - External LED:**
1. Insert LED into breadboard (note polarity!)
2. Connect resistor from GPIO2 to LED anode (long leg)
3. Connect LED cathode (short leg) to breadboard ground rail
4. Connect jumper from ESP32 GND to breadboard ground rail
5. Connect ESP32 to computer via USB

### Step 2: Create ESPHome Configuration

Via ESPHome Web UI (recommended):
1. Access ESPHome dashboard: http://192.168.40.201:6052
2. Click "**+ NEW DEVICE**"
3. Follow the wizard:
   - Name: `blink-led-test`
   - Device Type: `ESP32`
   - Board: `esp32dev`
4. Click "**SKIP**" on the encryption key screen (we'll add it manually)
5. Click "**EDIT**" on your new device
6. Replace the contents with the YAML configuration above
7. Click "**SAVE**"

### Step 3: First Flash (USB)

**Important:** The first flash MUST be via USB. After that, you can use OTA (WiFi) updates.

1. Click "**INSTALL**" button on your device card
2. Choose "**Plug into this computer**"
3. Browser will show USB device picker
4. Select your ESP32's serial port (usually shows as "CP210x" or "CH340")
5. Click "**Connect**"
6. Wait for compilation and upload (2-5 minutes)
7. Watch the logs - you should see:
   ```
   INFO Successfully connected to blink-led-test.local
   INFO WiFi Connected!
   INFO IP Address: 192.168.40.150
   ```

### Step 4: Verify in Home Assistant

1. Open Home Assistant: http://192.168.40.201:8123
2. Go to **Settings → Devices & Services → Integrations**
3. You should see a notification: "**ESPHome: blink-led-test discovered**"
4. Click "**CONFIGURE**"
5. Leave encryption key blank (or use the one from your YAML), click "**SUBMIT**"
6. Your device now appears! Click on it to see entities
7. Find "**Test LED**" entity

### Step 5: Test the LED!

**Via Home Assistant:**
1. Go to **Settings → Devices & Services → ESPHome → blink-led-test**
2. Click on "**Test LED**" entity
3. Toggle the switch ON/OFF - LED should respond!

**Via Developer Tools:**
1. Go to **Developer Tools → Services**
2. Service: `light.turn_on`
3. Target: `light.test_led`
4. Click "**CALL SERVICE**" - LED turns on!

### Step 6: Make Changes (OTA Update)

Now that your ESP32 is on WiFi, you can update wirelessly!

1. Edit `blink-led-test.yaml` (change blink interval to 2 seconds):
   ```yaml
   interval:
     - interval: 2s  # Changed from 1s
   ```
2. Click "**SAVE**" and "**INSTALL**"
3. Choose "**Wirelessly**"
4. No USB cable needed - update happens over WiFi!

---

## Understanding the Code

### ESPHome Platform Structure

```yaml
esphome:
  name: blink-led-test        # Device hostname (blink-led-test.local)
  friendly_name: "Blink LED"  # Display name in Home Assistant
  platform: ESP32              # Chip type
  board: esp32dev              # Board variant (affects pin mappings)
```

### WiFi Configuration

```yaml
wifi:
  ssid: !secret wifi_ssid      # !secret pulls from secrets.yaml
  password: !secret wifi_password

  manual_ip:                   # Static IP (optional but recommended)
    static_ip: 192.168.40.150  # Your chosen IP
    gateway: 192.168.40.1      # Your router
    subnet: 255.255.255.0
```

**Why static IP?**
- Device always has same IP address
- Easier to find in network scans
- More reliable for automations

### Light Entity

```yaml
light:
  - platform: binary           # On/off only (vs. dimmable)
    name: "Test LED"           # Name shown in Home Assistant
    output: led_output         # References the output defined below
    id: test_led               # Internal ID for automations
```

### GPIO Output

```yaml
output:
  - platform: gpio             # GPIO pin output
    pin: GPIO2                 # Pin number (check your board!)
    id: led_output             # Internal reference ID
```

**GPIO Pins Explained:**
- `GPIO` = General Purpose Input/Output
- ESP32 has 30+ GPIO pins
- Each can be configured as input (read sensors) or output (control LEDs, relays)
- Some pins have special functions (I2C, SPI, ADC)

### Automation: Blink Interval

```yaml
interval:
  - interval: 1s               # Run every 1 second
    then:
      - light.toggle: test_led # Toggle LED state (on→off or off→on)
```

**How it works:**
- Every 1 second, this automation runs
- `light.toggle` switches the LED state
- If LED is ON, it turns OFF (and vice versa)
- Result: LED blinks every second

---

## Troubleshooting

### LED doesn't light up

**Check 1: Polarity**
- Swap the LED direction (reverse it in breadboard)
- Long leg should connect to GPIO (through resistor)
- Short leg should connect to GND

**Check 2: Correct GPIO Pin**
- Verify you're using the correct pin (GPIO2 vs GPIO5)
- Check your ESP32 board's pinout diagram
- Try different pins (GPIO4, GPIO5, GPIO16, GPIO17 are usually safe)

**Check 3: Code uploaded successfully?**
- Check ESPHome logs for errors
- Look for "INFO Successfully connected to..."
- Verify device shows "ONLINE" in ESPHome dashboard

**Check 4: Wiring**
- Ensure resistor is in series (between GPIO and LED)
- Check breadboard connections (rows are connected, columns are not)
- Verify GND is connected to ESP32 GND pin

### ESP32 won't connect to WiFi

**Check 1: WiFi Credentials**
- Verify `secrets.yaml` has correct SSID and password
- Check for typos (case-sensitive!)
- Ensure WiFi is 2.4GHz (ESP32 doesn't support 5GHz)

**Check 2: Fallback Hotspot**
- If WiFi fails, ESP32 creates its own network: "Blink-LED-Fallback"
- Connect to it with phone/laptop (password: `12345678`)
- Access http://192.168.4.1 to configure WiFi

**Check 3: IP Address Conflict**
- Make sure 192.168.40.150 isn't used by another device
- Try a different IP (192.168.40.151, etc.)
- Remove `manual_ip:` section to use DHCP

### Can't flash via USB

**Check 1: USB Cable**
- Some USB cables are power-only (no data)
- Try a different cable
- Ensure cable is plugged into computer USB port (not a hub)

**Check 2: Drivers**
- ESP32 uses CP210x or CH340 USB-to-serial chip
- Check if drivers are installed (usually automatic on Linux)
- Run `ls /dev/ttyUSB*` or `ls /dev/ttyACM*` to see serial devices

**Check 3: Boot Mode**
- Some boards require holding "BOOT" button while plugging in USB
- Try holding BOOT button, then clicking "Connect" in browser
- Release BOOT button after upload starts

### Home Assistant doesn't discover device

**Check 1: Same Network**
- ESP32 and Home Assistant must be on same network (192.168.40.0/24)
- Ping the ESP32: `ping 192.168.40.150`

**Check 2: API Encryption**
- Check Home Assistant logs for connection errors
- Try removing `encryption:` section from YAML (less secure, but tests connectivity)

**Check 3: Manual Integration**
- Go to **Settings → Integrations → Add Integration**
- Search for "ESPHome"
- Enter IP: `192.168.40.150`
- Enter encryption key (from YAML)

---

## Next Steps & Enhancements

### Enhancement 1: Add a Physical Button

Add a button to manually toggle the LED:

```yaml
binary_sensor:
  - platform: gpio
    pin:
      number: GPIO4
      mode:
        input: true
        pullup: true
    name: "Button"
    on_press:
      - light.toggle: test_led
```

**Wiring:** Connect button between GPIO4 and GND (uses internal pullup resistor).

### Enhancement 2: Multiple LEDs

Create a light show with 3 LEDs:

```yaml
light:
  - platform: binary
    name: "Red LED"
    output: red_led
  - platform: binary
    name: "Green LED"
    output: green_led
  - platform: binary
    name: "Blue LED"
    output: blue_led

output:
  - platform: gpio
    pin: GPIO2
    id: red_led
  - platform: gpio
    pin: GPIO4
    id: green_led
  - platform: gpio
    pin: GPIO5
    id: blue_led

# Sequence: Red → Green → Blue → repeat
interval:
  - interval: 1s
    then:
      - light.turn_on: red_led
      - delay: 300ms
      - light.turn_off: red_led
      - light.turn_on: green_led
      - delay: 300ms
      - light.turn_off: green_led
      - light.turn_on: blue_led
      - delay: 300ms
      - light.turn_off: blue_led
```

### Enhancement 3: Home Assistant Automation

Create an automation in Home Assistant (not ESPHome):

1. Go to **Settings → Automations → Create Automation**
2. Trigger: Time pattern (every hour)
3. Action: Toggle LED 5 times (blink alert)

```yaml
alias: "Hourly Blink Alert"
trigger:
  - platform: time_pattern
    minutes: "0"  # Every hour (at :00)
action:
  - repeat:
      count: 5
      sequence:
        - service: light.toggle
          target:
            entity_id: light.test_led
        - delay: 0.5
```

### Enhancement 4: Brightness Control (PWM)

Make the LED dimmable using PWM (Pulse Width Modulation):

```yaml
output:
  - platform: ledc  # PWM output (instead of gpio)
    pin: GPIO2
    id: led_output
    frequency: 1000 Hz  # PWM frequency

light:
  - platform: monochromatic  # Dimmable (instead of binary)
    name: "Dimmable LED"
    output: led_output
```

Now you can set brightness from 0-100% in Home Assistant!

---

## Learning Resources

### ESPHome Documentation
- Official Docs: https://esphome.io/
- GPIO Output: https://esphome.io/components/output/gpio.html
- Light Component: https://esphome.io/components/light/

### ESP32 Pinout References
- Random Nerd Tutorials ESP32 Pinout: https://randomnerdtutorials.com/esp32-pinout-reference-gpios/
- Espressif Official Docs: https://docs.espressif.com/

### Electronics Basics
- All About Circuits - LED Tutorial: https://www.allaboutcircuits.com/
- SparkFun Electronics Tutorials: https://learn.sparkfun.com/

---

## What You've Learned

By completing this project, you now understand:

✅ **ESPHome Basics:**
- Creating device configurations in YAML
- Compiling and flashing firmware
- OTA (Over-The-Air) updates

✅ **GPIO Control:**
- Digital outputs (HIGH/LOW, 3.3V/0V)
- Pin numbering and board-specific layouts
- Current limiting with resistors

✅ **Home Assistant Integration:**
- Auto-discovery of ESPHome devices
- Creating light entities
- Controlling devices via HA interface

✅ **Electronics Fundamentals:**
- LED polarity and current requirements
- Resistor calculations
- Breadboard wiring

✅ **Networking:**
- Static vs. DHCP IP addressing
- WiFi configuration
- mDNS (device.local) addressing

**Ready for the next project?** Try [Project 2: Temperature & Humidity Monitor](02-temperature-humidity.md) to learn about sensor integration!
