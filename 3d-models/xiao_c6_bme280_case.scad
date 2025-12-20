/*
    Project: Seeed XIAO ESP32-C6 + BME280 Enclosure
    Author: Gemini (via User Request)
    Date: 2025-12-20
    
    Description:
    A compact case with a "false floor" to accommodate header pins and jumper wires.
    The XIAO and BME280 sit side-by-side to minimize thermal interference.
    
    Hardware:
    - Seeed XIAO ESP32-C6 (21 x 17.8mm)
    - Tstar BME280 (15 x 11.52mm)
*/

// --- Global Parameters ---
$fn = 50; // Resolution for circles

// Tolerances (Adjust for your printer)
tolerance = 0.2; 
wall_thickness = 1.6;

// Internal Clearance for Wires (The "Basement")
wire_clearance_height = 14; 

// --- XIAO Dimensions ---
xiao_len = 22.5; // Slight extra for USB protrusion
xiao_wid = 17.8;
xiao_pcb_thick = 1.6;
usb_c_width = 9.2;
usb_c_height = 3.4;

// --- BME280 Dimensions (Tstar Type B) ---
bme_len = 15;
bme_wid = 11.52;
bme_hole_diam = 3.0; 
bme_hole_dist = 10; // DISTANCE BETWEEN HOLES (Adjust this if needed!)

// Total Case Layout
case_len = xiao_len + bme_len + 10; // Extra room for spacing
case_wid = xiao_wid + 4;
case_height = wire_clearance_height + 8; // Wire space + component headroom

// --- Modules ---

module case_body() {
    difference() {
        // Outer Shell
        cube([case_len + 2*wall_thickness, case_wid + 2*wall_thickness, case_height]);
        
        // Inner Cavity
        translate([wall_thickness, wall_thickness, wall_thickness])
            cube([case_len, case_wid, case_height + 1]);
        
        // USB Cutout (Front)
        translate([-1, (case_wid/2) + wall_thickness - (usb_c_width/2), wire_clearance_height + wall_thickness + 0.5])
            cube([5, usb_c_width, usb_c_height]);
            
        // Ventilation Slots (Back/Side near Sensor)
        for(i=[0:3]) {
            translate([case_len - 5 - (i*3), -1, wire_clearance_height])
                cube([1.5, case_wid + 10, case_height/2]);
        }
    }
}

module internals() {
    // 1. XIAO Mounting Rails
    // These hold the PCB by the edge (1mm bite)
    translate([wall_thickness, wall_thickness + (case_wid-xiao_wid)/2, wall_thickness]) {
        
        // Left Rail
        translate([0, 0, wire_clearance_height])
            cube([xiao_len, 1.5, xiao_pcb_thick + 2]);
            
        // Right Rail
        translate([0, xiao_wid - 1.5, wire_clearance_height])
            cube([xiao_len, 1.5, xiao_pcb_thick + 2]);
            
        // Back Stop (Prevents pushing board in too far)
        translate([xiao_len, 0, wire_clearance_height])
            cube([2, xiao_wid, xiao_pcb_thick + 2]);
    }
    
    // 2. BME280 Standoffs
    // Located behind the XIAO
    sensor_x_offset = wall_thickness + xiao_len + 5;
    sensor_y_offset = wall_thickness + (case_wid - bme_wid)/2;
    
    translate([sensor_x_offset, sensor_y_offset, wall_thickness]) {
        // Post 1
        translate([2.5, bme_wid/2, 0])
            cylinder(h=wire_clearance_height, d=5);
            
        // Post 2 (Adjust distance based on bme_hole_dist)
        translate([2.5 + bme_hole_dist, bme_wid/2, 0])
            cylinder(h=wire_clearance_height, d=5);
    }
}

module screw_holes() {
    // Cuts the actual screw holes into the standoffs
    sensor_x_offset = wall_thickness + xiao_len + 5;
    sensor_y_offset = wall_thickness + (case_wid - bme_wid)/2;
    
    translate([sensor_x_offset, sensor_y_offset, wall_thickness]) {
        // Hole 1
        translate([2.5, bme_wid/2, 0])
            cylinder(h=wire_clearance_height+1, d=bme_hole_diam - 0.5); // Slightly smaller for self-tapping
            
        // Hole 2
        translate([2.5 + bme_hole_dist, bme_wid/2, 0])
            cylinder(h=wire_clearance_height+1, d=bme_hole_diam - 0.5);
    }
}

module lid() {
    lid_clearance = 0.1; // Make it slightly smaller to fit
    
    translate([0, case_wid + 10, 0]) { // Move lid to side for printing
        difference() {
            // Main Lid Plate
            cube([case_len + 2*wall_thickness, case_wid + 2*wall_thickness, 2]);
            
            // Ventilation Grid over Sensor
            for(i=[0:5]) {
                translate([case_len - 10 + (i*2), 5, -1])
                    cube([1, case_wid - 6, 4]);
            }
        }
        
        // Inner Lip (Snap fit)
        translate([wall_thickness + lid_clearance, wall_thickness + lid_clearance, 2])
            difference() {
                cube([case_len - 2*lid_clearance, case_wid - 2*lid_clearance, 2]);
                translate([2, 2, -1])
                    cube([case_len - 4, case_wid - 4, 4]);
            }
    }
}

// --- Render Assembly ---

// 1. The Main Box
difference() {
    union() {
        case_body();
        internals();
    }
    screw_holes();
}

// 2. The Lid (Printed to the side)
lid();

