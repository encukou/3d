module box (sizes, centering=[1, 1, 1], extra_negative=[0, 0, 0]) {
    translate ([
        -sizes[0]*centering[0]/2-extra_negative[0],
        -sizes[1]*centering[1]/2-extra_negative[1],
        -sizes[2]*centering[2]/2-extra_negative[2],
    ]) {
        cube ([
            sizes[0]+extra_negative[0],
            sizes[1]+extra_negative[1],
            sizes[2]+extra_negative[2],
        ]);
    }
}

BOX_Y = 121;    // incl.tol
BOX_X = 56;     // incl.tol
BOX_Z = 27;     // no tol

ZKOS = 5;

HINGE_DZ = 3;

EPS = 0.01;
$fn=50;

module groove (w, y, z) {
    translate ([0, y, -z]) {
        translate ([-1, 0, 0]) box ([100, w, z+EPS], [0, 1, 0]);
        children ();
    }
}

module screw_pos () {
    for (ys=[-1, 1]) scale ([1, ys, 1]) {
        for (x=[BOX_X/2 + 15, 25]) for (y=[15,40+15/2]) {
            translate ([x, y, 0]) children ();
        }
    }
}

module screw_hole () {
    translate ([0, 0, -BOX_Z+EPS]) cylinder (12, r=5/2-.25);
    translate ([0, 0, -50]) cylinder (100, r=3/2+.25);
}

module main () {
    difference () {
        union () {
            box ([BOX_X, BOX_Y, BOX_Z], [0, 1, 2]);
            screw_pos () {
                cylinder (2, r=8/2);
            }
        }

        translate ([0, 0, -ZKOS]) rotate ([0, -45, 0]) {
            box ([10, BOX_Y+EPS, 10], [0, 1, 0]);
        }

        for (ys=[-1, 1]) scale ([1, ys, 1]) {
            groove (4+.5, 0, 3+.5);

            D1 = 36.5 - 4/2 - 5/2;
            groove (5+1.5, D1, 2.5+.5);

            D2 = D1 + 2;
            groove (1.5+1, D2, 6+1) {
                translate ([0, 0, -24+7]) rotate ([0, -45, 0]) {
                    box ([30, 1.5+1, 30], [0, 1, 0]);
                }
                translate ([BOX_X, 0, -24+7]) rotate ([0, -45, 0]) {
                    box ([30, 1.5+1, 30], [0, 1, 0]);
                }
            }
            translate ([BOX_X-4, D1+1, -7]) {
                box ([4+EPS, 100, 100], [0, 0, 0]);
            }
            translate ([25, 40-1, -HINGE_DZ]) box ([13+2, 15+2, 12], [1, 0, 0]);
        }
        screw_pos () {
            screw_hole ();
        }

    }
}

module top_plate () {
    difference () {
        translate ([ZKOS, 0, EPS]) box ([BOX_X-ZKOS, BOX_Y, 2], [0, 1, 0]);
        screw_pos () {
            cylinder (100, r=3/2);
        }
        for (y=[-1, 1]) scale ([1, y, 1]) {
            translate ([25, 25, 0]) box ([13+3, 50, 12], [1, 0, 0]);
            translate ([25, 25, 0]) box ([50, 50, 12], [2, 0, 0]);
        }
    }
}

module hinge () {
    DZ = HINGE_DZ;
    XZ = .5;
    translate ([25, 0, 0]) difference () {
        for (y=[1]) scale ([1, y, 1]) {
            translate ([0, 40, -DZ]) box ([13, 15, 12+DZ+XZ], [1, 0, 0]);
        }
        translate ([0, 100, 10-8/2+XZ]) {
            rotate ([90, 0, 0]) cylinder (200, r=8/2+.5);
            RM = 8;
            hull () {
                box ([EPS, 200, RM], [1, 2, 0]);
                translate ([0, 0, RM*1.2]) box ([RM*2, 200, 100], [1, 2, 0]);
            }
        }
        for (y=[-1, 1]) scale ([1, y, 1]) translate ([0, 40+15/2, 0]) {
            translate ([0, 0, -BOX_Z-EPS]) cylinder (50, r=3/2+.25);
            translate ([0, 0, -1+XZ]) cylinder (50, r=5.5/2+.25);
        }
    }
}

//main ();
translate ([0, 0, 2]) color ([1,.2,0]) top_plate ();
//color ([0,1,1]) hinge ();
