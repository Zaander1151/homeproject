# PETG LED Diffuser Print Settings

**Printer:** Qidi Plus 4
**Material:** Transparent PETG
**Purpose:** LED channel diffuser printing for optimal light distribution

---

## Critical Settings for LED Diffusion

### Temperatures
```
Nozzle: 240-250°C (start at 245°C)
Bed: 80-85°C (use 85°C for first layer)
Chamber: 50-55°C (enable if available - big advantage!)
```

### Speed Settings
```
Print speed: 50-60mm/s (slower = better transparency)
First layer: 20-25mm/s (critical for adhesion)
Walls: 40-50mm/s (smooth outer surface)
Infill: 60-70mm/s (can be faster)
Travel: 150mm/s
```

### Cooling
```
Part cooling: 30-40% (PETG hates too much cooling)
First layer cooling: 0% (absolutely critical!)
Enable cooling after: Layer 3-4
```

### First Layer (Most Important!)
```
First layer height: 0.25mm (squish it down)
First layer width: 120% (better adhesion)
First layer temp: +5°C (250°C if nozzle is 245°C)
Z-offset: -0.05mm to -0.1mm (tune by eye - should squish slightly)
```

### Layer Settings
```
Layer height: 0.2mm (good balance of speed/quality)
Line width: 0.4mm (assuming 0.4mm nozzle)
Wall count: 4 perimeters (strength + diffusion)
Top layers: 5
Bottom layers: 4
```

### Infill (Critical for LED Diffusion!)
```
Infill: 30% (balance of diffusion and print time)
Pattern: GYROID ⭐ (best for even light diffusion!)
  Alternative: Grid or Cubic
  Avoid: Lines, Honeycomb (creates patterns in light)
```

**Why Gyroid?** Creates a 3D honeycomb-like structure that scatters light evenly in all directions, preventing hotspots and visible LED dots.

### Retraction (PETG strings!)
```
Retraction distance: 1.5-2.5mm (direct drive)
  (If Bowden: 4-6mm)
Retraction speed: 25-35mm/s
Z-hop: 0.2mm (prevents nozzle dragging)
Combing mode: Within infill (reduces stringing)
```

### Adhesion
```
Bed adhesion: Brim (8-10mm) for first test
  (Can switch to skirt once dialed in)
Bed surface: Clean PEI sheet OR glue stick
  (Wipe with IPA before printing)
```

---

## Print Orientation for LED Channels

```
┌─────────────────────────────┐
│   DIFFUSER SIDE UP ▲        │  ← Smooth top surface = better light
│   (smooth finish)            │
├──────────────────────────────┤
│   LED Cavity (hollow)        │
├──────────────────────────────┤
│   Mounting clips DOWN ▼      │  ← On print bed
└──────────────────────────────┘
      PRINT BED
```

**Why this orientation?**
- Diffuser facing up gets smooth top layers (better light transmission)
- Mounting clips print flat on bed (no supports needed!)
- LED cavity prints cleanly without overhangs

---

## Advanced Settings

```
Outer wall before inner: YES (better surface finish)
Alternate extra wall: YES (stronger)
Seam position: Random or "Sharpest corner"
Minimum layer time: 10 seconds (let layers cool)
```

---

## Pre-Print Checklist

### 1. Bed Preparation
- Clean bed with IPA (isopropyl alcohol)
- Heat bed to 85°C for 5 minutes first
- Apply thin glue stick layer (optional but helps)

### 2. Filament Preparation
- **CRITICAL:** PETG absorbs moisture! Dry if stored open for >1 week
- Extrude 20-30mm to purge old filament
- Watch first layer like a hawk

### 3. First Layer Validation
- Should be slightly squished/glossy
- No gaps between lines
- Not so squished it's transparent/dimpled
- Adjust Z-offset live if needed

---

## Test Print Strategy

Start with small tests before committing to full production:

### Test 1: Diffusion Wall Thickness Test (30-60 min)

Print 4 short segments (50-100mm) with varying wall thicknesses:
- 1.5mm wall (bright, may see individual LEDs)
- 1.7mm wall
- 1.9mm wall
- 2.1mm wall (more diffused, dimmer)

**How to test:**
1. Insert LED strip into each sample
2. Turn on full white
3. Evaluate:
   - Can you see individual LEDs? → Too thin
   - Is it dim/milky? → Too thick
   - Perfect even glow? → Just right!

### Test 2: Connector Fit Test (20 min)

Print just the male/female connectors:
- Verify snap-fit works with your printer's tolerances
- Should snap together with light pressure
- Should hold alignment without wiggling
- Should be removable without breaking

### Test 3: Full Segment Validation (2-3 hours)

Print ONE complete 280mm segment:
- Verify LED strip fits perfectly
- Test diffusion quality
- Check connector snap-fit
- Verify mounting clip strength
- Look for warping on long print

**If satisfied → proceed to production!**

---

## Common PETG Issues & Fixes

### Issue: Stringing between parts
**Solutions:**
- Increase retraction distance by 0.5mm
- Lower nozzle temp by 5°C
- Enable Z-hop
- Enable "Wipe nozzle" option
- Reduce travel speed

### Issue: Warping/lifting corners
**Solutions:**
- Increase bed temp to 90°C
- Add larger brim (15-20mm)
- Increase chamber temp to 55°C
- Ensure bed is level
- Reduce part cooling (try 20%)
- Print with draft shield (advanced)

### Issue: Poor bed adhesion
**Solutions:**
- Clean bed thoroughly with IPA
- Increase first layer squish (lower Z-offset by -0.05mm)
- Use glue stick or painter's tape
- Increase bed temp to 90°C
- Slow down first layer to 15mm/s
- Increase first layer extrusion to 105-110%

### Issue: Visible layer lines (not smooth diffusion)
**Solutions:**
- Increase wall thickness parameter in OpenSCAD design
- Increase infill to 40-50%
- Try different infill pattern (gyroid works best)
- Print at 0.16mm layer height (slower but smoother)
- Enable "Ironing" on top surface (advanced)

### Issue: Too dim/milky appearance
**Solutions:**
- Decrease wall thickness in design
- Reduce infill to 20%
- Check filament transparency (some brands better than others)
- Try lower layer height (0.16mm)
- Increase nozzle temp to 250°C for better flow

### Issue: Hotspots/visible individual LEDs
**Solutions:**
- Increase wall thickness to 2.0-2.2mm
- Increase infill to 40-60%
- Change infill pattern to Gyroid
- Print with 100% infill in diffuser layer (advanced slicer settings)
- Add frosted spray coating after printing (hardware solution)

---

## Transparent PETG Optimization Tips

### For Best Light Diffusion (LED Channels):
- ✅ Use **Gyroid infill** (creates 3D honeycomb pattern - best diffusion)
- ✅ Print with **consistent speed** (speed changes create visible patterns)
- ✅ Keep **consistent temperature** (don't let it cool between layers)
- ✅ Use **4+ wall lines** (more plastic to diffuse through)
- ✅ Print at **moderate speed** (50-60mm/s for quality)

### For Best Transparency (if you wanted clear, not diffused):
- Use 100% infill
- Print very slow (30-40mm/s)
- High temperature (250°C+)
- Minimize retractions
- *(Not needed for LED diffuser - you WANT diffusion!)*

---

## Recommended Starting Profile

### Conservative Settings (guaranteed to work):
```yaml
Temperature:
  Nozzle: 245°C
  Bed: 85°C
  Chamber: 50°C

Speed:
  Print: 50mm/s
  First layer: 25mm/s
  Walls: 45mm/s

Cooling:
  Part cooling: 30%
  First layer: 0%

Infill:
  Density: 30%
  Pattern: Gyroid

Retraction:
  Distance: 2mm
  Speed: 30mm/s
  Z-hop: 0.2mm

Adhesion:
  Type: Brim
  Width: 10mm

Layers:
  Height: 0.2mm
  First layer: 0.25mm
  Walls: 4
  Top: 5
  Bottom: 4
```

Once this works, you can speed up or fine-tune based on results.

---

## Tuning Wall Thickness for Optimal Diffusion

The diffuser wall thickness is the most critical parameter. Here's how to find your sweet spot:

### Too Thin (1.3-1.5mm):
- **Pros:** Very bright output
- **Cons:** Individual LEDs visible, hotspots, not even diffusion
- **Use case:** Accent lighting where brightness > aesthetics

### Sweet Spot (1.7-1.9mm):
- **Pros:** Even diffusion, no visible LEDs, good brightness
- **Cons:** None (ideal range)
- **Use case:** Ambient lighting (recommended for bed lighting)

### Too Thick (2.2-2.5mm):
- **Pros:** Very even diffusion
- **Cons:** Dim output, wasted filament
- **Use case:** Only if LEDs are extremely bright

### Testing Methodology:
1. Print test segments with increments of 0.2mm
2. Test with LEDs at **100% white** (worst case for hotspots)
3. View from normal eye level (not up close)
4. Choose thinnest wall that eliminates visible dots

**Starting recommendation:** 1.8mm wall thickness

---

## Material Recommendations

### Transparent PETG Brands (Best to Worst for Diffusion):

**Excellent Diffusion:**
- Prusament PETG Clear
- Polymaker PolyLite PETG Clear
- Overture PETG Clear

**Good Diffusion:**
- SUNLU PETG Clear
- Hatchbox PETG Clear
- eSUN PETG Clear

**Avoid:**
- Generic/no-name transparent PETG (inconsistent transparency)
- Colored translucent PETG (unless you want color - affects light color)

**Alternative:** Some users report success with **translucent white PETG** for better diffusion than clear.

---

## Post-Processing Options

### For Better Diffusion (if needed):

**1. Frosted Spray Coating:**
- Use Rust-Oleum Frosted Glass spray
- Light coat on inside of diffuser
- Increases diffusion significantly
- Reduces brightness ~20-30%

**2. Sanding (not recommended):**
- Creates uneven texture
- Reduces structural strength
- Hard to do consistently

**3. Second Diffuser Layer:**
- Print thinner wall (1.2mm)
- Add parchment paper or frosted film inside
- More work but very effective

---

## Troubleshooting: Production Runs (29+ Segments)

### Issue: First 5 segments good, then quality degrades
**Cause:** Heat creep, filament moisture absorption
**Solution:**
- Give printer 30 min cool-down every 5-8 hours
- Store filament in dry box between prints
- Check nozzle for clogs/buildup

### Issue: Segments not aligning when snapped together
**Cause:** Print bed leveling drift over time
**Solution:**
- Re-level bed every 10 segments
- Check bed temperature consistency
- Verify first layer squish remains consistent

### Issue: Running out of filament mid-print
**Solution:**
- Weigh filament spool before each print
- Each segment uses ~30-35g
- Set slicer to pause before running out
- Join spools mid-print if necessary

---

## Safety Notes

- **PETG Fumes:** Generally safe, but print in ventilated area
- **Bed Temperature:** 85°C bed is hot! Don't touch
- **First Layer Issues:** Watch first 5 minutes, pause if adhesion fails
- **Fire Safety:** Never leave printer unattended for hours (use camera/alerts)

---

## Related Documentation

- **Project Guide:** `bed-ambient-lighting.md`
- **LED Strip Specs:** `xiao-c6-rgb-strip-test.md`
- **ESPHome Config:** `/home/hazzard/home-assistant/esphome/xiao-c6-rgb-strip-test.yaml`

---

## Changelog

- **2025-01-05:** Initial documentation - Transparent PETG diffuser settings for LED channels
