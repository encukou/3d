include <p-all.scad>;    // poly_path4442

scale([1, -1, 1]) union() {
    difference() {
        union() {
            poly_py_outer(20);
            scale([1.2, 1.2, 1]) hull() {
                poly_py_outer(1);
            }
        }
        translate([0.1,0.1,-1]) {
            poly_py_inner(40);
        }
    }
}
