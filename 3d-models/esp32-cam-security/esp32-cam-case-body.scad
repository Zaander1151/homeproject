// ESP32-CAM Security Camera Case - Main Body
// For Creality Ender-3 V3
// Material: Hyper-PAL (Grey) or Hyper-PETG

// ===== PARAMETERS =====
// Main case dimensions
case_length = 50;
case_width = 35;
case_height = 30;
wall_thickness = 2;

// PCB dimensions
pcb_length = 39.8;
pcb_width = 27;
pcb_height = 4.5;
pcb_support_height = 2;

// Camera lens opening
lens_diameter = 12;
lens_bezel_width = 1;

// Ventilation
vent_slot_length = 10;
vent_slot_width = 2;
vent_hole_diameter = 3;

// USB cutout
usb_width = 10;
usb_height = 4;

// Snap-fit post
post_diameter = 2;
post_height = 16;

// ===== MAIN BODY =====
difference() {
    union() {
        // Outer shell
        cube([case_length, case_width, case_height]);

        // PCB support ribs
        translate([
            (case_length - pcb_length)/2,
            (case_width - pcb_width)/2,
            wall_thickness
        ])
        cube([pcb_length, 1, pcb_support_height]);

        translate([
            (case_length - pcb_length)/2,
            (case_width - pcb_width)/2 + pcb_width - 1,
            wall_thickness
        ])
        cube([pcb_length, 1, pcb_support_height]);

        // Snap-fit posts (4 corners)
        post_positions = [
            [(case_length - pcb_length)/2 + 3, (case_width - pcb_width)/2 + 3],
            [(case_length + pcb_length)/2 - 3, (case_width - pcb_width)/2 + 3],
            [(case_length - pcb_length)/2 + 3, (case_width + pcb_width)/2 - 3],
            [(case_length + pcb_length)/2 - 3, (case_width + pcb_width)/2 - 3]
        ];

        for (pos = post_positions) {
            translate([pos[0], pos[1], wall_thickness])
                cylinder(h=post_height, d=post_diameter, $fn=20);
        }

        // Rear clip holders (for cover attachment)
        // Left clip holder
        translate([wall_thickness, case_width/2 - 5, case_height - 5])
            cube([3, 10, 5]);

        // Right clip holder
        translate([case_length - wall_thickness - 3, case_width/2 - 5, case_height - 5])
            cube([3, 10, 5]);
    }

    // Hollow interior
    translate([wall_thickness, wall_thickness, wall_thickness])
        cube([
            case_length - 2*wall_thickness,
            case_width - 2*wall_thickness,
            case_height
        ]);

    // Camera lens opening (front)
    translate([case_length/2, case_width/2, -1])
        cylinder(h=wall_thickness+2, d=lens_diameter, $fn=50);

    // Lens bezel (recessed ring around lens)
    translate([case_length/2, case_width/2, wall_thickness - 0.5])
        cylinder(h=1.5, d=lens_diameter + 2*lens_bezel_width, $fn=50);

    // USB cutout (back, centered vertically)
    translate([case_length/2 - usb_width/2, case_width - wall_thickness - 1, case_height/3])
        cube([usb_width, wall_thickness+2, usb_height]);

    // Cable strain relief channel (below USB)
    translate([case_length/2 - 3, case_width - wall_thickness - 1, case_height/3 - 3])
        cube([6, wall_thickness+2, 3]);

    // Side ventilation slots (8 per side)
    for (i = [0:7]) {
        // Left side
        translate([
            wall_thickness + 5 + i*5,
            -1,
            case_height/2 - vent_slot_length/2
        ])
        cube([vent_slot_width, wall_thickness+2, vent_slot_length]);

        // Right side
        translate([
            wall_thickness + 5 + i*5,
            case_width - wall_thickness - 1,
            case_height/2 - vent_slot_length/2
        ])
        cube([vent_slot_width, wall_thickness+2, vent_slot_length]);
    }

    // Top ventilation holes (4 holes)
    for (i = [0:3]) {
        translate([
            case_length/2 + (i-1.5)*8,
            case_width/2,
            case_height - wall_thickness - 1
        ])
        cylinder(h=wall_thickness+2, d=vent_hole_diameter, $fn=20);
    }

    // GPIO access slot (bottom, optional)
    translate([case_length/2 - 10, wall_thickness - 1, wall_thickness])
        cube([20, wall_thickness+2, 3]);
}

// Front lens bezel ring (protective ridge)
difference() {
    translate([case_length/2, case_width/2, 0])
        cylinder(h=wall_thickness, d=lens_diameter + 2*lens_bezel_width, $fn=50);

    translate([case_length/2, case_width/2, -1])
        cylinder(h=wall_thickness+2, d=lens_diameter, $fn=50);

    // Cut away back half so it doesn't interfere with case
    translate([-case_length/2, -1, -1])
        cube([case_length*2, case_width/2, wall_thickness+2]);
}

// Add text label on bottom (optional - comment out if not desired)
translate([case_length/2 - 10, 3, 0.5])
    linear_extrude(height=0.5)
    text("CAM", size=4, font="Arial:style=Bold", halign="center");
