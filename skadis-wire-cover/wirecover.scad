HOLE_DIST_X = 40;
HOLE_SIZE_X = 5;
HOLE_DIST_Z = 40;
HOLE_SIZE_Z = 14;
BOARD_THICK = 4.5;
BULGE = 10;
TOL = 1;
EPS = 0.01;

$fn = 50;
halfthick = HOLE_SIZE_X/2-TOL;
fullthick = halfthick*2;

module nudge_negz () {
    translate ([0, 0, -EPS]) children();
}

difference () {
    scale ([HOLE_DIST_X/2+halfthick, BULGE+halfthick, 1]) {
        cylinder (HOLE_DIST_Z, r=1);
    }
    scale ([HOLE_DIST_X/2-halfthick, BULGE-halfthick, 1]) nudge_negz () {
        cylinder (HOLE_DIST_Z+TOL, r=1);
    }
    translate ([-HOLE_DIST_X, -BULGE*2, -EPS]) {
        cube ([HOLE_DIST_X*2, BULGE*2, HOLE_DIST_Z+TOL]);
    }
}

for (x=[-1,1]) scale ([x, 1, 1]) {
    translate ([HOLE_DIST_X/2-halfthick, -BOARD_THICK-TOL-fullthick, 0]) {
        cube ([
            halfthick*2,
            BOARD_THICK+TOL+fullthick+EPS,
            HOLE_SIZE_Z/4,
        ]);
        hull () {
            cube ([
                halfthick*2,
                fullthick,
                EPS,
            ]);
            translate ([halfthick, 0, HOLE_SIZE_Z-HOLE_SIZE_X-TOL]) {
                rotate ([-90, 0, 0]) cylinder (fullthick, r=halfthick);
            }
        }
    }
}
