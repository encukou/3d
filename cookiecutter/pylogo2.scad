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
    difference() {
        union() {
            for(r=[0,180]) {
                rotate([0,0,r]) translate([-18,23,0]) {
                    cube([35, 6, 1]);
                }
            }
            poly_eyes_outer(20);
        }
        translate([0,0,-1]) {
            poly_eyes_inner(22);
        }
    }
}
