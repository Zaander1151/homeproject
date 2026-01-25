// Voice Satellite - Amazon Echo Style Enclosure (TRULY PRINTABLE)
// VERSION 12
// Designed for ESP32-S3 with LED Ring, I2S Microphone/Speaker
//
// DESIGN PHILOSOPHY:
// - ZERO floating geometry
// - Everything prints from bed up OR dome down
// - No fancy clips or retention features
// - Simple ledges and friction fit
// - EASY ASSEMBLY - simplified top cap for component access
//
// Print Settings:
// - Material: PLA or PETG
// - Layer Height: 0.2mm
// - Infill: 20%
// - Supports: NONE
//
// CHANGELOG v12:
// - Base: Fixed ESP32 platform extruding through outer wall (constrained to interior).
// - Base: Increased header pin slot spacing by 1mm (now 23.86mm).
// - Base: Increased header pin slot width by 0.5mm (now 3.5mm).
// - Base: Cleaned up header slots.
//
// CHANGELOG v11:
// - Base: Adjusted ESP32 platform height so board USB aligns with case USB hole.
// - Base: Filled gap between ESP32 platform and outer wall.
// - Base: Refined Twist-Lock slots (internal only).

// ============================================
// PARAMETERS
// ============================================

// Main enclosure dimensions
enclosure_diameter = 90;
wall_thickness = 2.5;
base_height = 50;
top_height = 20;

// Top Cap specific overrides
top_wall_thickness = 5;
connection_height = 2; // Height of the lip that fits into base
connection_depth = 2.5; // Depth of the lip (should match wall_thickness difference if flush)

// LED Ring Channel specifications
led_channel_od = 37.15;
led_channel_width = 7.15;
led_channel_depth = 13;
channel_outer_wall_thickness = 1.5; // Thickness of the wall separating channel from interior
diffuser_tolerance = 0.2; // Clearance for diffuser fit

// Wire Hole Specs
wire_hole_diameter = 3;

// Speaker specifications
speaker_diameter = 45;
speaker_grill_hole_size = 2;
speaker_grill_spacing = 4;

// Button specifications
button_diameter = 12;
button_offset_from_center = 18;

// Microphone grill (on side wall opposite USB port)
mic_grill_width = 20;       // Width of microphone grill area
mic_grill_height = 12;      // Height of microphone grill area
mic_grill_hole_size = 2;    // Individual hole diameter
mic_grill_hole_spacing = 3; // Spacing between holes

// ESP32-S3 mounting
esp32_width = 25.4;
esp32_length = 50.8;
esp32_mount_height = 8;

// Cable management
usb_port_width = 10;
usb_port_height = 5;
usb_port_from_bottom = 15;

// Ventilation
vent_slot_width = 1.5;
vent_slot_height = 15;
vent_slot_count = 8;

// Assembly tolerances
assembly_gap = 0.3;

// Rendering selection
part_to_render = "all";  // Options: "all", "base", "top", "speaker_platform", "diffuser"

// Speaker platform support system
speaker_platform_height = base_height - 10;  // Height where platform sits
support_ring_width = 2;                       // How far ring extends inward from wall
platform_thickness = 2;                       // Thickness of speaker platform
support_beam_width = 8;                       // Width of cross-support beams
inner_ring_width = 5;                         // Width of inner speaker mounting ring

// ============================================
// RENDERING
// ============================================

if (part_to_render == "all") {
    base_assembly();
    translate([0, 0, base_height + 5])
        top_cap_assembly();
    translate([0, 0, base_height + 30])
        diffuser();
    speaker_platform_assembly();
}
else if (part_to_render == "base") {
    base_assembly();
}
else if (part_to_render == "top") {
    top_cap_assembly();
}
else if (part_to_render == "speaker_platform") {
    speaker_platform_assembly();
}
else if (part_to_render == "diffuser") {
    diffuser();
}

// ============================================
// BASE ASSEMBLY
// ============================================

module base_assembly() {
    difference() {
        union() {
            // Main cylindrical body
            cylinder(h = base_height, d = enclosure_diameter, $fn = 100);

            // Tapered base ring (connected to main body)
            cylinder(h = 2, d1 = enclosure_diameter + 2, d2 = enclosure_diameter, $fn = 100);
        }

        // Hollow interior
        translate([0, 0, wall_thickness])
            cylinder(h = base_height, d = enclosure_diameter - wall_thickness * 2, $fn = 100);

        // USB-C port cutout
        translate([enclosure_diameter/2 - wall_thickness - 1, -usb_port_width/2, usb_port_from_bottom])
            cube([wall_thickness + 2, usb_port_width, usb_port_height]);

        // Ventilation slots
        for (i = [0:vent_slot_count-1]) {
            rotate([0, 0, i * (360/vent_slot_count)])
                translate([enclosure_diameter/2 - wall_thickness - 0.5, -vent_slot_width/2, base_height - vent_slot_height - 5])
                    cube([wall_thickness + 1, vent_slot_width, vent_slot_height]);
        }

        // Twist-Lock Slots (L-shaped channels inside top rim)
        for (i = [0:2]) {
            rotate([0, 0, i * 120]) {
                // Vertical entry slot
                translate([enclosure_diameter/2 - wall_thickness - 1, -1.5, base_height - 4])
                    cube([1.5, 3, 4.1]); // Cut 1.5mm deep into the inner wall
                
                // Horizontal locking slot
                translate([enclosure_diameter/2 - wall_thickness - 1, 0, base_height - 4])
                    rotate([0, 0, -2]) // Slight angle for tension
                        cube([1.5, 10, 2]); // Cut horizontally
                
                // Actual horizontal cut using intersection to follow curve
                intersection() {
                     // Ring representing the cut depth area
                    translate([0,0, base_height - 3])
                        difference() {
                            cylinder(h=2, d=enclosure_diameter - wall_thickness*2 + 2, $fn=100);
                             cylinder(h=2, d=enclosure_diameter - wall_thickness*2 - 5, $fn=100);
                        }
                    // Pie slice to limit rotation
                    rotate([0,0,-15])
                        translate([0,0,base_height - 4])
                            cube([enclosure_diameter, enclosure_diameter/2, 5]); 
                }
            }
        }
    }

    // ESP32-S3 mounting system
    esp32_platform_top_z = usb_port_from_bottom - 1.75;
    
    // Position Calculations
    esp32_board_to_edge = 5;  
    esp32_center_x = enclosure_diameter/2 - wall_thickness - esp32_board_to_edge - esp32_length/2;

    // Header pin specifications
    header_pin_spacing = 23.86; // Increased by 1mm (was 22.86)
    header_slot_width = 3.5;    // Increased by 0.5mm (was 3.0)
    header_slot_depth = 8;

    // Platform with header pin slots
    difference() {
        // Solid platform base
        // Constrain to the interior of the enclosure so it doesn't poke out
        intersection() {
            // The Box we are creating
            translate([esp32_center_x - esp32_length/2 - 2, -esp32_width/2 - 2, wall_thickness]) {
                // Extended length to definitely reach the wall
                cube([esp32_length + 20, esp32_width + 4, esp32_platform_top_z - wall_thickness]);
            }
            
            // The constraining volume (Inside of the enclosure walls)
            // We use a cylinder slightly smaller than the outer diameter to be safe, 
            // or exactly the outer diameter if we want it flush with the hole.
            // Since we filled the gap, we want it to touch the inner wall.
            cylinder(h=base_height, d=enclosure_diameter - wall_thickness*0.1, $fn=100); // Almost outer diameter
        }

        // Slot 1: Left side header pins
        translate([esp32_center_x - esp32_length/2, -header_pin_spacing/2 - header_slot_width/2, esp32_platform_top_z - header_slot_depth]) {
            cube([esp32_length, header_slot_width, header_slot_depth + 1]);
        }

        // Slot 2: Right side header pins
        translate([esp32_center_x - esp32_length/2, header_pin_spacing/2 - header_slot_width/2, esp32_platform_top_z - header_slot_depth]) {
            cube([esp32_length, header_slot_width, header_slot_depth + 1]);
        }
    }

    // Continuous support ring (360° ledge around inner wall)
    translate([0, 0, speaker_platform_height]) {
        difference() {
            // Full ring
            cylinder(h = platform_thickness, d = enclosure_diameter - wall_thickness * 2, $fn = 100);
            // Hollow out center, leaving 2mm ring from wall
            translate([0, 0, -1])
                cylinder(h = platform_thickness + 2, d = enclosure_diameter - wall_thickness * 2 - support_ring_width * 2, $fn = 100);
        }
    }
}

// ============================================
// TOP CAP - REDESIGNED v10
// ============================================

module top_cap_assembly() {
    channel_floor_z = top_height - led_channel_depth;
    
    // Calculate the diameter of the hollow area AROUND the channel
    interior_hollow_d = led_channel_od + channel_outer_wall_thickness * 2;
    
    // Wire hole placement (middle of the channel width)
    wire_hole_radius_from_center = (led_channel_od / 2) - (led_channel_width / 2);

    difference() {
        // ========================================
        // SECTION 1: MAIN BODY
        // ========================================
        // Solid cylinder, no extra bridges needed now that floor is solid
        cylinder(h = top_height, d = enclosure_diameter, $fn = 100);

        // ========================================
        // SECTION 2: HOLLOW INTERIOR
        // ========================================
        
        // A. Main Outer Chamber Hollow
        difference() {
            // Remove everything inside the outer walls
            translate([0, 0, -1])
                cylinder(
                    h = top_height - top_wall_thickness, // Leave 5mm roof
                    d = enclosure_diameter - top_wall_thickness * 2, 
                    $fn = 100
                );
            
            // BUT protect the center column (Channel + Wall)
            translate([0,0,-2])
                cylinder(h=top_height+2, d=led_channel_od + channel_outer_wall_thickness*2, $fn=100);
        }
        
        // B. The Center Hollow (Inside the Center Island)
        translate([0, 0, -1]) // Connect to bottom
            cylinder(
                h = top_height - wall_thickness + 1, // High enough to reach grill
                d = led_channel_od - led_channel_width * 2 - 4, // Inner wall thickness 2mm
                $fn = 100
            );
            
        // C. Wire Pass-Through Holes
        // 4 Holes spaced 90 deg apart
        for (i = [0:3]) {
            rotate([0, 0, i * 90 + 45]) // +45 to avoid aligning with grill holes (optional)
                translate([wire_hole_radius_from_center, 0, -1])
                    cylinder(h = channel_floor_z + 2, d = wire_hole_diameter, $fn = 20);
        }

        // ========================================
        // SECTION 3: CONNECTION STEP (Rabbet)
        // ========================================
        difference() {
            translate([0, 0, -0.1])
                cylinder(h = connection_height + 0.1, d = enclosure_diameter + 1, $fn = 100);
            
            translate([0, 0, -1])
                cylinder(h = connection_height + 2, d = enclosure_diameter - wall_thickness * 2 - 0.4, $fn = 100);
        }

        // ========================================
        // SECTION 4: LED RING CHANNEL (Upper Part)
        // ========================================
        translate([0, 0, top_height - led_channel_depth])
            difference() {
                cylinder(h = led_channel_depth + 1, d = led_channel_od, $fn = 100);
                translate([0, 0, -1])
                    cylinder(h = led_channel_depth + 3, d = led_channel_od - led_channel_width * 2, $fn = 100);
            }

        // ========================================
        // SECTION 5: SPEAKER GRILL HOLES
        // ========================================
        translate([0, 0, 0])
            translate([0, 0, top_height - wall_thickness - 0.5]) // Z=17
                speaker_grill(led_channel_od - led_channel_width * 2 - 2, speaker_grill_hole_size, speaker_grill_spacing, 20); // Depth 20mm ensures cut through

        // ========================================
        // SECTION 6: MICROPHONE GRILL ON SIDE
        // ========================================
        rotate([0, 0, 180])
            translate([enclosure_diameter/2 - top_wall_thickness - 1, 0, top_height/2 + 2])
                rotate([0, 90, 0])
                    mic_grill_pattern(mic_grill_width, mic_grill_height, mic_grill_hole_size, mic_grill_hole_spacing, top_wall_thickness + 2);
    }
    
    // Add Locking Pins
    for (i = [0:2]) {
        rotate([0, 0, i * 120])
            translate([enclosure_diameter/2 - wall_thickness - 0.5, 0, 1]) // 1mm up from bottom
                rotate([0, 90, 0])
                    cylinder(h=2, d=1.8, $fn=20); // Small pin sticking out
    }
}

// ============================================
// DIFFUSER (SEPARATE PIECE)
// ============================================
module diffuser() {
    difference() {
        cylinder(h = 2, d = led_channel_od - diffuser_tolerance, $fn = 100);
        translate([0, 0, -1])
            cylinder(h = 4, d = led_channel_od - led_channel_width * 2 + diffuser_tolerance, $fn = 100);
    }
}

// ============================================
// SPEAKER PLATFORM (SEPARATE PIECE - SLIDES INTO BASE)
// ============================================

module speaker_platform_assembly() {
    // Calculate dimensions
    outer_diameter = enclosure_diameter - wall_thickness * 2 - support_ring_width * 2 - assembly_gap;
    inner_diameter = speaker_diameter - inner_ring_width * 2;
    wire_pass_through_diameter = 8;  // 8mm hole for wire bundle

    difference() {
        union() {
            // Outer circle (sits on support ring in base)
            difference() {
                cylinder(h = platform_thickness, d = outer_diameter, $fn = 100);
                // Hollow out most of it, leaving outer rim
                translate([0, 0, -1])
                    cylinder(h = platform_thickness + 2, d = outer_diameter - inner_ring_width * 2, $fn = 100);
            }

            // Inner circle (speaker mounting ring)
            difference() {
                cylinder(h = platform_thickness, d = speaker_diameter, $fn = 80);
                translate([0, 0, -1])
                    cylinder(h = platform_thickness + 2, d = inner_diameter, $fn = 80);
            }

            // Two cross-support beams (full diameter)
            // Beam 1: horizontal
            translate([-outer_diameter/2, -support_beam_width/2, 0])
                cube([outer_diameter, support_beam_width, platform_thickness]);

            // Beam 2: vertical
            translate([-support_beam_width/2, -outer_diameter/2, 0])
                cube([support_beam_width, outer_diameter, platform_thickness]);
        }

        // Wire pass-through hole in center (for LED and mic wires)
        translate([0, 0, -1])
            cylinder(h = platform_thickness + 2, d = wire_pass_through_diameter, $fn = 40);
    }
}

// ============================================
// HELPER MODULES
// ============================================

// Helper to cut an arc slot
module wire_slot_arc(r, width, angle, depth) {
    intersection() {
        // Ring
        difference() {
            cylinder(h=depth, r=r + width/2, $fn=100);
            translate([0,0,-1]) cylinder(h=depth+2, r=r - width/2, $fn=100);
        }
        // Pie slice
        translate([0,0,-1])
            linear_extrude(height=depth+2)
                polygon([
                    [0,0],
                    [2*r * cos(-angle/2), 2*r * sin(-angle/2)],
                    [2*r, 0], // Help fill the curve
                    [2*r * cos(angle/2), 2*r * sin(angle/2)]
                ]);
    }
}

module speaker_grill(diameter, hole_size, spacing, depth) {
    rows = floor(diameter / spacing);

    for (x = [-rows/2:rows/2]) {
        for (y = [-rows/2:rows/2]) {
            offset_x = x * spacing;
            offset_y = y * spacing + (x % 2) * (spacing / 2);

            if (sqrt(offset_x * offset_x + offset_y * offset_y) < diameter / 2) {
                translate([offset_x, offset_y, -1])
                    cylinder(h = depth, d = hole_size, $fn = 6);
            }
        }
    }
}

module mic_grill_pattern(width, height, hole_size, spacing, depth) {
    // Rectangular grid of holes for microphone
    cols = floor(width / spacing);
    rows = floor(height / spacing);

    for (x = [0:cols-1]) {
        for (y = [0:rows-1]) {
            translate([
                -1,
                x * spacing - width/2 + spacing/2,
                y * spacing - height/2 + spacing/2
            ])
                cylinder(h = depth, d = hole_size, $fn = 6);
        }
    }
}

// ============================================
// ASSEMBLY INSTRUCTIONS
// ============================================

// PRINT SETTINGS:
//
// BASE:
// - Set: part_to_render = "base";
// - Orientation: UPRIGHT
// - Supports: NONE
//
// TOP CAP:
// - Set: part_to_render = "top";
// - Orientation: UPRIGHT (flat top up)
// - Supports: NONE (Internal bridges allow channel floor to print)
//
// DIFFUSER:
// - Set: part_to_render = "diffuser";
// - Orientation: FLAT
// - Material: Translucent PLA/PETG/TPU
//
// SPEAKER PLATFORM:
// - Set: part_to_render = "speaker_platform";
// - Orientation: FLAT
////
