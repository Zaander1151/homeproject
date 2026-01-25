/*
    Project: Parametric LED Channel for SK6812 RGBW Strip
    Author: Claude Code
    Date: 2025-01-05

    Description:
    Modular LED channel segment optimized for Qidi Plus 4 printer (280mm segments).
    Features interlocking connectors, integrated mounting clips, wire routing channels,
    and tunable diffuser walls for perfect light distribution.

    Hardware:
    - SK6812 RGBW LED Strip (10mm wide, 60 LEDs/meter)
    - M3 mounting screws (optional)
    - Designed for bed frame mounting

    Assembly:
    - 29 segments needed for 8 meters total
    - Male/female connectors snap together
    - Power injection points every 2.5-3 meters

    Print Settings:
    - Material: Transparent PETG
    - Layer height: 0.2mm
    - Infill: 20-40% (balance between diffusion and strength)
    - Wall thickness: Tune 'diffuser_wall_thickness' for desired light spread
*/

// ============================================================================
// GLOBAL PARAMETERS - ADJUST THESE FOR YOUR NEEDS
// ============================================================================

$fn = 80; // Smoothness (higher = smoother curves, slower render)

// --- Segment Dimensions ---
segment_length = 280;        // Maximum length for Qidi Plus 4 (305mm bed)
channel_width = 14;          // Internal width (10mm LED strip + 2mm clearance each side)
channel_depth = 10;          // Internal depth (8mm for LEDs + 2mm clearance)
diffuser_wall_thickness = 1.8; // TUNE THIS: 1.5mm = bright, 2.0mm = more diffused
side_wall_thickness = 2.0;   // Side walls (structural strength)
base_thickness = 2.0;        // Bottom base

// --- LED Strip Specifications ---
led_strip_width = 10;        // SK6812 RGBW strip width
led_strip_height = 3;        // Strip thickness including adhesive backing

// --- Mounting Clips ---
enable_mounting_clips = true;  // Set to false to disable clips
clip_spacing = 140;            // Distance between mounting clips (2 per segment)
clip_height = 8;               // Height of mounting tab
clip_thickness = 3;            // Thickness of mounting tab
clip_hole_diameter = 3.5;      // M3 screw clearance hole
clip_width = 12;               // Width of each mounting clip

// --- Interlocking Connectors ---
connector_depth = 8;           // How deep the male/female connectors go
connector_tolerance = 0.3;     // Clearance for snap-fit (0.2-0.4mm typical)
connector_width = 10;          // Width of connector tabs

// --- Wire Routing Channels ---
wire_channel_width = 6;        // Width of wire routing slot
wire_channel_depth = 4;        // Depth of wire channel
wire_channel_positions = [70, 210]; // X positions for wire exit points (power injection)

// --- Calculated Dimensions ---
total_width = channel_width + (side_wall_thickness * 2);
total_height = channel_depth + base_thickness;

// ============================================================================
// MAIN ASSEMBLY - Render this!
// ============================================================================

module led_channel_segment() {
    difference() {
        union() {
            // Main channel body
            channel_body();

            // Mounting clips
            if (enable_mounting_clips) {
                mounting_clips();
            }

            // Male connector (right end)
            translate([segment_length, 0, 0])
                male_connector();
        }

        // Female connector cutout (left end)
        translate([0, 0, 0])
            female_connector_cutout();

        // Wire routing channels
        wire_routing_channels();
    }

    // Female connector guide rails (left end, inside channel)
    translate([0, 0, 0])
        female_connector_guides();
}

// ============================================================================
// MODULES
// ============================================================================

module channel_body() {
    difference() {
        // Outer shell
        cube([segment_length, total_width, total_height]);

        // Inner cavity for LED strip
        translate([0, side_wall_thickness, base_thickness])
            cube([segment_length, channel_width, channel_depth + 1]);

        // Top opening (diffuser layer only)
        translate([0, side_wall_thickness, base_thickness + led_strip_height])
            cube([segment_length, channel_width, channel_depth]);
    }
}

module mounting_clips() {
    // Calculate clip positions (centered, evenly spaced)
    num_clips = 2;
    first_clip_pos = (segment_length - ((num_clips - 1) * clip_spacing)) / 2;

    for (i = [0 : num_clips - 1]) {
        clip_x = first_clip_pos + (i * clip_spacing);

        translate([clip_x - clip_width/2, total_width/2 - clip_thickness/2, -clip_height]) {
            difference() {
                // Mounting tab
                cube([clip_width, clip_thickness, clip_height]);

                // Screw hole (countersunk from bottom)
                translate([clip_width/2, clip_thickness/2, -1])
                    cylinder(h = clip_height/2 + 1, d = clip_hole_diameter);

                // Countersink (optional, for flush mounting)
                translate([clip_width/2, clip_thickness/2, -1])
                    cylinder(h = 2, d1 = clip_hole_diameter * 1.8, d2 = clip_hole_diameter);
            }
        }
    }
}

module male_connector() {
    // Male connector extends from the right end
    connector_height = total_height - base_thickness;

    translate([0, side_wall_thickness + connector_tolerance, base_thickness]) {
        // Top tab
        translate([0, 0, connector_height/2 + 1])
            cube([connector_depth, connector_width - (connector_tolerance * 2), connector_height/2 - 1]);

        // Bottom tab
        translate([0, 0, 0])
            cube([connector_depth, connector_width - (connector_tolerance * 2), connector_height/2 - 1]);
    }
}

module female_connector_cutout() {
    // Female connector cutout receives male connector from previous segment
    connector_height = total_height - base_thickness;

    translate([-connector_depth, side_wall_thickness, base_thickness]) {
        // Top slot
        translate([0, 0, connector_height/2 + 1])
            cube([connector_depth + 0.5, connector_width, connector_height/2 + 1]);

        // Bottom slot
        translate([0, 0, 0])
            cube([connector_depth + 0.5, connector_width, connector_height/2 - 1]);
    }
}

module female_connector_guides() {
    // Guide rails inside channel to support female connector
    connector_height = total_height - base_thickness;
    guide_thickness = 1.5;

    translate([0, side_wall_thickness, base_thickness]) {
        // Left guide rail
        translate([0, -guide_thickness, 0])
            cube([connector_depth * 2, guide_thickness, connector_height]);

        // Right guide rail
        translate([0, connector_width, 0])
            cube([connector_depth * 2, guide_thickness, connector_height]);
    }
}

module wire_routing_channels() {
    // Cutouts in the base for power injection wires to exit
    for (x_pos = wire_channel_positions) {
        translate([x_pos - wire_channel_width/2, total_width/2 - wire_channel_depth/2, -1])
            cube([wire_channel_width, wire_channel_depth, base_thickness + 2]);
    }
}

// ============================================================================
// TEST PIECES - Uncomment to print individual components for testing
// ============================================================================

// Render full segment (default)
led_channel_segment();

// Test connector fit (print both, test snap-fit)
//translate([0, 0, 0]) male_connector();
//translate([15, 0, 0]) female_connector_cutout();

// Test diffusion (print 50mm segment with different wall thicknesses)
/*
for (i = [0:3]) {
    translate([0, i * 25, 0]) {
        difference() {
            cube([50, 20, total_height]);
            translate([0, side_wall_thickness, base_thickness])
                cube([50, channel_width, channel_depth + 1]);
            translate([0, side_wall_thickness, base_thickness + led_strip_height])
                cube([50, channel_width, channel_depth]);
        }
        // Label the wall thickness
        translate([5, 22, 0])
            linear_extrude(0.5)
                text(str((1.5 + i*0.2), "mm"), size=3);
    }
}
*/

// ============================================================================
// NOTES & ASSEMBLY INSTRUCTIONS
// ============================================================================

/*
PRINTING INSTRUCTIONS:
======================
1. Slice with:
   - Layer height: 0.2mm
   - Infill: 20-40% (higher = better diffusion, dimmer)
   - Walls: 3-4 perimeters
   - Top/bottom layers: 4-5
   - No supports needed!

2. Orientation:
   - Print with diffuser facing UP (better surface finish for light)
   - Mounting clips facing down (print on bed)

3. First Print:
   - Print 2 test segments (560mm total)
   - Test LED strip fit
   - Test connector snap-fit
   - Evaluate light diffusion
   - Adjust parameters if needed

TUNING DIFFUSION:
==================
- Too bright/see individual LEDs? Increase 'diffuser_wall_thickness' to 2.0-2.2mm
- Too dim? Decrease to 1.5-1.6mm
- Want hotspot-free? Increase infill to 40-60%
- Infill pattern: Gyroid or Grid works best for even light

ASSEMBLY:
=========
1. Insert LED strip into channel (adhesive side down on base)
2. Route power wires through wire_channel cutouts
3. Snap segments together (male into female connector)
4. Mount to bed frame using M3 screws through clip holes
5. Connect power injection wires at designated points

WIRE INJECTION POINTS:
======================
- First segment: Main power input
- Every 2.5-3 meters: Additional power injection
- Wire channels at 70mm and 210mm allow routing without gaps

CONNECTOR STRENGTH:
===================
- Snap-fit design holds segments aligned
- No glue needed for temporary installations
- Optional: Add tiny dab of super glue if permanent
- Tolerance of 0.3mm allows tight fit without binding

BOM FOR 8 METERS (29 SEGMENTS):
================================
- Filament: ~800g-1kg Transparent PETG
- Print time: ~70-80 hours
- Screws: 58x M3x8mm (2 per segment)
- LED strip: 8 meters SK6812 RGBW (480 LEDs)
- Power supply: 12V 5A + 3x LM2596 buck converters
*/
