# My Electronics Lab Setup Plan

**Created:** 2025-10-30
**Budget:** $500-700 (Intermediate)
**Experience Level:** Complete Beginner
**Workspace:** Dedicated Workbench
**Focus:** Home automation sensors, smart switches/relays, voice assistants, LED lighting

---

## Overview

This is your personalized plan to build a complete home electronics lab optimized for ESP32 development and home automation projects. As a beginner with a dedicated workbench and intermediate budget, this plan balances quality tools with cost-effectiveness, prioritizes safety, and phases purchases to match your learning curve.

---

## Budget Allocation

| Phase | Purpose | Budget | Timeline |
|-------|---------|--------|----------|
| **Phase 1** | Essential tools & safety | $250 | Order immediately |
| **Phase 2** | Project components | $200 | After 1-2 weeks |
| **Phase 3** | Advanced tools | $150 | After first 3 projects |
| **Total** | | **$600** | 4-6 weeks |

**Buffer:** $100 remaining for unexpected needs or upgrades

---

## Phase 1: Essential Tools & Safety ($250)
### Order These First - Start Learning Safely

This phase gets you everything needed to complete your first 3-5 projects safely and successfully.

### Soldering Equipment ($90)

#### ⭐ Soldering Iron - **RECOMMENDED: Pinecil V2** ($35)
- **Why this one:** USB-C powered, portable, fast heating, open-source, beginner-friendly
- **Specs:** 30W, 100-400°C, RISC-V processor, OLED display
- **Alternative:** Hakko FX-888D ($100) - more traditional, larger, equally beginner-friendly
- **Where:** Amazon.ca, Pine64 store
- **Canadian Price:** $35-40 CAD (Pinecil) or $100-120 CAD (Hakko)

**Why USB-C matters for beginners:** You can power it with a USB-C laptop charger (65W PD), making it portable and no separate outlet needed.

#### Solder ($12)
- **Type:** 60/40 Tin-Lead rosin core (easier to learn with than lead-free)
- **Size:** 0.8mm or 1.0mm diameter
- **Brand:** Kester, Multicore, or Alpha Fry
- **Amount:** 100g spool
- **Where:** Amazon.ca, DigiKey.ca
- **Price:** $12-15 CAD

**Beginner tip:** Leaded solder melts at lower temperature (easier), but wash hands after. Lead-free available if preferred (requires higher temp).

#### Helping Hands with Magnifier ($15)
- **Features:** Adjustable arms with alligator clips, 2.5x-3x magnifying glass
- **Use:** Holds PCBs/components while you solder
- **Where:** Amazon.ca
- **Price:** $12-18 CAD

#### Brass Wire Sponge ($8)
- **Why not wet sponge:** Brass doesn't reduce tip temperature, lasts longer
- **Where:** Amazon.ca (often comes with soldering iron)
- **Price:** $5-10 CAD

#### Solder Sucker & Desoldering Wick ($10)
- **Solder sucker:** Spring-loaded pump for removing solder
- **Wick:** Copper braid for cleaning up mistakes
- **Where:** Amazon.ca (often sold as kit)
- **Price:** $8-12 CAD for both

#### Tip Tinner & Cleaner ($10)
- **Use:** Cleans and prolongs tip life, crucial for beginners
- **Brand:** Thermaltronics, Chemtronics
- **Where:** Amazon.ca, DigiKey.ca
- **Price:** $8-12 CAD

---

### Hand Tools ($70)

#### Precision Screwdriver Set ($20)
- **Types:** Phillips (#0, #1, #2), Flathead (2mm, 3mm), Torx (T5, T6, T8, T10)
- **Recommended:** iFixit Mako Driver Kit (64 bits) or Wiha set
- **Where:** Amazon.ca, iFixit.com
- **Price:** $20-30 CAD
- **Why these:** Opens ESP32 boards, installs terminal blocks, assembles enclosures

#### Wire Cutters - Flush Cut ($12)
- **Type:** Diagonal flush cutters, spring-loaded
- **Recommended:** Hakko CHP-170 or Knipex 78 series
- **Where:** Amazon.ca, DigiKey.ca
- **Price:** $10-15 CAD
- **Use:** Trimming component leads, cutting solid wire

#### Wire Strippers - Self-Adjusting ($18)
- **Recommended:** Irwin Vise-Grip Self-Adjusting or Klein Tools
- **Size range:** 10-24 AWG (covers all your needs)
- **Where:** Amazon.ca, Home Depot
- **Price:** $15-20 CAD
- **Why self-adjusting:** Perfect for beginners, no gauge selection needed

#### Needle Nose Pliers ($10)
- **Type:** Long nose, smooth jaw
- **Use:** Bending component leads, holding small parts
- **Where:** Amazon.ca, Canadian Tire
- **Price:** $8-12 CAD

#### Tweezers - Precision Set ($10)
- **Types:** Straight, angled, curved (set of 3)
- **Material:** Stainless steel, anti-static coating preferred
- **Where:** Amazon.ca
- **Price:** $8-12 CAD
- **Use:** Placing small components, SMD work (future)

---

### Testing Equipment ($50)

#### ⭐ Multimeter - **RECOMMENDED: Klein Tools MM400** ($35)
- **Why this one:** Auto-ranging, loud continuity beeper, backlit display, beginner-friendly
- **Measures:** DC/AC voltage, current, resistance, continuity, diode test
- **Range:** 600V, 10A, 40MΩ
- **Alternative:** AstroAI DT132A ($25) - budget option, still good
- **Where:** Amazon.ca, Home Depot
- **Price:** $35-45 CAD (Klein), $22-28 CAD (AstroAI)

**Beginner tip:** The continuity beeper is your best friend - use it constantly to verify connections.

#### USB Power Meter ($15)
- **Type:** Inline USB-A or USB-C tester
- **Measures:** Voltage, current, power (W), capacity (mAh)
- **Recommended:** AVHzY USB tester or similar
- **Where:** Amazon.ca
- **Price:** $12-18 CAD
- **Use:** Verify ESP32 power consumption, check if cables are data or charge-only

---

### Safety & Workspace ($40)

#### ESD Mat with Wrist Strap ($25)
- **Size:** 24" x 16" minimum (larger if space allows)
- **Features:** Grounding snap, two-layer conductive material
- **Wrist strap:** 6-10 foot coiled cord
- **Where:** Amazon.ca
- **Price:** $20-30 CAD

**Critical for beginners:** ESP32 chips are static-sensitive. Always ground yourself when handling bare boards.

#### Heat-Resistant Silicone Mat ($15)
- **Size:** 15" x 12" minimum
- **Features:** High-temp silicone, section markers, screw trays, ruler markings
- **Where:** Amazon.ca
- **Price:** $12-18 CAD
- **Use:** Protects desk, prevents burns, organizes small parts during assembly

---

### Beginner Essentials ($0 - You likely have these)

- **Safety glasses** - Use when cutting wire, soldering (even old sunglasses work)
- **USB-C cable** - For powering Pinecil soldering iron
- **Laptop charger** - 65W USB-C PD charger works perfectly with Pinecil

---

## Phase 2: Project Components ($200)
### Order After Your First Successful Solder Joint

This phase provides components for your first 10-15 projects aligned with your interests.

### ESP32 Development Boards ($50)

#### ESP32 DevKit v1 - 5 units ($30)
- **Model:** ESP32-WROOM-32 (38-pin or 30-pin)
- **Features:** CP2102 or CH340 USB chip, breadboard-compatible
- **Where:** Amazon.ca, AliExpress
- **Price:** $5-7 CAD each (bulk discount available)

**Beginner tip:** Buy 5 units because:
1. You might break one (it's okay!)
2. Multi-device projects (sensor + hub)
3. Always have a spare
4. Learn by experimentation

#### ESP32-C3 SuperMini - 2 units ($10)
- **Features:** USB-C, smaller footprint, RISC-V, cheaper than ESP32
- **Where:** AliExpress
- **Price:** $3-5 CAD each

**Future use:** Great for small sensor nodes after you master the DevKit

#### M5Stack Atom Lite - 1 unit (Optional, $10)
- **Why:** You already have 2 Atom Echos, this adds flexibility
- **Where:** M5Stack.com, DigiKey.ca
- **Price:** $10-12 USD

---

### Prototyping Supplies ($25)

#### Breadboards ($12)
- **Full-size (830 point):** 2 units - for complex projects
- **Half-size (400 point):** 2 units - for simple sensors
- **Quality matters:** Avoid ultra-cheap ones (poor connections)
- **Where:** Amazon.ca, DigiKey.ca
- **Price:** $10-15 CAD for 4-piece set

#### Jumper Wire Kit ($13)
- **Types:** Male-male, male-female, female-female
- **Quantity:** 120-200 pieces total
- **Lengths:** Assorted (10cm, 20cm, 30cm)
- **Where:** Amazon.ca
- **Price:** $10-15 CAD

---

### Component Kits ($35)

#### Resistor Kit - 1/4W ($12)
- **Values:** 10Ω to 1MΩ (E12 series, 20 of each value)
- **Total pieces:** 500-600
- **Most used:** 220Ω, 330Ω, 1kΩ, 4.7kΩ, 10kΩ (LED current limiting, pull-ups)
- **Where:** Amazon.ca
- **Price:** $10-15 CAD

#### Capacitor Kit ($12)
- **Ceramic:** 10pF - 10µF (50V rated)
- **Electrolytic:** 1µF - 1000µF (16V-50V)
- **Total pieces:** 300-500
- **Most used:** 0.1µF (bypass caps), 10µF, 100µF (power smoothing)
- **Where:** Amazon.ca
- **Price:** $10-15 CAD

#### LED Assortment ($11)
- **Colors:** Red, green, blue, yellow, white (20 of each)
- **Size:** 5mm or 3mm
- **Total pieces:** 100-200
- **Specs:** Standard 20mA, 2-3.3V forward voltage
- **Where:** Amazon.ca
- **Price:** $8-12 CAD

**Beginner tip:** LEDs are your debugging tool. Use them to visualize what's happening.

---

### Sensors for Home Automation ($40)

#### Temperature/Humidity Sensors ($15)
- **DHT22:** 2 units @ $4 each = $8
  - Digital, easy to use, good for beginners
  - Where: Amazon.ca, DigiKey.ca

- **BME280:** 1 unit @ $7
  - I2C interface, temp + humidity + pressure, more accurate than DHT22
  - Where: Amazon.ca, AliExpress
  - **Your first I2C project**

#### Motion Sensors ($8)
- **PIR HC-SR501:** 2 units @ $3-4 each
- **Use:** Presence detection, automation triggers
- **Where:** Amazon.ca, AliExpress
- **Adjustable sensitivity and delay time**

#### Ultrasonic Distance Sensor ($5)
- **Model:** HC-SR04
- **Use:** Garage door position, tank level, proximity
- **Where:** Amazon.ca, AliExpress
- **Price:** $4-6 CAD

#### Light Sensor ($4)
- **Model:** BH1750 I2C light sensor
- **Use:** Auto-brightness, day/night detection
- **Where:** Amazon.ca, AliExpress
- **Price:** $3-5 CAD

#### Soil Moisture Sensor ($8)
- **Type:** Capacitive (not resistive - they corrode)
- **Quantity:** 2 units
- **Use:** Plant monitoring (great beginner project)
- **Where:** Amazon.ca, AliExpress
- **Price:** $3-5 CAD each

---

### Actuators for Smart Switches ($30)

#### Relay Modules ($20)
- **2-channel 5V relay module:** 2 units @ $6 each = $12
  - Optoisolated (safer for beginners)
  - Controls 120V AC or 12V DC loads
  - **Your first real home automation switch!**

- **Single relay module:** 2 units @ $4 each = $8
  - Compact for simple projects

- **Where:** Amazon.ca, AliExpress

**Safety note:** We'll cover AC wiring safety before you use these with mains voltage.

#### Servo Motor ($6)
- **Model:** SG90 micro servo (2 units)
- **Use:** Smart blinds, valve control, garage door lock
- **Where:** Amazon.ca, AliExpress
- **Price:** $2-4 CAD each

#### OLED Display ($4)
- **Size:** 0.96" I2C
- **Controller:** SSD1306
- **Use:** Status display, sensor readings, project info
- **Where:** Amazon.ca, AliExpress
- **Price:** $4-6 CAD

---

### Connectors & Wire ($20)

#### Solid Core Wire 22 AWG ($12)
- **Colors:** Red, black, yellow, green, blue (1 spool each)
- **Use:** Breadboard connections, permanent wiring
- **Where:** Amazon.ca, Home Depot
- **Price:** $10-15 CAD for 5-color set

#### Stranded Wire 22 AWG ($8)
- **Colors:** Red and black (25ft spools)
- **Use:** Flexible connections, sensor extensions
- **Where:** Amazon.ca, Home Depot
- **Price:** $6-10 CAD

#### USB Cables ($10-15)
- **Micro-USB data cables:** 3-5 units (for ESP32 DevKit)
- **USB-C cables:** 2 units (for ESP32-C3)
- **CRITICAL:** Must be DATA cables, not charge-only
- **Where:** Amazon.ca
- **Test:** Use your USB power meter to verify data capability

---

## Phase 3: Advanced Tools ($150)
### Order After Completing 3-5 Projects

These tools unlock more advanced projects and make debugging much easier.

### Bench Power Supply ($80)

**Recommended: Hanmatek HM305 or Eventek KPS3010D**
- **Specs:** 0-30V, 0-5A (150W)
- **Features:** Digital display, current limiting, short circuit protection
- **Use:** Precise voltage control, power-hungry projects (LED strips), simulate battery voltages
- **Where:** Amazon.ca
- **Price:** $70-90 CAD

**Why wait until Phase 3:** USB power (5V) and breadboard power modules handle 90% of beginner projects.

---

### Logic Analyzer ($20)

**Model: 8-channel USB logic analyzer (Saleae clone)**
- **Channels:** 8 inputs, 24MHz sample rate
- **Software:** PulseView (open-source) or Saleae Logic
- **Use:** Debug I2C, SPI, UART communication - see exactly what's happening on data lines
- **Where:** Amazon.ca, AliExpress
- **Price:** $12-20 CAD

**This tool is a game-changer:** When sensors don't work, you can SEE the communication problems.

---

### Fume Extractor ($50)

**Recommended: Desktop soldering fume extractor with carbon filter**
- **Features:** Adjustable fan speed, replaceable carbon filter, flexible arm
- **CFM:** 60+ cubic feet per minute
- **Where:** Amazon.ca
- **Price:** $40-60 CAD

**DIY Alternative ($15):** 120mm PC fan + activated carbon filter + 3D printed housing

**Why this matters:** Solder fumes contain rosin flux smoke (respiratory irritant). Critical for long soldering sessions.

---

## Additional Equipment (Future Upgrades)

### Oscilloscope ($350) - Wait 6+ months
- **Recommended:** Rigol DS1054Z (4-channel, 50MHz)
- **Use:** Advanced debugging, viewing waveforms, analog signal analysis
- **Priority:** Low for home automation projects, high for audio/RF work
- **When:** After you've completed 10+ projects and understand digital signals

### Hot Air Rework Station ($80) - Wait 6+ months
- **Use:** SMD soldering, removing components, heat-shrink application
- **When:** Only needed for advanced projects (custom PCBs, repair work)

### 3D Printer ($250-500) - Wait 12+ months
- **Recommended:** Creality Ender 3 V3 or Bambu Lab A1 Mini
- **Use:** Custom enclosures, mounting brackets, project housings
- **When:** After you have 5-10 projects that need enclosures

---

## Storage & Organization ($80)

### Component Storage ($50)

#### Plastic Parts Organizer ($30)
- **Type:** Multi-drawer unit (40-60 small drawers)
- **Recommended:** Akro-Mils 10164 or similar
- **Use:** Resistors, capacitors, LEDs, ICs organized by value
- **Where:** Amazon.ca, Home Depot
- **Label:** Brother P-touch or printed labels

#### Small Parts Boxes ($20)
- **Type:** Clear plastic boxes with adjustable dividers
- **Sizes:** 3-4 different sizes
- **Use:** Sensors, ESP32 boards, relay modules, larger components
- **Where:** Amazon.ca, Canadian Tire

### Tool Storage ($30)

#### Pegboard System ($25)
- **Size:** 2' x 4' pegboard
- **Accessories:** Hooks, bins, tool holders
- **Where:** Home Depot, Canadian Tire
- **Mount:** Above workbench for easy access

#### Cable Management ($5)
- **Items:** Cable ties, adhesive cable clips
- **Where:** Amazon.ca, Home Depot

---

## Workspace Layout Plan

Since you have a dedicated workbench, here's the optimal layout:

```
┌─────────────────────────────────── WALL ──────────────────────────────────────┐
│                                                                                │
│  [Pegboard 2'x4' - Tools, Wrist Strap, Cutters, Pliers, Screwdrivers]        │
│                                                                                │
├────────────────────────────────────────────────────────────────────────────────┤
│                         WORKBENCH (6' x 2.5')                                  │
│                                                                                │
│  ┌─────────────┐   ┌──────────────────┐   ┌──────────────┐   ┌────────────┐  │
│  │  SOLDERING  │   │   ASSEMBLY ZONE  │   │   TESTING    │   │  STORAGE   │  │
│  │    ZONE     │   │                  │   │     ZONE     │   │   DRAWERS  │  │
│  │             │   │                  │   │              │   │            │  │
│  │ - Pinecil   │   │ - Breadboards    │   │ - Multimeter │   │ - Parts    │  │
│  │ - Stand     │   │ - Active project │   │ - Power      │   │ - ESP32s   │  │
│  │ - Solder    │   │ - ESP32 boards   │   │   supply     │   │ - Sensors  │  │
│  │ - Flux      │   │ - Component bins │   │ - Logic      │   │ - Modules  │  │
│  │ - Magnifier │   │                  │   │   analyzer   │   │            │  │
│  │             │   │                  │   │ - USB meter  │   │            │  │
│  └─────────────┘   └──────────────────┘   └──────────────┘   └────────────┘  │
│                                                                                │
│  [───────────────── ESD MAT (24" x 36") covers center zones ─────────────]    │
│  [Heat-resistant mat on left for soldering]                                   │
│                                                                                │
└────────────────────────────────────────────────────────────────────────────────┘

[Power strip mounted under front edge - 6 outlets + USB ports]
[Magnifying lamp clamps to left edge, swings over soldering/assembly zones]
[Overhead LED task lighting (5000K-6500K) directly above workbench]
[Small trash bin underneath for component lead trimmings]
[Fume extractor positioned to pull from soldering zone]
```

### Lighting Requirements
- **Overhead:** LED strip or shop light, 5000K-6500K (daylight), 3000+ lumens
- **Task light:** Magnifying lamp with LED, adjustable arm
- **Where:** Home Depot, Canadian Tire, Amazon.ca
- **Budget:** $40-80

---

## Learning Path: First 5 Projects

Aligned with your interests, ordered by difficulty:

### Project 1: LED Blink ⭐ (1-2 hours)
**Skills:** Basic soldering, ESP32 programming, GPIOs
**Components:** ESP32, breadboard, LED, 220Ω resistor, jumper wires
**Outcome:** Understand basic circuits, ESPHome setup
**Guide:** `/home/hazzard/homeproject/docs/esp32-starter-projects.md`

### Project 2: Temperature Sensor ⭐⭐ (2-3 hours)
**Skills:** Sensor reading, Home Assistant integration
**Components:** ESP32, DHT22, breadboard, jumper wires
**Outcome:** First real home automation sensor
**Integration:** Shows up in Home Assistant automatically

### Project 3: Motion-Activated LED ⭐⭐ (3-4 hours)
**Skills:** Binary sensors, automation triggers
**Components:** ESP32, PIR sensor, LED strip (future), relay
**Outcome:** Foundation for occupancy detection
**Safety:** Low-voltage (5V) only

### Project 4: Smart Relay Switch ⭐⭐⭐ (4-6 hours)
**Skills:** Relay control, AC safety (theory), enclosures
**Components:** ESP32, relay module, project box
**Outcome:** Control real devices (lamp, fan)
**Safety:** Start with 12V DC loads, progress to AC after research

### Project 5: Multi-Sensor Node ⭐⭐⭐ (5-8 hours)
**Skills:** I2C communication, multiple sensors, OLED display
**Components:** ESP32, BME280, BH1750, OLED display
**Outcome:** Comprehensive environmental monitor
**Debugging:** Use logic analyzer if I2C issues occur

---

## Canadian Vendor Guide

### Fast Shipping (2-5 days)
1. **Amazon.ca** - Prime eligible, easy returns
   - Tools, ESP32 boards, component kits, storage
   - Expect: 10-20% markup over AliExpress, but arrives in 2 days

2. **DigiKey Canada** (digikey.ca)
   - Professional components, excellent selection
   - Free shipping over $100 CAD
   - Expect: Same-day shipping if ordered early

3. **Mouser Electronics Canada** (mouser.ca)
   - Similar to DigiKey, massive inventory
   - Free shipping over $75 CAD

### Budget Option (3-8 weeks)
4. **AliExpress**
   - Bulk ESP32 boards, cheap sensors, relay modules
   - 50-70% cheaper than Canadian vendors
   - Expect: 20-60 days shipping, occasional lost packages
   - **Strategy:** Order Phase 2 components from here while learning with Phase 1

### Local (Toronto Area)
5. **Sayal Electronics** (sayal.com)
   - Multiple GTA locations (Mississauga, Markham, Vaughan)
   - Walk-in store, good for odd components
   - Pricing: Between Amazon and AliExpress

6. **Creatron Inc.** (creatroninc.com)
   - Toronto (Spadina/Dundas), walk-in store
   - Arduino, Raspberry Pi, components
   - Good for immediate needs

7. **Canada Robotix** (canadarobotix.com)
   - Markham location, online store
   - Robotics and electronics components

---

## Phase 1 Shopping Strategy

### Week 1: Order Immediately
**From Amazon.ca (arrives in 2-5 days):**
- Pinecil soldering iron
- Multimeter (Klein MM400 or AstroAI)
- Hand tool set (screwdrivers, cutters, strippers, pliers)
- ESD mat + wrist strap
- Silicone heat-resistant mat
- Helping hands
- Solder, flux, tip tinner
- USB power meter

**Budget:** ~$250 CAD

### Week 2-3: While learning to solder
**From Amazon.ca or DigiKey:**
- ESP32 DevKit boards (5 units)
- Breadboards (4 units)
- Jumper wire kit
- Component kits (resistors, capacitors, LEDs)
- First sensors (DHT22, PIR)

**Budget:** ~$100 CAD

**From AliExpress (order at same time, arrives in 4-6 weeks):**
- Additional ESP32 boards (10 units) - backup stock
- BME280 sensors (5 units) - future projects
- Relay modules (5 units)
- LED strips
- Cheaper duplicates of Phase 2 items

**Budget:** ~$80 CAD (same items would be $150+ from Amazon)

### Week 4-6: After first projects
**From Amazon.ca:**
- Bench power supply
- Logic analyzer
- Fume extractor
- Storage organizers

**Budget:** ~$150 CAD

---

## Safety Checklist (Critical for Beginners)

### Before First Soldering Session
- [ ] Read beginner safety guide (`beginner-safety-guide.md`)
- [ ] Set up fume extraction (window open minimum, fan recommended)
- [ ] Have first aid kit nearby
- [ ] Wear safety glasses
- [ ] Clear workspace of flammable materials
- [ ] Have soldering iron stand ready
- [ ] Know where circuit breaker is

### Every Session
- [ ] Attach ESD wrist strap before handling ESP32 boards
- [ ] Turn off soldering iron when not in use (>2 minutes)
- [ ] Never touch tip (stays hot for 5+ minutes after power off)
- [ ] Wash hands after soldering (lead solder)
- [ ] Unplug bench power supply when not in use
- [ ] Double-check polarity before powering ESP32

### AC Mains Voltage (120V)
- [ ] **NEVER work on AC circuits until you've completed 10+ DC projects**
- [ ] Always use proper enclosures
- [ ] Understand Canadian Electrical Code basics
- [ ] Consider hiring electrician for first AC project
- [ ] Use GFCI outlets for testing

---

## Budget Summary

| Phase | Cost | Timeline | Purpose |
|-------|------|----------|---------|
| **Phase 1** | $250 | Week 1 | Essential tools + safety |
| **Phase 2** | $200 | Week 2-4 | Project components |
| **Phase 3** | $150 | Week 6-8 | Advanced tools |
| **Total** | **$600** | 8 weeks | Complete lab |

**Remaining buffer:** $100 for:
- Replacement components (you'll break things - it's okay!)
- Specialized sensors for specific projects
- Enclosures and mounting hardware
- Unexpected needs

---

## Next Steps

### This Week
1. ✅ Read this entire plan
2. ✅ Read `/home/hazzard/homeproject/docs/beginner-safety-guide.md`
3. ✅ Measure your workbench space
4. ✅ Order Phase 1 items from Amazon.ca
5. ✅ Order Phase 2 items from AliExpress (they'll arrive later)

### Week 2 (When Phase 1 arrives)
1. Set up workbench layout
2. Organize tools on pegboard
3. Watch beginner soldering tutorials:
   - "How to Solder Through-Hole Components" (Sparkfun)
   - "Beginner Soldering Tutorial" (Great Scott)
4. Practice soldering on scrap wire
5. Attempt Project 1 (LED Blink)

### Week 3-4
1. Complete Projects 2-3 (Temperature sensor, motion LED)
2. Order Phase 3 items
3. Integrate first sensors into Home Assistant

### Week 6-8
1. Complete Project 4-5 (Smart switch, multi-sensor)
2. Begin custom projects aligned with your home automation needs
3. Update component inventory
4. Share success photos in home automation communities!

---

## Additional Resources

### Beginner Learning
- **Paul McWhorter YouTube** - "New Arduino Tutorials" series
  - Excellent beginner explanations, step-by-step
- **Andreas Spiess** - #1 ESP32 YouTube channel
  - "Best ESP32 Tutorials" playlist
- **ESPHome Documentation** - esphome.io
  - Your primary reference for Home Assistant integration

### Communities (Ask Questions!)
- **r/homeassistant** - Reddit community, very helpful
- **r/esp32** - ESP32-specific projects and help
- **Home Assistant Community Forums** - community.home-assistant.io
- **ESPHome Discord** - Real-time help with configuration

### Safety Resources
- **Sparkfun: How to Solder** - learn.sparkfun.com/tutorials/how-to-solder
- **EEVblog Soldering Tutorial** - YouTube
- **Canadian Electrical Code** basics - electrical-contractor.net

---

## Success Metrics

After 3 months with this lab, you should be able to:

✅ Solder through-hole components confidently
✅ Design and build ESP32-based sensors
✅ Debug I2C and SPI communication issues
✅ Integrate devices with Home Assistant seamlessly
✅ Control real-world devices safely (relays, servos)
✅ Read schematics and understand datasheets
✅ Troubleshoot power and connectivity problems
✅ Build your 3rd, 4th, 5th M5Stack voice assistants
✅ Create custom smart switches for home automation
✅ Design multi-sensor environmental monitoring nodes

---

## Questions? Next Steps

This plan is living document. Update it as you:
- Discover new tools you need
- Find better Canadian vendors
- Complete projects and learn what works

**Your immediate action:** Order Phase 1 items from Amazon.ca today. The sooner you start, the sooner you'll have a working temperature sensor in Home Assistant!

**Good luck, and welcome to electronics!** 🛠️⚡
