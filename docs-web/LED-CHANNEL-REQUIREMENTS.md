# LED Channel Design Requirements

## Project Overview

Design a parametric OpenSCAD file for modular LED channel segments to house SK6812 RGBW LED strips for a bed ambient lighting project.

## Printer Specifications

- **Printer:** Qidi Plus 4
- **Build volume:** 305mm × 305mm × 305mm
- **Enclosed chamber:** Yes (excellent for PETG)
- **Material:** Transparent PETG filament

## LED Strip Specifications

- **Type:** SK6812 RGBW LED Strip (BTF-Lighting model: BTF-5V-030L-W)
- **Strip width:** 10mm
- **Strip thickness:** ~3mm (including adhesive backing)
- **Density:** 60 LEDs per meter
- **Total length needed:** 8 meters (480 LEDs total)

## Design Requirements

### 1. Segment Dimensions

- **Segment length:** 280mm (optimal for 305mm bed, allows margins)
- **Total segments needed:** 29 segments (8000mm ÷ 280mm)
- **Channel internal width:** 12-14mm (to fit 10mm strip with clearance)
- **Channel internal depth:** 10mm minimum (to accommodate LED height + clearance)

### 2. Diffuser Layer

- **Purpose:** Transparent PETG wall that diffuses light evenly
- **Critical requirement:** Wall thickness should be **parametric/tunable** (recommended starting point: 1.8mm)
- **User needs to test:** Print samples with different wall thicknesses (1.5mm, 1.7mm, 1.9mm, 2.1mm) to find optimal diffusion
- **Goal:** Even light spread without visible individual LEDs, but not too dim

### 3. Interlocking Connector System

**Required:** Male/female snap-fit connectors so segments join seamlessly

- **Male connector:** Extends from one end of segment
- **Female connector:** Recessed cutout in opposite end
- **Tolerance:** 0.2-0.4mm clearance for snap-fit (should hold firmly but be removable)
- **Connector depth:** 8-10mm (deep enough for alignment, not too deep to weaken structure)
- **Goal:** Segments snap together without glue, maintain alignment, create continuous LED channel

### 4. Mounting System

**Required:** Integrated mounting clips for attaching to bed frame

- **Clip style:** Tabs extending from bottom of channel
- **Clip spacing:** 140mm apart (2 clips per 280mm segment)
- **Clip features:**
  - Screw hole for M3 mounting screws
  - Sufficient thickness for strength (3mm minimum)
  - Should not interfere with LED strip installation

### 5. Wire Routing

**Required:** Cutouts/channels for power injection wires

- **Purpose:** LED strips need power injection every 2.5-3 meters to maintain brightness
- **Location:** 2 wire exit points per segment (suggested: 70mm and 210mm from left edge)
- **Wire channel size:** 6mm wide × 4mm deep (to route 18-22 AWG wires)
- **Placement:** Through the base/bottom of channel

### 6. Structural Requirements

- **Base thickness:** 2mm minimum (structural strength)
- **Side walls:** 2mm minimum (strength)
- **Overall durability:** Must withstand installation/removal without breaking
- **Print-in-place:** All features should print without supports

### 7. Parametric Design

**Critical:** All major dimensions should be adjustable via variables at top of file

Key parameters to expose:
- Segment length
- Channel width/depth
- Diffuser wall thickness ⭐ (most important for tuning)
- Clip spacing
- Connector tolerance
- Wire channel positions

## Assembly Context

### How It Will Be Used:

1. **Print 29 segments** (280mm each)
2. **Insert LED strips** into channels (adhesive backing on base)
3. **Snap segments together** using interlocking connectors
4. **Route power wires** through wire channels at injection points
5. **Mount to bed frame** using M3 screws through mounting clips
6. **Connect to ESP32-C6** controller (GPIO2 for data, buck converters for power)

### Installation Layout:

- **Under bed perimeter:** 6.3 meters (23 segments)
- **Behind headboard:** 1.7 meters (6 segments)
- **Total:** 8 meters (29 segments)

## Design Priorities (in order)

1. **Tunable diffusion** - User MUST be able to easily adjust wall thickness to test
2. **Strong snap-fit connectors** - Segments must align perfectly and hold together
3. **Printability** - No supports, reliable prints on PETG
4. **Mounting flexibility** - Clips must be easy to screw into bed frame
5. **Wire management** - Clean routing for power injection
6. **Parametric** - Easy to adjust dimensions if needed

## Test Print Strategy

User should print small test pieces before committing to 29 segments:

1. **Diffusion test:** Short segments (50-100mm) with varying wall thicknesses
2. **Connector test:** Just the male/female connectors to verify snap-fit
3. **Full segment test:** 2 complete segments to verify everything before production

## Example Use Case

**Bed Ambient Lighting Project:**
- 8 meters of indirect LED lighting around bed
- Creates ambient room lighting (no overhead light needed)
- Controlled via Home Assistant with voice commands
- Scenes: bedtime dimming, morning wake-up, movie mode, etc.

## Success Criteria

A successful design will:
- ✅ Print reliably on Qidi Plus 4 with PETG
- ✅ Allow user to tune diffusion by changing ONE parameter
- ✅ Snap together firmly but be removable
- ✅ Hold LED strips securely
- ✅ Mount easily to furniture
- ✅ Look professional when installed
- ✅ Route power wires cleanly

## What NOT to Include

- Don't over-complicate with cable clips/management beyond wire channels
- Don't add LED strip retention clips (adhesive backing is sufficient)
- Don't design for non-PETG materials (focus on transparent PETG)
- Don't make segments longer than 280mm (printer bed limit)

## Additional Context

- User successfully completed a small RGB LED test project with 10 LEDs
- User has experience with breadboard → soldering workflow
- User has Creality Ender-3 V3 also, but Qidi Plus 4 is preferred for this (enclosed chamber)
- User has prior OpenSCAD experience (has designed other enclosures)
- User values functional design over decorative features

---

**Output:** A single, well-commented OpenSCAD file that generates one 280mm LED channel segment with all features above.
