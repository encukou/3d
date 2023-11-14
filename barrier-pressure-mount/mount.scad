THICKNESS = 3;
SIZE = 15;
SCREW1_R = 3/2;
SCREW1_TOP_R = 6/2;
SCREW2_R = 10/2;
TOL = 0.5;
EPS = 0.01;

$fn = 60;

module cylhole (h, r) render(convexity=1) {
    N = 8;
    cylinder (500, r=r);
    intersection () {
        translate ([-r-r/sqrt(2), -r, 0]) cube ([r, r*2, h]);
        rotate ([0, 0, 180/N]) cylinder (500, r=r/cos(180/N), $fn=N);
    }
}

difference () {
    translate ([-SIZE/2-THICKNESS, -SIZE/2-THICKNESS, 0]) hull () {
        cube ([SIZE+THICKNESS*2, SIZE+THICKNESS*2, SIZE+THICKNESS*2]);
        cube ([SIZE*2+THICKNESS*2, SIZE+THICKNESS*2, THICKNESS]);
    }
    translate ([-SIZE/2, -SIZE/2, THICKNESS]) {
        cube ([SIZE, SIZE, SIZE+THICKNESS*2]);
    }
    translate ([SIZE/2+THICKNESS, -SIZE/2, THICKNESS]) {
        cube ([SIZE, SIZE, SIZE+THICKNESS]);
    }
    rotate ([0, 90, 0]) translate ([-SIZE/2-THICKNESS, 0, -SIZE]) {
        cylhole (SIZE*2, r=SCREW2_R+TOL);
    }
    for (x=[0,1]) translate ([x*(SIZE+THICKNESS), 0, -EPS]) {
        cylinder (SIZE, r=SCREW1_R);
        translate ([0, 0, THICKNESS-SCREW1_TOP_R+EPS*2]) {
            cylinder (SCREW1_TOP_R, r1=0, r2=SCREW1_TOP_R);
        }
    }
}
