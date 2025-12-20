# Electronics Workbench Build Guide

> **⚠️ NOTE:** This document has been consolidated into a comprehensive guide.
>
> **See:** [`/home/hazzard/homeproject/docs-web/electronics-workbench-complete-guide.md`](/home/hazzard/homeproject/docs-web/electronics-workbench-complete-guide.md)
>
> The new guide combines:
> - This general equipment guide
> - Your personalized lab plan
> - Workbench layout recommendations
> - Current inventory status
> - Shopping priorities
>
> This file is kept for reference but the consolidated guide is now the primary resource.

---

**Last Updated:** 2025-12-07
**Status:** Workbench actively built and in use
**Consolidated:** 2025-12-07

---

## Current Inventory Status

### ✅ **OWNED & IN USE**

**Workbench Setup:**
- IKEA Karlby countertop (~6ft) on 2x IKEA Alex drawers
- Overhead LED ceiling light
- Magnifying lamp (clamp-style)
- Office chair (upgrade desired)
- Power strip with surge protection

**Soldering Station:**
- Weller WLSK3012A soldering station
- Solder (both leaded and lead-free)
- Soldering stand (no tip cleaner)
- Helping hands + magnifier lamp
- Silicone heat-resistant mat
- Fume extractor

**Test Equipment:**
- Nawei NP3010 bench power supply (0-30V, 0-10A)
- Multimeter (digital, auto-ranging)
- LCR meter / component tester

**Development Boards:**
- 5x ESP32 DevKit v1
- 5x ESP32-S3
- 3x M5Stack Atom Echo (voice assistants)

**Components:**
- 600pc resistor kit
- 15-value capacitor kit
- 200pc transistor kit
- LED assortment
- Diode kit
- Logic ICs (SN74HC00N series)
- Large button/switch selection
- 460pc JST-XH connector kit

**Sensors & Modules:**
- 1x PIR motion sensor (HC-SR501)
- Photoresistor light sensors
- 1x OLED display (0.96" I2C)
- 1x Relay module

**Prototyping:**
- 3x Full-size breadboards (830 point)
- Jumper wire kits (M-M, M-F, F-F)
- Stranded wire (5 colors, 10M each)
- Heat shrink tubing

**Cables:**
- ~10 Micro-USB cables
- 5 USB-C cables

**Hand Tools:**
- Wire cutters (flush cut)
- Wire strippers
- Needle nose pliers
- Precision screwdriver set
- Hobby knife
- Crimping tool

**Organization:**
- Gridfinity system in Alex drawers (in progress)
- Multiple clear parts boxes
- Cable ties

**Other Equipment:**
- Creality Ender-3 V3 3D printer
- Heat gun
- Safety glasses

### 🔧 **NEEDS ACQUISITION**
- ESD mat + wrist strap
- Brass tip cleaner, solder sucker, desoldering wick, tip tinner
- Precision tweezers
- Fire extinguisher
- USB power meter
- Logic analyzer
- Additional sensors (DHT22, BME280, ultrasonic)
- Servo motors, LED strips
- Solid core wire (22 AWG)
- Power supplies (5V/12V)

---

## Table of Contents
1. [Workspace Requirements](#workspace-requirements)
2. [Essential Tools](#essential-tools)
3. [Power & Testing Equipment](#power--testing-equipment)
4. [Components & Supplies](#components--supplies)
5. [Storage & Organization](#storage--organization)
6. [Safety Equipment](#safety-equipment)
7. [Optional Upgrades](#optional-upgrades)
8. [Budget Breakdown](#budget-breakdown)

---

## Workspace Requirements

### Physical Space
**Minimum:** 4' × 2' desk/table surface
**Ideal:** 6' × 2.5' dedicated workbench with overhead lighting

### Workbench Features
- **Height:** 28-30" (standard desk height) or 36-42" (standing/stool height)
- **Surface:** ESD-safe mat (24" × 36" minimum) or ESD-safe tabletop
- **Lighting:**
  - Overhead task light (LED, 5000K-6500K color temperature)
  - Magnifying lamp with adjustable arm (5x-10x magnification)
- **Power:**
  - 4-6 outlet power strip on desk
  - Surge protection required
  - USB charging ports (helpful but not essential)
- **Ventilation:**
  - Near window or have portable fan
  - Required for soldering fumes
- **Chair/Stool:**
  - Adjustable height
  - Back support for long sessions

### Environmental
- **Temperature:** Comfortable room temp (68-75°F)
- **Humidity:** Low to moderate (prevents corrosion)
- **Dust:** Keep workspace clean (compressed air helpful)
- **Static Control:** ESD mat + wrist strap for sensitive components

---

## Essential Tools

### Core Tools (Must Have)

#### Soldering Equipment
- [x] **Soldering Iron** - Temperature controlled (60-80W)
  - *Recommended:* Hakko FX-888D, Pinecil, TS-100
  - *Budget:* Any temperature-controlled station >50W
  - *Temperature range:* 200-450°C
  - **Cost:** $50-100 (good quality)
  - **YOUR SETUP:** ✅ Weller WLSK3012A

- [x] **Solder** - Leaded (easier) or lead-free
  - *Size:* 0.8mm or 1.0mm diameter
  - *Type:* 60/40 or 63/37 rosin core
  - **Cost:** $10-15
  - **YOUR SETUP:** ✅ Both leaded and lead-free

- [x] **Soldering Stand** - Helps prevent burns and tip damage
  - *Features:* Brass/steel wool tip cleaner
  - **Cost:** $10-20 (often included with iron)
  - **YOUR SETUP:** ✅ Stand included (no tip cleaner - consider adding brass wool)

- [x] **Helping Hands / PCB Holder**
  - *Type:* Third hand with clips and magnifier
  - *Alternative:* Dedicated PCB vice/holder
  - **Cost:** $10-25
  - **YOUR SETUP:** ✅ Helping hands + larger magnifier lamp

- [ ] **Solder Sucker / Desoldering Pump**
  - For fixing mistakes, removing components
  - **Cost:** $5-10
  - **STATUS:** ⚠️ Not owned - recommended for beginners

- [ ] **Desoldering Wick/Braid**
  - Copper braid for cleaning up solder
  - **Cost:** $5-10
  - **STATUS:** ⚠️ Not owned - recommended for beginners

#### Hand Tools
- [x] **Wire Cutters** - Flush cut type
  - *Use:* Trimming component leads, cutting wires
  - **Cost:** $8-15
  - **YOUR SETUP:** ✅ Owned

- [x] **Wire Strippers** - Adjustable or multi-size
  - *Size range:* 18-30 AWG
  - **Cost:** $10-20
  - **YOUR SETUP:** ✅ Owned

- [x] **Needle Nose Pliers**
  - *Use:* Bending leads, holding small parts
  - **Cost:** $8-15
  - **YOUR SETUP:** ✅ Owned

- [x] **Precision Screwdriver Set**
  - *Types:* Phillips, flathead, Torx (T5, T6, T8)
  - *For:* Opening enclosures, terminal blocks
  - **Cost:** $15-25
  - **YOUR SETUP:** ✅ Owned

- [ ] **Tweezers** - Fine point and curved
  - *Use:* Placing small components (SMD work)
  - **Cost:** $10-20 (set)
  - **STATUS:** ⚠️ Not owned - recommended for SMD work

- [x] **Hobby Knife / X-Acto Knife**
  - *Use:* Cutting, stripping insulation, cleaning PCBs
  - **Cost:** $5-10
  - **YOUR SETUP:** ✅ Owned

#### Electrical Tools
- [x] **Crimping Tool**
  - *For:* Dupont connectors, JST connectors
  - *Optional but very useful for clean connections*
  - **Cost:** $15-30
  - **YOUR SETUP:** ✅ Owned

- [ ] **USB to Serial Adapter** - CP2102 or CH340
  - *Use:* Flashing ESP32 boards without built-in USB
  - **Cost:** $5-10
  - **STATUS:** ℹ️ Not needed - ESP32 DevKit and ESP32-S3 have built-in USB

---

## Power & Testing Equipment

### Must Have

- [x] **Multimeter** - Digital, auto-ranging
  - *Measures:* Voltage, current, resistance, continuity
  - *Features:* Beeper for continuity, diode test
  - *Min range:* DC 0-20V, AC 0-250V, 0-10A, 0-20MΩ
  - *Recommended:* Fluke 115 ($$) or AstroAI/Etekcity ($)
  - **Cost:** $20-50 (budget), $150+ (professional)
  - **YOUR SETUP:** ✅ Owned

- [ ] **USB Power Meter** - Voltage/current monitor
  - *Use:* Check power consumption, verify 5V supply
  - *Features:* USB-A or USB-C passthrough
  - **Cost:** $10-20
  - **STATUS:** ⚠️ Not owned - useful for debugging power issues

- [x] **Bench Power Supply** - Variable DC (adjustable voltage/current)
  - *Specs:* 0-30V, 0-5A minimum
  - *Features:* Dual output helpful, current limiting
  - *Alternative:* USB power bank + breadboard power supply module
  - **Cost:** $40-100 (entry level), $150-300 (quality)
  - **YOUR SETUP:** ✅ Nawei NP3010 (0-30V, 0-10A) - Excellent choice!

- [ ] **Breadboard Power Supply Module**
  - *Output:* 3.3V and 5V rails
  - *Input:* USB or DC jack
  - **Cost:** $5-10
  - **STATUS:** ℹ️ Optional - bench power supply covers this need

### Highly Recommended

- [ ] **Logic Analyzer** - 8-channel USB type
  - *Use:* Debug I2C, SPI, UART communication
  - *Software:* PulseView, Saleae Logic
  - **Cost:** $10-15 (clone), $100+ (Saleae official)
  - **STATUS:** ⚠️ Not owned - very useful for debugging serial protocols

- [ ] **Oscilloscope** - Entry-level digital storage oscilloscope
  - *Use:* View waveforms, debug timing issues
  - *Budget:* DSO138 kit (~$25), USB scope (~$50-100)
  - *Quality:* Rigol DS1054Z (~$350) - excellent starter scope
  - **Priority:** Low for beginners, valuable for advanced projects
  - **Cost:** $25-500+
  - **STATUS:** ℹ️ Future upgrade - not critical for IoT projects

### Component Testing

- [x] **LCR Meter / Component Tester**
  - *Use:* Test resistors, capacitors, inductors, transistors
  - *Features:* Auto-identify component type and values
  - **Cost:** $15-30
  - **YOUR SETUP:** ✅ LCR meter owned

---

## Components & Supplies

### Microcontrollers & Development Boards

- [x] **ESP32 DevKit v1** (5-10 units)
  - *Pinout:* 38-pin or 30-pin
  - *Features:* CP2102/CH340 USB chip, breadboard compatible
  - **Cost:** $3-7 each (bulk cheaper)
  - **YOUR SETUP:** ✅ 5 units owned

- [x] **ESP32-S3** (NEW - upgraded boards)
  - *Advantages:* More powerful than ESP32, more GPIO, better performance
  - **Cost:** $4-8 each
  - **YOUR SETUP:** ✅ 5 units owned - Great upgrade!

- [ ] **ESP32-C3** (2-3 units) - Optional
  - *Advantages:* USB-C, smaller, cheaper, RISC-V architecture
  - **Cost:** $3-5 each
  - **STATUS:** ℹ️ Not owned - optional for compact projects

- [x] **M5Stack Atom Echo** (voice assistant platform)
  - *Use:* Compact voice assistant projects, built-in mic/speaker
  - **Cost:** $10-15 each
  - **YOUR SETUP:** ✅ 3 units owned (see CLAUDE.md for deployed devices)

### Prototyping Supplies

- [x] **Breadboards**
  - Full size (830 points): 2-3 units
  - Mini (400 points): 2-3 units
  - **Cost:** $2-5 each
  - **YOUR SETUP:** ✅ 3x full-size breadboards (830 point)

- [x] **Jumper Wire Kit**
  - Male-to-male: 100+ pieces
  - Male-to-female: 40-60 pieces
  - Female-to-female: 40-60 pieces
  - *Various lengths:* 10cm, 20cm, 30cm
  - **Cost:** $10-15 (full kit)
  - **YOUR SETUP:** ✅ Several kits of each type owned

- [ ] **Solid Core Wire** - 22 AWG
  - *Colors:* Red, black, yellow, green, blue, white
  - *Use:* Breadboard connections, neat wiring
  - **Cost:** $10-20 (assorted spools)
  - **STATUS:** ⚠️ Not owned - recommended for neat breadboard wiring

- [x] **Stranded Wire** - 22-24 AWG
  - *Use:* Flexible connections, longer runs
  - **Cost:** $10-15
  - **YOUR SETUP:** ✅ 5 colors, 10M each - well stocked!

### Passive Components (Get Assorted Kits)

- [x] **Resistor Kit** - 1/4W through-hole
  - *Values:* 10Ω - 1MΩ (E12 or E24 series)
  - *Most used:* 220Ω, 330Ω, 1kΩ, 4.7kΩ, 10kΩ
  - **Cost:** $10-15 (500-1000 piece kit)
  - **YOUR SETUP:** ✅ 600pc kit owned

- [x] **Capacitor Kit** - Ceramic and electrolytic
  - *Ceramic:* 10pF - 10μF
  - *Electrolytic:* 1μF - 1000μF, 16V-50V
  - *Most used:* 0.1μF (bypass), 10μF, 100μF
  - **Cost:** $10-15 (200-300 piece kit)
  - **YOUR SETUP:** ✅ 15-value kit owned

- [x] **LEDs** - Assorted colors, 5mm or 3mm
  - *Colors:* Red, green, blue, yellow, white
  - *Spec:* 20mA typical, 2-3.3V forward voltage
  - **Cost:** $8-12 (100-200 piece kit)
  - **YOUR SETUP:** ✅ LED assortment owned

- [x] **Diodes**
  - *Types:* 1N4001-1N4007 (rectifier), 1N4148 (signal)
  - **Cost:** $5-8 (50-100 pieces)
  - **YOUR SETUP:** ✅ Diode kit owned

### Active Components

- [x] **Transistors Kit**
  - *NPN:* 2N2222, 2N3904, BC547
  - *PNP:* 2N3906, BC557
  - *MOSFET:* IRLZ44N (logic level N-channel)
  - **Cost:** $10-15 (assorted kit)
  - **YOUR SETUP:** ✅ 200pc transistor kit owned

- [x] **Logic ICs** - Digital logic chips
  - *Examples:* SN74HC00N series (NAND gates, flip-flops, etc.)
  - **Cost:** Varies
  - **YOUR SETUP:** ✅ Selection of IC chips owned

- [x] **Buttons/Switches**
  - *Types:* Tactile push buttons, toggle switches
  - **Cost:** $10-15 (assorted kit)
  - **YOUR SETUP:** ✅ Large selection owned

- [ ] **Voltage Regulators**
  - *Types:* LM7805 (5V), AMS1117-3.3 (3.3V)
  - **Cost:** $5-10 (10 pieces each)
  - **STATUS:** ℹ️ Optional - bench power supply provides regulated voltages

### Sensors (Start Small, Add as Needed)

#### Beginner Sensors
- [ ] **DHT22** - Temperature/humidity (2-3 units)
  - **Cost:** $3-5 each
  - **STATUS:** ⚠️ Not owned - useful for environmental monitoring

- [x] **PIR Motion Sensor** - HC-SR501 (2-3 units)
  - **Cost:** $2-4 each
  - **YOUR SETUP:** ✅ 1 unit owned (see CLAUDE.md - 3x M5Stack PIR units also available)

- [ ] **Ultrasonic Sensor** - HC-SR04 (1-2 units)
  - **Cost:** $2-4 each
  - **STATUS:** ⚠️ Not owned - useful for distance measurement

#### Intermediate Sensors
- [ ] **BME280** - Temp/humidity/pressure, I2C (1-2 units)
  - **Cost:** $5-8 each
  - **STATUS:** ℹ️ Not owned (M5Stack ENVIV unit available - similar functionality)

- [x] **Light Sensor** - BH1750 I2C or photoresistor
  - **Cost:** $1-5
  - **YOUR SETUP:** ✅ Photoresistor sensors owned

- [ ] **Soil Moisture** - Capacitive type (2-3 units)
  - **Cost:** $3-5 each
  - **STATUS:** ℹ️ Not owned - optional for plant monitoring projects

### Actuators & Outputs

- [x] **Relay Modules**
  - *Types:* 1-channel, 2-channel, 4-channel
  - *Voltage:* 5V coil with optoisolation
  - *Start with:* 2-channel module (2 units)
  - **Cost:** $3-8 each
  - **YOUR SETUP:** ✅ 1 relay module owned

- [ ] **Servo Motors** - SG90 micro servos (2-3 units)
  - **Cost:** $2-4 each
  - **STATUS:** ⚠️ Not owned - useful for motorized projects

- [ ] **WS2812B LED Strip** - Addressable RGB
  - *Length:* 1m or 5m (60 LEDs/m)
  - *Voltage:* 5V
  - *Note:* Requires separate 5V power supply (3A per meter)
  - **Cost:** $8-20 depending on length
  - **STATUS:** ⚠️ Not owned - great for lighting projects

- [x] **OLED Display** - 0.96" I2C, SSD1306
  - **Cost:** $5-8 each
  - **YOUR SETUP:** ✅ 1 unit (0.96" display) owned

### Connectors & Headers

- [ ] **Pin Headers** - 2.54mm pitch
  - *Types:* Straight male, right-angle, female
  - **Cost:** $8-12 (assorted kit)
  - **STATUS:** ℹ️ Likely have some, consider stocking up

- [x] **JST-XH Connectors** - Battery/sensor connectors
  - *Includes:* Housings, crimp pins
  - *Use with:* Crimping tool
  - **Cost:** $10-15 (kit)
  - **YOUR SETUP:** ✅ 460pc JST-XH connector kit owned - excellent!

- [ ] **Dupont Connectors** - 2.54mm
  - *Includes:* Housings, crimp pins
  - *Use with:* Crimping tool
  - **Cost:** $10-15 (kit)
  - **STATUS:** ℹ️ Consider adding for custom jumper wires

- [ ] **Screw Terminals** - 2-3 position, 5mm pitch
  - **Cost:** $10-15 (20-30 pieces)
  - **STATUS:** ℹ️ Optional - useful for permanent installations

- [x] **Heat Shrink Tubing** - Assorted sizes
  - *Sizes:* 1.5mm - 10mm diameter
  - **Cost:** $10-15 (assorted kit)
  - **YOUR SETUP:** ✅ Owned

### USB Cables & Power

- [x] **Micro-USB Cables** (5+ units)
  - *Must be:* Data cables, not charge-only
  - **Cost:** $1-3 each
  - **YOUR SETUP:** ✅ ~10 cables owned

- [x] **USB-C Cables** (2-3 units, for newer boards)
  - **Cost:** $2-5 each
  - **YOUR SETUP:** ✅ 5 cables owned

- [ ] **5V Power Supplies** - USB or barrel jack
  - *Specs:* 2A minimum, 3-5A for LED projects
  - **Cost:** $8-15 each
  - **STATUS:** ⚠️ Not owned - bench power supply can provide 5V

- [ ] **12V Power Supply** - Barrel jack (optional)
  - *Use:* Powering relays, motors, LED strips
  - **Cost:** $10-15
  - **STATUS:** ℹ️ Not owned - bench power supply can provide 12V

---

## Storage & Organization

### Component Storage

- [x] **Parts Organizer** - Multi-drawer plastic unit
  - *Size:* 20-60 small drawers
  - *For:* Resistors, capacitors, LEDs, ICs, sensors
  - *Label:* Each drawer clearly
  - **Cost:** $20-40
  - **YOUR SETUP:** ✅ Gridfinity organization system in IKEA Alex drawers (in progress)

- [x] **Small Parts Boxes** - Clear plastic with dividers
  - *Sizes:* Various sizes for different components
  - *Quantity:* 5-10 boxes
  - **Cost:** $3-8 each
  - **YOUR SETUP:** ✅ Several boxes currently holding components

- [ ] **Anti-Static Bags** - For storing sensitive ICs
  - **Cost:** $10 (100 pieces)
  - **STATUS:** ℹ️ Consider adding for ESP32 boards and sensitive ICs

### Tool Storage

- [ ] **Tool Roll or Foam Organizer**
  - *For:* Screwdrivers, pliers, cutters
  - **Cost:** $15-25
  - **STATUS:** ℹ️ Optional - tools can be stored in Alex drawers

- [ ] **Pegboard** - Wall-mounted tool organization
  - *Size:* 2' × 4' minimum
  - *Accessories:* Hooks, bins, holders
  - **Cost:** $20-40 (board + accessories)
  - **STATUS:** ℹ️ Optional upgrade for wall organization

### Cable Management

- [x] **Cable Ties** - Various sizes
  - **Cost:** $8-12 (pack of 100+)
  - **YOUR SETUP:** ✅ Owned

- [ ] **Cable Clips** - Adhesive mount
  - **Cost:** $5-10
  - **STATUS:** ℹ️ Optional for cable routing

- [ ] **Label Maker** or **Label Tape**
  - *For:* Labeling drawers, cables, projects
  - **Cost:** $20-40 (label maker) or $5-10 (tape + marker)
  - **STATUS:** ⚠️ Recommended for Gridfinity organization

---

## Safety Equipment

### Personal Protection

- [x] **Safety Glasses** - Impact resistant
  - *Use:* Cutting wires, soldering, handling chemicals
  - **Cost:** $10-20
  - **YOUR SETUP:** ✅ Owned

- [ ] **ESD Wrist Strap** - With grounding cord
  - *Use:* Preventing static damage to components
  - *Connect to:* ESD mat ground point or earth ground
  - **Cost:** $8-15
  - **STATUS:** ⚠️ RECOMMENDED - ESP32 boards are ESD sensitive

- [x] **Heat-Resistant Mat** - Silicone soldering mat
  - *Size:* 12" × 16" or larger
  - *Features:* Section markers, screw trays
  - **Cost:** $15-25
  - **YOUR SETUP:** ✅ Silicone mat owned

### Fire Safety

- [ ] **Fire Extinguisher** - ABC type, small size
  - *Keep:* Within reach of workbench
  - *For:* Electrical fires
  - **Cost:** $20-40
  - **STATUS:** ⚠️ RECOMMENDED for safety

- [ ] **Smoke Detector** - Battery or AC powered
  - *Install:* Near workbench
  - **Cost:** $10-20
  - **STATUS:** ℹ️ Check if room already has one

### Ventilation

- [x] **Soldering Fume Extractor**
  - *Type:* Desktop fan with carbon filter
  - *DIY:* Computer fan + activated carbon filter
  - **Cost:** $30-60 (commercial), $10-20 (DIY)
  - **YOUR SETUP:** ✅ Fume extractor owned

- [ ] **Fan** - Small desk fan for general ventilation
  - **Cost:** $15-30
  - **STATUS:** ℹ️ Optional - fume extractor covers this need

---

## Optional Upgrades

### Nice to Have (Add Over Time)

- [x] **Heat Gun** - For heat shrink, general hot air work
  - **Cost:** $20-40
  - **YOUR SETUP:** ✅ Heat gun owned

- [ ] **Hot Air Rework Station** - For precision SMD work
  - **Cost:** $50-100
  - **STATUS:** ℹ️ Optional upgrade from heat gun for SMD rework

- [ ] **Magnifying Camera/Microscope** - USB digital microscope
  - *Use:* Inspecting solder joints, SMD work
  - **Cost:** $30-100
  - **STATUS:** ℹ️ Optional - magnifying lamp covers most needs

- [ ] **PCB Prototyping Boards** - Perfboard, stripboard
  - *For:* Permanent project builds
  - **Cost:** $10-20 (assorted pack)
  - **STATUS:** ℹ️ Consider adding for permanent projects

- [x] **3D Printer** - For enclosures and brackets
  - *Popular:* Ender 3, Prusa Mini
  - **Cost:** $200-500
  - **YOUR SETUP:** ✅ Creality Ender-3 V3 owned (see CLAUDE.md)

- [ ] **Label Printer** - Brother P-touch or similar
  - **Cost:** $30-60
  - **STATUS:** ⚠️ Recommended for Gridfinity organization

- [x] **Component Tester** - LCR meter, transistor tester
  - **Cost:** $15-30
  - **YOUR SETUP:** ✅ LCR meter owned

- [ ] **Programmable USB Power Supply** - PD trigger board
  - *Outputs:* 5V, 9V, 12V, 15V, 20V from USB-C PD
  - **Cost:** $10-20
  - **STATUS:** ℹ️ Optional - bench power supply covers this need

---

## Budget Breakdown

### Minimum Starter Setup ($200-300)
*Enough to get started with basic projects*

| Category | Cost |
|----------|------|
| Soldering iron + solder + accessories | $70 |
| Basic hand tools (cutters, strippers, screwdrivers) | $40 |
| Multimeter | $25 |
| ESP32 boards (5 units) | $25 |
| Breadboards + jumper wires | $20 |
| Component kits (resistors, caps, LEDs) | $30 |
| Basic sensors (DHT22, PIR) | $15 |
| USB cables + power supplies | $20 |
| ESD mat + wrist strap | $25 |
| Storage boxes | $30 |
| **Total** | **~$300** |

### Intermediate Setup ($500-700)
*More tools and components for diverse projects*

| Category | Cost |
|----------|------|
| All from Starter Setup | $300 |
| Quality soldering station (Hakko/Pinecil) | $50 (upgrade) |
| Bench power supply | $80 |
| Logic analyzer | $15 |
| More ESP32 boards (10 more) | $40 |
| Relay modules, servos, displays | $40 |
| More sensors (BME280, ultrasonic, etc.) | $40 |
| LED strips + additional power supplies | $40 |
| Better storage + organization | $40 |
| Magnifying lamp | $40 |
| Fume extractor | $50 |
| **Total** | **~$700** |

### Advanced Setup ($1000-1500+)
*Professional-grade tools for serious development*

| Category | Cost |
|----------|------|
| All from Intermediate Setup | $700 |
| Quality oscilloscope (Rigol DS1054Z) | $350 |
| Hot air rework station | $80 |
| USB microscope | $50 |
| Large component inventory | $100 |
| Pegboard + wall organization | $50 |
| 3D printer | $300 |
| Better power supplies | $100 |
| Additional sensors/actuators | $100 |
| PCBs, enclosures, project materials | $100 |
| **Total** | **~$1500+** |

---

## Shopping List Priority

### Phase 1: Get Started (Order First)
1. Soldering iron + solder
2. Multimeter
3. Basic hand tools (cutters, strippers, screwdriver set)
4. ESP32 boards (5 units)
5. Breadboards + jumper wires
6. USB cables
7. Component starter kits (resistors, caps, LEDs)

### Phase 2: First Projects
1. DHT22 sensors
2. Relay modules
3. PIR sensors
4. ESD mat + wrist strap
5. Storage organizers
6. Helping hands

### Phase 3: Expand Capabilities
1. Bench power supply
2. More ESP32 boards
3. BME280 sensors
4. LED strips
5. Logic analyzer
6. Fume extractor

### Phase 4: Advanced Tools (As Needed)
1. Oscilloscope
2. Hot air station
3. Microscope
4. 3D printer

---

## Recommended Vendors

### Online Retailers
- **Amazon** - Fast shipping, good for tools and kits
- **AliExpress/Banggood** - Cheapest for components (slow shipping)
- **Adafruit** - Quality components, excellent documentation
- **SparkFun** - Educational kits and sensors
- **Digi-Key / Mouser** - Professional components, great selection
- **Micro Center** (if near you) - Local pickup, good prices

### Canadian Specific
- **Amazon.ca** - Prime shipping
- **Sayal Electronics** - Toronto-area electronics store
- **DigiKey Canada** - Professional components, Canadian stock
- **RobotShop.com** - Canadian robotics/electronics store
- **Creatron Inc.** (Toronto) - Local shop in Chinatown

---

## Workbench Layout Suggestions

```
[Wall Pegboard - Tools]
┌──────────────────────────────────────────────────────────┐
│                   Desk Surface (6' × 2.5')                │
│                                                            │
│  [Soldering      [Breadboard    [Testing       [Storage  │
│   Station]        Area]          Equipment]     Drawers]  │
│                                                            │
│  - Iron          - Projects     - Multimeter    - Parts   │
│  - Stand         - ESP32s       - Power Supply  - Boards  │
│  - Solder        - Components   - Cables        - Sensors │
│                                                            │
└──────────────────────────────────────────────────────────┘
[ESD Mat covers center section]
[Magnifying lamp clamps to left edge]
[Power strip mounted on wall or under desk]
```

---

## Next Steps

1. **Measure your space** - Determine desk size and layout
2. **Set budget** - Choose starter, intermediate, or advanced
3. **Order Phase 1 items** - Get the essentials first
4. **Set up workspace** - Install desk, lighting, power
5. **Organize components** - Label everything clearly
6. **Start with Project 1** - LED blink (from starter projects doc)
7. **Expand gradually** - Buy components as you need them for projects

---

## Maintenance & Upkeep

### Daily
- Clean up breadboard projects
- Return tools to proper places
- Wipe down work surface

### Weekly
- Organize loose components
- Check solder tip condition
- Review project notes

### Monthly
- Inventory components (update `/home/hazzard/homeproject/esp32/components-inventory/inventory.md`)
- Clean solder tip (brass wool + tip tinner)
- Update shopping list for next projects

### Yearly
- Check fire extinguisher expiration
- Replace ESD mat if worn
- Evaluate tool upgrades
- Donate/sell unused components

Happy building! 🛠️
