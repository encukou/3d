BAT_LENGTH = 65.5;
BAT_R = 18.5/2;

BOTTOM_THICKNESS = 2;
SIDE_THICKNESS = 1;

PROTRUSION_HEIGHT = 2;
PROTRUSION_WIDTH = 7;
PROTRUSION_THICKNESS = 1;
WINDOW_HEIGHT = PROTRUSION_WIDTH*1.6;

HOLE_WIDTH = 1;

MID_LENGTH = BAT_LENGTH - BAT_R*2;
MID_EPS = 0.1;
MID_MIN_THICKNESS = 1.2;
MID_HEIGHT = BAT_R * 1.5;

WIDTH = (BAT_R + MID_EPS + MID_MIN_THICKNESS) * 2;

$fn = 100;

module plate (h, l, w) {
    translate ([-h/2, -l/2, 0]) {
        cube ([h, l, w]);
    }
}

module arch_thing (width) {
    translate ([0, -WIDTH/2, 0]) cube ([width, WIDTH, BAT_R]);
    translate ([0, 0, BAT_R]) rotate ([0, 90, 0]) cylinder (width, r=WIDTH/2);
}

module side () {
    difference () {
        union () {
            translate ([0, -WIDTH/2, 0]) cube ([SIDE_THICKNESS, WIDTH, BAT_R]);
            translate ([0, 0, BAT_R]) rotate ([0, -90, 0]) {
                translate ([0, 0, -SIDE_THICKNESS]) cylinder (SIDE_THICKNESS, r=WIDTH/2);
                translate ([0, 0, PROTRUSION_HEIGHT/2]) {
                    plate (PROTRUSION_THICKNESS, PROTRUSION_WIDTH, PROTRUSION_HEIGHT/2);
                }
                for (t=[0,180]) rotate ([0, 0, t]) {
                    translate ([0, -PROTRUSION_WIDTH/2-PROTRUSION_THICKNESS/2, 0]) hull () {
                        plate (PROTRUSION_THICKNESS, PROTRUSION_THICKNESS, PROTRUSION_HEIGHT);
                        plate (WINDOW_HEIGHT, PROTRUSION_THICKNESS, 0.01);
                    }
                }
            }
        }
        union () {
            translate ([0, 0, BAT_R]) {
                rotate ([0, -90, 0]) translate ([0, 0, -SIDE_THICKNESS*2]) {
                    plate (WINDOW_HEIGHT, PROTRUSION_WIDTH, SIDE_THICKNESS*2+PROTRUSION_THICKNESS);
                }
            }
        }
    }
}

module mid () {
    difference () {
        translate ([-MID_LENGTH/2, 0, 0]) {
            intersection () {
                arch_thing (MID_LENGTH);
                translate ([-BAT_LENGTH, -BAT_LENGTH, 0]) cube ([BAT_LENGTH*2, BAT_LENGTH*2, MID_HEIGHT]);
            }
        }
        for (s=[-1, 1]) translate ([-MID_LENGTH/2*s, BAT_LENGTH/2, BAT_R]) hull () {
            rotate ([90, 0, 0]) {
                cylinder (BAT_LENGTH*2, r=BAT_R);
                translate ([0, BAT_R, 0]) cylinder (BAT_LENGTH*2, r=BAT_R);
            }
        }
    }
}

difference () {
    union () {
        translate ([0, 0, -BOTTOM_THICKNESS]) {
            plate (BAT_LENGTH+PROTRUSION_HEIGHT*2+SIDE_THICKNESS*2, WIDTH, BOTTOM_THICKNESS);
        }
        mid ();
    }
    translate ([0, 0, BAT_R]) rotate ([0, -90, 0]) translate ([0, 0, -BAT_LENGTH/2-MID_EPS]) {
        cylinder (BAT_LENGTH+MID_EPS*2, r=BAT_R+MID_EPS);
    }
}
for (t=[0,180]) rotate ([0, 0, t]) {
    translate ([BAT_LENGTH/2+PROTRUSION_HEIGHT, 0, 0]) side ();
}

% translate ([-BAT_LENGTH/2, 0, BAT_R]) rotate ([0, 90, 0]) cylinder (BAT_LENGTH, r=BAT_R);
