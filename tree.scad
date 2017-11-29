module t(n) {
    if (n > 0) {
        translate([0,0,-4]) cylinder(13, 9, 9);
        translate([0,0,9]) {
            sphere(9);
            translate([0,0,2]) scale(0.51) {
                for (i = [0:3]) {
                    rotate([0,0,i*360/3]) translate([0,-8.8,0]) rotate([5, 0, 0]) t(n-1);
                }
            }
        }
    }
}

union() {
    translate([0, 0, -5])
    difference() {

        t(6); /* <- vetsi cislo pro vetsi detail! */

        translate([0,0,-10]) cylinder(15, 10, 10);
    }
    cylinder(2, 11.5, 11);
}
