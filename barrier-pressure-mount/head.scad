NUT_SIDE = 20/2;
NUT_R = 10/2;
NUT_H = 8;
GIZMO_R = 32/3;
GIZMO_H = 8;
SCREW_R = 10/2;
TOL = 0.5;

$fn = 50;

difference () {
    union () {
        for (a = [0:30:360]) rotate ([0, 0, a]) translate ([GIZMO_R, 0, 0]) {
            cylinder(GIZMO_H, r=3.2);
        }
        cylinder(GIZMO_H, r=GIZMO_R);
    }
    translate ([0, 0, 1]) cylinder (NUT_H, r=NUT_SIDE+TOL/2, $fn=6);
    translate ([0, 0, -1]) cylinder (NUT_H, r=SCREW_R+TOL);
}
