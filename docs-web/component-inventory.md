# Component Inventory

**Last Updated:** 2025-12-07

This is a living inventory of all electronics components, tools, and hardware available for ESP32 and home automation projects. Update this document as components are acquired or used.

---

## ESP32 Development Boards

| Component | Quantity | Status | Location | Notes |
|-----------|----------|--------|----------|-------|
| Espressif ESP32 DevKitC | 5 | Available | Electronics bin | Official Espressif dev board |
| Seeed Studio XIAO ESP32 C6 | 10 | Available | Electronics bin | WiFi 6, BLE 5, Zigbee/Matter, ultra-compact |
| ESP32-C3 Development Board | 1 | Available | Electronics bin | 16-pin Type-C, Mini Wi-Fi BT |
| ESP32-S3 Development Board | 5 | Available | Electronics bin | 44-pin Type-C, 16MB Flash, 8MB PSRAM |
| M5Stack Atom Echo | 2 | Deployed | Living Room, Office | Voice assistant devices |
| M5Stack Atom Echo | 1 | Available | Electronics bin | Spare voice assistant |

**Total ESP32 Boards:** 49 (46 available, 3 deployed)

**Notes:**
- **ESP32 C6 boards** support Matter/Thread protocols for future smart home expansion
- **ESP32-S3 boards** have extra RAM/Flash for complex projects (camera, display, ML)
- **XIAO form factor** is ultra-compact (21x17.5mm) - ideal for space-constrained projects

---

## Sensors & Modules

### Temperature & Humidity

| Component | Quantity | Status | Location | Notes |
|-----------|----------|--------|----------|-------|
| DHT22 Temperature/Humidity Sensor | 0 | Need to order | - | For basic temp/humidity projects |
| BME280 I2C Sensor | 0 | Need to order | - | For advanced environmental monitoring |
| M5Stack ENVIV Unit | 1 | Available | Electronics bin | Temp, humidity, pressure, eCO2, TVOC |

### Motion & Presence

| Component | Quantity | Status | Location | Notes |
|-----------|----------|--------|----------|-------|
| M5Stack PIR Motion Unit (AS312) | 3 | Available | Electronics bin | Passive infrared motion detection |
| HC-SR501 PIR Sensor | 2 | Available | Electronics bin | Adjustable sensitivity & delay |
| LD2410C 24GHz mmWave Radar | 2 | Available | Electronics bin | Human presence, heartbeat detection, high accuracy |
| Obstacle Avoidance Module | 1 | Available | Electronics bin | IR-based proximity detection |

**Notes:**
- **LD2410C** detects stationary presence (unlike PIR which requires movement)
- **mmWave radar** works through walls/obstacles, ideal for room occupancy detection

### Audio & Microphones

| Component | Quantity | Status | Location | Notes |
|-----------|----------|--------|----------|-------|
| INMP441 MEMS Microphone Module | 2 | Available | Electronics bin | I2S interface, omnidirectional, high precision |
| EGBO Omnidirectional Microphone | 5 | Available | Electronics bin | I2S interface, low power |
| MAX98357A I2S Audio Amplifier | 5 | Available | Electronics bin | 3W Class D digital power amp |
| 2" Full Range Speaker (4Ω, 3W) | 4 | Available | Electronics bin | 52mm square, for DIY voice/audio projects |
| Passive Buzzer | 1 | Available | Electronics bin | Requires PWM signal (melody capable) |
| Active Buzzer | 1 | Available | Electronics bin | Simple on/off (single tone) |

**Notes:**
- **INMP441** is preferred for voice assistant projects (better SNR than EGBO)
- **MAX98357A + Speaker** combo enables DIY smart speakers with ESP32

### Light & Display

| Component | Quantity | Status | Location | Notes |
|-----------|----------|--------|----------|-------|
| 0.96" OLED Display I2C (SSD1306) | 2 | Available | Electronics bin | 128x64, 3.3V-5V, blue/yellow display |
| WS2812B RGB LED Ring (12 LEDs) | 5 | Available | Electronics bin | 5050 addressable RGB, integrated drivers |
| 5mm LED (Red) | 10+ | Available | Component organizer | Status indicators |
| 5mm LED (Green) | 10+ | Available | Component organizer | Status indicators |
| 5mm LED (Blue) | 10+ | Available | Component organizer | Status indicators |

**Notes:**
- **WS2812B rings** are perfect for visual feedback on voice assistants or status displays

### Touch & Input

| Component | Quantity | Status | Location | Notes |
|-----------|----------|--------|----------|-------|
| TTP223 Capacitive Touch Button | 20 | Available | Electronics bin | Single channel, self-locking, no mechanical wear |

### Other Sensors

| Component | Quantity | Status | Location | Notes |
|-----------|----------|--------|----------|-------|
| Capacitive Soil Moisture Sensor | 0 | Need to order | - | For plant monitoring projects |
| LDR (Light Dependent Resistor) | 0 | Need to order | - | For ambient light detection |

---

## Power Components

### Batteries & Charging

| Component | Quantity | Status | Location | Notes |
|-----------|----------|--------|----------|-------|
| 18650 Li-Ion Battery (3.7V) | 0 | Need to order | - | For battery-powered sensor nodes |
| TP4056 Battery Charger Module | 0 | Need to order | - | USB charging for Li-Ion batteries |
| Battery Holder (18650) | 0 | Need to order | - | For easy battery replacement |

### Power Management & Switching

| Component | Quantity | Status | Location | Notes |
|-----------|----------|--------|----------|-------|
| USB Power Supply (5V 1A) | Several | Available | Various | For always-on projects |
| 12V Power Supply (2A) | 0 | Need to order | - | For LED strips |
| Slide Switch (Power) | 0 | Need to order | - | On/off control for battery projects |
| 5V 2-Channel Relay Module | 1 | Available | Electronics bin | Control AC/high-power devices |

---

## Electronic Components

### Integrated Circuits

| Component | Quantity | Status | Location | Notes |
|-----------|----------|--------|----------|-------|
| 74HC Logic IC Kit | 1 kit (80pcs) | Available | Component organizer | DIP-14: 00N, 04N, 08N, 14N, 138N, 164N, 165N, 595N |

**IC Functions:**
- **74HC00N:** Quad 2-input NAND gate
- **74HC04N:** Hex inverter
- **74HC08N:** Quad 2-input AND gate
- **74HC14N:** Hex Schmitt trigger inverter
- **74HC138N:** 3-to-8 line decoder
- **74HC164N:** 8-bit shift register (serial-in, parallel-out)
- **74HC165N:** 8-bit shift register (parallel-in, serial-out)
- **74HC595N:** 8-bit shift register with output latches (LED/relay driving)

### Transistors & MOSFETs

| Component | Quantity | Status | Location | Notes |
|-----------|----------|--------|----------|-------|
| Transistor Kit (TO-92) | 1 kit (200pcs) | Available | Component organizer | BC327, BC337, 2N2222, 2N2907, 2N3904, 2N3906, S8050, S8550, A1015, C1815 |
| IRLZ44N N-Channel MOSFET | 0 | Need to order | - | For high-power LED control |

**Transistor Types:**
- **PNP:** BC327, 2N2907, A1015
- **NPN:** BC337, 2N2222, 2N3904, 2N3906, S8050, S8550, C1815

### Diodes

| Component | Quantity | Status | Location | Notes |
|-----------|----------|--------|----------|-------|
| 1N5408 Rectifier Diode | 50 | Available | Component organizer | 3A, 1000V, DO-27 package |

### Resistors

| Component | Quantity | Status | Location | Notes |
|-----------|----------|--------|----------|-------|
| 10kΩ Resistor (1/4W) | 10+ | Available | Component organizer | Pull-up/pull-down resistors |
| 220Ω Resistor (1/4W) | 10+ | Available | Component organizer | LED current limiting |
| Metal Film Resistor Kit | 1 kit (300pcs) | Available | Component organizer | 30 values, 10Ω-1MΩ, 1/4W 1% |

### Capacitors

| Component | Quantity | Status | Location | Notes |
|-----------|----------|--------|----------|-------|
| Electrolytic Capacitor Kit | 1 kit (1000pcs) | Available | Component organizer | 0.1µF-1000µF, 15-36 values, 10-50V, with storage box |
| 100µF Electrolytic Capacitor | 5+ | Available | Component organizer | Power filtering |
| 0.1µF Ceramic Capacitor | 10+ | Available | Component organizer | Decoupling |

### Wiring & Connectors

| Component | Quantity | Status | Location | Notes |
|-----------|----------|--------|----------|-------|
| Breadboard (Full-size) | 2 | Available | Workbench | For prototyping |
| Breadboard (Mini) | 2 | Available | Electronics bin | For small projects |
| Jumper Wires (M-M) | 40+ | Available | Electronics bin | Male-to-male |
| Jumper Wires (M-F) | 40+ | Available | Electronics bin | Male-to-female |
| Jumper Wires (F-F) | 40+ | Available | Electronics bin | Female-to-female |
| JST-XH & Dupont Connector Kit | 1 kit (460pcs) | Available | Component organizer | 2.54mm, 2-6 pin, headers/housings |
| Heat Shrink Tubing Kit | 1 kit (164pcs) | Available | Electronics bin | Assorted sizes for wire insulation |

---

## Prototyping & PCB

| Component | Quantity | Status | Location | Notes |
|-----------|----------|--------|----------|-------|
| Double-Sided PCB Prototype Boards | 1 kit (20pcs) | Available | Electronics bin | Mixed sizes: 2x8, 3x7, 4x6, 5x7cm |
| Tactile Push Button Switch Kit | 1 kit (620pcs) | Available | Component organizer | 32 values, SMD micro momentary |

---

## Tools & Equipment

### Soldering Equipment

| Tool | Quantity | Status | Location | Notes |
|------|----------|--------|----------|-------|
| Weller WLSK3012A Soldering Station | 1 | Available | Workbench | Professional station |
| Electrisol 60/40 Solder (0.81mm, 113g) | 1 spool | Available | Workbench | Electronics solder |
| Solder Tip Cleaner (Brass) | 1 | Available | Workbench | Tip maintenance |
| Helping Hands | 0 | Need to order | - | For holding components while soldering |

### Measurement & Testing Tools

| Tool | Quantity | Status | Location | Notes |
|------|----------|--------|----------|-------|
| Digital Caliper (15cm, 0.001" accuracy) | 1 | Available | Workbench | Precision measurements |
| LCR-T4 Component Tester | 1 | Available | Workbench | Tests transistors, diodes, capacitors, ESR, Mega328-based |
| Digital Multimeter | 0 | Need to order | - | Voltage, current, resistance testing |

### Hand Tools

| Tool | Quantity | Status | Location | Notes |
|------|----------|--------|----------|-------|
| Wire Strippers | 1 | Available | Workbench | For custom wire lengths |
| Flush Cutters | 1 | Available | Workbench | Clean component trimming |
| Needle Nose Pliers | 1 | Available | Workbench | Wire manipulation |
| Screwdriver Set | 1 set | Available | Workbench | Various sizes |
| Laptop Screw Kit (M2/M2.5/M3) | 1 kit (360pcs) | Available | Tool drawer | Flat head screws for electronics |
| Tweezers (ESD-safe) | 0 | Need To Order | | |

---

## 3D Printing

### Printer & Filament

| Item | Quantity | Status | Location | Notes |
|------|----------|--------|----------|-------|
| Creality Ender-3 V3 | 1 | Available | 3D Printer Area | FDM printer |
| Hyper-PAL Filament (Grey) | 1 spool | Available | Storage shelf | General purpose printing |
| Hyper-PAL Filament (Orange) | 1 spool | Available | Storage shelf | General purpose printing |
| Hyper-PAL Filament (Black) | 1 spool | Available | Storage shelf | General purpose printing |
| Hyper-PAL Filament (White) | 1 spool | Available | Storage shelf | General purpose printing |
| Hyper-PAL Filament (Pink) | 1 spool | Available | Storage shelf | General purpose printing |
| Hyper-PETG Filament (White) | 1 spool | Available | Storage shelf | Higher strength applications |

---

## Smart Home Devices

### Smart Plugs

| Device | Quantity | Status | Location | Notes |
|--------|----------|--------|----------|-------|
| TP-Link Tapo Smart Plug | 1 | Deployed | Kitchen | Coffee Machine (Auto Off 1 Hour) |
| TP-Link Tapo Smart Plug | 1 | Deployed | Office | Glue Gun (Auto Off 30 Min) |
| TP-Link Tapo Smart Plug | 1 | Deployed | Office | Creality Ender3 V3 |
| TP-Link Tapo Smart Plug | 1 | Deployed | Bedroom | Bedroom Fan |
| TP-Link Tapo Smart Plug | 1 | Available | Electronics bin | Available for new automations |

### Voice Assistants

| Device | Quantity | Status | Location | Notes |
|--------|----------|--------|----------|-------|
| Google Nest Audio | 1 | Deployed | Bedroom | "Bedroom Speaker" (media_player.living_room_speaker) |

---

## Project Enclosures

| Item | Quantity | Status | Location | Notes |
|------|----------|--------|----------|-------|
| Small Plastic Project Box | 0 | Need to order | - | For sensor nodes |
| Wall-Mount Enclosure | 0 | Need to order | - | For central display coordinator |

---

## Planned Purchases

### High Priority (for current projects)

- [ ] DHT22 Temperature Sensors (x3) - For Project 8 sensor nodes
- [ ] 18650 Li-Ion Batteries (x3) - For battery-powered sensor nodes
- [ ] TP4056 Charger Modules (x3) - For battery charging
- [ ] Digital Multimeter - Essential for debugging
- [ ] IRLZ44N MOSFET (x5) - For LED control projects
- [ ] LED Strip (WS2812B, 1m+) - For motion lighting project (have rings, need strips)

### Medium Priority (for future projects)

- [ ] BME280 I2C Sensors (x3) - Upgrade from DHT22 for better accuracy
- [ ] Capacitive Soil Moisture Sensors (x3) - For plant monitoring
- [ ] Helping Hands with Magnifier - Soldering aid
- [ ] Project Enclosures (assorted sizes)
- [ ] LDR Modules (x5) - For light level detection

### Low Priority (nice to have)

- [ ] Solar Panel (6V 1W) - For outdoor sensors
- [ ] HC-SR04 Ultrasonic Sensors (x3) - For distance detection
- [ ] Larger OLED Display (1.3" or 2.4") - Better visibility
- [ ] 12V Power Supply (2A+) - For LED strips

---

## Component Status Legend

- **Available:** In stock and ready to use
- **Deployed:** Currently in use in a project
- **Reserved:** Set aside for a specific planned project
- **Need to order:** Required for upcoming projects
- **On order:** Ordered but not yet received

---

## Project Ideas with Available Components

### 🎙️ Voice Assistant Projects

**Components Available:**
- 20x ESP32 C6/S3 boards
- 5x INMP441 microphones (I2S)
- 5x MAX98357A amplifiers (I2S)
- 4x Speakers (3W)
- 5x WS2812B LED rings (visual feedback)

**Possible Projects:**
- Multi-room voice assistant system (custom wake word, local processing)
- Voice-controlled RGB lighting with visual feedback
- Two-way intercom system between rooms
- Voice-activated smart home control panels

### 👁️ Presence Detection Projects

**Components Available:**
- 3x PIR motion sensors (M5Stack AS312)
- 2x HC-SR501 PIR sensors
- 2x LD2410C mmWave radar sensors

**Possible Projects:**
- Room occupancy detection (true presence vs motion)
- Automatic lighting control (motion + ambient light)
- Security/intrusion detection system
- Energy-saving automation (turn off devices when room empty)

### 💡 Smart Lighting Projects

**Components Available:**
- 5x WS2812B RGB LED rings
- 20x Capacitive touch buttons
- 5x PIR sensors
- 2x LD2410C mmWave sensors

**Possible Projects:**
- Touch-controlled RGB mood lighting
- Motion-activated under-cabinet lighting
- Presence-aware desk lamp (dims when you leave)
- Color-changing notification lights (smart home alerts)

### 🌡️ Environmental Monitoring

**Components Available:**
- 1x M5Stack ENVIV sensors (temp, humidity, pressure, eCO2, TVOC)
- 20x ESP32 boards (low power for battery operation)

**Possible Projects:**
- Multi-room air quality monitoring
- HVAC efficiency tracking
- Greenhouse/terrarium climate control
- Outdoor weather station

### 🔊 Audio Projects

**Components Available:**
- 5x I2S microphones
- 5x I2S amplifiers
- 4x Speakers
- 2x Buzzers (active/passive)

**Possible Projects:**
- Smart doorbell with voice announcements
- Baby monitor with sound detection
- Music-reactive LED displays
- Noise level monitoring system

---

## Storage Organization

- **Electronics Bin:** General components (resistors, capacitors, LEDs, jumper wires)
- **Component Organizer:** Small parts (resistors, capacitors) sorted by value with labels
- **Workbench:** Active tools and current project components
- **Storage Shelf:** Filament, large components, enclosures
- **Tool Drawer:** Screws, fasteners, hardware

---

## Component Tracking Tips

1. **Update this document immediately** when components are:
   - Purchased/received
   - Used in a project
   - Moved to a different location
   - Running low and need reordering

2. **Before starting a project:**
   - Check this inventory first
   - Mark components as "Reserved" if needed
   - Add missing components to "Planned Purchases"

3. **After completing a project:**
   - Update component status (Deployed/Available)
   - Return unused components to proper storage
   - Note any components that need replacement

4. **Maintenance:**
   - Monthly inventory check for damaged/missing items
   - Clean and organize component storage boxes
   - Test and calibrate measurement tools

---

## Quick Links

- [ESP32 Starter Projects](esp32-starter-projects.md) - Component requirements for each project
- [Electronics Workbench Guide](electronics-workbench-complete-guide.md) - Tool usage and safety
- [Beginner Safety Guide](beginner-safety-guide.md) - Essential safety information
- [Project Guides (Beginner)](projects/01-blink-led.md) - Step-by-step tutorials
- [Project Guides (Intermediate)](projects/05-environmental-station.md) - Advanced builds

---

**Inventory Summary:**
- **ESP32 Boards:** 49 total (46 available, 3 deployed)
- **Sensors:** 18+ modules (motion, presence, environmental, audio)
- **Passive Components:** 2000+ pieces (resistors, capacitors, diodes, transistors)
- **Tools:** Professional soldering station, component tester, calipers, hand tools
- **Ready to Build:** Voice assistants, presence detection, smart lighting, environmental monitoring

**🎉 You're well-equipped for advanced ESP32 projects!**
