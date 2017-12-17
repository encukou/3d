BAT_LENGTH = 65.5;
BAT_R = 18.5/2;

BOTTOM_THICKNESS = 2;
SIDE_THICKNESS = 0.5;

PROTRUSION_HEIGHT = 2;
PROTRUSION_WIDTH = 7;
PROTRUSION_THICKNESS = 1;

HOLE_WIDTH = 1;

MID_LENGTH = BAT_LENGTH/2;
MID_EPS = 1;

$fn = 100;

module plate (h, l, w) {
    translate ([-h/2, -l/2, 0]) {
        cube ([h, l, w]);
    }
}

module side () {
    difference () {
        union () {
            translate ([0, -BAT_R, 0]) cube ([SIDE_THICKNESS, BAT_R*2, BAT_R]);
            translate ([0, 0, BAT_R]) rotate ([0, -90, 0]) {
                translate ([0, 0, -SIDE_THICKNESS]) cylinder (SIDE_THICKNESS, r=BAT_R);
                translate ([0, 0, PROTRUSION_HEIGHT/2]) {
                    plate (PROTRUSION_THICKNESS, PROTRUSION_WIDTH, PROTRUSION_HEIGHT/2);
                }
                for (t=[0,180]) rotate ([0, 0, t]) {
                    translate ([0, -PROTRUSION_WIDTH/2-PROTRUSION_THICKNESS/2, 0]) hull () {
                        plate (PROTRUSION_THICKNESS, PROTRUSION_THICKNESS, PROTRUSION_HEIGHT);
                        plate ((PROTRUSION_HEIGHT+PROTRUSION_THICKNESS)*3, PROTRUSION_THICKNESS, 0.01);
                    }
                }
            }
        }
        union () {
            translate ([0, 0, BAT_R]) {
                rotate ([0, -90, 0]) translate ([0, 0, -SIDE_THICKNESS*2]) {
                    plate (PROTRUSION_WIDTH, PROTRUSION_WIDTH, SIDE_THICKNESS*2+PROTRUSION_THICKNESS);
                }
            }
        }
    }
}

module mid () {
}

difference () {
    union () {
        translate ([0, 0, -BOTTOM_THICKNESS]) {
            plate (BAT_LENGTH+PROTRUSION_HEIGHT*2+SIDE_THICKNESS*2, BAT_R*2, BOTTOM_THICKNESS);
        }
        translate ([0, 0, -BOTTOM_THICKNESS]) {
            plate (MID_LENGTH, BAT_R*2+MID_EPS*3, BAT_R+BOTTOM_THICKNESS);
        }
    }
    translate ([0, 0, BAT_R]) rotate ([0, -90, 0]) translate ([0, 0, -BAT_LENGTH/2-MID_EPS]) {
        cylinder (BAT_LENGTH+MID_EPS*2, r=BAT_R+MID_EPS);
    }
}
for (t=[0,180]) rotate ([0, 0, t]) {
    translate ([BAT_LENGTH/2+PROTRUSION_HEIGHT, 0, 0]) side ();
}
mid ();
