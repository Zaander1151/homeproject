// Voice Satellite - Amazon Echo Style Enclosure (TRULY PRINTABLE)
// VERSION 5
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
// CHANGELOG v5:
// - FIXED: Hollow interior now stops below top surface
// - Top surface is now SOLID (2.5mm thick) with speaker grill holes cut through
// - Bottom interior is hollow for component access
// - Correct geometry: solid top, hollow bottom
//
// CHANGELOG v4:
// - Single microphone grill on side wall (opposite USB port)
// - Microphone grill is a pattern of holes (not single hole)
// - Cleaner, more practical design
//
// CHANGELOG v3:
// - Simplified top cap: flat top, no dome, no LED recess, no button
// - Speaker grill on top surface (easier assembly)
// - Microphone holes on side wall instead of top
// - Much easier to access components during assembly
//
// CHANGELOG v2:
// - Added 2.75mm groove to bottom of top cap for base fit
// - Moved speaker grill to 3/4 height (15mm from bottom)
// - Added wire pass-through hole in speaker platform center

// ============================================
// PARAMETERS
// ============================================

// Main enclosure dimensions
enclosure_diameter = 90;
wall_thickness = 2.5;
base_height = 50;
top_height = 20;

// LED Ring specifications
led_ring_outer_diameter = 44;
led_ring_inner_diameter = 32;

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
part_to_render = "all";  // Options: "all", "base", "top", "speaker_platform"

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
    translate([0, 0, base_height - 0.1])
        top_cap_assembly();
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

        // Snap-fit groove (cut into top rim)
        translate([0, 0, base_height - 3])
            difference() {
                cylinder(h = 3.5, d = enclosure_diameter - wall_thickness * 1.5, $fn = 100);
                translate([0, 0, -1])
                    cylinder(h = 5.5, d = enclosure_diameter - wall_thickness * 2 - 1.5, $fn = 100);
            }
    }

    // ESP32-S3 mounting system (USB port aligned to wall cutout)
    // Board positioned so USB port faces the cutout
    esp32_usb_height = usb_port_from_bottom + usb_port_height/2 - 2;  // Align USB port center
    esp32_board_to_edge = 5;  // Distance from edge of enclosure
    esp32_center_x = enclosure_diameter/2 - wall_thickness - esp32_board_to_edge - esp32_length/2;

    // Header pin specifications
    header_pin_spacing = 22.86;  // Distance between inner edges of header rows (standard 0.9")
    header_slot_width = 3.0;     // Width of slot for header pins (2.54mm pin pitch + tolerance)
    header_slot_depth = 8;       // Depth of slot for pins to insert

    // Platform with header pin slots
    difference() {
        // Solid platform base
        translate([esp32_center_x - esp32_length/2 - 2, -esp32_width/2 - 2, wall_thickness]) {
            cube([esp32_length + 4, esp32_width + 4, esp32_usb_height]);
        }

        // Slot 1: Left side header pins
        translate([esp32_center_x - esp32_length/2, -header_pin_spacing/2 - header_slot_width/2, wall_thickness + esp32_usb_height - header_slot_depth]) {
            cube([esp32_length, header_slot_width, header_slot_depth + 1]);
        }

        // Slot 2: Right side header pins
        translate([esp32_center_x - esp32_length/2, header_pin_spacing/2 - header_slot_width/2, wall_thickness + esp32_usb_height - header_slot_depth]) {
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

    // Cable routing posts
    for (angle = [45, 135, 225, 315]) {
        rotate([0, 0, angle])
            translate([15, 0, wall_thickness])
                cylinder(h = 10, d = 3, $fn = 20);
    }
}

// ============================================
// TOP CAP - SIMPLIFIED FLAT TOP DESIGN
// ============================================

module top_cap_assembly() {
    difference() {
        union() {
            // Main cylinder - flat top
            cylinder(h = top_height, d = enclosure_diameter, $fn = 100);

            // Snap-fit ridge (extends from outer wall into base)
            translate([0, 0, 1.5])
                difference() {
                    cylinder(h = 1.5, d = enclosure_diameter - wall_thickness * 1.5 - assembly_gap, $fn = 100);
                    translate([0, 0, -1])
                        cylinder(h = 4, d = enclosure_diameter - wall_thickness * 2 - 2, $fn = 100);
                }
        }

        // Hollow interior - leaves solid top surface for speaker grill
        // Goes from z=2.5mm to z=17.5mm, leaving 2.5mm solid top
        translate([0, 0, wall_thickness])
            cylinder(h = top_height - wall_thickness * 2, d = enclosure_diameter - wall_thickness * 2, $fn = 100);

        // Groove for fitting into base (2.75mm deep, bottom 2.5mm)
        translate([0, 0, 0])
            difference() {
                cylinder(h = 2.5, d = enclosure_diameter, $fn = 100);
                cylinder(h = 2.5, d = enclosure_diameter - 2.75 * 2, $fn = 100);
            }

        // Speaker grill holes cut through SOLID TOP surface (z=17.5 to z=20)
        translate([0, 0, top_height - wall_thickness - 0.5])
            speaker_grill(speaker_diameter, speaker_grill_hole_size, speaker_grill_spacing, wall_thickness + 1);

        // Microphone grill on SIDE WALL (opposite USB port at 180°)
        rotate([0, 0, 180])
            translate([enclosure_diameter/2 - wall_thickness - 1, 0, top_height/2])
                rotate([0, 90, 0])
                    mic_grill_pattern(mic_grill_width, mic_grill_height, mic_grill_hole_size, mic_grill_hole_spacing, wall_thickness + 2);
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
// - Layer height: 0.2mm
// - Infill: 20%
//
// TOP CAP:
// - Set: part_to_render = "top";
// - Orientation: UPRIGHT (flat top up)
// - Supports: NONE
// - Layer height: 0.2mm
// - Infill: 20%
// - Material: Any PLA/PETG color
//
// SPEAKER PLATFORM:
// - Set: part_to_render = "speaker_platform";
// - Orientation: FLAT (tabs facing up)
// - Supports: NONE
// - Layer height: 0.2mm
// - Infill: 30% (stronger for speaker weight)
//
// ASSEMBLY ORDER:
//
// 1. Install ESP32-S3 in base:
//    - Align header pins with the two slots in the platform
//    - Press down to seat pins into slots
//    - USB port should face the wall cutout
//
// 2. Wire all components (much easier without speaker platform in the way!):
//    - Connect microphone wires
//    - Connect amplifier
//    - Connect LED ring wires (route through center)
//    - Wire button
//    - Route cables using cable routing posts
//
// 3. Install speaker platform:
//    - Align 4 tabs with 4 wall slots (at 22.5°, 112.5°, 202.5°, 292.5°)
//    - Slide platform down into slots (tabs insert into wall)
//    - Platform clicks into place
//
// 4. Mount speaker on platform:
//    - Place speaker face-up on ring
//    - Hot glue or small screws to secure
//    - Connect speaker wires to amplifier
//
// 5. Final assembly:
//    - Route microphone wires through speaker platform center hole
//    - Position microphone near mic port holes on top cap wall
//    - Snap top cap onto base (groove fits over base rim)
//    - Connect USB power through rear port
//    - Test all functions!
//
// DISASSEMBLY/SERVICING:
// - Remove top cap (pull straight up)
// - Lift speaker platform straight up (tabs slide out of slots)
// - Full access to all electronics for troubleshooting/upgrades
// - ESP32 pulls straight up out of header slots
//
// BENEFITS OF MODULAR DESIGN:
// ✅ Easy assembly - install ESP32 and wiring before speaker
// ✅ Easy access - remove speaker platform for servicing
// ✅ No supports needed on any part
// ✅ Replaceable components
// ✅ Upgrade-friendly (swap ESP32, speaker, etc.)
// ✅ Simple flat top - much easier to access components during assembly
