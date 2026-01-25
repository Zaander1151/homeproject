# XIAO ESP32-C6 LED Strip Controller

Expandable SK6812 RGBW LED strip controller using the Seeed XIAO ESP32-C6. Designed for 1m sections at 30 LED/m with power injection for reliable expansion.

## Overview

| Specification | Value |
|---------------|-------|
| **Controller** | Seeed XIAO ESP32-C6 |
| **LED Strip** | SK6812 RGBW (30 LED/m) |
| **Data Pin** | GPIO2 |
| **Power** | 5V DC (external supply) |
| **Section Length** | 1 meter (30 LEDs) |
| **Expandable** | Yes, with power injection |

---

## Circuit Diagram

### Power Distribution Overview

```
                              5V Power Supply
                           (3A minimum, 5A recommended)
                                    │
                           ┌────────┴────────┐
                           │   INLINE FUSE   │
                           │   (10A blade)   │
                           └────────┬────────┘
                                    │
                    ┌───────────────┴───────────────┐
                    │                               │
               ─────┴─────                     ─────┴─────
                5V (Red)                       GND (Black)
               ─────┬─────                     ─────┬─────
                    │                               │
        ┌───────────┼───────────────────────────────┼───────────┐
        │           │                               │           │
        │      ┌────┴────┐                     ┌────┴────┐      │
        │      │  1000µF │ Electrolytic        │         │      │
        │      │  16V+   │ Capacitor           │         │      │
        │      └────┬────┘                     │         │      │
        │           │                          │         │      │
        │     ══════╧══════════════════════════╧══════   │      │
        │     ║  POWER DISTRIBUTION BUS (18 AWG)     ║   │      │
        │     ║  5V Rail ─────────────────────────── ║   │      │
        │     ║  GND Rail ────────────────────────── ║   │      │
        │     ══════╤══════════════════════════╤══════   │      │
        │           │                          │         │      │
        │           │                          │         │      │
        │    ┌──────┴──────┐            ┌──────┴──────┐  │      │
        │    │ JST-SM 3pin │            │ JST-SM 2pin │  │      │
        │    │  to XIAO    │            │ Power Tap   │  │      │
        │    └──────┬──────┘            └──────┬──────┘  │      │
        │           │                          │         │      │
        └───────────┼──────────────────────────┼─────────┘      │
                    │                          │                │
                    ▼                          ▼                │
                                                                │
                                                                │
                                      Common Ground ────────────┘
```

---

### Controller Unit

```
                         XIAO ESP32-C6
                    ┌─────────────────────┐
                    │                     │
                    │       [USB-C]       │
                    │                     │
       From PSU ────┤ 5V             GND  ├──── From PSU
                    │                     │
                    │ D2/GPIO2            │
                    │    │                │
                    │    │   D0/GPIO0     │──── (Future: Button)
                    │    │                │
                    │    │   D1/GPIO1     │──── (Future: Sensor)
                    │    │                │
                    └────┼────────────────┘
                         │
                    ┌────┴────┐
                    │  470Ω   │
                    └────┬────┘
                         │
                         ▼
                  ┌──────────────┐
                  │ JST-SM 3-pin │ DATA OUT (to first strip section)
                  │ Female       │
                  │ 5V/DIN/GND   │
                  └──────────────┘
```

---

### LED Strip Section

Each 1m section uses the same wiring pattern. Repeat for expansion.

```
     POWER IN                                              POWER IN
    (from bus)                                            (from bus)
        │                                                      │
        ▼                                                      ▼
   ┌─────────┐                                            ┌─────────┐
   │JST-SM   │                                            │JST-SM   │
   │2-pin    │                                            │2-pin    │
   │5V / GND │                                            │5V / GND │
   └────┬────┘                                            └────┬────┘
        │              SK6812 RGBW LED STRIP                   │
        │                 1 meter / 30 LEDs                    │
        │    ┌─────────────────────────────────────────┐       │
        └───►│●  ●  ●  ●  ●  ●  ●  ●  ●  ●  ●  ●  ●  ● │◄──────┘
   DATA IN   │ 1  2  3  4  5  6  7  8  9 10 ... ... 30 │   DATA OUT
     ───────►│ ►  ►  ►  ►  ►  ►  ►  ►  ►  ►  ►  ►  ►  ►│────────►
             └─────────────────────────────────────────┘
        ▲                                                      │
   ┌────┴────────┐                                    ┌────────┴────┐
   │ JST-SM 3-pin│                                    │ JST-SM 3-pin│
   │ Male        │                                    │ Female      │
   │ 5V/DIN/GND  │                                    │ 5V/DOUT/GND │
   └─────────────┘                                    └─────────────┘
    From previous                                      To next section
    section/controller                                 (or cap if end)
```

---

### Expansion Layout (Top View)

```
    5V POWER SUPPLY (5A)
           │
           ▼
    ┌──────────────┐
    │   DC Jack    │
    │   5.5x2.1mm  │
    └──────┬───────┘
           │
    ┌──────┴───────┐
    │  INLINE FUSE │
    │  (10A blade) │
    └──────┬───────┘
           │
    ═══════╪════════════════════════════════════════════════════════════
           │                    POWER BUS (18 AWG)
    ═══════╪════════════════════════════════════════════════════════════
           │         │              │              │              │
           │         │              │              │              │
           ▼         ▼              ▼              ▼              ▼
    ┌───────────┐ ┌─────┐       ┌─────┐       ┌─────┐       ┌─────┐
    │   XIAO    │ │POWER│       │POWER│       │POWER│       │POWER│
    │Controller │ │ TAP │       │ TAP │       │ TAP │       │ TAP │
    └─────┬─────┘ └──┬──┘       └──┬──┘       └──┬──┘       └──┬──┘
          │          │             │             │             │
          │     ┌────┴────┐   ┌────┴────┐   ┌────┴────┐   ┌────┴────┐
          │     │         │   │         │   │         │   │         │
          └────►│ Strip 1 │──►│ Strip 2 │──►│ Strip 3 │──►│ Strip 4 │
          DATA  │  1m/30  │   │  1m/30  │   │  1m/30  │   │  1m/30  │
                │         │   │         │   │         │   │         │
                └─────────┘   └─────────┘   └─────────┘   └─────────┘

                ◄─── START ───►  ◄──────── EXPANSION ─────────────►
```

---

## Wiring Summary

| XIAO ESP32-C6 | Component | Notes |
|---------------|-----------|-------|
| GPIO2 (D2) | 470Ω → LED DIN | Data signal |
| 5V | Power Bus | From external PSU |
| GND | Common Ground | Shared with PSU and strips |

---

## Connector Pinouts

### JST-XH 3-Pin (Data + Power)

| Pin | Color | Function |
|-----|-------|----------|
| 1 | Red | 5V (from bus) |
| 2 | Green | DATA |
| 3 | Black | GND (from bus) |

Used at each strip section for data passthrough and power injection from the bus.

### Soldering Wires to JST-XH Headers

When using through-hole JST-XH headers without a PCB, solder wires directly to the pins:

**Steps:**

1. **Tin separately** - Tin the header pins and wire ends before joining
2. **Slide heat shrink first** - Put small heat shrink on each wire before soldering
3. **Solder quickly** - Don't dwell or the plastic housing deforms
4. **Shrink individual tubes** - Insulate each pin connection
5. **Strain relief** - Hot glue or large heat shrink at the base where wires meet header

**Finished assembly:**
```
        Wires (to bus/strip)
             │ │ │
        ┌────┴─┴─┴────┐
        │ heat shrink │  ← individual tubes per wire
        │  + hot glue │  ← strain relief at base
        ├─────────────┤
        │ ┌─┬─┬─┐     │
        │ │1│2│3│     │  ← header pins
        │ └─┴─┴─┘     │
        └─────────────┘
              ▼
        [JST-XH Housing]  ← plugs in here
```

**Tips:**

- Mark pin 1 before soldering - match your pinout
- Don't flex the joint repeatedly - solder-to-pin connections fatigue
- Hot glue adds mechanical strength and insulation

---

## Component List

### Initial Build (1m / 30 LEDs)

| Qty | Component | Notes |
|-----|-----------|-------|
| 1 | XIAO ESP32-C6 | Controller |
| 1 | SK6812 RGBW Strip 1m/30LED | IP30 (indoor) or IP65 (outdoor) |
| 1 | 5V 15A Power Supply | DC 5.5x2.1mm barrel jack (size for final length) |
| 1 | DC Jack Female Panel Mount | For enclosure |
| 1 | Inline Blade Fuse Holder | With 10A blade fuse |
| 1 | 1000µF 16V Capacitor | Electrolytic, power smoothing |
| 1 | 470Ω Resistor | 1/4W, data line protection |
| 2 | Wago 221-413 (3-port) | Power distribution in enclosure (1x 5V, 1x GND) |
| 1 | JST-XH 3-pin Connector | Data + power to first strip |
| 1m | Heat Shrink Tubing (assorted) | For inline solder tap insulation |
| 5m | 18 AWG Silicone Wire (Red) | 5V power bus (length of installation) |
| 5m | 18 AWG Silicone Wire (Black) | GND power bus (length of installation) |
| 0.3m | 22 AWG Wire (Green) | Data line |

### Per Expansion Section (each additional 1m)

| Qty | Component | Notes |
|-----|-----------|-------|
| 1 | SK6812 RGBW Strip 1m/30LED | Match existing strip type |
| 1 | JST-XH 3-pin Connector Pair | Data + power (in from bus/previous strip, out to next) |
| 0.2m | 22 AWG Wire (Red/Black) | Tap wires from bus to JST |
| - | Heat Shrink | For solder tap joints |

---

## Power Calculations

SK6812 RGBW LEDs draw approximately **60mA per LED** at full white (all channels at 100%).

| Sections | LEDs | Max Current | Recommended PSU | Fuse Rating |
|----------|------|-------------|-----------------|-------------|
| 1m | 30 | 1.8A | 3A | 3A |
| 2m | 60 | 3.6A | 5A | 5A |
| 3m | 90 | 5.4A | 8A | 7.5A |
| 4m | 120 | 7.2A | 10A | 10A |
| 5m | 150 | 9.0A | 12A | 10A |
| 6m | 180 | 10.8A | 15A | 15A |

!!! warning "Power Injection Required"
    Power injection at every 1m prevents voltage drop and ensures consistent brightness across all LEDs.

---

## Critical Notes

### 1. Power Injection

- Inject power at the **START** of each 1m section
- Without injection: LEDs at end will be dimmer/discolored
- Power bus runs parallel to strip, taps at each section

### 2. Data Signal

- Data flows **IN SERIES** through all sections
- 470Ω resistor only at controller output (not between sections)
- Keep data wires short between sections (<10cm ideal)

### 3. Common Ground

**ALL grounds must connect together:**

- Power supply GND
- XIAO GND
- All strip section GNDs
- Power bus GND

### 4. Capacitors

- Place 1000µF cap at power input (near PSU connection)
- Optional: Add 100µF at each power injection point

### 5. Fuse Protection

- Place inline fuse between DC jack and power bus
- Fuse protects against short circuits and wiring faults
- Size fuse ~10-20% above expected max current (see Power Calculations table)
- Automotive blade fuses are cheap and easy to replace
- For 5-6m installations, use 10A fuse with 12-15A PSU

### 6. Power Bus Construction

The power bus runs parallel to the LED strips with inline solder taps at each section for power injection. This keeps the installation compact without bulky connectors at each junction.

**Bus layout:**
```
[Enclosure] ═══╤═══════════╤═══════════╤═══════════╤═══► (end)
               │           │           │           │
            Tap 1       Tap 2       Tap 3       Tap 4
               ▼           ▼           ▼           ▼
            Strip 1     Strip 2     Strip 3     Strip 4
```

**Creating inline solder taps:**

1. **Score two rings** - Use razor/X-Acto knife to lightly cut around the wire insulation at each end of the window (10-15mm apart). Cut insulation only, not copper.

2. **Lengthwise slit** - Connect the two rings with a straight cut along the top of the wire.

3. **Peel the window** - Lift and remove the insulation flap, exposing bare copper.

```
        ┌─ score ─┐
        ▼         ▼
    ═══════════════════
        │█████████│      ← peel this section
    ═══════════════════
        ▲─────────▲
          lengthwise slit
```

4. **Tin the window** - Apply solder to the exposed copper.

5. **Solder the tap wire** - Attach 22 AWG wire for the JST connection.

6. **Heat shrink** - Cover the joint with heat shrink tubing for insulation and strain relief.

**Tips:**
- Use a sharp blade, replace if dull
- Silicone insulation peels cleanly
- Nicking a strand or two is fine at these currents
- Tin before soldering for better flow
- Stagger 5V and GND taps slightly to avoid bulk

### 7. Connector Orientation

- Mark "IN" and "OUT" on each strip section
- Data direction matters! (arrows on strip PCB)
- Power polarity matters! (double-check before powering)

### 8. ESPHome Config

Update `num_leds:` in YAML when adding sections:

- 1m = 30 LEDs
- 2m = 60 LEDs
- 3m = 90 LEDs
- 4m = 120 LEDs
- 5m = 150 LEDs
- 6m = 180 LEDs

---

## ESPHome Configuration

The ESPHome config file is located at:

```
/home/hazzard/home-assistant/esphome/xiao-c6-rgb-strip-test.yaml
```

### Key Configuration

```yaml
light:
  - platform: esp32_rmt_led_strip
    rgb_order: GRB
    chipset: SK6812
    is_rgbw: true
    pin: GPIO2
    num_leds: 30  # Update for your total LED count
    name: "RGB Strip"
    id: rgb_strip
    restore_mode: RESTORE_DEFAULT_OFF
    default_transition_length: 0.5s
```

### Available Effects

- Random
- Strobe
- Flicker
- Rainbow
- Color Wipe
- Scan
- Twinkle
- Fireworks

---

## Home Assistant Entity

| Property | Value |
|----------|-------|
| **Entity ID** | `light.led_office_desk_rgb_strip` |
| **IP Address** | 192.168.40.185 |
| **Platform** | ESPHome |

---

## Enclosure Requirements

The controller enclosure houses the power input, fuse, distribution, and microcontroller. The power bus exits the enclosure and runs along the LED strip installation.

**Components inside enclosure:**

| Component | Dimensions (approx) |
|-----------|---------------------|
| XIAO ESP32-C6 | 21 × 18 × 4mm |
| DC Jack (panel mount) | 14mm diameter hole |
| Inline Blade Fuse Holder | 40 × 20 × 15mm |
| 1000µF Capacitor | 10mm dia × 20mm tall |
| Wago 221-413 (×2) | 18 × 19 × 8mm each |
| 470Ω Resistor | 6 × 2mm |

**Connections exiting enclosure:**

- 18 AWG 5V bus (red)
- 18 AWG GND bus (black)
- JST-XH 3-pin to first strip (5V, Data, GND)

**Design considerations:**

- Strain relief for bus wires at exit point
- Ventilation not critical (low heat)
- Access to XIAO USB-C for reprogramming
- Mounting holes or clips for installation location

---

## Related Files

- **ESPHome Config:** `/home/hazzard/home-assistant/esphome/xiao-c6-rgb-strip-test.yaml`
- **3D Enclosure:** (to be designed)

---

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| LEDs dim at end of strip | Voltage drop | Add power injection |
| First LED flickers/wrong color | Missing data resistor | Add 470Ω on data line |
| Random flickering | Power noise | Add 1000µF capacitor |
| No LEDs light up | Wrong data direction | Check arrow direction on strip |
| Only some sections work | Broken data connection | Check JST connectors |
