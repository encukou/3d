$fn = 50;
TOL = .5;
EPS = 0.01;

intersection () {
    difference () {
        linear_extrude (30) {
            import("shapes.svg");
        }
        translate ([60, 90, 3-EPS]) {
            translate ([0, 0, 1]) cylinder (r=6+TOL, 200);
            rotate ([0, 0, 45]) cube ([50, 50, 40]);
            translate ([-.5, -20, 0]) cube ([1, 30, 40]);
        }
        translate ([-1, 3, 5-TOL/2]) cube ([200, 30-3+TOL, 20+TOL]);
        intersection () {
            translate ([-1, 3, 5]) cube ([200, 50, 20]);
            x=-15;
            translate ([-1, -x, 15]) rotate ([0, 90, 0]) cylinder (200, r=33+x+TOL, $fn=300);
        }
        translate ([-1, -10, (30-19)/2]) cube ([200, 20, 19]);
        for (x=[1, 2, 10, 11]) {
            translate ([x*10, 0, -1]) cylinder (200, r=3/2);
            translate ([x*10, 0, -1]) cylinder (5, r=6/2);
            translate ([x*10, 0, 25]) cylinder (5+1, r=6/2);
        }
    }
    translate ([-10, -10, 3]) cube ([200, 200, 30-6]);
}
