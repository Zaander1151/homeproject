# ESP32-CAM Security Camera Case

**Project:** AI-Integrated Security Camera System
**Hardware:** ESP32-CAM-MB with OV2640 2MP Camera
**Printer:** Creality Ender-3 V3
**Material:** Hyper-PAL Filament (Grey) or Hyper-PETG

---

## Overview

This is a modular, 3D-printable enclosure system for the ESP32-CAM-MB development board, designed for a 4-camera home security system integrated with Home Assistant and Ollama AI detection.

**Design Goals:**
- Compact, professional appearance
- Excellent ventilation (ESP32 runs warm)
- Modular mounting system (wall, corner, ceiling)
- Camera lens protection
- Easy access to micro USB and GPIO pins
- Optional IR LED housing for night vision

---

## Hardware Specifications

**ESP32-CAM-MB Dimensions:**
- PCB: 39.8mm × 27mm × 4.5mm
- MB Board Height: ~10mm
- Camera Module Height: ~10-15mm above PCB
- Total Assembly: ~40mm × 27mm × 25mm

**Features:**
- ESP32-S dual-core @ 240MHz
- OV2640 2MP camera (1600×1200)
- WiFi 802.11 b/g/n + Bluetooth 4.2
- CH340G USB-to-serial (Micro USB)
- 9 GPIO pins available
- TF card slot (up to 4GB)
- Operating: -20°C to 85°C

---

## Case Design Specifications

### Main Enclosure Body

**Exterior Dimensions:**
- Length: 50mm
- Width: 35mm
- Height: 30mm (base) + mounting bracket
- Wall Thickness: 2mm

**Features:**

1. **Front Face:**
   - Camera lens opening: Ø12mm with 1mm bezel lip
   - Recessed 0.5mm to prevent scratches
   - Optional threaded insert for lens cover

2. **Top/Side Ventilation:**
   - 8× 2mm × 10mm ventilation slots on each side
   - 4× Ø3mm circular vents on top
   - Keeps airflow without exposing internals

3. **Bottom/Back:**
   - Micro USB cutout: 10mm × 4mm (centered)
   - Cable exit channel with strain relief ridge
   - 4× M3 mounting boss inserts (for brackets)
   - GPIO breakout slot: 20mm × 3mm (optional access)

4. **Interior:**
   - PCB support ribs (0.5mm raised)
   - 4× snap-fit posts (2mm diameter, flexible TPU tips optional)
   - Cable management channels
   - Space for optional 40mm × 40mm × 10mm cooling fan

**Assembly Method:**
- Snap-fit design (no screws required for main body)
- Optional: 2× M2.5 screws for extra security
- Rear cover slides on with clips (tool-free opening)

---

### Mounting Bracket System

All brackets attach to the case via 4× M3 threaded inserts on the rear panel.

#### 1. Wall Mount Bracket

**Dimensions:** 50mm × 40mm × 5mm
**Angle Adjustment:** 0° to 45° in 15° increments

**Features:**
- 2× Ø4mm mounting holes (8mm spacing)
- Ball-joint style pivot (print-in-place or separate assembly)
- Cable routing channel along back
- Drywall anchor compatible

**Print Settings:**
- Supports: Yes (for overhang)
- Infill: 40%
- Perimeters: 4

#### 2. Corner Mount Bracket

**Dimensions:** 50mm × 50mm × 90° internal angle
**Use Case:** Room corners, ceiling/wall junction

**Features:**
- 90° bracket fits into corners
- 4× mounting holes (2 per surface)
- Integrated cable clip
- Covers dead zones

**Print Settings:**
- Orientation: Print flat, corner vertical
- Supports: None needed
- Infill: 30%

#### 3. Ceiling Mount Bracket

**Dimensions:** Ø60mm circular base × 15mm height
**Angle:** Downward facing (adjustable 0-30° tilt)

**Features:**
- Flush mount design
- 3× Ø4mm mounting holes (120° apart)
- Swivel joint for pan adjustment
- Wire pass-through center hole

**Print Settings:**
- Supports: Yes (for overhang on tilt joint)
- Infill: 50% (strength for ceiling load)

#### 4. Magnetic Mount (Optional)

**Dimensions:** Same as wall mount + magnet pockets
**Magnet Specs:** 4× Ø10mm × 2mm neodymium magnets

**Features:**
- Embedded magnet pockets (press-fit)
- Attaches to metal surfaces (door frames, shelves)
- Quick repositioning without tools

**Print Settings:**
- Pause at layer for magnet insertion
- Infill: 60% (magnet retention)

---

## IR LED Night Vision Add-on

**Optional Component:** Adds infrared illumination for zero-light recording

### IR LED Ring Specifications

**Components Required:**
- 6× IR LEDs (850nm, 5mm, 100mA each)
- 6× 33Ω resistors (for 5V power)
- Perfboard: 30mm × 30mm
- Wire: 24 AWG red/black
- Power: 5V rail from ESP32 (or external)

**Housing Design:**
- Ring diameter: Ø35mm (surrounds camera lens)
- LED spacing: 60° apart (6 LEDs)
- Thickness: 3mm
- Attaches to front face with 4× M2 screws
- Diffuser: Print in natural/clear PETG for light spread

**Circuit:**
```
5V ----[33Ω]---[IR LED]---[33Ω]---[IR LED]--- GND
        (Series pairs of 3× 2 LED groups in parallel)
```

**Power Draw:** ~300mA @ 5V (0.5W per LED × 6 = 3W total)

**Print Settings:**
- Material: Natural PETG (light-transmitting)
- Layer Height: 0.12mm (fine detail)
- Infill: 30%
- Post-process: Sand smooth, acetone vapor for clarity (PETG)

---

## Printing Instructions

### General Settings (Ender-3 V3)

**Main Case Body:**
- Material: Hyper-PAL (Grey) or Hyper-PETG
- Layer Height: 0.2mm
- Nozzle Temp: 210°C (PAL) / 235°C (PETG)
- Bed Temp: 60°C (PAL) / 80°C (PETG)
- Infill: 20% (adequate for structure)
- Perimeter Walls: 3
- Top/Bottom Layers: 4
- Speed: 50mm/s
- Supports: None for main body
- Brim: 5mm (recommended for bed adhesion)

**Mounting Brackets:**
- Same settings as above, but increase infill to 40-50%
- Supports: Yes (for angled/overhanging brackets)

**IR LED Ring (if using):**
- Material: Natural PETG (for light transmission)
- Layer Height: 0.12mm (smooth finish)
- Infill: 30%
- Supports: None

### Print Orientation

**Main Case:**
- Bottom (with USB cutout) facing down on bed
- Front face vertical (no supports needed)

**Mounting Brackets:**
- Wall Mount: Flat on bed, bracket arm vertical
- Corner Mount: 90° angle horizontal on bed
- Ceiling Mount: Circular base down, joint upward

### Estimated Print Times

- Main Case Body: ~3.5 hours
- Rear Cover: ~1 hour
- Wall Mount Bracket: ~2 hours
- Corner Mount Bracket: ~2.5 hours
- Ceiling Mount Bracket: ~3 hours
- IR LED Ring: ~1.5 hours

**Total for 4 Cameras (with wall mounts):** ~26 hours

---

## Assembly Instructions

### Step 1: Prepare Components

**Tools Needed:**
- M3 heat-set threaded inserts (8 per camera)
- Soldering iron (for inserts)
- M3 × 8mm screws (4 per camera)
- M2.5 × 6mm screws (2 per camera, optional)
- Wire cutters/strippers
- Micro USB cable

**Components:**
- ESP32-CAM-MB board (assembled)
- Printed case parts
- Mounting hardware

### Step 2: Install Heat-Set Inserts

1. Heat soldering iron to 200°C
2. Place M3 insert on rear panel mounting bosses
3. Press gently until flush with surface
4. Repeat for all 4 corner bosses
5. Let cool for 1 minute

### Step 3: Mount ESP32-CAM Board

1. Route micro USB cable through rear opening
2. Align ESP32-CAM-MB board with interior support ribs
3. Camera lens should align with front opening (Ø12mm)
4. Press down gently until snap-fit posts engage
5. Optional: Secure with 2× M2.5 screws through PCB mounting holes

### Step 4: Close Rear Cover

1. Route cable through strain relief channel
2. Slide rear cover onto case body
3. Clips should engage with audible snap
4. Test: Pull gently to ensure secure fit

### Step 5: Attach Mounting Bracket

1. Choose bracket type (wall/corner/ceiling)
2. Align bracket with rear heat-set inserts
3. Thread 4× M3 screws through bracket into inserts
4. Tighten until snug (don't overtighten plastic)

### Step 6: Wall Mounting

**For Wall Mount:**
1. Mark drill locations on wall (use level)
2. Drill pilot holes
3. Insert drywall anchors (if needed)
4. Secure bracket with screws
5. Adjust angle as needed

**For Magnetic Mount:**
1. Press 4× neodymium magnets into pockets
2. Attach to metal surface
3. Adjust position and angle

**For Corner/Ceiling Mounts:**
1. Follow same process as wall mount
2. Ensure both surfaces (corner) or ceiling support weight

### Step 7: Cable Management

1. Route micro USB cable along bracket channel
2. Use cable clips or zip ties to secure to wall
3. Connect to 5V power supply
4. Ensure no tension on USB connector

### Step 8: IR LED Installation (Optional)

1. Solder IR LED circuit on perfboard
2. Connect power wires to ESP32 5V and GND pins
3. Align IR ring with front face
4. Secure with 4× M2 screws
5. Test: View through phone camera (IR LEDs glow on camera screen)

---

## ESPHome Configuration

Once mounted, flash with ESPHome firmware for Home Assistant integration.

**Create:** `/home/hazzard/home-assistant/esphome/camera-{location}.yaml`

**Example Config:**
```yaml
esphome:
  name: camera-front-door
  platform: ESP32
  board: esp32cam

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  manual_ip:
    static_ip: 192.168.40.110  # Front Door
    gateway: 192.168.40.1
    subnet: 255.255.255.0
    dns1: 8.8.8.8

api:
  encryption:
    key: !secret api_key

ota:
  password: !secret ota_password

logger:

# Camera Configuration
esp32_camera:
  name: "Front Door Camera"
  external_clock:
    pin: GPIO0
    frequency: 20MHz
  i2c_pins:
    sda: GPIO26
    scl: GPIO27
  data_pins: [GPIO5, GPIO18, GPIO19, GPIO21, GPIO36, GPIO39, GPIO34, GPIO35]
  vsync_pin: GPIO25
  href_pin: GPIO23
  pixel_clock_pin: GPIO22
  power_down_pin: GPIO32

  # Image Settings
  resolution: 1600x1200  # UXGA (2MP)
  jpeg_quality: 10  # Lower = better quality (10-63)
  max_framerate: 10fps
  idle_framerate: 0.1fps  # Power saving when not streaming

  # Image Adjustments
  vertical_flip: false
  horizontal_mirror: false
  contrast: 0  # -2 to 2
  brightness: 0  # -2 to 2
  saturation: 0  # -2 to 2

# LED Flash (if using external white LED)
output:
  - platform: gpio
    pin: GPIO4
    id: camera_flash

light:
  - platform: binary
    output: camera_flash
    name: "Camera Flash"

# Status LED
status_led:
  pin:
    number: GPIO33
    inverted: true

# Motion Detection (via Home Assistant)
binary_sensor:
  - platform: gpio
    pin: GPIO13
    name: "Camera PIR Sensor"
    device_class: motion
```

**Assign Static IPs:**
- 192.168.40.110 - Front Door Camera
- 192.168.40.111 - Living Room Camera
- 192.168.40.112 - Bedroom Hallway Camera
- 192.168.40.113 - Balcony/Window Camera

**Flash Firmware:**
```bash
cd /home/hazzard/home-assistant/esphome
docker exec -it esphome esphome run camera-front-door.yaml
```

---

## Home Assistant Integration

### Add Camera Entities

ESPHome cameras automatically appear in Home Assistant once flashed and online.

**View in HA:**
1. Navigate to Configuration → Integrations
2. ESPHome should show 4 new devices
3. Add to Lovelace dashboard

**Lovelace Card:**
```yaml
type: picture-glance
title: Security Cameras
camera_image: camera.front_door_camera
entities:
  - camera.front_door_camera
  - camera.living_room_camera
  - camera.bedroom_hallway_camera
  - camera.balcony_camera
camera_view: live
```

### AI Motion Detection with Ollama

**Use n8n workflow to analyze frames:**

1. Home Assistant triggers on motion detection
2. Snapshot sent to n8n webhook
3. n8n calls Ollama vision model (`llama-vision` or `minicpm-v`)
4. AI analyzes: "Is there a person? Package? Pet?"
5. Send alert via Telegram with classification

**n8n Workflow Steps:**
1. Webhook Trigger (from HA automation)
2. HTTP Request to HA camera snapshot
3. Ollama Vision Node (analyze image)
4. Switch Node (route based on detection)
5. Telegram Node (send alert with image)

**Home Assistant Automation:**
```yaml
automation:
  - alias: "AI Security Alert"
    trigger:
      - platform: state
        entity_id: binary_sensor.front_door_camera_motion
        to: 'on'
    action:
      - service: camera.snapshot
        data:
          entity_id: camera.front_door_camera
          filename: /tmp/motion_snapshot.jpg
      - service: rest_command.n8n_analyze_motion
        data:
          camera: front_door
          timestamp: "{{ now().isoformat() }}"
```

---

## OpenSCAD Parametric Design

For customization, here's an OpenSCAD script to generate the case with adjustable parameters.

**Save as:** `esp32-cam-case.scad`

```openscad
// ESP32-CAM Security Camera Case
// Parametric Design - Adjust dimensions below

// ===== PARAMETERS =====
// Main case dimensions
case_length = 50;
case_width = 35;
case_height = 30;
wall_thickness = 2;

// PCB dimensions
pcb_length = 39.8;
pcb_width = 27;
pcb_height = 4.5;
pcb_support_height = 2;

// Camera lens opening
lens_diameter = 12;
lens_bezel_width = 1;

// Ventilation
vent_slot_length = 10;
vent_slot_width = 2;
vent_hole_diameter = 3;

// USB cutout
usb_width = 10;
usb_height = 4;

// Mounting
mounting_boss_diameter = 5;
mounting_hole_diameter = 3;  // M3 threaded insert

// ===== MODULES =====

// Main case body
module case_body() {
    difference() {
        // Outer shell
        cube([case_length, case_width, case_height]);

        // Hollow interior
        translate([wall_thickness, wall_thickness, wall_thickness])
            cube([
                case_length - 2*wall_thickness,
                case_width - 2*wall_thickness,
                case_height
            ]);

        // Camera lens opening (front)
        translate([case_length/2, case_width/2, -1])
            cylinder(h=wall_thickness+2, d=lens_diameter, $fn=50);

        // USB cutout (back)
        translate([case_length/2 - usb_width/2, -1, case_height/3])
            cube([usb_width, wall_thickness+2, usb_height]);

        // Side ventilation slots (8 per side)
        for (i = [0:7]) {
            translate([
                wall_thickness + 5 + i*5,
                -1,
                case_height/2
            ])
            cube([vent_slot_width, wall_thickness+2, vent_slot_length]);

            translate([
                wall_thickness + 5 + i*5,
                case_width - wall_thickness - 1,
                case_height/2
            ])
            cube([vent_slot_width, wall_thickness+2, vent_slot_length]);
        }

        // Top ventilation holes (4 holes)
        for (i = [0:3]) {
            translate([
                case_length/2 + (i-1.5)*8,
                case_width/2,
                case_height - wall_thickness - 1
            ])
            cylinder(h=wall_thickness+2, d=vent_hole_diameter, $fn=20);
        }
    }

    // PCB support ribs
    translate([
        (case_length - pcb_length)/2,
        (case_width - pcb_width)/2,
        wall_thickness
    ])
    cube([pcb_length, 1, pcb_support_height]);

    translate([
        (case_length - pcb_length)/2,
        (case_width - pcb_width)/2 + pcb_width - 1,
        wall_thickness
    ])
    cube([pcb_length, 1, pcb_support_height]);

    // Snap-fit posts (4 corners)
    post_positions = [
        [(case_length - pcb_length)/2 + 3, (case_width - pcb_width)/2 + 3],
        [(case_length + pcb_length)/2 - 3, (case_width - pcb_width)/2 + 3],
        [(case_length - pcb_length)/2 + 3, (case_width + pcb_width)/2 - 3],
        [(case_length + pcb_length)/2 - 3, (case_width + pcb_width)/2 - 3]
    ];

    for (pos = post_positions) {
        translate([pos[0], pos[1], wall_thickness])
            cylinder(h=pcb_support_height + pcb_height + 2, d=2, $fn=20);
    }
}

// Rear cover plate
module rear_cover() {
    difference() {
        cube([case_length, case_width, wall_thickness]);

        // Cable routing slot
        translate([case_length/2 - 5, case_width - 5, -1])
            cube([10, 6, wall_thickness+2]);
    }

    // Mounting bosses with threaded insert holes
    boss_positions = [
        [5, 5],
        [case_length - 5, 5],
        [5, case_width - 5],
        [case_length - 5, case_width - 5]
    ];

    for (pos = boss_positions) {
        difference() {
            translate([pos[0], pos[1], wall_thickness])
                cylinder(h=8, d=mounting_boss_diameter, $fn=30);

            // M3 threaded insert hole
            translate([pos[0], pos[1], wall_thickness - 1])
                cylinder(h=10, d=mounting_hole_diameter, $fn=20);
        }
    }
}

// Wall mount bracket
module wall_mount() {
    difference() {
        union() {
            // Base plate
            cube([case_length, 40, 5]);

            // Angle adjustment arm (simplified - full version needs pivot joint)
            translate([case_length/2 - 10, 35, 0])
                cube([20, 5, 30]);
        }

        // Mounting holes for case attachment
        for (x = [5, case_length - 5]) {
            for (y = [5, 35]) {
                translate([x, y, -1])
                    cylinder(h=7, d=mounting_hole_diameter + 0.5, $fn=20);
            }
        }

        // Wall mounting holes
        translate([case_length/2 - 4, 10, -1])
            cylinder(h=7, d=4, $fn=20);
        translate([case_length/2 + 4, 10, -1])
            cylinder(h=7, d=4, $fn=20);
    }
}

// Corner mount bracket
module corner_mount() {
    difference() {
        union() {
            // 90-degree bracket
            cube([case_length, 50, 5]);
            translate([0, 0, 0])
                rotate([0, 0, 0])
                cube([5, 50, 50]);
        }

        // Mounting holes for case
        for (x = [5, case_length - 5]) {
            for (y = [5, 45]) {
                translate([x, y, -1])
                    cylinder(h=7, d=mounting_hole_diameter + 0.5, $fn=20);
            }
        }

        // Wall mounting holes (2 per surface)
        translate([case_length/2, 20, -1])
            cylinder(h=7, d=4, $fn=20);
        translate([case_length/2, 40, -1])
            cylinder(h=7, d=4, $fn=20);

        translate([-1, 20, 20])
            rotate([0, 90, 0])
            cylinder(h=7, d=4, $fn=20);
        translate([-1, 40, 40])
            rotate([0, 90, 0])
            cylinder(h=7, d=4, $fn=20);
    }
}

// IR LED ring (optional)
module ir_led_ring() {
    difference() {
        cylinder(h=3, d=35, $fn=60);

        // Center cutout for camera lens
        translate([0, 0, -1])
            cylinder(h=5, d=lens_diameter + 2, $fn=50);

        // LED mounting holes (6 LEDs at 60° spacing)
        for (angle = [0:60:300]) {
            rotate([0, 0, angle])
                translate([15, 0, -1])
                cylinder(h=5, d=5.2, $fn=20);  // 5mm LED diameter
        }

        // Mounting screw holes (4 at 90° spacing)
        for (angle = [45:90:315]) {
            rotate([0, 0, angle])
                translate([14, 0, -1])
                cylinder(h=5, d=2.5, $fn=20);  // M2 screw
        }
    }
}

// ===== RENDER =====
// Uncomment the part you want to generate:

case_body();  // Main case

// translate([60, 0, 0]) rear_cover();  // Rear cover

// translate([0, 50, 0]) wall_mount();  // Wall mount bracket

// translate([70, 50, 0]) corner_mount();  // Corner mount

// translate([0, 100, 0]) ir_led_ring();  // IR LED ring
```

**To Generate STL Files:**

1. Open in OpenSCAD
2. Uncomment the part you want (e.g., `case_body();`)
3. Render (F6)
4. Export STL (File → Export → Export as STL)
5. Repeat for each component

**Customization Tips:**
- Increase `wall_thickness` for more durability
- Adjust `vent_slot_length` for more/less airflow
- Change `lens_diameter` if using different camera module
- Modify `case_height` if adding cooling fan

---

## Bill of Materials (BOM)

### Per Camera Unit

| Component | Quantity | Notes |
|-----------|----------|-------|
| ESP32-CAM-MB with OV2640 | 1 | Already owned (4 units) |
| Hyper-PAL Filament | ~30g | Grey, for main case |
| M3 Heat-Set Inserts | 4 | Brass, 5mm length |
| M3 × 8mm Screws | 4 | For bracket attachment |
| M2.5 × 6mm Screws | 2 | Optional, PCB security |
| Micro USB Cable | 1 | Power + programming |
| 5V Power Supply | 1 | 1A minimum per camera |
| Drywall Anchors | 2 | For wall mounting |

### Optional: IR Night Vision Add-on

| Component | Quantity | Notes |
|-----------|----------|-------|
| 850nm IR LEDs (5mm) | 6 | 100mA, 1.5V forward voltage |
| 33Ω Resistors (1/4W) | 6 | Current limiting |
| Perfboard (30×30mm) | 1 | For LED circuit |
| 24 AWG Wire | 0.5m | Red + black |
| M2 × 6mm Screws | 4 | IR ring attachment |
| Natural PETG Filament | ~10g | Light-transmitting |

### Total for 4-Camera System

| Item | Quantity | Cost Estimate |
|------|----------|---------------|
| ESP32-CAM-MB Boards | 4 | Already owned |
| Filament (PAL) | ~120g | ~$3 |
| M3 Inserts | 16 | ~$2 |
| M3 Screws | 16 | ~$1 |
| M2.5 Screws | 8 | ~$1 |
| USB Cables | 4 | ~$8 |
| Power Supplies | 4 | ~$20 (or use multi-port adapter) |
| Mounting Hardware | 8 anchors | ~$2 |
| **TOTAL** | | **~$37** (excluding owned hardware) |

---

## Camera Placement Strategy

### Recommended Locations (4-Camera Setup)

**Camera 1: Front Door (Entrance)**
- **Mount:** Wall mount, angled down 30°
- **Height:** 7 feet (eye level + 1 foot)
- **Coverage:** Doorway, hallway approach
- **IP Address:** 192.168.40.110
- **AI Priority:** Person detection, package detection

**Camera 2: Living Room (Main Area)**
- **Mount:** Corner mount, high ceiling angle
- **Height:** 8 feet (ceiling corner)
- **Coverage:** Living room, kitchen entrance
- **IP Address:** 192.168.40.111
- **AI Priority:** Person detection, activity monitoring

**Camera 3: Bedroom Hallway**
- **Mount:** Ceiling mount, center hallway
- **Height:** 8 feet (ceiling)
- **Coverage:** Bedroom doors, bathroom entrance
- **IP Address:** 192.168.40.112
- **AI Priority:** Motion detection, nighttime monitoring

**Camera 4: Balcony/Window**
- **Mount:** Wall mount, facing outward
- **Height:** 6 feet (windowsill level)
- **Coverage:** Balcony, exterior window view
- **IP Address:** 192.168.40.113
- **AI Priority:** Intrusion detection, outdoor activity
- **Note:** Use IR LEDs for night vision (no street lights)

### Coverage Optimization

**Dead Zone Elimination:**
- Camera 1 + 2 overlap in hallway (redundancy)
- Camera 2 + 3 overlap at kitchen/hallway junction
- All interior cameras have 110° FOV (OV2640 default)

**Privacy Considerations:**
- No cameras in bathroom or private changing areas
- Bedroom camera faces hallway only (door monitoring)
- Disable audio recording (ESPHome microphone off by default)

---

## AI Detection Workflow (n8n + Ollama)

### Workflow Overview

**Trigger:** Motion detected on any camera
**Process:**
1. Home Assistant sends webhook to n8n
2. n8n requests camera snapshot via HA API
3. Snapshot sent to Ollama vision model
4. AI analyzes: Person? Package? Pet? Unknown?
5. Classification determines action

### n8n Workflow Nodes

**Node 1: Webhook Trigger**
- Method: POST
- Path: `/webhook/camera-motion`
- Payload: `{ "camera": "front_door", "timestamp": "ISO8601" }`

**Node 2: Get Camera Snapshot**
- Type: HTTP Request
- URL: `http://homeassistant:8123/api/camera_proxy/camera.{{$json.camera}}_camera`
- Headers: `Authorization: Bearer <HA_TOKEN>`
- Response Format: Binary (image/jpeg)

**Node 3: Ollama Vision Analysis**
- Type: Ollama (via HTTP or n8n-nodes-ollama)
- Model: `llama-vision` or `minicpm-v:8b`
- Prompt:
  ```
  Analyze this security camera image. Identify:
  1. Is there a person visible? (yes/no)
  2. Is there a package or delivery? (yes/no)
  3. Is there a pet? (yes/no)
  4. Describe any unusual activity.

  Respond in JSON format:
  {
    "person": boolean,
    "package": boolean,
    "pet": boolean,
    "description": "string"
  }
  ```

**Node 4: Switch (Classification)**
- Route based on `{{ $json.person }}`:
  - **Person Detected** → High priority alert
  - **Package Detected** → Delivery notification
  - **Pet Only** → Log only (no alert)
  - **Unknown/Error** → Default alert

**Node 5a: Telegram Alert (Person)**
- Chat ID: `6299872789`
- Message:
  ```
  🚨 SECURITY ALERT

  📹 Camera: {{$json.camera}}
  👤 Person Detected
  🕐 {{$json.timestamp}}

  {{$json.description}}
  ```
- Attachment: Camera snapshot

**Node 5b: Telegram Notification (Package)**
- Message:
  ```
  📦 Delivery Detected

  📹 Camera: {{$json.camera}}
  🕐 {{$json.timestamp}}

  A package has been left at your door.
  ```
- Attachment: Snapshot

**Node 5c: InfluxDB Log (Pet/Other)**
- Write to InfluxDB for historical tracking
- No immediate alert

### Home Assistant Automation

**File:** `/home/hassistant/config/automations.yaml`

```yaml
- alias: "Camera Motion - AI Analysis"
  description: "Send motion snapshots to n8n for AI detection"
  trigger:
    - platform: state
      entity_id:
        - binary_sensor.front_door_camera_motion
        - binary_sensor.living_room_camera_motion
        - binary_sensor.bedroom_hallway_camera_motion
        - binary_sensor.balcony_camera_motion
      to: 'on'
  action:
    - service: rest_command.n8n_camera_motion
      data:
        camera: "{{ trigger.entity_id.split('.')[1].replace('_camera_motion', '') }}"
        timestamp: "{{ now().isoformat() }}"

# REST Command configuration
rest_command:
  n8n_camera_motion:
    url: http://n8n:5678/webhook/camera-motion
    method: POST
    content_type: application/json
    payload: >
      {
        "camera": "{{ camera }}",
        "timestamp": "{{ timestamp }}"
      }
```

### Ollama Model Recommendations

**Vision Models for Detection:**
- **llama-vision** (7B) - Fast, good accuracy
- **minicpm-v:8b** - Better detail recognition
- **llava:13b** - Highest accuracy (slower)

**Download Model:**
```bash
docker exec -it ollama ollama pull llama-vision
```

**Test Vision Analysis:**
```bash
docker exec -it ollama ollama run llama-vision "What do you see in this image?" < /tmp/test_snapshot.jpg
```

---

## Maintenance & Troubleshooting

### Common Issues

**Problem: Camera shows offline in Home Assistant**
- Check WiFi signal strength (ESP32 antenna is weak)
- Verify static IP not conflicting
- Restart ESP32: Unplug/replug power
- Check ESPHome logs: `docker exec -it esphome esphome logs camera-front-door.yaml`

**Problem: Image quality is poor/blurry**
- Adjust `jpeg_quality` (lower = better, 10 recommended)
- Check for lens smudges (clean with microfiber cloth)
- Increase lighting in area
- Disable auto-exposure: Set manual exposure in ESPHome

**Problem: Camera overheating**
- Verify ventilation slots are clear
- Reduce framerate: `max_framerate: 5fps`
- Enable idle mode: `idle_framerate: 0.1fps`
- Add 40mm fan to case interior

**Problem: Night vision not working (IR LEDs)**
- Check IR LED circuit polarity
- Verify 5V power supply can handle 300mA extra draw
- Test IR LEDs with phone camera (should see faint glow)
- Check resistor values (33Ω for 5V supply)

**Problem: Motion detection too sensitive**
- Adjust Home Assistant motion sensor sensitivity
- Add cooldown period (15 seconds between triggers)
- Use AI filtering to ignore false positives (plants moving, shadows)

### Firmware Updates

**Update ESPHome:**
```bash
cd /home/hazzard/home-assistant/esphome
docker exec -it esphome esphome run camera-front-door.yaml --device <IP_ADDRESS>
```

**OTA Updates (over WiFi):**
- Edit YAML config
- Click "Upload" in ESPHome dashboard (http://192.168.40.201:6052)
- Wait for compilation and wireless upload

### Performance Optimization

**Reduce Network Bandwidth:**
- Lower resolution: `800x600` instead of `1600x1200`
- Increase `jpeg_quality` number (lower quality, smaller file)
- Use `idle_framerate` when not streaming

**Improve AI Detection Speed:**
- Use smaller Ollama model (`llama-vision` vs `llava:13b`)
- Reduce snapshot resolution before sending to AI
- Cache recent analysis results (avoid re-analyzing same scene)

**Power Consumption:**
- Enable WiFi power save mode in ESPHome
- Reduce LED brightness (if using status LED)
- Disable Bluetooth if not needed

---

## Future Enhancements

### Phase 2: Advanced Features

1. **License Plate Recognition**
   - Use Ollama OCR model to read plates (parking/driveway camera)
   - Log vehicle arrivals/departures

2. **Facial Recognition**
   - Train custom model on family members
   - Differentiate between "known person" vs "stranger"
   - Privacy: All processing local (no cloud)

3. **Activity Heatmaps**
   - Track motion patterns over time
   - Visualize high-traffic areas in Grafana
   - Optimize camera placement

4. **Two-Way Audio**
   - Add I2S speaker to ESP32-CAM
   - Intercom functionality via Home Assistant
   - Speak to delivery person remotely

5. **PTZ (Pan-Tilt-Zoom)**
   - Add servo motors for pan/tilt
   - Control via Home Assistant dashboard
   - Auto-tracking mode (follow detected person)

6. **Edge AI Processing**
   - Run TensorFlow Lite models directly on ESP32
   - Offline person detection (no cloud/server needed)
   - Faster response times

### Integration Ideas

- **Home Assistant Automations:**
  - Turn on lights when person detected at night
  - Lock door if stranger lingers at entrance
  - Pause TV when delivery arrives

- **Voice Assistant Commands:**
  - "Show me the front door camera"
  - "Did any packages arrive today?"
  - "Alert me if someone enters the living room"

- **Grafana Dashboards:**
  - Live camera feed grid (4 cameras)
  - Motion event timeline
  - Detection statistics (persons/day, packages/week)

---

## Resources

### Documentation
- [ESP32-CAM Module Pinout](https://components101.com/modules/esp32-cam-camera-module)
- [ESPHome Camera Component](https://esphome.io/components/esp32_camera.html)
- [OV2640 Datasheet](https://blog.arducam.com/ov2640/)
- [Home Assistant Camera Integration](https://www.home-assistant.io/integrations/camera/)

### 3D Printing References
- [Thingiverse ESP32-CAM Cases](https://www.thingiverse.com/thing:3463679)
- [Printables ESP32-CAM Designs](https://www.printables.com/model/75024-esp32-cam-case)

### AI Vision Models
- [Ollama Vision Models](https://ollama.com/library)
- [n8n Ollama Integration](https://docs.n8n.io/integrations/ollama/)

---

## Support & Contributing

**Questions or improvements?**
- File an issue in the homeproject repository
- Test prints and share results
- Suggest AI detection improvements

**Safety Reminder:**
- Follow local laws regarding surveillance cameras
- Post signage if required in your jurisdiction
- Disable audio recording to comply with privacy laws
- Secure Home Assistant access (use strong passwords, enable 2FA)

---

**Last Updated:** 2025-12-17
**Project Status:** Design Complete - Ready for Printing
**Next Steps:** Generate STL files, print first prototype, flash ESPHome firmware

---

## Sources

- [Aideepen ESP32-CAM-MB User Manual](https://manuals.plus/asin/B08P2578LV)
- [ESP32-CAM Module Specifications](https://components101.com/modules/esp32-cam-camera-module)
- [Thingiverse ESP32-CAM Case Designs](https://www.thingiverse.com/thing:3463679)
- [Printables ESP32-CAM Case Library](https://www.printables.com/model/75024-esp32-cam-case)
