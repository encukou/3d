$fn = 50;

linear_extrude (0.01) {
    import("shapes.svg");
}
translate ([0, 3, -3]) cube ([120, 30, 200]);
