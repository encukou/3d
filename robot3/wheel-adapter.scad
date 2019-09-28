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

TOL = 0.5;

SHAFT_R = 5/2;
SHAFT_W = 3.5;
SHAFT_LEN = 8;
SHAFT_SCREW_R = 2/2;
SHAFT_SCREW_B = 1;

MAIN_SCREW_R = 4/2;

difference () {
    union () {
        difference () {
            union () {
                cylinder (
                    BODY_SIZE,
                    r1=GROOVE_R_OUT-BODY_SIZE,    // maintain 45° overhang
                    r2=GROOVE_R_OUT-TOL,
                    $fn=50);
                translate ([0, 0, BODY_SIZE]) {
                    cylinder (GROOVE_DEPTH, r=GROOVE_R_OUT-TOL, $fn=50);
                }
            }
            translate ([0, 0, BODY_SIZE]) {
                cylinder (100, r=GROOVE_R_IN+TOL, $fn=50);
                translate ([0, 0, -RIM_DEPTH]) cylinder (100, r=RIM_R+TOL, $fn=50);
                translate ([0, -GROOVE_STUD_D/2, GROOVE_STUD_CLEARANCE]) {
                    cube ([100, GROOVE_STUD_D, 100]);
                }
            }
        }
        cylinder (WHEEL_THICK+BODY_SIZE, r=AXLE_R-TOL, $fn=50);
    }

    // Motor shaft
    cylinder (100, r=SHAFT_SCREW_R, $fn=50);
    translate ([0, 0, -1]) intersection () {
        cylinder (100, r=SHAFT_R+TOL, $fn=50);
        translate ([-(SHAFT_W+TOL*2)/2, -50, 0]) cube ([SHAFT_W+TOL*2, 100, SHAFT_LEN+1]);
    }

    // Screw
    translate ([0, 0, SHAFT_LEN+SHAFT_SCREW_B]) cylinder (100, r=MAIN_SCREW_R, $fn=50);
}
