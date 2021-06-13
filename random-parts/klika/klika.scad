
// Measured:

MAIN_LENGTH = 105;
MAIN_WIDTH = 23;
MAIN_HEIGHT = 12;

SHAFT_R = 18/2;
SHAFT_LEN_FROM_LIP = 63;
SHAFT_LIP = 5;

BASE_R = 24/2;
BASE_LENGTH = 8;

AUX_R = 5;

CORE_A = 8;
CORE_B = 9;
CORE_LEN = 25;
CORE_SCREW_POS = 13;
CORE_SCREW_DEPTH = 2.5;
BRIDGE_SAG = 0.5;

// M2x10 screws and M2x14 screw:

SCREW_R_A = 2.8/2; // includes bit of tolerance
SCREW_R_B = 2.5/2; // includes bit of tolerance
SCREW_LEN_A = 12;
SCREW_LEN_B = 16;
SCREW_HEAD_R_A = 5.5/2; // includes bit of tolerance
SCREW_HEAD_R_B = 4.5/2; // includes bit of tolerance
NUT_R_A = 6.0/2; // includes bit of tolerance
NUT_R_B = 5.0/2; // includes bit of tolerance
NUT_WIDTH = 2;

// Mine

BASE_RING_WIDTH = 5;

// Helper dimensions:

INF = 300;
EPS = 0.001;
TOL = 0.1;

$fn=100;

// Calculated:

MAIN_R = MAIN_WIDTH/2;
MAIN_OFFSET = MAIN_R - SHAFT_R;
BASE_AUX_R = BASE_R - SHAFT_R;
SHAFT_LEN_TO_0 = SHAFT_LEN_FROM_LIP - MAIN_WIDTH/2;

module box (sizes, centering=[1, 1, 1], offset=[0, 0, 0]) {
    translate ([
        -sizes[0]*centering[0]/2+offset[0],
        -sizes[1]*centering[1]/2+offset[1],
        -sizes[2]*centering[2]/2+offset[2],
    ]) {
        cube ([
            sizes[0],
            sizes[1],
            sizes[2],
        ]);
    }
}

module cyl (length, r) {
    translate ([0, 0, -length/2]) cylinder (length, r=r);
}

module torus(outer_r, inner_r) {
  r = (outer_r - inner_r)/2;
  rotate_extrude() translate([inner_r + r, 0, 0]) circle(r);
}

module screw_hole (len_, screw_r, head_r, nut_r, nut_mult=2.4) {
    cyl (len_, screw_r);
    translate ([0, 0, len_/2 - NUT_WIDTH]) {
        cylinder (NUT_WIDTH*nut_mult, r=nut_r, $fn=6);
    }
    scale ([1, 1, -1]) translate ([0, 0, len_/2 - NUT_WIDTH]) {
        cylinder (INF, r=head_r);
    }
}

module door_handle (demo=0) difference () {
    union () {
        // Main body
        translate ([MAIN_OFFSET, 0, 0]) hull () {
            sphere (r=MAIN_R);
            translate ([MAIN_LENGTH - MAIN_WIDTH, 0, 0]) sphere (r=MAIN_R);
        }
        /* weird shaft
        for (sc=[1, -1]) scale ([sc, 1, 1]) {
            intersection () {
                translate ([MAIN_OFFSET, 0, 0]) {
                    rotate ([-90, 0, 0]) cylinder (SHAFT_LEN_TO_0, r=MAIN_R);
                }
                translate ([EPS, 0, 0]) box ([INF, INF, INF], [2, 1, 1]);
            }
        }
        */
        // Shaft
        rotate ([-90, 0, 0]) cylinder (SHAFT_LEN_TO_0+SHAFT_LIP, r=SHAFT_R);
        // Base
        translate ([0, SHAFT_LEN_TO_0, 0]) rotate ([90, 0, 0]) difference () {
            translate ([0, 0, BASE_RING_WIDTH]) {
                cylinder (BASE_LENGTH+BASE_AUX_R-BASE_RING_WIDTH, r=BASE_R);
            }
            translate ([0, 0, BASE_LENGTH+BASE_AUX_R]) rotate_extrude () {
                translate ([SHAFT_R+BASE_AUX_R, 0, 0]) circle (BASE_AUX_R);
            }
        }
        // Connect radius: Main body/shaft
        translate ([SHAFT_R+AUX_R, MAIN_WIDTH/2, 0]) {
            scale ([1, SHAFT_R/MAIN_R, 1]) translate ([0, AUX_R, 0]) {
                intersection () {
                    rotate_extrude () {
                        translate ([AUX_R+SHAFT_R, 0, 0]) circle(SHAFT_R);
                    }
                    box (
                        [SHAFT_R+AUX_R, MAIN_WIDTH/2+AUX_R, MAIN_WIDTH],
                        [2, 2, 1]
                    );
                }
            }
        }
    }
    // Top/bottom cut-out
    for (sc=[1, -1]) scale ([1, 1, sc]) {
        box (
            [MAIN_LENGTH*2, MAIN_WIDTH+AUX_R*2, MAIN_HEIGHT],
            [1, 1, 0], [0, 0, MAIN_HEIGHT/2]
        );
        translate ([0, MAIN_WIDTH/2+AUX_R, MAIN_HEIGHT/2+AUX_R]) {
            rotate ([0, 90, 0]) cyl (MAIN_LENGTH, AUX_R);
        }
    }
    // Shaft radius shave of main body
    difference () {
        box ([MAIN_LENGTH, MAIN_WIDTH+EPS, MAIN_LENGTH], [2, 1, 1]);
        rotate ([-90, 0, 0]) cyl (INF, SHAFT_R+EPS);
    }
    translate ([0, SHAFT_LEN_TO_0+SHAFT_LIP, 0]) {
        screw_pos = [CORE_A/2-CORE_SCREW_DEPTH+SCREW_R_B, -CORE_SCREW_POS, 0];
        difference () {
            // Core cutout
            union () {
                // Main core
                box ([CORE_A, CORE_LEN*2, CORE_A+BRIDGE_SAG*2]);
                // Core taper
                hull () {
                    translate ([0, CORE_SCREW_POS, 0]) {
                        box ([CORE_A, CORE_LEN*2, CORE_A+BRIDGE_SAG*2]);
                    }
                    translate ([0, CORE_LEN, 0]) {
                        box ([CORE_B, CORE_LEN*2, CORE_B+BRIDGE_SAG*2]);
                    }
                }
            }
            // Reg mark
            if (demo==1) translate (screw_pos) hull () {
                cyl (1, SCREW_R_B);
                translate ([CORE_A, 0, 0]) cyl (1, SCREW_R_B);
            }
        }
        // Core screw
        if (demo!=1) translate (screw_pos) screw_hole(
            SCREW_LEN_B,
            SCREW_R_B,
            SCREW_HEAD_R_B,
            NUT_R_B
        );
    }
    // Screws
    screw_hole(
        SCREW_LEN_A,
        SCREW_R_A,
        SCREW_HEAD_R_A,
        NUT_R_A
    );
    translate ([MAIN_LENGTH-MAIN_WIDTH+MAIN_OFFSET, 0, 0]) screw_hole(
        SCREW_LEN_A,
        SCREW_R_A,
        SCREW_HEAD_R_A,
        NUT_R_A
    );
    translate ([(MAIN_LENGTH-MAIN_WIDTH+MAIN_OFFSET)/2, 0, 0]) screw_hole(
        SCREW_LEN_A,
        SCREW_R_A,
        SCREW_HEAD_R_A,
        NUT_R_A
    );
    translate ([0, SHAFT_LEN_TO_0-CORE_LEN, 0]) screw_hole(
        SCREW_LEN_A,
        SCREW_R_A,
        SCREW_HEAD_R_A,
        NUT_R_A,
        10
    );

    /* Screw position demo
    if (demo == 2) difference () {
        box ([200, 200, 50]);
        cyl (200, r=5);
        translate ([MAIN_LENGTH-MAIN_WIDTH+MAIN_OFFSET, 0, 0]) cyl (200, r=5);
        translate ([0, SHAFT_LEN_TO_0-CORE_SCREW_POS-5, 0]) box ([50, 50, 50], [1, 0, 1]);
    }
    //*/
}

module base_ring () {
    difference () {
        cylinder (BASE_RING_WIDTH, r=BASE_R);
        translate ([0, 0, -1]) cylinder (BASE_RING_WIDTH+2, r=SHAFT_R+TOL*2);
    }
}

scale ([1, 1, -1]) {
    /* Demo
    translate ([30, 30, 0]) intersection () {
        door_handle (demo=1);
        box ([INF, INF, 0.4]);
    }

    //door_handle ();

    /*/
    // Door handle halves
    //intersection () {
      //  union(){box ([15, 400, 12.5], [1, 1, 1]);
        //    translate ([0, -65, 0]) box ([15, 400, 25], [1, 2, 1]);
        //};union(){
    intersection () {
        door_handle ();
        box ([INF, INF, INF], [1, 1, 2]);
    }

    translate ([0, -MAIN_WIDTH*6/5, 0]) rotate ([180, 0, 0]) intersection () {
        door_handle (demo=2);
        box ([INF, INF, INF], [1, 1, 0]);
    }
    //*/

    /*intersection (demo=2) {
        door_handle (demo=1);
        box ([INF, INF, 0.4]);
    }*/
}
    //}}

translate ([-20, -15, 0]) base_ring ();
