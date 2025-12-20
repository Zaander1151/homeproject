// ESP32-CAM Security Camera - Ceiling Mount Bracket
// For Creality Ender-3 V3
// Material: Hyper-PAL (Grey) or Hyper-PETG
// Print with 50% infill for ceiling load strength

// ===== PARAMETERS =====
case_length = 50;
base_diameter = 60;
base_thickness = 5;
arm_height = 20;
arm_width = 30;

// Tilt adjustment
tilt_angle = 20;  // Downward tilt from ceiling (0-30 degrees)

// Mounting holes
case_mount_spacing_x = 40;
case_mount_spacing_y = 25;
mount_hole_diameter = 3.5;  // M3 screw clearance
ceiling_hole_diameter = 4;  // Ceiling screw/anchor size

// ===== CEILING MOUNT BRACKET =====

module ceiling_mount() {
    difference() {
        union() {
            // Circular base plate (flush mount to ceiling)
            cylinder(h=base_thickness, d=base_diameter, $fn=60);

            // Mounting arm (downward extending)
            translate([0, 0, base_thickness])
                rotate([0, tilt_angle, 0])
                translate([-arm_width/2, -15, 0])
                cube([arm_width, 30, arm_height]);

            // Case attachment platform
            translate([0, 0, base_thickness + arm_height])
                rotate([0, tilt_angle, 0])
                translate([-case_length/2, -18, 0])
                cube([case_length, 36, base_thickness]);

            // Reinforcement ribs (radial from center)
            for (angle = [0, 90, 180, 270]) {
                rotate([0, 0, angle])
                    translate([-2, 0, base_thickness])
                    linear_extrude(height=2)
                    polygon([
                        [0, 0],
                        [0, 15],
                        [4, 0]
                    ]);
            }

            // Cable pass-through tube (center of base)
            difference() {
                cylinder(h=base_thickness + 5, d=12, $fn=30);
                translate([0, 0, -1])
                    cylinder(h=base_thickness + 7, d=8, $fn=30);
            }
        }

        // Ceiling mounting holes (3 holes at 120° spacing)
        for (angle = [0, 120, 240]) {
            rotate([0, 0, angle])
                translate([base_diameter/2 - 10, 0, -1])
                cylinder(h=base_thickness+2, d=ceiling_hole_diameter, $fn=30);

            // Countersink for screw heads
            rotate([0, 0, angle])
                translate([base_diameter/2 - 10, 0, base_thickness - 2])
                cylinder(h=3, d1=ceiling_hole_diameter, d2=ceiling_hole_diameter+3, $fn=30);
        }

        // Case mounting holes (4 holes on platform)
        translate([0, 0, base_thickness + arm_height])
            rotate([0, tilt_angle, 0])
            translate([-case_length/2, -18, 0]) {
                // Match rear cover boss positions
                case_mount_positions = [
                    [5, 8],
                    [case_length - 5, 8],
                    [5, 28],
                    [case_length - 5, 28]
                ];

                for (pos = case_mount_positions) {
                    translate([pos[0], pos[1], -1])
                        cylinder(h=base_thickness+2, d=mount_hole_diameter, $fn=30);

                    // Countersink
                    translate([pos[0], pos[1], base_thickness - 2])
                        cylinder(h=3, d1=mount_hole_diameter, d2=mount_hole_diameter+2, $fn=30);
                }
            }

        // Central cable pass-through hole
        translate([0, 0, -1])
            cylinder(h=base_thickness + arm_height + 10, d=8, $fn=30);

        // Cable exit slot (side of arm)
        translate([-3, arm_width/2 - 2, base_thickness + 5])
            cube([6, 5, arm_height - 5]);
    }
}

// Render the ceiling mount
ceiling_mount();

// Add text label (optional)
translate([-12, -2, 0.5])
    linear_extrude(height=0.5)
    text("CEILING", size=3, font="Arial:style=Bold");

// Print orientation:
// Print with base plate down on bed
// Supports required for overhanging platform
// Use 50% infill for strength (ceiling load)
// Add brim or raft for bed adhesion
