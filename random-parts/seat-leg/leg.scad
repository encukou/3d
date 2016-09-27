WIDTH = 60;
HEIGHT = 24.5;
ROUND = 2;

union() {
    difference() {
        hull() {
            //translate([0, 0, ROUND]) cube([WIDTH, WIDTH, HEIGHT-ROUND]);
            translate([ROUND, ROUND, 0]) cylinder(h=1, r=ROUND, $fn=20);
            translate([WIDTH-ROUND, ROUND, 0]) cylinder(h=1, r=ROUND, $fn=20);
            translate([ROUND, WIDTH-ROUND, 0]) cylinder(h=1, r=ROUND, $fn=20);
            translate([WIDTH-ROUND, WIDTH-ROUND, 0]) cylinder(h=1, r=ROUND, $fn=20);

            translate([ROUND, ROUND, HEIGHT-ROUND]) sphere(ROUND, $fn=20);
            translate([WIDTH-ROUND, ROUND, HEIGHT-ROUND]) sphere(ROUND, $fn=20);
            translate([ROUND, WIDTH-ROUND, HEIGHT-ROUND]) sphere(ROUND, $fn=20);
            translate([WIDTH-ROUND, WIDTH-ROUND, HEIGHT-ROUND]) sphere(ROUND, $fn=20);
        }
        for (p=[15, WIDTH-15]) {
            translate([WIDTH/2, p, HEIGHT-10]) cylinder(h=100, d=10, $fn=40);
            translate([WIDTH/2, p, -9.9]) cylinder(h=100, d=4.4, $fn=20);
        }
    }
}
