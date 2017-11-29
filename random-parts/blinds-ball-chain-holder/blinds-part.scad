BALL_R = 4.1/2;
BODY_ROUNDING = 3;

MIDDLE_W = 10.5;

union () {
    difference () {
        union () {
            hull () for (x=[-1,1]) for (y=[-1,1]) {
                BR = BODY_ROUNDING;
                translate ([(12/2-BR)*x, (33/2-BR)*y, 0]) cylinder (3, r=BR, $fn=20);
            }
            translate ([-MIDDLE_W/2, -15/2]) cube ([MIDDLE_W, 15, 4]);
        }
        for (y=[12,-12]) {
            translate ([0, y, 0.5]) cylinder (100, r=4, $fn=20);
            translate ([0, y, -15]) cylinder (100, r=2, $fn=15);
        }
    }
    translate ([0, 0, 4]) difference () {
        intersection () {
            // http://math.stackexchange.com/questions/564058/calculate-the-radius-of-a-circle-given-the-chord-length-and-height-of-a-segment

            h = 3.5;
            l = 15;
            r = (4*h*h + l*l) / (8*h);

            translate ([-MIDDLE_W/2, 0, -r+h]) rotate ([0, 90, 0]) cylinder (MIDDLE_W, r=r);
            translate ([-50, -50, 0]) cube ([100, 100, 100]);
        }
        for (sx=[-1, 1]) for (sy=[-1, 1]) scale ([sx, sy, 1]) {
            translate ([2.4, 0, BALL_R]) {
                translate ([0, -BALL_R, 0]) hull () {
                    rotate ([90, 0, 0]) cylinder (100, r=BALL_R, $fn=20);
                    translate ([0, -100, 0]) cylinder (BALL_R, r=BALL_R, $fn=20);
                    sphere (r=BALL_R, $fn=20);
                }
                hull () for (z=[0, 5]) {
                    translate ([0, 1, z]) rotate ([90, 0, 0]) cylinder (100, r=0.25, $fn=20);
                }
            }
        }
    }
}

