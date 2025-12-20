// ESP32-CAM Security Camera - Corner Mount Bracket
// For Creality Ender-3 V3
// Material: Hyper-PAL (Grey) or Hyper-PETG
// Use for room corners or ceiling/wall junctions

// ===== PARAMETERS =====
case_length = 50;
bracket_arm_length = 50;
bracket_arm_width = 50;
bracket_thickness = 5;

// Mounting holes
case_mount_spacing_x = 40;
case_mount_spacing_y = 25;
mount_hole_diameter = 3.5;  // M3 screw clearance
wall_hole_diameter = 4;     // Wall screw size

// ===== CORNER MOUNT BRACKET =====

module corner_bracket() {
    difference() {
        union() {
            // Horizontal arm (attaches to one wall)
            cube([bracket_arm_length, bracket_arm_width, bracket_thickness]);

            // Vertical arm (attaches to perpendicular wall)
            cube([bracket_thickness, bracket_arm_width, bracket_arm_length]);

            // Case mounting platform (at 45° in corner)
            translate([bracket_arm_length/2 - case_length/2, bracket_arm_width - 35, 20])
                rotate([0, 0, 45])
                cube([case_length, 35, bracket_thickness]);

            // Reinforcement gussets (triangular supports)
            // Gusset 1: Horizontal to vertical transition
            translate([0, bracket_arm_width/2, 0])
                rotate([0, 0, 0])
                linear_extrude(height=2)
                polygon([
                    [0, 0],
                    [0, 15],
                    [bracket_thickness, 15],
                    [bracket_thickness, 0],
                    [20, 0],
                    [20, -bracket_arm_width/2]
                ]);

            // Gusset 2: Support platform
            translate([bracket_arm_length/2 - 10, bracket_arm_width - 30, bracket_thickness])
                linear_extrude(height=2)
                polygon([
                    [0, 0],
                    [0, 20],
                    [20, 0]
                ]);

            // Cable routing clip (integrated)
            translate([bracket_thickness + 2, bracket_arm_width - 10, 10])
                difference() {
                    cube([6, 8, 15]);
                    translate([3, -1, 5])
                        cube([3, 10, 8]);
                }
        }

        // Case mounting holes (4 holes, positioned on angled platform)
        // These align with the rear cover bosses
        case_mount_base_x = bracket_arm_length/2 - case_length/2;
        case_mount_base_y = bracket_arm_width - 35;

        case_mount_positions = [
            [case_mount_base_x + 10, case_mount_base_y + 10],
            [case_mount_base_x + 40, case_mount_base_y + 10],
            [case_mount_base_x + 10, case_mount_base_y + 25],
            [case_mount_base_x + 40, case_mount_base_y + 25]
        ];

        for (pos = case_mount_positions) {
            translate([pos[0], pos[1], 18])
                rotate([0, 0, 45])
                cylinder(h=bracket_thickness+4, d=mount_hole_diameter, $fn=30);
        }

        // Wall mounting holes - Horizontal arm (2 holes)
        translate([bracket_arm_length/2 - 4, 15, -1])
            cylinder(h=bracket_thickness+2, d=wall_hole_diameter, $fn=30);

        translate([bracket_arm_length/2 + 4, 15, -1])
            cylinder(h=bracket_thickness+2, d=wall_hole_diameter, $fn=30);

        // Wall mounting holes - Vertical arm (2 holes)
        translate([-1, 15, bracket_arm_length/2 - 4])
            rotate([0, 90, 0])
            cylinder(h=bracket_thickness+2, d=wall_hole_diameter, $fn=30);

        translate([-1, 15, bracket_arm_length/2 + 4])
            rotate([0, 90, 0])
            cylinder(h=bracket_thickness+2, d=wall_hole_diameter, $fn=30);

        // Cable pass-through (vertical slot in corner)
        translate([bracket_thickness - 1, bracket_arm_width - 15, 5])
            cube([bracket_thickness+2, 5, 30]);
    }
}

// Render the corner bracket
corner_bracket();

// Add text labels (optional)
translate([bracket_arm_length/2 - 8, 8, 0.5])
    linear_extrude(height=0.5)
    text("CORNER", size=3, font="Arial:style=Bold");

// Print orientation:
// Print with horizontal arm flat on bed
// Vertical arm pointing up
// Use supports for the angled platform
// 40% infill recommended
