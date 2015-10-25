handle_r = 25;
handle_base_h = 3;

dome_r = 50;

shaft_r = 8;
shaft_sides = 6;
shaft_h = 40;

centerhole_r = 4;

screw_h = 32;
screw_r = 4.6 / 2;

nut_r = 8/2;
nut_h = 5;

if(shaft_h <= screw_h + handle_base_h + 2) {
    error("Screw won't fit");
}

//

dome_center_depth = sqrt(dome_r * dome_r - handle_r * handle_r);

nut_pos = screw_h * 2 / 3 + handle_base_h;

module handle() {
    union() {
        intersection() {
            cylinder(dome_r, r=handle_r, $fn=200);
            translate([0,0,-dome_center_depth + handle_base_h])
                sphere(dome_r, $fn=100);
        }

        rotate([0,0,360/6/2])
            linear_extrude(height=shaft_h)
            circle(shaft_r, $fn=shaft_sides);
    }
}

module _nut() {
    linear_extrude(height=nut_h)
        circle(nut_r, $fn=6);
}

module hole() {
    union() {
        translate([0, 0, handle_base_h - 1])
            cylinder(shaft_h, r=screw_r, $fn=20);

        hull() {
            translate([0, 0, nut_pos]) _nut();
            translate([handle_r, 0, nut_pos]) _nut();
        }
    }
}

difference() {
    handle();
    hole();
}