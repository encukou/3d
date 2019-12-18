BODY_SIZE = 5;

GROOVE_R_OUT = 26/2;
GROOVE_R_IN = 19/2;
GROOVE_STUD_D = 3;
GROOVE_STUD_CLEARANCE = 2;
GROOVE_DEPTH = 5;
AXLE_R = 8/2;
RIM_R = 11/2;
RIM_DEPTH = 2;
WHEEL_THICK = 17;

EPS = 0.001;
TOL = 0.5;

SHAFT_R = 5.5/2;
SHAFT_W = 3.5;
SHAFT_LEN = 9;
SHAFT_BASE = 1;
SHAFT_SCREW_R = 2/2;
SHAFT_SCREW_B = 1;

MAIN_SCREW_R = 4/2;

THRU_SCREW_SIZE = 20;
THRU_SCREW_PEN = 3;

CAP_SIZE = THRU_SCREW_SIZE+SHAFT_LEN-THRU_SCREW_PEN-BODY_SIZE-WHEEL_THICK;
CAP_PROT = 10;

module base () {
    difference () {
        union () {
            difference () {
                union () {
                    // tapered bottom part
                    cylinder (
                        BODY_SIZE,
                        r1=GROOVE_R_OUT-BODY_SIZE*2/3,    // maintain 45° overhang
                        r2=GROOVE_R_OUT-TOL,
                        $fn=100);
                    // upper outer rim
                    translate ([0, 0, BODY_SIZE]) {
                        cylinder (GROOVE_DEPTH, r=GROOVE_R_OUT-TOL, $fn=100);
                    }
                }
                translate ([0, 0, BODY_SIZE]) {
                    // main cutout (inside outer rim)
                    cylinder (100, r=GROOVE_R_IN+TOL, $fn=100);
                    // further cutout
                    translate ([0, 0, -RIM_DEPTH]) cylinder (100, r=RIM_R+TOL, $fn=100);
                    // stud hole
                    translate ([0, -GROOVE_STUD_D/2, GROOVE_STUD_CLEARANCE]) {
                        cube ([100, GROOVE_STUD_D, 100]);
                    }
                }
            }
            // center column
            cylinder (WHEEL_THICK+BODY_SIZE-CAP_PROT, r=AXLE_R-TOL/2, $fn=100);
        }

        // All-the-way-through screw hole
        cylinder (100, r=SHAFT_SCREW_R+TOL/2, $fn=50);
        // Motor shaft
        translate ([0, 0, -1]) intersection () {
            union () {
                // cylinder
                cylinder (SHAFT_LEN+TOL+EPS, r=SHAFT_R+TOL/2, $fn=50);
                // taper to prevent overhangs
                translate ([0, 0, SHAFT_LEN+TOL]) cylinder (SHAFT_R, r1=SHAFT_R+TOL, r2=0, $fn=50);
            }
            // cross-cube
            translate ([-(SHAFT_W+TOL)/2, -50, 0]) cube ([SHAFT_W+TOL, 100, 100]);
        }
        translate ([0, 0, -EPS]) cylinder(SHAFT_BASE+TOL, r=SHAFT_R+TOL/2, $fn=100);
    }
}

module cap () {
    union () {
        difference () {
            cylinder (CAP_SIZE+EPS, r1=GROOVE_R_OUT-TOL-CAP_SIZE*2/3, r2=GROOVE_R_OUT-TOL, $fn=100);
            translate ([0, 0, -50]) cylinder (100, r=2.8, $fn=50);
            translate ([0, 0, CAP_SIZE-RIM_DEPTH]) cylinder (100, r=RIM_R+TOL, $fn=100);
        }
        difference () {
            cylinder (CAP_SIZE+CAP_PROT, r=AXLE_R-TOL, $fn=100);
            translate ([0, 0, -50]) cylinder (50+(WHEEL_THICK+BODY_SIZE+CAP_SIZE)-18, r=2.7, $fn=100);
            translate ([0, 0, -50]) cylinder (500, r=1.5, $fn=100);
        }
        translate ([0, 0, CAP_SIZE]) difference () {
            cylinder (GROOVE_DEPTH, r=GROOVE_R_OUT-TOL, $fn=100);
            translate ([0, 0, -50]) cylinder (100, r=GROOVE_R_IN+TOL, $fn=100);
            translate ([0, 0, GROOVE_STUD_CLEARANCE]) cube ([100, GROOVE_STUD_D, 100]);
        }
    }
}

base();
translate ([GROOVE_R_OUT*2, 0, 0]) cap();


%translate ([0, 0, WHEEL_THICK+BODY_SIZE+CAP_SIZE]) scale ([1, 1, -1]) {
    cap();
}

%translate ([0, 0, SHAFT_LEN-THRU_SCREW_PEN]) color ([0, 0, 0]) {
    cylinder (THRU_SCREW_SIZE, r=SHAFT_SCREW_R, $fn=50);
}
