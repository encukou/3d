W = 140;
L = 150;
H = 86;

module screwhole () {
    translate ([0, 0, -10]) cylinder (50, r=2);
    translate ([0, 0, 7.01]) cylinder (3, r1=2, r2=5);
    translate ([0, 0, 9.99]) cylinder (30, r=5);
}

module leg() {
    translate([-6, 0, 0]) union () {
        difference () {
            union () {
                translate ([-10, -10, 0])  cube ([117, 20, 90]);
                translate ([-10, -30, 0])  cube ([25, 60, 10]);
                hull () {
                    translate([-10, -30, 0]) cube ([3, 60, 10]);
                    translate([-10, -10, 0]) cube ([3, 20, 30]);
                }
            }
            translate ([0, 0, -10]) union () {
                translate ([3, 19, 10]) screwhole ();
                translate ([3, -19, 10]) screwhole ();
            }
            translate ([-1, 0, H-50]) union () {
                cylinder (500, r=7/2);
                translate([0, -7/2, 0]) cube ([7/2, 7, 500]);
            }
            translate ([-10, 0, H-20]) union () {
                translate ([-1, -5, 0]) cube ([10+1, 10, 5]);
                translate ([10, 0, 0]) rotate ([0, 0, 90]) cylinder(r=4.9, h=5, $fn=6);
            }

            // Uncomment for output cables cutout:
            //scale ([1, -1, 1]) translate ([5, 0, 70]) rotate ([0, -90, atan(L/W)])
            //    translate([0, -12-5, 0]) cylinder (r=12, 500);

            // Uncomment for power socket cutout:
            translate ([4.6, 0, 29])
                rotate ([-45, 0, -atan(L/W)])
                translate ([-20, 0, 0])
                cube ([40, 22, 22]);
        }
    }
}

module holder () {
    difference () {
        union () {
            translate ([0, 0, 0]) rotate ([0, 0, atan(L/W)]) leg ();
            translate ([W, 0, 0]) rotate ([0, 0, 180-atan(L/W)]) leg ();
            translate ([0, L, 0]) rotate ([0, 0, -atan(L/W)]) leg ();
            translate ([W, L, 0]) rotate ([0, 0, 180+atan(L/W)]) leg ();
        }
        translate ([-1, -1, -1]) cube ([W+2, L+2, H+1]);
    }
}

module part1 () {
    rotate ([180, 0, 0]) intersection () {
        holder ();
        translate ([-200, -500, 80]) cube([1000, 1000, 1000]);
    }
}

module part2 () {
    rotate ([0, 0, -atan(L/W)]) intersection () {
        holder ();
        translate ([-500, -500, 0]) cube([500+W/2, 500+H/2, 80]);
    }
}

/** The entire thing **/

holder ();

/** The top part only **/

//translate ([-W/2, L/2, 0]) translate ([0, 0, H+5]) part1();

/** Single legs **/

//rotate ([0, -90, 0]) part2 ();

/** 4 legs **/

for (x=[40, -40]) {
    for (n=[1, -1]) {
        //translate ([x, -10*n, 16]) rotate ([90, -90, 180*(n-1)/2]) part2 ();
    }
}

