
// Circular segment params
// https://en.wikipedia.org/wiki/Circular_segment
c = 50;
h = 10;

R = h/2 + (c*c) / (8*h);
d = R - h;

// 

THICKNESS = 10;

SCREW_R = 4/2;
NUT_R = 8/2;

difference () {
    translate ([0, 0, -THICKNESS/2]) linear_extrude (THICKNESS) {
        intersection () {
            translate ([0, -d]) circle(r=R, $fn=250);
            translate ([-R, 0]) square([R*2, R]);
        }
    }
    rotate ([-90, 0, 0]) {
        $fn=50;
        translate ([0, 0, -1]) cylinder (100, r=SCREW_R);
        translate ([0, 0, h/3]) cylinder (100, r=NUT_R);
    }
}
