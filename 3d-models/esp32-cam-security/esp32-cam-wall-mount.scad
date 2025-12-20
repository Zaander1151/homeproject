// ESP32-CAM Security Camera - Wall Mount Bracket
// For Creality Ender-3 V3
// Material: Hyper-PAL (Grey) or Hyper-PETG
// Print with 40-50% infill for strength

// ===== PARAMETERS =====
case_length = 50;
bracket_width = 40;
bracket_thickness = 5;
wall_thickness = 2;

// Mounting holes
case_mount_spacing_x = 40;  // Distance between screw holes horizontally
case_mount_spacing_y = 25;  // Distance between screw holes vertically
wall_mount_spacing = 8;     // Distance between wall mounting holes
mount_hole_diameter = 3.5;  // M3 screw clearance (3mm + tolerance)
wall_hole_diameter = 4;     // Wall screw/anchor size

// Angle adjustment
tilt_angle = 30;  // Default downward tilt (0-45 degrees)

// ===== WALL MOUNT BRACKET =====

module wall_mount_base() {
    difference() {
        union() {
            // Base plate (attaches to wall)
            cube([case_length, bracket_width, bracket_thickness]);

            // Angled mounting arm
            translate([case_length/2 - 10, bracket_width - bracket_thickness, bracket_thickness])
                rotate([-tilt_angle, 0, 0])
                cube([20, 5, 30]);

            // Reinforcement ribs (triangular gussets)
            for (x = [case_length/2 - 12, case_length/2 + 7]) {
                translate([x, bracket_width - bracket_thickness, bracket_thickness])
                    rotate([0, 0, 0])
                    linear_extrude(height=2)
                    polygon([
                        [0, 0],
                        [0, 15],
                        [10, 0]
                    ]);
            }

            // Cable routing channel (along back of arm)
            translate([case_length/2 - 3, bracket_width - bracket_thickness - 2, bracket_thickness])
                cube([6, 2, 25]);
        }

        // Case mounting holes (4 holes matching rear cover bosses)
        case_mount_positions = [
            [case_length/2 - case_mount_spacing_x/2, bracket_width/2 - case_mount_spacing_y/2],
            [case_length/2 + case_mount_spacing_x/2, bracket_width/2 - case_mount_spacing_y/2],
            [case_length/2 - case_mount_spacing_x/2, bracket_width/2 + case_mount_spacing_y/2],
            [case_length/2 + case_mount_spacing_x/2, bracket_width/2 + case_mount_spacing_y/2]
        ];

        for (pos = case_mount_positions) {
            translate([pos[0], pos[1], -1])
                cylinder(h=bracket_thickness+2, d=mount_hole_diameter, $fn=30);

            // Countersink for screw heads
            translate([pos[0], pos[1], bracket_thickness - 2])
                cylinder(h=3, d1=mount_hole_diameter, d2=mount_hole_diameter+2, $fn=30);
        }

        // Wall mounting holes (2 holes for drywall anchors)
        translate([case_length/2 - wall_mount_spacing/2, 10, -1])
            cylinder(h=bracket_thickness+2, d=wall_hole_diameter, $fn=30);

        translate([case_length/2 + wall_mount_spacing/2, 10, -1])
            cylinder(h=bracket_thickness+2, d=wall_hole_diameter, $fn=30);

        // Keyhole slot for easy hanging (optional - top hole elongated)
        translate([case_length/2 - wall_mount_spacing/2, 10 - 5, -1])
            cube([wall_hole_diameter, 5, bracket_thickness+2]);

        translate([case_length/2 + wall_mount_spacing/2, 10 - 5, -1])
            cube([wall_hole_diameter, 5, bracket_thickness+2]);

        // Cable pass-through slot
        translate([case_length/2 - 2.5, bracket_width - 15, -1])
            cube([5, 20, bracket_thickness+2]);
    }
}

// Render the bracket
wall_mount_base();

// Add text label (optional)
translate([case_length/2, 25, 0.5])
    linear_extrude(height=0.5)
    text("WALL", size=4, font="Arial:style=Bold", halign="center");

// Print orientation note:
// Print flat on bed with base plate down
// No supports needed for this angle
// Add brim for bed adhesion
