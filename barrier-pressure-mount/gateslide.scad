WTOL = 2;
WOOD_W = 24+WTOL;
WOOD_H = 30+WTOL;
WALL = 4;
WALL_BOTTOM = 2;
LENGTH = 30;
SCREW_R = 6/3;
TOOTH = 5;
TOL = 1;

$fn = 50;

module cube_zround (wlh, r) {
    w = wlh[0];
    l = wlh[1];
    h = wlh[2];
    hull () for (x=[r,w-r]) for (y=[r,l-r]) {
        translate ([x, y, 0]) cylinder (h, r=r);
    }
}

difference () {
    translate ([-WOOD_W-WALL*3/2, 0, 0]) {
        cube_zround ([WOOD_W*2 + WALL*3, WOOD_H + WALL*2, LENGTH], WALL/2);
    }
    translate ([WALL/2, WALL, WALL_BOTTOM]) {
        cube_zround ([WOOD_W, WOOD_H, 100], WALL/4);
    }
    translate ([-WOOD_W-WALL/2, WALL, -WALL]) {
        cube_zround ([WOOD_W, WOOD_H, 100], WALL/4);
    }
    translate ([-WOOD_W-WALL/2+TOOTH*2, WALL+WOOD_H-TOOTH, -WALL]) hull() {
        cube ([WOOD_W-TOOTH*4, WALL, 100]);
        translate ([-WALL*2-TOOTH*2, WALL*2+TOOTH*2, 0]) {
            cube ([WOOD_W+WALL*4, WALL, 100]);
        }
    }
    translate ([WOOD_W/2+WALL/2, WALL+WOOD_H/2, -1]) cylinder(100, r=SCREW_R+TOL*2);
}
