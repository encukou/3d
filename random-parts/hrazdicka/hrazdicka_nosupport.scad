$fn = 50;

linear_extrude (0.01) {
    import("shapes.svg");
}
translate ([0, 3, -3]) cube ([120, 20-3, 200]);
translate ([0, 22, -3]) cube ([120, 20-3, 200]);
for (x=[1, 2, 10, 11]) {
    translate ([x*10, 0, -1]) cylinder (200, r=6/2);
}
