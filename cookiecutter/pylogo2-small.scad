include <p-small.scad>;    // poly_path4442

scale([1, -1, 1]) union() {
    difference() {
        union() {
            poly_small_outside(20);
            scale([1.2, 1.2, 1]) hull() {
                poly_small_outside(1);
            }
        }
        translate([0.1,0.1,-1]) {
            poly_small_inside(40);
        }
    }
}
