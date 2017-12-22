BAT_R = 15/2;
WALL_WIDTH = 1.5;
TOL = 0.1;

BOTTOM_HEIGHT = 1;
HEIGHT = 10;

SLIT_WIDTH = 2;
SLIT_HEIGHT = 0.5;

RUBBER_WIDTH = BAT_R/sqrt(2);
RUBBER_GUIDE_DEPTH = WALL_WIDTH/3;

NUB_SIDE = SLIT_WIDTH;
NUB_HEIGHT = 0.5;

TAB_HEIGHT = 0.5;
TAB_WIDTH = BAT_R/sqrt(2);
SCREW_R = 1;

$fn = 100;

module plate (h, l, w) {
    translate ([-h/2, -l/2, 0]) {
        cube ([h, l, w]);
    }
}

module octa_prism (span, height) {
    a = span / (1 + sqrt(2));
    hull () {
        plate (span, a, height);
        plate (a, span, height);
    }
}

module ramp_cutout () {
    translate ([-RUBBER_WIDTH/2, BAT_R, -BOTTOM_HEIGHT]) {
       rotate ([-45, 0, 0]) cube ([RUBBER_WIDTH, BAT_R, BAT_R]);
    }
}

module guide_cutout () {
    translate ([-RUBBER_WIDTH/2, BAT_R+WALL_WIDTH-RUBBER_GUIDE_DEPTH, -BOTTOM_HEIGHT]) {
       cube ([RUBBER_WIDTH, HEIGHT*10, HEIGHT*10]);
    }
}

module tab () {
    a = TAB_WIDTH / (1+sqrt(2));
    difference () {
        intersection () {
            translate ([0, -BAT_R, 0]) cube ([BAT_R*2, BAT_R*2, TAB_HEIGHT]);
            translate ([a/2, 0, 0]) octa_prism (TAB_WIDTH, TAB_HEIGHT);
        }
        translate ([a*3/4, 0, -HEIGHT/2]) cylinder(HEIGHT, r=SCREW_R);
    }
}

union () {
    translate ([0, 0, -BOTTOM_HEIGHT]) {
        intersection () {
            rotate ([0, 0, 45]) plate (NUB_SIDE, NUB_SIDE, BOTTOM_HEIGHT+NUB_HEIGHT);
            translate ([0, -BAT_R/2, BOTTOM_HEIGHT+NUB_HEIGHT]) {
                rotate ([0, 135, 0]) cube ([BAT_R, BAT_R, BAT_R]);
            }
        }
    }
    for (a=[0, 180]) rotate ([0, 0, a]) {
        translate ([BAT_R+WALL_WIDTH, 0, -BOTTOM_HEIGHT]) {
            tab ();
        }
    }
    difference () {
        union () {
            translate ([0, 0, -BOTTOM_HEIGHT]) {
                octa_prism ((BAT_R+WALL_WIDTH)*2, HEIGHT+BOTTOM_HEIGHT);
            }
        }
        cylinder (HEIGHT*100, r=BAT_R+TOL);
        translate ([0, -SLIT_WIDTH/2, -BOTTOM_HEIGHT+(BAT_R+WALL_WIDTH)-RUBBER_GUIDE_DEPTH]) {
            rotate ([0, 90+45, 0]) cube ([BAT_R*10, SLIT_WIDTH, BAT_R*10]);
        }
        for (a=[0, 180]) rotate ([0, 0, a]) {
            guide_cutout ();
            ramp_cutout ();
        }
        for (a=[45, 135, -45, -135]) rotate ([0, 0, a]) {
            translate ([0, 0, -RUBBER_GUIDE_DEPTH]) ramp_cutout ();
        }
        for (a=[0:8]) rotate ([0, 0, a*45]) {
            translate ([0, 0, HEIGHT+BOTTOM_HEIGHT+RUBBER_GUIDE_DEPTH]) ramp_cutout ();
            translate ([0, 0, (HEIGHT-BOTTOM_HEIGHT)/2]) {
                rotate ([90, 0, 0]) octa_prism (BAT_R/(1+sqrt(2)), BAT_R*10);
            }
        }
    }
}
