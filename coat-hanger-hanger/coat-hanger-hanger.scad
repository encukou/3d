HOLE_R = 7/2;
HANGER_R = 7;
WALL_W = 18;

PIN_HANGER_R = 1;

LENGTH = 70;

END_L = 10;

BEGIN_L = 30;

CAP_W = 2;
CAP_H = 7;

FN = 90;
TOL = 0.5;

module holder () {

    difference () {
        union () {
            rotate ([0, -90, 0]) cylinder (5+WALL_W, r=HOLE_R);
            translate ([-5-WALL_W, 0, 0]) sphere (r=HOLE_R);
        }
        translate ([-WALL_W-PIN_HANGER_R, 0, -100]) cylinder (200, r=PIN_HANGER_R);
    }

    rotate ([0, 90, 0]) cylinder (LENGTH, r=HANGER_R);

    module stub (r, fill) {
        intersection () {
            translate ([-r, r, 0]) {
                rotate_extrude () {
                    translate ([r, 0, 0]) circle (r=HANGER_R);
                }
            }
            translate ([-r, 0, -HANGER_R]) cube ([r, r, HANGER_R*2]);
        }
        difference () {
            translate ([-r, 0, -HANGER_R]) cube ([r, r, HANGER_R*2]);
            translate ([-r, r, -100]) {
                cylinder (200, r=r);
            }
        }
        intersection () {
            translate ([0, r, 0]) sphere (r=HANGER_R);
            translate ([-100, 0, -100]) cube ([100, 100, 200]);
        }
    }

    rotate ([0, 0, 180]) stub (BEGIN_L, 1);

    translate ([LENGTH, END_L, 0]) {
        intersection () {
            rotate_extrude () {
                translate ([END_L, 0, 0]) circle (r=HANGER_R);
            }
            translate ([0, -END_L*2, -100]) cube ([END_L*2, END_L*2, 200]);
        }
        translate ([END_L, 0, 0]) rotate ([-90, 0, 0]) cylinder (CAP_H, r=HANGER_R-CAP_W);
    }
}

module cap () {
    translate ([0, 20, 0]) difference () {
        cylinder (CAP_H+CAP_W, r=HANGER_R);
        translate ([0, 0, CAP_W]) cylinder (100, r=HANGER_R-CAP_W+TOL);
    }
}

intersection () {
    holder ($fn=FN);
    translate ([-1000, -1000, 0]) cube ([2000, 2000, 2000]);
}

translate ([-50, 40, 0]) intersection () {
    rotate ([180, 0, 0]) holder ($fn=FN);
    translate ([-1000, -1000, 0]) cube ([2000, 2000, 2000]);
}

cap ($fn=FN);
