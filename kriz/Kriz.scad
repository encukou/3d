//cube([3,3,3]);
linear_extrude (15) {
    polygon([
        // base
        [15/2, 0],
        [15/2, 2.5],
        [-15/2, 2.5],
        [-15/2, 0],
    ]);
}

linear_extrude (2) {
    polygon([
        //tower
        [-1, 2.5],
        [1, 2.5],
        [1, 32],
        [0, 33],
        [-1, 32],
        ]);
}

for (x=[-1,1]) scale([x,1,1]) {
    linear_extrude (2) {
        polygon([
            //cross-arm
            [-15/2, 33],
            [15/2, 19],
            [15/2, 16],
            [-15/2, 30]
        ]);
    }
}