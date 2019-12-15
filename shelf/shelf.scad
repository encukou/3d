// Measured
BODY_W = 88;
BODY_L = 115;
RIM_W = 5;
RIM_L = 8;
RIM_H = 6;
PLASTIC_T = 1;
BACK_W = 11;
BACK_SEP = 39;
BACK_H = 3;
OVERALL_H = 15; // from screw
SCREW_R = 4/2;
SCREW_R_HEAD = 8/2;

// Calc
BASE_H = OVERALL_H - RIM_H;

// Mine
BASE_W = 11;
BASE_L = 8;
SCREW_POS = 10;


// Misc
EPS = 0.001;
TOL = 0.5;

module box (sizes, centering=[1, 1, 1], extra_negative=[0, 0, 0]) {
    translate ([
        -sizes[0]*centering[0]/2-extra_negative[0],
        -sizes[1]*centering[1]/2-extra_negative[1],
        -sizes[2]*centering[2]/2-extra_negative[2],
    ]) {
        cube ([
            sizes[0]+extra_negative[0],
            sizes[1]+extra_negative[1],
            sizes[2]+extra_negative[2],
        ]);
    }
}

union () {
    R=RIM_W/2-PLASTIC_T;
    difference () {
        box ([BODY_W+RIM_W*2+BASE_W*2, BODY_L, RIM_H+R], [1, 0, 0], [0, RIM_L+BASE_L, BASE_H]);
        box ([BODY_W, BODY_L+EPS, 1000], [1, 0, 1]);
        box ([BODY_W+RIM_W*2, BODY_L+EPS, 1000], [1, 0, 0], [0, RIM_L, 0]);
        for (x=[-1,1]) {
            // gaps in the back
            translate ([x*(BACK_SEP/2+BACK_W/2), 0, 0]) box ([BACK_W+TOL, 1000, 1000], [1, 0, 0], [0, RIM_L, BACK_H]);
            // screw holes
            for (y=[SCREW_POS, BODY_L-SCREW_POS]) {
                translate ([x*(BODY_W/2+RIM_W/2+BASE_W/2), y, -BASE_H-EPS]) {
                    cylinder (1000, r=SCREW_R, $fn=20);
                    cylinder (SCREW_R_HEAD-SCREW_R+EPS, r1=SCREW_R_HEAD, r2=SCREW_R, $fn=20);
                }
            }
        }
    }
    for (x=[-1,1]) {
        B = R+PLASTIC_T;
        hull () {
            translate ([x*(BODY_W/2+RIM_W/2), -B, 0]) rotate ([-90, 0, 0]) {
                cylinder (BODY_L, r=R, $fn=20);
            }
            translate ([x*(BODY_W/2+RIM_W/2), 0, 0]) box ([R, BODY_L, 0], [1, 0, 0], [0, RIM_L/2+B, EPS]);
        }
    }
    hull () {
        translate ([-BODY_W/2, -R-PLASTIC_T, -BACK_H]) rotate ([0, 90, 0]) cylinder (BODY_W, r=R, $fn=20);
        translate ([0, -R-PLASTIC_T, -BACK_H]) box ([BODY_W, (R)*2, 0], [1, 1, 0], [0, PLASTIC_T, EPS]);
    }
}

