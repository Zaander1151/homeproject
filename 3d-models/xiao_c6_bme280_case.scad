/*
    Project: Seeed XIAO ESP32-C6 + BME280 Enclosure (Screw-Top Version)
    Author: Gemini (via User Request)
    Date: 2025-12-20
    
    Description:
    A compact case with a "false floor" to accommodate header pins and jumper wires.
    The XIAO and BME280 sit side-by-side.
    Now features M3 screw posts for a secure lid and countersunk holes.
    
    Hardware:
    - Seeed XIAO ESP32-C6 (21 x 17.8mm)
    - Tstar BME280 (15 x 11.52mm)
    - 4x M3x8mm (or M2.5) countersunk screws for the lid
*/

// --- Global Parameters ---
$fn = 50; 

// Tolerances
tolerance = 0.2; 
wall_thickness = 1.6;

// Screw settings
screw_post_diam = 6.0;   // Outer diameter of corner posts
screw_hole_diam = 3.4;   // Clearance hole in lid (loose fit for M3)
screw_thread_diam = 2.8; // Hole in base (tight for self-tapping M3)
screw_head_diam = 6.2;   // Diameter of the countersink head
countersink_depth = 1.4; // Depth of the countersink (lid is 2mm total)

// Internal Clearance
wire_clearance_height = 14; 

// --- Component Dimensions ---
xiao_len = 22.5; 
xiao_wid = 17.8;
xiao_pcb_thick = 1.6;
usb_c_width = 9.2;
usb_c_height = 3.4;

bme_len = 15;
bme_wid = 11.52;
bme_hole_diam = 3.0; 
bme_hole_dist = 10;

// --- Calculated Case Dimensions ---
padding_x = screw_post_diam + 2; 
padding_y = 2;

internal_len = xiao_len + bme_len + 15 + padding_x; 
internal_wid = xiao_wid + 6; 

case_len = internal_len; 
case_wid = internal_wid;
case_height = wire_clearance_height + 8; 

module case_body() {
    difference() {
        // 1. Solid Block (Outer Shell)
        cube([case_len + 2*wall_thickness, case_wid + 2*wall_thickness, case_height]);
        
        // 2. Main Cavity
        translate([wall_thickness, wall_thickness, wall_thickness])
            cube([case_len, case_wid, case_height + 1]);
            
        // 3. USB Cutout
        translate([-1, wall_thickness + (case_wid/2) - (usb_c_width/2), wire_clearance_height + wall_thickness + 0.5])
            cube([5, usb_c_width, usb_c_height]);
            
        // 4. Ventilation Slots (Side/Back)
        for(i=[0:3]) {
            translate([case_len - 10 + (i*3), -1, wire_clearance_height])
                cube([1.5, case_wid + 20, case_height/2]);
        }
    }
    
    // 5. Add Corner Posts
    post_xy = [
        [wall_thickness + screw_post_diam/2, wall_thickness + screw_post_diam/2], 
        [case_len + wall_thickness - screw_post_diam/2, wall_thickness + screw_post_diam/2],
        [wall_thickness + screw_post_diam/2, case_wid + wall_thickness - screw_post_diam/2],
        [case_len + wall_thickness - screw_post_diam/2, case_wid + wall_thickness - screw_post_diam/2]
    ];
    
    for(pos = post_xy) {
        translate([pos[0], pos[1], wall_thickness])
            difference() {
                cylinder(h=case_height-wall_thickness, d=screw_post_diam);
                cylinder(h=case_height, d=screw_thread_diam); 
            }
    }
}

module internals() {
    // 1. XIAO Mounting Rails
    xiao_x_start = wall_thickness + (screw_post_diam/2) + 2; 
    
    translate([xiao_x_start, wall_thickness + (case_wid-xiao_wid)/2, wall_thickness]) {
        // Left Rail
        translate([0, 0, wire_clearance_height])
            cube([xiao_len, 1.5, xiao_pcb_thick + 2]);
        // Right Rail
        translate([0, xiao_wid - 1.5, wire_clearance_height])
            cube([xiao_len, 1.5, xiao_pcb_thick + 2]);
        // Back Stop
        translate([xiao_len, 0, wire_clearance_height])
            cube([2, xiao_wid, xiao_pcb_thick + 2]);
    }
    
    // 2. BME280 Standoffs
    sensor_x_offset = xiao_x_start + xiao_len + 8;
    sensor_y_offset = wall_thickness + (case_wid - bme_wid)/2;
    
    translate([sensor_x_offset, sensor_y_offset, wall_thickness]) {
        // Post 1
        translate([2.5, bme_wid/2, 0])
            difference() {
                cylinder(h=wire_clearance_height, d=5);
                cylinder(h=wire_clearance_height+1, d=bme_hole_diam - 0.5);
            }
        // Post 2
        translate([2.5 + bme_hole_dist, bme_wid/2, 0])
            difference() {
                cylinder(h=wire_clearance_height, d=5);
                cylinder(h=wire_clearance_height+1, d=bme_hole_diam - 0.5);
            }
    }
}

module lid() {
    translate([0, case_wid + 15, 0]) { // Move lid to side
        difference() {
            // Main Lid Plate
            cube([case_len + 2*wall_thickness, case_wid + 2*wall_thickness, 2]);
            
            // Screw Holes with Countersinks
            post_xy = [
                [wall_thickness + screw_post_diam/2, wall_thickness + screw_post_diam/2],
                [case_len + wall_thickness - screw_post_diam/2, wall_thickness + screw_post_diam/2],
                [wall_thickness + screw_post_diam/2, case_wid + wall_thickness - screw_post_diam/2],
                [case_len + wall_thickness - screw_post_diam/2, case_wid + wall_thickness - screw_post_diam/2]
            ];
            
            for(pos = post_xy) {
                // 1. The Main Through-Hole
                translate([pos[0], pos[1], -1])
                    cylinder(h=4, d=screw_hole_diam); 
                
                // 2. The Countersink (Cone at the top surface)
                translate([pos[0], pos[1], 2 - countersink_depth])
                    cylinder(h=countersink_depth + 0.1, d1=screw_hole_diam, d2=screw_head_diam);
            }
            
            // Ventilation Grille over Sensor Area
            grid_start_x = case_len - 15;
            for(i=[0:5]) {
                translate([grid_start_x + (i*2.5), (case_wid/2) - 4 + wall_thickness, -1])
                    cube([1.5, 8, 4]);
            }
        }
    }
}

// --- Render Assembly ---

union() {
    case_body();
    internals();
}

lid();