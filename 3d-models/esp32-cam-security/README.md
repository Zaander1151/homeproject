# ESP32-CAM Security Camera - 3D Printable Files

This directory contains OpenSCAD files for printing a complete ESP32-CAM security camera enclosure system.

## Files Included

| File | Description | Print Time | Material |
|------|-------------|------------|----------|
| `esp32-cam-case-body.scad` | Main camera case body | ~3.5 hours | PAL/PETG |
| `esp32-cam-rear-cover.scad` | Removable rear cover | ~1 hour | PAL/PETG |
| `esp32-cam-wall-mount.scad` | Wall mounting bracket | ~2 hours | PAL/PETG |
| `esp32-cam-corner-mount.scad` | Corner mounting bracket | ~2.5 hours | PAL/PETG |
| `esp32-cam-ceiling-mount.scad` | Ceiling mounting bracket | ~3 hours | PAL/PETG |
| `esp32-cam-ir-led-ring.scad` | IR night vision LED ring | ~1.5 hours | Clear PETG |

## Quick Start

### 1. Generate STL Files

**Option A: Using OpenSCAD (Recommended)**

1. Download and install [OpenSCAD](https://openscad.org/downloads.html)
2. Open the desired `.scad` file
3. Press **F6** to render (wait for completion)
4. File → Export → Export as STL
5. Save to your slicing software directory

**Option B: Command Line (Linux/Mac)**

```bash
cd /home/hazzard/homeproject/3d-models/esp32-cam-security

# Generate all STL files at once
for file in *.scad; do
    openscad -o "${file%.scad}.stl" "$file"
done
```

### 2. Slice for Printing

**Creality Ender-3 V3 Settings:**

- **Filament:** Hyper-PAL (Grey) or Hyper-PETG
- **Nozzle:** 0.4mm
- **Layer Height:** 0.2mm (0.12mm for IR ring)
- **Infill:** 20% (case), 40% (brackets)
- **Perimeters:** 3 walls
- **Top/Bottom Layers:** 4
- **Print Speed:** 50mm/s
- **Supports:** Only for angled brackets
- **Brim:** 5mm recommended

**Temperatures:**
- PAL: Nozzle 210°C, Bed 60°C
- PETG: Nozzle 235°C, Bed 80°C

### 3. Print Order

For a complete camera system, print in this order:

1. **esp32-cam-case-body.scad** (main case)
2. **esp32-cam-rear-cover.scad** (rear cover)
3. **esp32-cam-wall-mount.scad** (or corner/ceiling mount)
4. **esp32-cam-ir-led-ring.scad** (optional, if using night vision)

**Total Material:** ~40g per camera (excluding mount)

## Customization

All `.scad` files have adjustable parameters at the top. Common modifications:

### Change Case Size
Edit `esp32-cam-case-body.scad`:
```openscad
case_length = 50;  // Increase for larger boards
case_width = 35;
case_height = 30;
```

### Adjust Mounting Angle
Edit wall/ceiling mount files:
```openscad
tilt_angle = 30;  // 0-45 degrees (wall mount)
tilt_angle = 20;  // 0-30 degrees (ceiling mount)
```

### LED Count (IR Ring)
Edit `esp32-cam-ir-led-ring.scad`:
```openscad
led_count = 6;  // Change to 8 or 12 for more LEDs
```

After editing, re-render and export STL.

## Assembly Instructions

See full guide: `/home/hazzard/homeproject/docs-web/projects/esp32-cam-security-case.md`

**Quick Assembly:**
1. Print all parts
2. Install M3 heat-set inserts in rear cover (4 inserts)
3. Mount ESP32-CAM board in case body
4. Snap rear cover onto case
5. Attach mounting bracket with M3 screws
6. Mount to wall/ceiling
7. Connect power and flash ESPHome firmware

## Hardware Requirements

**Per Camera:**
- 4x M3 heat-set inserts (brass, 5mm length)
- 4x M3 × 8mm screws (bracket attachment)
- 2x M2.5 × 6mm screws (optional, PCB security)
- 2x Drywall anchors (wall mounting)

**Optional IR Night Vision:**
- 6x IR LEDs (850nm, 5mm, 100mA)
- 6x 33Ω resistors (1/4W)
- 4x M2 × 6mm screws
- Perfboard (30mm × 30mm)
- Wire (24 AWG)

## Troubleshooting

**Print failed / warping:**
- Increase bed temperature (+5°C)
- Add brim or raft
- Clean bed with isopropyl alcohol
- Level bed carefully

**Screw holes too tight:**
- Adjust `mount_hole_diameter` parameter (+0.2mm)
- Drill out holes with 3.5mm bit after printing

**Snap-fit posts break:**
- Increase `post_diameter` from 2mm to 2.5mm
- Print slower (30mm/s) for better layer adhesion

**IR ring not clear enough:**
- Sand with 400, 600, 1000-grit sandpaper
- Acetone vapor smoothing (PETG only)
- Print with 100% infill for better transparency

## License

These designs are part of the home automation infrastructure project.
Free to use, modify, and share for personal/educational purposes.

## Version History

- **v1.0** (2025-12-17): Initial release
  - Main case body
  - Rear cover
  - Wall/corner/ceiling mounts
  - IR LED ring

## Contact

Questions or improvements? Update the documentation or create an issue in the homeproject repository.

---

**Ready to Print!** Start with the case body, then add your preferred mounting bracket.
