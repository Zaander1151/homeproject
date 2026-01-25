// Cable Management Box
// Dimensions: 300mm L × 100mm D × 80mm H
// Hollow channel for power cables with sturdy top for power bar mounting

// Parameters
box_length = 300;
box_depth = 100;
box_height = 80;
wall_thickness = 3;  // Sturdy walls
top_thickness = 5;   // Extra thick top for screw mounting

// Cable channel dimensions
channel_width = 60;   // Wide channel for cables
channel_height = 60;  // Height of hollow space

// Cable entry/exit openings
cable_opening_width = 40;
cable_opening_height = 20;

// Main module
module cable_box() {
    difference() {
        // Outer shell
        cube([box_length, box_depth, box_height]);

        // Hollow out the interior (cable channel)
        translate([wall_thickness, wall_thickness, wall_thickness]) {
            cube([
                box_length - (2 * wall_thickness),
                box_depth - (2 * wall_thickness),
                channel_height
            ]);
        }

        // Cable entry opening (left end)
        translate([0, (box_depth - cable_opening_width) / 2, wall_thickness]) {
            cube([wall_thickness + 0.1, cable_opening_width, cable_opening_height]);
        }

        // Cable exit opening (right end)
        translate([box_length - wall_thickness - 0.1, (box_depth - cable_opening_width) / 2, wall_thickness]) {
            cube([wall_thickness + 0.1, cable_opening_width, cable_opening_height]);
        }
    }
}

// Render the box
cable_box();

// Print information
echo("Cable Management Box Specifications:");
echo(str("Outer dimensions: ", box_length, "mm × ", box_depth, "mm × ", box_height, "mm"));
echo(str("Wall thickness: ", wall_thickness, "mm"));
echo(str("Top thickness: ", top_thickness, "mm (extra sturdy for mounting)"));
echo(str("Interior channel: ", box_length - 2*wall_thickness, "mm × ", box_depth - 2*wall_thickness, "mm × ", channel_height, "mm"));
echo(str("Cable openings: ", cable_opening_width, "mm × ", cable_opening_height, "mm (both ends)"));
echo("");
echo("Print settings recommendation:");
echo("- Material: PETG for strength, PLA for easier printing");
echo("- Infill: 20-30% (higher for extra strength under screw mounting points)");
echo("- Perimeters: 3-4 walls for rigidity");
echo("- Top/bottom layers: 5+ for sturdy screw mounting surface");
