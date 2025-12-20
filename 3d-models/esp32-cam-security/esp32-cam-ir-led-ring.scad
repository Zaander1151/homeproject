// ESP32-CAM Security Camera - IR LED Ring (Night Vision)
// For Creality Ender-3 V3
// Material: Natural/Clear PETG (for light transmission)
// Print at 0.12mm layer height for smooth finish

// ===== PARAMETERS =====
ring_outer_diameter = 35;
ring_inner_diameter = 14;  // Slightly larger than lens (12mm) for clearance
ring_thickness = 3;

led_count = 6;
led_diameter = 5.2;  // 5mm LED + tolerance
led_circle_radius = 15;  // Distance from center to LED position

// Mounting holes
mounting_hole_diameter = 2.5;  // M2 screw clearance
mounting_hole_circle_radius = 14;

// ===== IR LED RING =====

module ir_led_ring() {
    difference() {
        union() {
            // Main ring body
            cylinder(h=ring_thickness, d=ring_outer_diameter, $fn=60);

            // LED retaining clips (small tabs to hold LEDs in place)
            for (angle = [0:360/led_count:359]) {
                rotate([0, 0, angle])
                    translate([led_circle_radius, 0, 0])
                    cylinder(h=ring_thickness + 1, d=2, $fn=20);
            }
        }

        // Center cutout for camera lens
        translate([0, 0, -1])
            cylinder(h=ring_thickness + 2, d=ring_inner_diameter, $fn=50);

        // LED mounting holes (6 LEDs at 60° spacing)
        for (angle = [0:360/led_count:359]) {
            rotate([0, 0, angle])
                translate([led_circle_radius, 0, -1])
                cylinder(h=ring_thickness + 2, d=led_diameter, $fn=30);

            // Wire routing channel (from LED to edge)
            rotate([0, 0, angle])
                translate([led_circle_radius, -0.5, ring_thickness - 1])
                cube([ring_outer_diameter/2 - led_circle_radius + 2, 1, 1.5]);
        }

        // Mounting screw holes (4 holes at 90° spacing, M2 size)
        for (angle = [45, 135, 225, 315]) {
            rotate([0, 0, angle])
                translate([mounting_hole_circle_radius, 0, -1])
                cylinder(h=ring_thickness + 2, d=mounting_hole_diameter, $fn=20);

            // Countersink for screw heads
            rotate([0, 0, angle])
                translate([mounting_hole_circle_radius, 0, ring_thickness - 1])
                cylinder(h=2, d1=mounting_hole_diameter, d2=mounting_hole_diameter+1.5, $fn=20);
        }

        // Cable routing slot (for power wires to exit ring)
        translate([ring_outer_diameter/2 - 2, -1.5, -1])
            cube([3, 3, ring_thickness + 2]);

        // Wire management channel (circular groove on back side)
        translate([0, 0, ring_thickness - 1])
            difference() {
                cylinder(h=1.5, d=ring_outer_diameter - 4, $fn=60);
                translate([0, 0, -1])
                    cylinder(h=3, d=ring_outer_diameter - 6, $fn=60);
            }
    }

    // Diffuser ridges (optional - helps spread IR light)
    // Small concentric rings on front face
    for (d = [18, 22, 26, 30]) {
        difference() {
            cylinder(h=0.3, d=d, $fn=60);
            translate([0, 0, -1])
                cylinder(h=3, d=d-0.5, $fn=60);
        }
    }
}

// Render the IR LED ring
ir_led_ring();

// Add text label (optional)
translate([-5, -1.5, 0.3])
    linear_extrude(height=0.3)
    text("IR", size=3, font="Arial:style=Bold");

// === ASSEMBLY NOTES ===
// 1. Print in Natural or Clear PETG for light transmission
// 2. Use 0.12mm layer height for smooth surface
// 3. Post-process: sand with 600-grit, then acetone vapor for clarity
// 4. Insert 6x IR LEDs (850nm, 5mm, 100mA)
// 5. Solder in series-parallel configuration:
//    - 2 parallel groups of 3 LEDs in series
//    - Each series string: LED -> 33Ω resistor -> LED -> 33Ω -> LED
//    - Connect to ESP32 5V and GND
// 6. Route wires through cable slot
// 7. Attach to camera case with 4x M2 screws

// === IR LED CIRCUIT ===
// Power: 5V from ESP32 (or external supply)
// Total Current: ~300mA (6 LEDs x 50mA average)
//
// Circuit Diagram:
//        5V
//         |
//    +----+----+
//    |         |
//   [R]       [R]   R = 33Ω resistor
//    |         |
//  [LED]     [LED]  IR LED (850nm, 1.5V forward)
//    |         |
//   [R]       [R]
//    |         |
//  [LED]     [LED]
//    |         |
//   [R]       [R]
//    |         |
//  [LED]     [LED]
//    |         |
//    +----+----+
//         |
//        GND
//
// Each LED: ~1.5V forward voltage, 100mA max
// Series string: 3 LEDs = 4.5V, leaves 0.5V for resistor
// Resistor: R = V/I = 0.5V / 0.05A = 10Ω (use 33Ω for safety margin)
// Actual current with 33Ω: I = 0.5V / 33Ω = 15mA per LED (safe, long life)
