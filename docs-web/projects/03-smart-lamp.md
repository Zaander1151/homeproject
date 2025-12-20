# Project 3: Smart Lamp / Nightlight

**Difficulty:** Beginner
**Estimated Time:** 2-4 hours
**Cost:** $20-30

## Learning Objectives

By completing this project, you will learn:
- Relay control for switching AC/DC loads
- Electrical safety with mains voltage (120V AC)
- Home Assistant switch entities
- Restore state (remembering on/off after power loss)
- Automations with timers and schedules
- Integration with voice assistants (Alexa, Google Home)

---

## ⚠️ **SAFETY WARNING** ⚠️

This project involves **mains voltage (120V AC)** which can be **LETHAL**.

**Safety Rules:**
1. **Start with low-voltage (12V) LED strip** to learn safely
2. **NEVER work on AC circuits while plugged in**
3. **Use a relay rated for your load** (10A minimum for lamps)
4. **Double-check all connections before powering on**
5. **Use proper wire nuts or terminal blocks** (no exposed wires)
6. **If unsure, hire a licensed electrician** or stick to low-voltage projects

**Recommended Learning Path:**
1. **This guide (Phase 1):** Low-voltage 12V LED strip (safe, no risk)
2. **Phase 2 (optional):** AC lamp control (only after mastering Phase 1)

**Legal Note:** Some jurisdictions require licensed electricians for AC wiring. Check local codes.

---

## Parts List

### Phase 1: Low-Voltage LED Strip (Recommended Start)

| Part | Quantity | Approximate Cost (CAD) | Notes |
|------|----------|------------------------|-------|
| ESP32 Development Board | 1 | $8-12 | Reuse from previous projects |
| Relay Module (5V, 1-channel) | 1 | $3-5 | Optocoupler isolated |
| 12V LED Strip (white or RGB) | 1m | $8-12 | 5050 SMD, 60 LEDs/m |
| 12V Power Supply (2A) | 1 | $8-12 | Barrel jack or screw terminals |
| Jumper Wires | 3-4 | Reuse | Male-to-male or male-to-female |
| Breadboard (optional) | 1 | Reuse | For prototyping |

**Total Cost (Phase 1):** ~$20-30

### Phase 2: AC Lamp Control (Advanced, Optional)

| Part | Quantity | Approximate Cost (CAD) | Notes |
|------|----------|------------------------|-------|
| All parts from Phase 1 | - | - | ESP32, relay module, etc. |
| AC Lamp | 1 | $10-20 | Any 120V lamp (< 500W) |
| Electrical Box | 1 | $5 | For mounting relay safely |
| Wire Nuts | 3-4 | $2 | For AC wire connections |
| 14-gauge wire | 2m | $3 | Black (hot), white (neutral) |

**Total Cost (Phase 2):** +$15-25

---

## Understanding the Parts

### Relay Module

A relay is an electrically controlled switch. It uses a low-voltage signal (3.3V from ESP32) to control a high-voltage circuit (12V or 120V AC).

**How it Works:**
1. ESP32 sends 3.3V signal to relay coil
2. Coil energizes, creating magnetic field
3. Magnetic field pulls contact closed (switch ON)
4. High-voltage circuit completes → lamp turns on
5. ESP32 removes signal → relay opens → lamp turns off

**Relay Module Components:**
- **Relay:** The actual switching mechanism (SPDT or SPST)
- **Optocoupler:** Isolates ESP32 from relay (protects ESP32)
- **LED Indicator:** Shows relay state (ON/OFF)
- **Screw Terminals:** For connecting high-voltage load

**Relay Ratings:**
- **Coil Voltage:** 5V DC (some are 3.3V)
- **Contact Rating:** 10A @ 250V AC, 10A @ 30V DC (typical)
- **Relay Type:** SPDT (Single Pole Double Throw)

**Terminals:**
- **COM (Common):** Always connected
- **NO (Normally Open):** Connects to COM when relay is ON
- **NC (Normally Closed):** Connects to COM when relay is OFF

**For this project, use NO (Normally Open).**

### LED Strip (12V)

**Specifications:**
- **Voltage:** 12V DC (never connect to AC!)
- **Type:** 5050 SMD (chip size: 5.0mm × 5.0mm)
- **Density:** 60 LEDs/meter (standard)
- **Power:** ~14W/meter (1.2A/meter @ 12V)
- **Color:** White (warm/cool/daylight) or RGB (multicolor)

**Connections:**
- **+12V** (red wire): Positive
- **GND** (black wire): Ground/negative

**Important:** 1 meter of LED strip draws ~1.2A. Use 2A power supply for safety margin.

### 12V Power Supply

**Specifications:**
- **Output:** 12V DC, 2A (24W)
- **Connector:** Barrel jack (5.5mm × 2.1mm) or screw terminals
- **Input:** 100-240V AC (universal)

**Safety:** Use a UL/CSA-certified power supply (look for certification marks).

---

## Wiring Diagram

### Phase 1: Low-Voltage LED Strip (Safe for Beginners)

```
12V Power Supply                Relay Module (NO terminals)        LED Strip

   +12V -----> COM
                                    NO -----> +12V (Red)
   GND -------------------------------------------> GND (Black)


ESP32 Board                     Relay Module (Control)

   GPIO4 --------> IN (Signal)
   GND ----------> GND
   5V -----------> VCC (if relay needs 5V, some can use 3.3V)
```

**Step-by-Step Wiring:**

1. **Relay Module Control (Low-Voltage Side):**
   - ESP32 **GPIO4** → Relay **IN** (signal)
   - ESP32 **GND** → Relay **GND**
   - ESP32 **5V** → Relay **VCC** (or 3.3V if relay supports it)

2. **LED Strip Power (High-Voltage Side):**
   - 12V Power Supply **+12V** → Relay **COM** (common)
   - Relay **NO** (normally open) → LED Strip **+12V** (red wire)
   - 12V Power Supply **GND** → LED Strip **GND** (black wire)

**How it Works:**
- Relay OFF: No connection between COM and NO → LED strip OFF
- Relay ON: COM connects to NO → +12V flows to LED strip → LEDs light up

**Visual Breadboard Layout:**
```
[ESP32]          [Relay Module]           [LED Strip]
 GPIO4  -------->  IN
 GND    -------->  GND
 5V     -------->  VCC

                   COM  <---+12V (Power Supply)
                   NO   ---> +12V (LED Strip Red)

[Power Supply GND] ----> [LED Strip Black/GND]
```

---

## ESPHome Configuration

Create a new file: `/home/hazzard/home-assistant/esphome/smart-lamp-1.yaml`

### Complete Configuration (Phase 1: 12V LED Strip)

```yaml
esphome:
  name: smart-lamp-1
  friendly_name: "Smart Nightlight"
  platform: ESP32
  board: esp32dev

# WiFi configuration
wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password

  manual_ip:
    static_ip: 192.168.40.152
    gateway: 192.168.40.1
    subnet: 255.255.255.0
    dns1: 8.8.8.8

  ap:
    ssid: "Smart-Lamp-Fallback"
    password: "12345678"

logger:

api:
  encryption:
    key: !secret api_key_smart_lamp

ota:
  - platform: esphome
    password: !secret ota_password

# Define the relay switch
switch:
  - platform: gpio
    pin: GPIO4
    name: "Nightlight"
    id: nightlight_switch
    icon: "mdi:lightbulb"

    # Restore state after power loss
    restore_mode: RESTORE_DEFAULT_OFF
    # Options:
    #   RESTORE_DEFAULT_OFF - Default to OFF after power cycle
    #   RESTORE_DEFAULT_ON - Default to ON after power cycle
    #   ALWAYS_OFF - Always start OFF
    #   ALWAYS_ON - Always start ON
    #   RESTORE_INVERTED_DEFAULT_OFF - Restore opposite of last state

    # Optional: Interlock (prevent multiple relays on simultaneously)
    # interlock: [relay2, relay3]
    # interlock_wait_time: 100ms

# Optional: Physical button to toggle relay
binary_sensor:
  - platform: gpio
    pin:
      number: GPIO5
      mode:
        input: true
        pullup: true
      inverted: true
    name: "Nightlight Button"
    on_press:
      - switch.toggle: nightlight_switch

# Optional: Auto-off timer (turn off after 30 minutes)
# Uncomment to enable:
# script:
#   - id: auto_off_timer
#     then:
#       - delay: 30min
#       - switch.turn_off: nightlight_switch
#
# on_...:
#   switch.turn_on:
#     - script.execute: auto_off_timer
```

---

## Step-by-Step Build Guide

### Step 1: Test Relay Module (Verify Before Connecting Load)

**Important:** Always test relay operation before connecting high-voltage loads!

1. **Wiring Test Setup:**
   - Connect ESP32 GPIO4 → Relay IN
   - Connect ESP32 GND → Relay GND
   - Connect ESP32 5V → Relay VCC
   - **DO NOT connect LED strip or power supply yet**

2. **Flash ESP32:**
   - Use the ESPHome configuration above
   - Flash via USB (first time)
   - Check logs for successful connection

3. **Test Relay Manually:**
   - In Home Assistant, toggle "Nightlight" switch ON
   - **Listen for relay click** (you should hear/feel a mechanical click)
   - Relay LED indicator should light up
   - Toggle OFF → click again, LED off

**If relay clicks and LED lights up, proceed to Step 2.**

### Step 2: Connect LED Strip (Low-Voltage Test)

**Safety Check:**
- ✅ Relay tested and working
- ✅ 12V power supply unplugged
- ✅ Polarity verified (red = +12V, black = GND)

**Wiring:**
1. **Power Supply → Relay:**
   - Connect 12V power supply **+12V** wire to relay **COM** terminal
   - Tighten screw terminal securely

2. **Relay → LED Strip:**
   - Connect relay **NO** terminal to LED strip **+12V** (red wire)
   - Tighten screw terminal securely

3. **Complete Ground Path:**
   - Connect 12V power supply **GND** directly to LED strip **GND** (black wire)
   - Use wire nut or screw terminal

4. **Double-Check:**
   - Verify polarity (red to red, black to black)
   - Ensure no exposed wires or shorts
   - Check relay terminals are tight

5. **Power On:**
   - Plug in 12V power supply
   - Toggle relay in Home Assistant
   - **LED strip should light up!**

### Step 3: Add to Home Assistant

1. Home Assistant auto-discovers device
2. Go to **Settings → Integrations → ESPHome**
3. Configure `smart-lamp-1`
4. Find entity: `switch.nightlight`

### Step 4: Create Dashboard Card

1. **Overview → Edit Dashboard → Add Card**
2. Card Type: "**Button**" or "**Light**"
3. Entity: `switch.nightlight`
4. Icon: `mdi:lightbulb` or `mdi:lamp`
5. Name: "Nightlight"
6. Tap Action: Toggle

### Step 5: Test Automations

Create a simple automation:

```yaml
alias: "Test Nightlight Toggle"
trigger:
  - platform: time
    at: "20:00:00"  # 8:00 PM
action:
  - service: switch.turn_on
    target:
      entity_id: switch.nightlight
  - delay: 5
  - service: switch.turn_off
    target:
      entity_id: switch.nightlight
```

---

## Understanding the Code

### Relay Switch Platform

```yaml
switch:
  - platform: gpio         # GPIO output (digital HIGH/LOW)
    pin: GPIO4             # Control pin for relay IN
    name: "Nightlight"     # Name in Home Assistant
    id: nightlight_switch  # Internal ID for scripts/automations
    icon: "mdi:lightbulb"  # Material Design Icon
```

### Restore Mode

```yaml
restore_mode: RESTORE_DEFAULT_OFF
```

**What is Restore Mode?**
Controls the relay's state after power loss (e.g., power outage, ESP32 reboot).

**Options:**
- **RESTORE_DEFAULT_OFF** - Turn OFF after reboot (safe default)
- **RESTORE_DEFAULT_ON** - Turn ON after reboot (useful for always-on devices)
- **ALWAYS_OFF** - Force OFF (ignore previous state)
- **ALWAYS_ON** - Force ON (useful for critical devices)

**Example Scenario:**
1. Nightlight is ON
2. Power outage occurs
3. Power restored
4. With `RESTORE_DEFAULT_OFF`: Nightlight stays OFF
5. With `RESTORE_DEFAULT_ON`: Nightlight turns back ON

**Recommendation:** Use `RESTORE_DEFAULT_OFF` for safety (don't surprise users with lights turning on).

### Interlock (Mutual Exclusion)

```yaml
switch:
  - platform: gpio
    pin: GPIO4
    id: relay1
    interlock: [relay2, relay3]  # Can't turn on if relay2 or relay3 is on
    interlock_wait_time: 100ms   # Wait 100ms before switching
```

**Use Case:** Prevent two relays from being ON simultaneously (e.g., heating and cooling).

---

## Troubleshooting

### Relay clicks but LED strip doesn't light up

**Check 1: Polarity**
- Verify +12V goes to LED strip red wire
- Verify GND goes to LED strip black wire
- Swap wires if reversed

**Check 2: Relay Terminal**
- Ensure you're using **NO (Normally Open)**, not NC (Normally Closed)
- Power supply +12V → COM
- NO → LED strip +12V

**Check 3: Power Supply**
- Test power supply with multimeter (should read 12V DC)
- Check if power supply is plugged in and switched on
- Try a different power supply

**Check 4: LED Strip**
- Test LED strip directly with power supply (bypass relay)
- If strip doesn't light, strip may be faulty

### Relay doesn't click when toggled

**Check 1: Relay Control Wiring**
- Verify GPIO4 → Relay IN
- Verify GND → Relay GND
- Verify 5V → Relay VCC (some relays need 5V, not 3.3V)

**Check 2: GPIO Pin**
- Try different GPIO pin (GPIO5, GPIO16, GPIO17)
- Update YAML `pin: GPIO5`

**Check 3: Relay Module Power**
- Some relay modules have a jumper for VCC selection (3.3V vs. 5V)
- Check relay module documentation

**Check 4: Inverted Logic**
- Some relays are active-LOW (trigger with 0V instead of 3.3V)
- Try adding `inverted: true` to pin config:
  ```yaml
  pin:
    number: GPIO4
    inverted: true
  ```

### ESP32 reboots when relay switches

**Cause:** Relay coil draws too much current, causing voltage drop.

**Fix:**
1. **Use external power for relay:**
   - Don't power relay from ESP32 5V pin
   - Use separate 5V power supply for relay module
   - Share GND between ESP32 and relay power supply

2. **Add decoupling capacitor:**
   - Place 100µF capacitor between ESP32 5V and GND (near relay)

3. **Use optocoupled relay:**
   - Most relay modules have optocouplers (isolated)
   - Verify your module has optocoupler IC (usually PC817 or similar)

---

## Phase 2: AC Lamp Control (Advanced)

**⚠️ DANGER: This section involves 120V AC mains voltage. Risk of electrocution.**

### Safety Requirements

Before proceeding:
- ✅ Completed Phase 1 successfully
- ✅ Have basic electrical knowledge
- ✅ Understand AC wiring color codes (black = hot, white = neutral, green = ground)
- ✅ Know how to use a voltage tester
- ✅ Have appropriate tools (wire strippers, screwdrivers, multimeter)
- ✅ Relay module rated for AC (10A @ 120V minimum)

**If any box is unchecked, do NOT proceed. Hire an electrician.**

### AC Wiring Diagram

```
AC Outlet (120V)              Relay Module (NO)           Lamp Socket

Hot (Black) ----> COM
                               NO -----> Hot (Black) to Lamp
Neutral (White) --------------------------------> Neutral (White) to Lamp
Ground (Green) ----------------------------------> Ground (Green) to Lamp


ESP32 (Control)               Relay Module

   GPIO4 --------> IN
   GND ----------> GND
   5V -----------> VCC
```

**Critical Safety Rules:**
1. **Turn OFF circuit breaker** before working on wiring
2. **Test with voltage tester** to confirm power is off
3. **Never touch exposed wires** while circuit is live
4. **Use wire nuts** for all connections (no electrical tape alone)
5. **Mount relay in electrical box** (not exposed)
6. **Follow local electrical codes** (may require licensed electrician)

### AC Wiring Steps

1. **Turn OFF circuit breaker** for outlet
2. **Test outlet with voltage tester** (should read 0V)
3. **Cut lamp cord** (near plug, not near lamp)
4. **Strip wires** (1/2 inch of insulation)
5. **Connect to relay:**
   - AC Hot (black) → Relay COM
   - Relay NO → Lamp Hot (black)
   - AC Neutral (white) → Lamp Neutral (white) (direct connection, bypasses relay)
   - AC Ground (green) → Lamp Ground (green) (direct connection)
6. **Secure connections with wire nuts**
7. **Mount relay in electrical box** (secure with screws)
8. **Close box and verify no exposed wires**
9. **Turn ON circuit breaker**
10. **Test with voltage tester** (relay COM should read 120V when circuit is on)
11. **Toggle relay in Home Assistant**
12. **Lamp should turn on/off**

**Note:** Only the "hot" wire (black) is switched by the relay. Neutral and ground are always connected.

---

## Creating Automations

### Automation 1: Sunset to Sunrise

Turn nightlight ON at sunset, OFF at sunrise.

```yaml
alias: "Nightlight Auto Schedule"
trigger:
  # Turn ON at sunset
  - platform: sun
    event: sunset
    offset: "-00:30:00"  # 30 minutes before sunset
action:
  - service: switch.turn_on
    target:
      entity_id: switch.nightlight

---
# Separate automation to turn OFF
alias: "Nightlight Auto Off"
trigger:
  - platform: sun
    event: sunrise
    offset: "00:30:00"  # 30 minutes after sunrise
action:
  - service: switch.turn_off
    target:
      entity_id: switch.nightlight
```

### Automation 2: Motion-Activated Night Light

Turn on nightlight when motion detected (only between 10 PM - 6 AM).

```yaml
alias: "Motion Night Light"
trigger:
  - platform: state
    entity_id: binary_sensor.motion_sensor_living_room
    to: "on"
condition:
  - condition: time
    after: "22:00:00"  # After 10 PM
    before: "06:00:00"  # Before 6 AM
action:
  - service: switch.turn_on
    target:
      entity_id: switch.nightlight
  # Auto-off after 5 minutes of no motion
  - wait_for_trigger:
      - platform: state
        entity_id: binary_sensor.motion_sensor_living_room
        to: "off"
        for:
          minutes: 5
  - service: switch.turn_off
    target:
      entity_id: switch.nightlight
```

### Automation 3: Sleep Timer

Turn off nightlight after 30 minutes (bedtime).

```yaml
alias: "Nightlight Sleep Timer"
trigger:
  - platform: state
    entity_id: switch.nightlight
    to: "on"
action:
  - delay:
      minutes: 30
  - service: switch.turn_off
    target:
      entity_id: switch.nightlight
```

### Automation 4: Voice Control (Google Home/Alexa)

After integrating Home Assistant with Google Home or Alexa:

1. **Google Home:**
   - Go to Google Home app → Add device → Works with Google → Home Assistant
   - Find "Nightlight" in device list
   - Say: "Hey Google, turn on the nightlight"

2. **Alexa:**
   - Go to Alexa app → Skills → Home Assistant
   - Discover devices
   - Say: "Alexa, turn on the nightlight"

**Customize Voice Name:**
In Home Assistant, rename entity to something shorter:
- `switch.nightlight` → "Lamp" or "Light"
- Voice command: "Turn on the light" (shorter, easier)

---

## Next Steps & Enhancements

### Enhancement 1: Add Dimming (PWM)

For 12V LED strips, add dimming control:

```yaml
output:
  - platform: ledc  # PWM output
    pin: GPIO4
    id: lamp_output
    frequency: 1000 Hz

light:
  - platform: monochromatic
    name: "Dimmable Nightlight"
    output: lamp_output
    gamma_correct: 1.0  # Brightness curve adjustment
```

Now you can set brightness 0-100%!

**Note:** This requires removing the relay and controlling LED strip directly with a MOSFET (see [Project 9: RGB Mood Lighting](09-rgb-lighting.md)).

### Enhancement 2: RGB LED Strip

Control color-changing LED strips:

```yaml
light:
  - platform: rgb
    name: "RGB Nightlight"
    red: red_output
    green: green_output
    blue: blue_output
```

See [Project 9: RGB Mood Lighting](09-rgb-lighting.md) for full guide.

### Enhancement 3: Multiple Relays (4-channel module)

Control 4 lamps independently:

```yaml
switch:
  - platform: gpio
    pin: GPIO4
    name: "Lamp 1"
  - platform: gpio
    pin: GPIO5
    name: "Lamp 2"
  - platform: gpio
    pin: GPIO16
    name: "Lamp 3"
  - platform: gpio
    pin: GPIO17
    name: "Lamp 4"
```

### Enhancement 4: Power Monitoring

Add a power monitoring relay (e.g., Sonoff Pow R2) to track energy usage.

---

## What You've Learned

By completing this project, you now understand:

✅ **Relay Control:**
- How relays work (electromechanical switches)
- Optocoupler isolation
- COM, NO, NC terminals

✅ **Electrical Safety:**
- Low-voltage vs. high-voltage wiring
- AC mains hazards
- Safe wiring practices

✅ **Home Assistant Switches:**
- Switch entities vs. light entities
- Restore modes (power loss behavior)
- Interlock for mutual exclusion

✅ **Automations:**
- Time-based schedules
- Sunset/sunrise triggers
- Motion-activated lighting
- Voice control integration

✅ **Power Management:**
- Calculating load requirements (amps, watts)
- Relay current ratings
- Proper power supply sizing

**Ready for the next project?** Try [Project 4: Presence Detection](04-presence-detection.md) to add motion sensing!
