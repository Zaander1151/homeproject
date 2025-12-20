# ESP32 Wiring Standards & Guidelines

**Version:** 1.0
**Last Updated:** December 2024

## Purpose

This document establishes consistent wiring color standards for all ESP32 and electronics projects. Following these guidelines will:

- **Improve readability** - Instantly recognize connections by color
- **Reduce errors** - Prevent accidental shorts and miswiring
- **Speed up troubleshooting** - Trace connections visually
- **Enable collaboration** - Anyone can understand your wiring
- **Create professional documentation** - Consistent photos and diagrams

---

## Standard Wire Color Codes

### Power Rails

| Connection | Wire Color | Notes |
|------------|------------|-------|
| **GND (Ground)** | **Black** | Always black - no exceptions! |
| **3.3V** | **Red** | Primary power for ESP32 logic |
| **5V** | **Orange** or **Red with stripe** | Secondary power (sensors, servos) |
| **VIN (Battery/External)** | **Brown** | Raw input voltage |

**Why these colors?**
- **Black = Ground** - Universal electronics standard
- **Red = Positive** - Standard for primary voltage
- **Orange = 5V** - Distinguishes from 3.3V to prevent damage
- **Brown = Raw power** - Indicates unregulated voltage

### Data & Signal Lines

| Connection Type | Wire Color | Usage |
|----------------|------------|-------|
| **I2C SDA (Data)** | **Yellow** | I2C data line |
| **I2C SCL (Clock)** | **Green** | I2C clock line |
| **SPI MOSI** | **Blue** | Master Out, Slave In |
| **SPI MISO** | **Purple** | Master In, Slave Out |
| **SPI SCK** | **Green** | SPI clock |
| **SPI CS** | **White** | Chip select |
| **UART TX** | **Blue** | Transmit data |
| **UART RX** | **Purple** | Receive data |
| **Single GPIO** | **Yellow** | General purpose I/O |
| **Analog Input** | **Gray** | ADC readings |
| **PWM Output** | **Teal/Cyan** | Pulse width modulation |

### Special Connections

| Connection | Wire Color | Usage |
|------------|------------|-------|
| **Reset** | **White** | Reset/RST pins |
| **Enable/Chip Enable** | **White with stripe** | EN pins |
| **Interrupt Pins** | **Pink** | External interrupts |
| **Speaker/Audio Out** | **Teal** | Audio signals |
| **LED Control** | **Cyan** or **Yellow** | LED data/control |

---

## Color Code Quick Reference Card

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
         ESP32 WIRING COLOR STANDARDS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

POWER:
  ████ BLACK     = GND (Ground) - Always!
  ████ RED       = 3.3V (Primary)
  ████ ORANGE    = 5V (Secondary)
  ████ BROWN     = VIN/Battery

I2C BUS:
  ████ YELLOW    = SDA (Data)
  ████ GREEN     = SCL (Clock)

SPI BUS:
  ████ BLUE      = MOSI (Master Out)
  ████ PURPLE    = MISO (Master In)
  ████ GREEN     = SCK (Clock)
  ████ WHITE     = CS (Chip Select)

SERIAL (UART):
  ████ BLUE      = TX (Transmit)
  ████ PURPLE    = RX (Receive)

GENERAL:
  ████ YELLOW    = GPIO/Data
  ████ GRAY      = Analog Input
  ████ TEAL      = PWM/Audio
  ████ WHITE     = Reset/Enable
  ████ PINK      = Interrupts

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Print and keep near your workbench!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Wiring Practices

### 1. Power Distribution

**Best Practice: Power Rails First**

Always establish power rails before connecting signal lines:

```
Step 1: Connect ESP32 3V3 → Breadboard + rail (RED wire)
Step 2: Connect ESP32 GND → Breadboard - rail (BLACK wire)
Step 3: Connect all device VCC pins to + rail (RED wires)
Step 4: Connect all device GND pins to - rail (BLACK wires)
Step 5: Connect signal lines (colored wires)
```

**Why?**
- Ensures all devices have proper power before signals
- Reduces risk of floating inputs damaging devices
- Easier to troubleshoot power issues

### 2. Wire Length Management

| Wire Length | Use Case | Notes |
|-------------|----------|-------|
| **2-3 cm** | Breadboard jumpers | Adjacent rows |
| **5-10 cm** | Nearby components | Same breadboard area |
| **15-20 cm** | Across breadboard | Opposite sides |
| **30+ cm** | Off-board sensors | Keep as short as possible |

**Best Practices:**
- ✅ Use pre-cut jumper wire kits (various lengths)
- ✅ Keep I2C/SPI wires **< 20cm** for reliability
- ✅ Bundle parallel wires together (use wire ties)
- ❌ Avoid excess wire length (creates antenna for noise)
- ❌ Don't stretch wires tight (causes breakage)

### 3. Wire Routing

**Good Wire Routing:**
```
┌─────────────────────────────────────┐
│  ESP32         Component             │
│                                      │
│   3V3 ─RED──────┐                   │
│   GND ─BLK──┐   │                   │
│   D6  ─YEL──┼───┼──→ SDA            │
│   D7  ─GRN──┼───┼──→ SCL            │
│             │   │                   │
│             │   └──→ VCC            │
│             └──────→ GND            │
│                                      │
│  (Wires run along edges, no crossing)│
└─────────────────────────────────────┘
```

**Poor Wire Routing:**
```
┌─────────────────────────────────────┐
│  ESP32         Component             │
│                                      │
│   3V3 ─RED─┐ ┌───────→ VCC          │
│   GND ─BLK─┼─┼─┐─────→ GND          │
│   D6  ─YEL─┼─┼─┼───┐→ SDA           │
│   D7  ─GRN─┼─┼─┼───┼→ SCL           │
│            └─┼─┘   │                │
│              └─────┘                │
│                                      │
│  (Tangled wires, hard to trace!)    │
└─────────────────────────────────────┘
```

**Routing Rules:**
- ✅ Group power wires together (red/black/orange)
- ✅ Group data wires together (yellow/green/blue)
- ✅ Run wires along breadboard edges
- ✅ Use right-angle turns (not diagonal)
- ❌ Avoid crossing wires over components
- ❌ Don't create "wire spaghetti" in center

### 4. Connection Order

**Safe Connection Sequence:**

1. **Power OFF** - Unplug USB before wiring
2. **Ground first** - Connect all GND connections
3. **Power second** - Connect 3.3V/5V connections
4. **Signals last** - Connect data/control lines
5. **Double-check** - Verify connections before power-on
6. **Power ON** - Plug in USB and test

**When Disconnecting:**

1. **Power OFF** - Unplug USB first
2. **Signals first** - Remove data lines
3. **Power second** - Remove voltage lines
4. **Ground last** - Remove ground connections

**Why this order?**
- Prevents voltage spikes during connection/disconnection
- Ground reference established before applying voltage
- Reduces risk of ESD (electrostatic discharge) damage

---

## Wire Gauge Recommendations

### Jumper Wires (Breadboard/Prototyping)

| Wire Gauge | Diameter | Max Current | Use Case |
|------------|----------|-------------|----------|
| **22 AWG** | 0.64mm | 7A | Power rails (preferred) |
| **24 AWG** | 0.51mm | 3.5A | Most breadboard work |
| **26 AWG** | 0.40mm | 2.2A | Signal lines only |
| **28 AWG** | 0.32mm | 1.4A | Fine-pitch connections |

**Recommendations:**
- **Power connections (3.3V/5V/GND):** Use **22 AWG or 24 AWG**
- **Signal lines (I2C, SPI, GPIO):** Use **24 AWG or 26 AWG**
- **Long wire runs (>50cm):** Use **22 AWG** to reduce resistance

### Solid vs Stranded Wire

| Type | Advantages | Disadvantages | Best For |
|------|------------|---------------|----------|
| **Solid Core** | Stays in breadboard holes, neat appearance | Breaks with repeated bending | Breadboard prototyping |
| **Stranded** | Flexible, durable | Doesn't stay in breadboard well | Permanent installations, moving parts |

**Use solid core for:**
- Breadboard prototyping (all projects in this guide)
- Static connections that won't move

**Use stranded for:**
- Connections to moving parts (servo wires, robot arms)
- Permanent soldered connections
- Off-board sensors with flex (door sensors, etc.)

---

## Connector Standards

### Dupont Connectors (Pre-Made Jumpers)

Common configurations:

- **Male-to-Male (M-M):** Breadboard to breadboard
- **Male-to-Female (M-F):** Breadboard to component with header pins
- **Female-to-Female (F-F):** Component to component

**Color Kit Recommendations:**
- Buy jumper wire kits with **10 colors minimum**
- Keep each color in separate organizer compartments
- Label compartments with wire function (GND, 3.3V, I2C SDA, etc.)

### JST Connectors (Permanent Connections)

For projects moving from breadboard to enclosure:

| Connector Type | Pitch | Use Case |
|----------------|-------|----------|
| **JST-XH** | 2.5mm | Battery connections |
| **JST-PH** | 2.0mm | Small sensors (I2C, UART) |
| **JST-SH** | 1.0mm | Compact devices (Qwiic/STEMMA QT) |

**Wire colors for JST connectors:**
- Follow same color code (black=GND, red=3.3V/5V, etc.)
- **Exception:** Pre-made JST cables may have manufacturer colors

---

## Special Cases & Exceptions

### Qwiic/STEMMA QT (I2C Standard Connectors)

**Standard Wire Colors:**
- **Black** = GND
- **Red** = 3.3V
- **Blue** = SDA
- **Yellow** = SCL

**Note:** These differ slightly from our standard (we use yellow=SDA, green=SCL), but Qwiic cables are pre-made. When making your own I2C connections, use **yellow=SDA, green=SCL** for consistency.

### Servo Motors (3-Wire)

**Standard Servo Wire Colors:**
- **Brown/Black** = GND
- **Red** = 5V (power)
- **Orange/Yellow/White** = Signal (PWM)

**Note:** Servo wire colors vary by manufacturer! Always verify with a multimeter before connecting.

### RGB LEDs (Common Anode/Cathode)

**Common Cathode (GND shared):**
- **Black/Blue** = Common cathode (GND)
- **Red** = Red LED
- **Green** = Green LED
- **Blue** = Blue LED

**Common Anode (VCC shared):**
- **Red** = Common anode (VCC)
- **Varies** = R, G, B pins

### WS2812B/NeoPixel LED Strips

**Standard:**
- **White/Black** = GND
- **Red** = 5V
- **Green/Yellow** = Data (DIN)

**Note:** Some strips use JST connectors with different colors!

---

## Safety & Best Practices

### Voltage Safety Rules

| Rule | Reason |
|------|--------|
| **NEVER connect 5V to ESP32 GPIO** | ESP32 is 3.3V logic - 5V will damage it! |
| **Use level shifters for 5V devices** | Protect 3.3V ESP32 from 5V signals |
| **Check polarity before power-on** | Reversed polarity = magic smoke |
| **Don't mix 3.3V and 5V on same rail** | Will damage 3.3V devices |
| **Use fuses for high-current loads** | Prevent fire hazards |

### Wiring Checklist (Before Power-On)

Print this checklist and keep it at your workbench:

```
┌──────────────────────────────────────────────────┐
│         PRE-POWER-ON WIRING CHECKLIST            │
├──────────────────────────────────────────────────┤
│                                                  │
│  Power Connections:                              │
│    [ ] GND (black) connected to - rail           │
│    [ ] 3.3V (red) connected to + rail            │
│    [ ] No 5V connected to ESP32 GPIO pins        │
│    [ ] All device GND connected to GND rail      │
│    [ ] All device VCC connected to correct rail  │
│                                                  │
│  Signal Connections:                             │
│    [ ] I2C SDA (yellow) to correct GPIO          │
│    [ ] I2C SCL (green) to correct GPIO           │
│    [ ] No shorts between adjacent pins           │
│    [ ] Wire colors match documentation           │
│                                                  │
│  Safety:                                         │
│    [ ] No loose wires touching metal             │
│    [ ] No exposed wire strands                   │
│    [ ] Polarity verified with multimeter         │
│    [ ] Component datasheets consulted            │
│    [ ] Current draw calculated (< USB limit)     │
│                                                  │
│  Testing:                                        │
│    [ ] Visual inspection complete                │
│    [ ] Photos taken (for documentation)          │
│    [ ] Multimeter continuity test (GND to GND)   │
│    [ ] Multimeter resistance test (no shorts)    │
│                                                  │
│  Ready to power on: YES [ ]  NO [ ]              │
│                                                  │
└──────────────────────────────────────────────────┘
```

### Common Wiring Mistakes

| Mistake | Symptom | Prevention |
|---------|---------|------------|
| **Reversed power** | Component gets hot, smoke | Use red/black consistently |
| **5V to ESP32 GPIO** | ESP32 dead | Never connect 5V to GPIO |
| **Floating GND** | Erratic behavior, random resets | All devices share common GND |
| **Loose breadboard connection** | Intermittent failures | Push wires firmly, use solid core |
| **Wire too long** | I2C/SPI errors | Keep data wires < 20cm |
| **Crossed SDA/SCL** | I2C devices not found | Yellow=SDA, Green=SCL |
| **Missing pull-up resistors** | I2C fails | Add 4.7kΩ resistors or use modules with built-in |

---

## Documentation Standards

### Photographing Your Wiring

**Best Practices:**
1. **Clean the workspace** - Remove clutter
2. **Good lighting** - Use desk lamp or natural light
3. **Multiple angles** - Top view + side view
4. **Close-ups** - Show critical connections
5. **Color accuracy** - Auto white balance ON
6. **Annotations** - Add arrows in image editor

**Photo Checklist:**
- [ ] Top-down view (shows entire circuit)
- [ ] Close-up of ESP32 connections
- [ ] Close-up of each component
- [ ] Power rail connections visible
- [ ] Wire colors clearly distinguishable

### Wiring Diagrams (ASCII Art)

When creating text-based wiring diagrams:

**Use these symbols:**
```
ESP32 Pin:  ●
Wire:       ─── or ━━━
Connection: ┬ ┴ ├ ┤ ┼
Component:  [SENSOR] or ┌───┐
                        │   │
                        └───┘
Rail:       ═══════════════
```

**Example:**
```
ESP32                    DHT22 Sensor
                         ┌──────────┐
3V3 ──RED───────────────>│ VCC      │
                         │          │
GND ──BLACK──────────────>│ GND      │
                         │          │
GPIO4 ──YELLOW──────────>│ DATA     │
                         └──────────┘
```

### Fritzing Diagrams (Optional)

For permanent documentation, consider learning Fritzing:
- Creates professional breadboard diagrams
- Shows actual component appearances
- Exports to PNG/PDF
- Free and open-source

**Link:** https://fritzing.org

---

## Wire Labeling

### When to Label Wires

**Always label when:**
- Wire runs > 30cm
- Multiple identical wires
- Permanent installations (moving from breadboard to enclosure)
- Debugging complex circuits

**Labeling Methods:**

1. **Heat-shrink labels**
   - Professional appearance
   - Durable
   - Requires heat gun

2. **Masking tape + marker**
   - Quick and easy
   - Removable
   - Good for prototyping

3. **Wire markers (write-on tabs)**
   - Reusable
   - Professional
   - More expensive

4. **Color-coded heat shrink**
   - Reinforces wire color meaning
   - Very durable

**Label Content:**
```
Format: [SOURCE] → [DESTINATION] ([FUNCTION])

Examples:
  "ESP32 D6 → AHT10 SDA (I2C)"
  "GND → OLED GND"
  "3.3V → Sensor Rail"
```

---

## Wire Organization & Storage

### Workbench Organization

**Recommended Setup:**

```
┌─────────────────────────────────────────────┐
│  Wire Storage Organizer (by color)          │
├─────┬─────┬─────┬─────┬─────┬─────┬─────┬───┤
│ BLK │ RED │ ORG │ YEL │ GRN │ BLU │ PUR │...│
│(GND)│(3V3)│(5V) │(SDA)│(SCL)│(TX) │(RX) │   │
└─────┴─────┴─────┴─────┴─────┴─────┴─────┴───┘

Compartment Labels:
  - Wire color
  - Wire function
  - Wire gauge (if multiple gauges)
```

**Storage Options:**
- Plastic organizer boxes (fishing tackle boxes work great!)
- Drawer organizers with dividers
- Resealable bags (labeled)
- 3D-printed wire dispensers

### Pre-Cut Wire Kits

**Recommended Lengths to Pre-Cut:**
- 5cm (x10 of each color)
- 10cm (x10 of each color)
- 15cm (x10 of each color)
- 20cm (x5 of each color)

**How to Pre-Cut:**
1. Cut wires to exact length
2. Strip 5mm from each end
3. Store in labeled compartments by length AND color
4. Refill when running low

**Benefits:**
- Faster prototyping
- Neater breadboard layouts
- Consistent appearance
- Easier troubleshooting

---

## Color Blindness Considerations

### Alternative Identification Methods

For those with color vision deficiencies:

**1. Wire Labeling**
- Always label critical wires (see "Wire Labeling" section)
- Use text labels in addition to colors

**2. Pattern-Based Identification**
```
GND:    Solid black       ████████
3.3V:   Solid red         ████████
5V:     Striped red       ▓▓▓▓▓▓▓▓
I2C:    Use striped       ▓▓░░▓▓░░
```

**3. Position-Based System**
- Always route GND on leftmost side
- Power next to GND
- Data lines on rightmost side

**4. Texture-Based Markers**
- Textured heat shrink for power lines
- Smooth heat shrink for data lines

**5. Multimeter Testing**
- Use continuity mode to verify connections
- Don't rely on color alone

---

## Quick Reference for Common Projects

### I2C Device Wiring (Standard)

**Every I2C device uses the same 4 wires:**

```
ESP32                    I2C Device (Any)

3V3 ──RED──────────────> VCC
GND ──BLACK────────────> GND
D6  ──YELLOW───────────> SDA
D7  ──GREEN────────────> SCL
```

**Examples:** OLED displays, AHT10, BME280, BH1750, etc.

### SPI Device Wiring (Standard)

**Every SPI device uses 6-7 wires:**

```
ESP32                    SPI Device

3V3 ──RED──────────────> VCC
GND ──BLACK────────────> GND
D23 ──BLUE─────────────> MOSI
D19 ──PURPLE───────────> MISO
D18 ──GREEN────────────> SCK
D5  ──WHITE────────────> CS
```

**Examples:** SD cards, NRF24L01 radio, LoRa modules

### UART/Serial Device

```
ESP32                    UART Device

3V3 ──RED──────────────> VCC
GND ──BLACK────────────> GND
TX  ──BLUE─────────────> RX (crossed!)
RX  ──PURPLE───────────> TX (crossed!)
```

**Note:** TX connects to RX and vice versa!

### DHT22 Sensor (1-Wire)

```
ESP32                    DHT22

3V3 ──RED──────────────> VCC
GND ──BLACK────────────> GND
GPIO4 ──YELLOW─────────> DATA
        ┌──────┐
        │ 10kΩ │ (Pull-up resistor)
        └──────┘
          │
3V3 ──────┘
```

### WS2812B LED Strip

```
ESP32                    LED Strip

5V  ──ORANGE───────────> 5V (VCC)
GND ──BLACK────────────> GND
GPIO8 ──┬──────────────> DIN (Data)
        │
     [470Ω]
     Resistor
```

---

## Troubleshooting by Wire Color

### If Something Isn't Working...

**Check black (GND) wires first:**
- Verify common ground between all devices
- Check breadboard rail continuity
- Ensure ESP32 GND connected to rail

**Check red (3.3V) wires:**
- Measure voltage at device VCC pin (should be 3.2-3.4V)
- Check for shorts to ground (would read 0V)
- Verify current capacity (USB provides max 500mA)

**Check orange (5V) wires:**
- Verify device actually needs 5V (not 3.3V)
- Check ESP32 not connected to 5V (damage!)
- Measure voltage (should be 4.8-5.2V)

**Check yellow/green (I2C) wires:**
- Verify SDA/SCL not swapped
- Check for pull-up resistors (4.7kΩ)
- Measure wire length (< 20cm preferred)

**Check blue/purple (SPI/UART) wires:**
- Verify TX→RX and RX→TX (crossed for UART)
- Check for correct MOSI/MISO (not crossed for SPI)
- Verify clock signal present

---

## Upgrading from Breadboard to PCB

### When Prototyping Works, Make it Permanent

**Wire Color Continuity:**
- Keep same wire colors when moving to perfboard/PCB
- Makes comparing to breadboard prototype easier
- Simplifies troubleshooting

**PCB Design Tools:**
- **KiCad** - Free, professional, auto-routing
- **EasyEDA** - Web-based, JLCPCB integration
- **Fritzing** - Breadboard→PCB workflow

**Wire Color in PCB:**
- Power planes: Use red/black silkscreen labels
- Traces: Use colored silkscreen to mark I2C/SPI
- Headers: Label with wire color references

---

## Printable Quick Reference

### Color Code Sticker (for Workbench)

```
┌────────────────────────────────────────────────┐
│   ESP32 WIRE COLOR QUICK REFERENCE             │
├────────────────────────────────────────────────┤
│                                                │
│  POWER:                                        │
│    ● ████ BLACK   = GND (Ground)               │
│    ● ████ RED     = 3.3V                       │
│    ● ████ ORANGE  = 5V                         │
│                                                │
│  I2C:                                          │
│    ● ████ YELLOW  = SDA (Data)                 │
│    ● ████ GREEN   = SCL (Clock)                │
│                                                │
│  UART:                                         │
│    ● ████ BLUE    = TX (Transmit)              │
│    ● ████ PURPLE  = RX (Receive)               │
│                                                │
│  GENERAL:                                      │
│    ● ████ YELLOW  = GPIO/Signal                │
│    ● ████ GRAY    = Analog                     │
│                                                │
│  ⚠️  NEVER connect 5V to ESP32 GPIO!           │
│  ⚠️  All devices MUST share common GND!        │
│                                                │
└────────────────────────────────────────────────┘
```

**Print this and laminate it!** Keep it visible at your workbench.

---

## Summary

### The Golden Rules

1. ⚫ **Black = GND** - No exceptions, ever!
2. 🔴 **Red = 3.3V** - Primary power for ESP32
3. 🟠 **Orange = 5V** - Secondary power (when needed)
4. 🟡 **Yellow = I2C SDA** - Data line
5. 🟢 **Green = I2C SCL** - Clock line
6. 🔵 **Blue = UART TX** - Transmit
7. 🟣 **Purple = UART RX** - Receive

### Benefits of Following These Standards

✅ **Faster builds** - Grab the right color wire instantly
✅ **Fewer mistakes** - Visual confirmation of connections
✅ **Easier debugging** - Trace signals by color
✅ **Better documentation** - Photos and diagrams are clear
✅ **Professional results** - Consistent, clean wiring
✅ **Collaboration ready** - Others can understand your work

### Getting Started

**Immediate Actions:**
1. Organize your wire collection by color
2. Print the quick reference card
3. Label wire storage compartments
4. Pre-cut wires in standard lengths
5. Use these standards in your next project!

---

## Additional Resources

**Online Tools:**
- [Wire Gauge Calculator](https://www.powerstream.com/Wire_Size.htm)
- [Resistor Color Code Calculator](https://www.digikey.com/en/resources/conversion-calculators/conversion-calculator-resistor-color-code)
- [Voltage Divider Calculator](https://ohmslawcalculator.com/voltage-divider-calculator)

**Standards References:**
- IEC 60757 - Electronic component color codes
- EIA RS-359 - Electronic wiring color codes
- ANSI/TIA-598-C - Fiber optic cable color coding

**Community:**
- r/AskElectronics - Reddit community for questions
- ESP32 Forum - Official Espressif forum
- EEVblog Forums - Electronics engineering discussions

---

**Last Updated:** December 2024
**Version:** 1.0
**Maintained by:** Home Automation Project Documentation

*This standard is a living document. Suggestions for improvements welcome!*
