L = 58;
H = 40;
W = 15;

HOLE_R = 8/2;
HOLE_L = 37+3;
BOTTOM_W = 7;

NUT_SIDE = 11/2;
NUT_DEPTH = 5;
NUT_GAP = 2.5;
NUT_SEP = 13;
TOL = .25;

SCREW_R = 6/2;

module torus(outerRadius, innerRadius) {
  r=(outerRadius-innerRadius)/2;
  rotate_extrude() translate([innerRadius+r,0,0]) circle(r);
}

module rbox (size, r, t) {
    union () {
        for (xs=[-1, 1]) for (ys=[-1, 1]) {
            translate ([xs*(size[0]/2-r), ys*(size[1]/2-r), 0]) {
                cylinder (size[2]-t, r=r);
                cylinder (size[2], r=r-t);
                translate ([0, 0, size[2]-t]) torus (r, r-2*t);
            }
        }
        translate ([-size[0]/2+r, -size[1]/2, 0]) cube ([size[0]-r*2, size[1], size[2]-t]);
        translate ([-size[0]/2, -size[1]/2+r, 0]) cube ([size[0], size[1]-r*2, size[2]-t]);
        translate ([-size[0]/2+r, -size[1]/2+t, 0]) cube ([size[0]-r*2, size[1]-t*2, size[2]]);
        translate ([-size[0]/2+t, -size[1]/2+r, 0]) cube ([size[0]-t*2, size[1]-r*2, size[2]]);
        for (xs=[-1, 1]) {
            translate ([xs*(size[0]/2-t), -size[1]/2, size[2]-t]) rotate ([-90, 0, 0]) {
                cylinder (size[1]-r, r=t);
            }
        }
        translate ([-size[0]/2+r, size[1]/2-t, size[2]-t]) rotate ([0, 90, 0]) {
            cylinder (size[0]-2*r, r=t);
        }
    }
}

difference () {
    translate ([0, H/2, 0]) rbox ([L, H, W], 6, 2, $fn=50);
    hull () for (xs=[-1, 1]) {
        translate ([xs * (HOLE_L/2 - HOLE_R), BOTTOM_W+HOLE_R, -1]) {
            cylinder (100, r=HOLE_R+TOL/2, $fn=50);
        }
    }
    for (xs=[-1, 1]) {
        translate ([xs * (NUT_SEP/2 + NUT_SIDE), H-NUT_GAP-NUT_SIDE, -50]) {
            translate ([0, 0, 50+W-NUT_DEPTH]) cylinder (100, r=NUT_SIDE+TOL, $fn=6);
            cylinder (100, r=SCREW_R+TOL/2, $fn=50);
        }
    }
    translate ([-50, -100, 10]) {
        cube ([100, 120+TOL, 100]);
    }
}

translate ([0, 22, 0]) rotate ([0, 0, 45]) scale ([.2, .2, 1]) {
    linear_extrude(height = W+.2) {
        square(20);
        translate([10, 20, 0]) circle(10);
        translate([20, 10, 0]) circle(10);
    }
}

