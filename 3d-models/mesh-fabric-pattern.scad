// Mesh Fabric Embedded Pattern
// 250mm x 250mm design for 3-layer print with mesh insert
// Layer 1: 0.2mm base, then mesh, then Layers 2-3: 0.4mm top

// ===== PARAMETERS =====
design_size = 250;          // Overall size (mm)
layer_height = 0.2;         // Single layer height (mm)
base_thickness = layer_height;  // First layer before mesh
top_thickness = layer_height * 2;  // Two layers after mesh
total_thickness = base_thickness + top_thickness;

// Pattern parameters
num_rings = 8;              // Number of concentric rings
ring_width = 2;             // Width of ring lines
num_spokes = 24;            // Radial spokes
spoke_width = 1.5;          // Width of spokes
star_points = 8;            // Points in center star
hex_grid_size = 15;         // Size of hexagonal cells in corners

// ===== MODULES =====

// Create a ring at given radius
module ring(radius, width) {
    difference() {
        circle(r = radius + width/2, $fn=120);
        circle(r = radius - width/2, $fn=120);
    }
}

// Create radial spokes
module spokes(count, length, width) {
    for (i = [0:count-1]) {
        rotate([0, 0, i * 360/count])
            translate([0, -width/2, 0])
                square([length, width]);
    }
}

// Create center star
module center_star(points, outer_r, inner_r) {
    for (i = [0:points-1]) {
        rotate([0, 0, i * 360/points])
            polygon([
                [0, 0],
                [outer_r * cos(0), outer_r * sin(0)],
                [inner_r * cos(360/points/2), inner_r * sin(360/points/2)],
                [outer_r * cos(360/points), outer_r * sin(360/points)]
            ]);
    }
}

// Create hexagon
module hexagon(size) {
    circle(r = size, $fn=6);
}

// Create hexagonal grid in corner
module hex_grid_corner(size, cell_size) {
    spacing = cell_size * 1.732;  // sqrt(3) for hex spacing
    cols = ceil(size / spacing);
    rows = ceil(size / (cell_size * 1.5));

    for (row = [0:rows]) {
        for (col = [0:cols]) {
            x = col * spacing + (row % 2) * spacing/2;
            y = row * cell_size * 1.5;

            // Only draw hexes in corner triangle
            if (x + y < size * 0.9) {
                translate([x, y, 0])
                    difference() {
                        hexagon(cell_size);
                        hexagon(cell_size - 1);
                    }
            }
        }
    }
}

// Create wave pattern along edge
module wave_border(length, amplitude, frequency, width) {
    for (i = [0:360*frequency]) {
        x = (i / (360*frequency)) * length;
        y = amplitude * sin(i);
        translate([x, y, 0])
            circle(r = width/2, $fn=20);
    }
}

// ===== MAIN DESIGN =====
linear_extrude(height = total_thickness)
difference() {
    // Base plate
    square([design_size, design_size], center=true);

    // Remove interior, leave border frame
    offset(r = -5)
        square([design_size - 10, design_size - 10], center=true);
}

// Center focal point
linear_extrude(height = total_thickness)
translate([0, 0, 0]) {
    // Concentric rings
    for (i = [1:num_rings]) {
        radius = (design_size / 2 - 30) * (i / num_rings);
        ring(radius, ring_width);
    }

    // Radial spokes
    spokes(num_spokes, design_size/2 - 15, spoke_width);

    // Center star
    center_star(star_points, 25, 15);

    // Small circle at dead center
    circle(r = 5, $fn=60);
}

// Corner decorations - hexagonal grids
linear_extrude(height = total_thickness) {
    // Bottom-left corner
    translate([-design_size/2 + 5, -design_size/2 + 5, 0])
        hex_grid_corner(40, hex_grid_size);

    // Bottom-right corner
    translate([design_size/2 - 5, -design_size/2 + 5, 0])
        mirror([1, 0, 0])
            hex_grid_corner(40, hex_grid_size);

    // Top-left corner
    translate([-design_size/2 + 5, design_size/2 - 5, 0])
        mirror([0, 1, 0])
            hex_grid_corner(40, hex_grid_size);

    // Top-right corner
    translate([design_size/2 - 5, design_size/2 - 5, 0])
        rotate([0, 0, 180])
            hex_grid_corner(40, hex_grid_size);
}

// Connecting arcs between corners and center
linear_extrude(height = total_thickness)
for (angle = [0:90:270]) {
    rotate([0, 0, angle])
        translate([design_size/4, 0, 0])
            rotate([0, 0, 30])
                for (i = [0:2]) {
                    rotate([0, 0, i * 15])
                        translate([0, -0.75, 0])
                            square([design_size/5, 1.5]);
                }
}

// Decorative circles at cardinal points
linear_extrude(height = total_thickness)
for (angle = [0, 90, 180, 270]) {
    rotate([0, 0, angle])
        translate([design_size/2 - 20, 0, 0]) {
            difference() {
                circle(r = 8, $fn=60);
                circle(r = 6, $fn=60);
            }
            // Small triangles pointing outward
            for (a = [0:120:240]) {
                rotate([0, 0, a])
                    translate([8, 0, 0])
                        polygon([[-2, -1.5], [2, -1.5], [0, 2]]);
            }
        }
}

// Add some smaller orbital circles
linear_extrude(height = total_thickness)
for (ring = [0.4, 0.6, 0.8]) {
    for (i = [0:12]) {
        angle = i * (360/12) + ring * 30;  // Offset each ring
        radius = (design_size/2 - 30) * ring;
        rotate([0, 0, angle])
            translate([radius, 0, 0])
                circle(r = 2, $fn=30);
    }
}
