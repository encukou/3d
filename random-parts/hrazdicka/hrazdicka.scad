$fn = 50;

difference () {
    linear_extrude (30) {
        import("shapes.svg");
    }
    translate ([60, 90, 5]) cylinder (d=12, 200);
    translate ([-1, 3, 5]) cube ([200, 30-3, 20]);
    intersection () {
        translate ([-1, 3, 5]) cube ([200, 50, 20]);
        x=-15;
        translate ([-1, -x, 15]) rotate ([0, 90, 0]) cylinder (200, r=33+x, $fn=300);
    }
    translate ([-1, -10, (30-15)/2]) cube ([200, 20, 15]);
    for (x=[1, 2, 10, 11]) {
        translate ([x*10, 0, -1]) cylinder (200, r=3/2);
        translate ([x*10, 0, -1]) cylinder (5, r=6/2);
        translate ([x*10, 0, 25]) cylinder (5+1, r=6/2);
    }
}
