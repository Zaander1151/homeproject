// ESP32-CAM Security Camera - Rear Cover
// For Creality Ender-3 V3
// Material: Hyper-PAL (Grey) or Hyper-PETG

// ===== PARAMETERS =====
case_length = 50;
case_width = 35;
wall_thickness = 2;

// Mounting boss dimensions
mounting_boss_diameter = 5;
mounting_hole_diameter = 3;  // M3 threaded insert
boss_height = 8;

// ===== REAR COVER =====
difference() {
    union() {
        // Main cover plate
        cube([case_length, case_width, wall_thickness]);

        // Mounting bosses with threaded insert holes
        boss_positions = [
            [5, 5],
            [case_length - 5, 5],
            [5, case_width - 5],
            [case_length - 5, case_width - 5]
        ];

        for (pos = boss_positions) {
            translate([pos[0], pos[1], wall_thickness])
                cylinder(h=boss_height, d=mounting_boss_diameter, $fn=30);
        }

        // Slide-in clips for case attachment (top edge)
        // Left clip
        translate([wall_thickness + 2, case_width/2 - 4, 0])
            cube([4, 8, wall_thickness]);

        // Right clip
        translate([case_length - wall_thickness - 6, case_width/2 - 4, 0])
            cube([4, 8, wall_thickness]);

        // Center support ribs (prevent warping)
        translate([case_length/2 - 0.5, wall_thickness + 5, wall_thickness])
            cube([1, case_width - 2*wall_thickness - 10, 2]);

        translate([wall_thickness + 5, case_width/2 - 0.5, wall_thickness])
            cube([case_length - 2*wall_thickness - 10, 1, 2]);
    }

    // Cable routing slot (for USB cable exit)
    translate([case_length/2 - 5, case_width - 5, -1])
        cube([10, 6, wall_thickness+2]);

    // Strain relief groove (around cable slot)
    translate([case_length/2 - 7, case_width - 7, wall_thickness - 0.5])
        cube([14, 8, 1.5]);

    // M3 threaded insert holes (for heat-set inserts)
    boss_positions = [
        [5, 5],
        [case_length - 5, 5],
        [5, case_width - 5],
        [case_length - 5, case_width - 5]
    ];

    for (pos = boss_positions) {
        translate([pos[0], pos[1], wall_thickness - 1])
            cylinder(h=boss_height + 2, d=mounting_hole_diameter, $fn=20);
    }

    // Ventilation holes (4 holes for airflow)
    vent_positions = [
        [case_length/4, case_width/3],
        [3*case_length/4, case_width/3],
        [case_length/4, 2*case_width/3],
        [3*case_length/4, 2*case_width/3]
    ];

    for (pos = vent_positions) {
        translate([pos[0], pos[1], -1])
            cylinder(h=wall_thickness+2, d=3, $fn=20);
    }
}

// Add text label (optional - camera number)
translate([case_length/2, case_width - 10, 0.5])
    linear_extrude(height=0.5)
    text("#1", size=5, font="Arial:style=Bold", halign="center");

// Note: Change "#1" to "#2", "#3", "#4" for different cameras
// This helps identify which camera during assembly/maintenance
