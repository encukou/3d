HOLE_R = 4/2;
BOX_DEPTH = 9;
HOLE_DEPTH = 8+1;

PHOLE_R = 5/2;
PHOLE_DEPTH = 1;

$fn = 50;

module holes (r=HOLE_R, pr=PHOLE_R) {
    for(z=[17/2, 38-17/2]) {
        translate ([7.5/2, 0, z]) rotate ([-90, 0, 0]) {
            translate ([0, 0, (BOX_DEPTH-HOLE_DEPTH)]) {
                cylinder (HOLE_DEPTH+BOX_DEPTH+15, r=r);
            }
            translate ([0, 0, (BOX_DEPTH-PHOLE_DEPTH)]) {
                cylinder (PHOLE_DEPTH+BOX_DEPTH+15, r=pr);
            }
        }
    }
}

// Main part
difference () {
    union () {
        //translate ([0, -14, 0]) color ([1,0,1]) import ("Boaxel_Hook.stl");
        color ([1,0,0]) linear_extrude(17) import ("shape.svg");
        color ([1,0,0]) linear_extrude(1.5) hull () {
            import ("shape.svg");
        }
        translate ([3, -14, 0]) color ([1,.4,0]) cube ([1.5, 14, 38]);
        translate ([0, -2, 0]) color ([1,.6,0]) cube ([7.5, 2.001, 38]);
        translate ([0, 0, 0]) cube ([7.5, BOX_DEPTH, 38]);
        translate ([-3, 1, 0]) cube ([7.5+6, BOX_DEPTH, 38]);
    }

    holes ();
}


// Alignment guide
color ([0, 0, 1]) difference () {
    translate ([-3-2, 1.001, -1]) cube ([7.5+6+4, BOX_DEPTH+2+1.25, 33]);
    translate ([-3-.25, 0, 0]) cube ([7.5+6+.5, BOX_DEPTH+1, 38+1]);
    translate ([-3-2-2, 1-.001, 5]) cube ([7.5+6+4+4, BOX_DEPTH, 38]);

    translate ([-3-2-2, 1+BOX_DEPTH-.25, 0]) cube ([7.5+6+4+4, 2+.5, 38+1]);
    translate ([7.5/2+3, 1+BOX_DEPTH, 0]) cube ([10, 10, 40]);
    translate ([-6, 1+BOX_DEPTH, 0]) cube ([7.5/2+3, 10, 40]);

    holes (r=1, pr=1);
}

// Double washer
color ([0, 1, 0]) difference () {
    hull () intersection () {
        holes (r=1, pr=HOLE_R+2);
        translate ([-5, BOX_DEPTH+4.5, -1]) cube ([30, .5, 38]);
    }

    holes (pr=HOLE_R+.25);
}
