# LED Channel 3D Printing Guide

## Quick Start

**File:** `led-channel-segment.scad`

**What you get:**
- 280mm channel segments optimized for Qidi Plus 4
- Snap-together interlocking connectors (no glue needed!)
- Integrated mounting clips with M3 screw holes
- Wire routing channels for power injection
- Tunable diffuser wall thickness

---

## Before You Start: Print Test Pieces First!

### Test Print #1: Diffusion Test (1 hour, ~20g filament)

**Goal:** Find the perfect wall thickness for your transparent PETG

1. Open `led-channel-segment.scad` in OpenSCAD
2. Scroll to bottom, find "TEST PIECES" section (line ~220)
3. Comment out main render:
   ```scad
   // led_channel_segment();  // Add // to disable
   ```
4. Uncomment diffusion test block:
   ```scad
   for (i = [0:3]) {
       // ... (remove the /* and */ around this block)
   }
   ```
5. Render (F6) and export STL
6. Print all 4 samples (wall thicknesses: 1.5mm, 1.7mm, 1.9mm, 2.1mm)
7. Put LED strip in each, turn on full white, evaluate:
   - Can you see individual LEDs? (too thin)
   - Is it dim/milky? (too thick)
   - Perfect even glow? (just right!)

**Recommended starting point:** 1.8mm (already set as default)

---

### Test Print #2: Connector Fit Test (30 min, ~10g filament)

**Goal:** Verify snap-fit connectors work with your printer's tolerances

1. In OpenSCAD, find "TEST PIECES" section
2. Uncomment connector test:
   ```scad
   translate([0, 0, 0]) male_connector();
   translate([15, 0, 0]) female_connector_cutout();
   ```
3. Print both pieces
4. Test fit:
   - Should snap together with light pressure
   - Should hold alignment without wiggling
   - Should be removable without breaking
5. Adjust `connector_tolerance` if needed:
   - Too tight? Increase to 0.4mm
   - Too loose? Decrease to 0.2mm

---

### Test Print #3: Full 280mm Segment (2.5 hours, ~60g filament)

**Goal:** Verify everything before committing to 29 segments

1. Re-enable main render:
   ```scad
   led_channel_segment();
   ```
2. Print 2 segments (560mm total when connected)
3. Verify:
   - ✓ LED strip fits perfectly (10mm wide SK6812)
   - ✓ Diffuser thickness is correct (from Test #1)
   - ✓ Connectors snap together cleanly
   - ✓ Mounting clips fit your bed frame
   - ✓ Wire channels are positioned well
   - ✓ Overall strength/rigidity is good

**If satisfied:** Proceed to production! 🎉
**If not:** Adjust parameters in lines 18-47 and re-test

---

## Production Printing (29 Segments)

### Recommended Settings:

**Qidi Plus 4 Profile:**
```
Material: Transparent PETG
Nozzle temp: 235-250°C
Bed temp: 80-90°C
Chamber: 45-55°C (if available)
Layer height: 0.2mm
First layer: 0.25mm
Infill: 30% Gyroid (best diffusion pattern)
Wall count: 4 perimeters
Top layers: 5
Bottom layers: 4
Print speed: 60-80mm/s
Cooling: 30-50% (PETG doesn't like too much cooling)
Support: NONE NEEDED
```

### Orientation:
```
       ╔════════════════════════════╗
       ║   Diffuser (smooth side)   ║  ← Print facing UP
       ╠════════════════════════════╣
       ║   LED cavity (hollow)      ║
       ╠════════════════════════════╣
Clips ▼   Base (solid)              ▼  ← Print on bed
═══════════════════════════════════════
              Print Bed
```

### Time & Material Estimates:

| Segments | Print Time | Filament | Cost (@ $20/kg) |
|----------|------------|----------|-----------------|
| 2 (test) | 5 hours    | ~120g    | $2.40           |
| 29 (full)| 70-80 hours| 850-950g | $17-19          |

**Strategy:** Print overnight/weekends over 5-7 days

---

## Tuning Parameters (lines 18-47)

### Critical Settings:

```scad
segment_length = 280;        // Don't change (optimized for Qidi Plus 4)
diffuser_wall_thickness = 1.8; // TUNE THIS (see Test #1)
```

### Optional Tweaks:

```scad
channel_width = 14;          // Increase if strip doesn't fit
channel_depth = 10;          // Increase if LEDs touch diffuser
clip_spacing = 140;          // Adjust mounting clip positions
wire_channel_positions = [70, 210]; // Move wire exit points
```

### If Using Different LED Strip:

For WS2812B RGB (not RGBW):
```scad
led_strip_width = 10;   // Same width
led_strip_height = 2.5; // RGB strips are slightly thinner
```

For higher density (120 LEDs/m):
```scad
// No changes needed! Channel fits any density
```

---

## Assembly Instructions

### Step 1: Prepare Segments (1 hour)

1. Check each segment for quality
2. Remove any stringing/blobs with hobby knife
3. Test-fit connectors (should snap cleanly)
4. Label segments 1-29 with marker on bottom

### Step 2: Install LED Strips (2 hours)

1. **Starting point:** First segment gets main power connection
2. **Layout:** Dry-fit all segments in final position
3. **Strip installation:**
   - Peel adhesive backing
   - Insert strip into channel (adhesive side DOWN on base)
   - Press firmly to secure
   - Leave 50mm of strip at connectors for routing
4. **Connect segments:**
   - Snap male connector into female receiver
   - Route LED strip through junction
   - Verify electrical continuity

### Step 3: Mount to Bed Frame (2 hours)

1. **Under bed run (6.3m = 23 segments):**
   - Start at headboard right corner
   - Route around bed perimeter
   - Use M3 screws through mounting clips
   - Space screws every 140mm

2. **Behind headboard (1.7m = 6 segments):**
   - Center on headboard width
   - Mount to back panel or wall
   - Align with under-bed run for seamless look

### Step 4: Power Injection (1 hour)

**Required:** 3 injection points for 8 meters

1. **Point 1 (main):** First segment
   - Connect to ESP32-C6 + Buck Converter #1
   - Route wires through wire_channel_positions[0]

2. **Point 2 (~2.5m):** Segment 9
   - Buck Converter #2
   - Use wire_channel_positions[1]

3. **Point 3 (~5m):** Segment 18
   - Buck Converter #3
   - Use wire_channel_positions[0]

**Wiring:**
- Red wire: 5V rail
- Black wire: GND rail
- White wire: Data (GPIO2 from ESP32-C6)

---

## Troubleshooting

### Issue: Segments don't snap together cleanly

**Solution:** Adjust `connector_tolerance` in line 37:
- Increase to 0.4-0.5mm for looser fit
- Decrease to 0.2mm for tighter fit
- Re-print test connectors to verify

### Issue: Can see individual LEDs through diffuser

**Solutions:**
1. Increase `diffuser_wall_thickness` to 2.0-2.2mm
2. Increase infill to 40-60% (more plastic = more diffusion)
3. Print with 100% infill in diffuser layer (advanced slicer settings)
4. Add frosted spray coating after printing

### Issue: Too dim, not enough light output

**Solutions:**
1. Decrease `diffuser_wall_thickness` to 1.5-1.6mm
2. Decrease infill to 20-30%
3. Use 0% infill (hollow walls only) - not recommended for strength

### Issue: Mounting clips don't align with bed frame

**Solution:** Adjust `clip_spacing` in line 32:
- Increase/decrease to match your bed frame slats
- Can also adjust `wire_channel_positions` to avoid conflicts

### Issue: LED strip doesn't fit in channel

**Solution:**
1. Measure your strip width with calipers
2. Adjust `channel_width` (line 22) to strip_width + 4mm clearance
3. Re-print test segment

### Issue: Warping during print

**PETG warping solutions:**
- Increase bed temp to 85-90°C
- Enable chamber heating (Qidi Plus 4 advantage!)
- Use glue stick or PEI sheet for better adhesion
- Reduce cooling fan speed to 20-30%
- Add brim (5-10mm) in slicer

---

## Advanced Customization

### Add RGB Sync Port

For future WS2812B expansion:
```scad
// Add at line 90 (after wire_channel_positions definition)
data_port_position = segment_length - 20;

// Add in wire_routing_channels() module:
translate([data_port_position, total_width - 5, -1])
    cube([8, 5, base_thickness + 2]);
```

### Angled Mounting Clips (for slanted bed frames)

```scad
// Replace mounting_clips() module with rotated version
rotate([10, 0, 0]) // 10° angle
    cube([clip_width, clip_thickness, clip_height]);
```

### Longer Segments (if your printer allows)

```scad
segment_length = 300; // Max for Qidi Plus 4 diagonal
// Warning: More segments = better alignment, fewer joints
```

---

## What's Next?

Once you've verified test prints:

1. **Queue production:** 29 segments × 2.5 hours = 72.5 hours
2. **Print schedule:**
   - Day 1-2: Segments 1-10 (overnight prints)
   - Day 3-4: Segments 11-20
   - Day 5-6: Segments 21-29
   - Day 7: Assembly

3. **Follow bed-ambient-lighting.md:**
   - ESP32-C6 wiring (GPIO2 → DIN)
   - Power system (3× buck converters)
   - Home Assistant configuration
   - Scene programming

**Your total project cost:**
- Filament: ~$18
- LEDs: $45
- Electronics: $25
- **Total: ~$88** (vs $120+ for commercial aluminum channels)

**Plus you get:**
- Custom-fit mounting clips
- Tool-free assembly
- Flex/creative satisfaction
- Repairable/modifiable design

---

## Support

Questions? Check:
- Main project guide: `/home/hazzard/homeproject/docs-web/projects/bed-ambient-lighting.md`
- ESPHome config reference: `/home/hazzard/home-assistant/esphome/xiao-c6-rgb-strip-test.yaml`
- Web docs: http://192.168.40.201:8888

**Happy printing!** 🎉
