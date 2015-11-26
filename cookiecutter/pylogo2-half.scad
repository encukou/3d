include <p-half.scad>;    // poly_path4442

scale([1, -1, 1]) union() {
    difference() {
        union() {
            poly_half_outer(20);
            scale([1.2, 1.2, 1]) hull() {
                poly_half_outer(1);
            }
        }
        translate([0.1,0.1,-10]) {
            poly_half_inner(40);
        }
    }
    difference() {
        union() {
            translate([-4,8,0]) {
                cube([7, 18, 1]);
            }
            poly_half_eye_outer(20);
        }
        translate([0,0,-1]) {
            poly_half_eye_inner(22);
        }
    }
}
