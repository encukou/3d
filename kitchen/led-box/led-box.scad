PROFILE_W = 30;
PROFILE_D = 20;
PROFILE_T = 2;

GAP_T = 1;
WALL_T = 2;

CENTERCOL_R = 5/2;

// 3x16
SCREW_R_1 = 3/2;
SCREW_IN_R_1 = 2/2;
SCREW_HEAD_R_1 = 6/2;
SCREW_LEN_1 = 16;

// 4x25
SCREW_R_2 = 4/2;
SCREW_IN_R_2 = 2.5/2;
SCREW_HEAD_R_2 = 8/2;
SCREW_LEN_2 = 25;

TOL = .25;
EPS = 0.001;

TOTAL_H = 50;
PROFILE_H = TOTAL_H - WALL_T*2;
SIDE = PROFILE_W + PROFILE_D + GAP_T;

$fs = .5;

module profile () {
    color ([.2, .8, 1]) {
        cube ([PROFILE_W, PROFILE_T+TOL, PROFILE_H+TOL]);
        cube ([PROFILE_T+TOL, PROFILE_D, PROFILE_H+TOL]);
    }
}

module profiles () {
    profile ();
    translate ([0, SIDE, 0]) rotate ([0, 0, -90]) profile();
    translate ([SIDE, 0, 0]) rotate ([0, 0, 90]) profile();
    translate ([SIDE, SIDE, 0]) rotate ([0, 0, 180]) profile();
}

module bottom () {
    difference () {
        union () {
            translate ([-GAP_T, -GAP_T, -WALL_T]) {
                cube ([SIDE+GAP_T*2, SIDE+GAP_T*2, WALL_T+GAP_T]);
            };
            h = PROFILE_H - TOL/2;
            translate ([PROFILE_W-GAP_T, -GAP_T, -GAP_T]) {
                cube ([PROFILE_T+GAP_T*2, PROFILE_T+GAP_T*2, h]);
            }
            translate ([-GAP_T, PROFILE_D-GAP_T, -GAP_T]) {
                cube ([PROFILE_T+GAP_T*2, PROFILE_T+GAP_T*2, h]);
            }
            translate ([PROFILE_D-GAP_T, SIDE-GAP_T-PROFILE_T, -GAP_T]) {
                cube ([PROFILE_T+GAP_T*2, PROFILE_T+GAP_T*2, h]);
            }
            translate ([SIDE-GAP_T-PROFILE_T, PROFILE_W-GAP_T, -GAP_T]) {
                cube ([PROFILE_T+GAP_T*2, PROFILE_T+GAP_T*2, h]);
            }
        }
        profiles ();
        translate ([SIDE/2, SIDE/2, -WALL_T-EPS]) {
            cylinder (WALL_T*4, r=SCREW_R_2+TOL/2);
            cylinder (SCREW_HEAD_R_2, r1=SCREW_HEAD_R_2+TOL, r2=0);
        }
        translate ([SIDE/2, SIDE/2, GAP_T-TOL]) {
            cylinder (WALL_T*4, r=CENTERCOL_R+TOL);
        }
    }
}

module top () {
    difference () {
        union () {
            translate ([-GAP_T, -GAP_T, -GAP_T]) {
                cube ([SIDE+GAP_T*2, SIDE+GAP_T*2, WALL_T+GAP_T]);
            };
            translate ([SIDE/2, SIDE/2, -PROFILE_H+GAP_T]) {
                cylinder (PROFILE_H-WALL_T, r=CENTERCOL_R);
            }
        }
        mirror ([0, 0, 1]) profiles ();
        translate ([SIDE/2, SIDE/2, -PROFILE_H-EPS]) {
            cylinder (SCREW_LEN_2+WALL_T+TOL, r=SCREW_IN_R_2);
        }
        for (x=[-1,1]) for (y=[-1,1]) {
            translate ([SIDE/2+x*SIDE/4, SIDE/2+y*SIDE/4, -GAP_T-EPS]) {
                cylinder (PROFILE_H, r=SCREW_R_1+TOL);
                cylinder (SCREW_HEAD_R_1, r1=SCREW_HEAD_R_1+TOL, r2=0);
            }
        }
    }
}

module demo () {
    difference () { union () {
    bottom ();
    translate ([0, -PROFILE_H*1.5, 0]) color ([1, 0, 0]) bottom ();
    translate ([0, 0, PROFILE_H]) color ([0, 1, 0]) top ();
    translate ([SIDE*2+20, 0, 0]) rotate ([0, 180, 0]) top ();
    } translate ([0, SIDE/2, -10]) cube ([300, 30, 300]);}
}

//demo ();
!bottom ();
top ();
