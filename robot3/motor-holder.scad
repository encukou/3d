/* TODO:
   - mirrorFLAP_* placement (at back of motor)
   - Push motor screw holes a bit toward front of motor
   - Larger nut holes (in 1st layer)
   - Wider through screw holer
*/

MOTOR_OUT = 16;
MOTOR_H = 22.4+1;
MOTOR_W = 18;
SHAFT_POS = 10.92;
SHAFT_R = 3.49;
PIN_POS = 22.35;
PIN_R = 3.68/2;
PIN_L = 2;
SCREW_POS = 31.17;
SCREW_R = 2.64/2;
SCREW_SEP = 17.42;
WALL_W = 4;
THIN_WALL = 2;
FLAP_W = 3;
FLAP_L = 6;
FLAP_S = 7;
NUT_R = 3;
NUT_H = 2;

VERTICAL_SCREW_OUT = 17;
CENTER_HOLE_R = 15/2;
CENTER_FLARE = 3;

TOL = 0.5;
EPS = 0.01;

module sym3 () {
    for (r=[0, 1, 2]) rotate ([0, 0, 360/3*r]) {
        children();
    }
}

module box (sizes, centering=[1, 1, 1]) {
    translate ([
        -sizes[0]*centering[0]/2,
        -sizes[1]*centering[1]/2,
        -sizes[2]*centering[2]/2]) cube (sizes);
}

module cylinder_hole (h, r, sep=100) {
    hull () {
        rotate ([90, 0, 0]) cylinder (h, r=r);
        translate ([0, 0, sep]) rotate ([90, 0, 0]) cylinder (h, r=r);
    }
}

module drop_cylinder(h, r) {
    intersection () {
        hull () for (x=[0, 1]) translate ([-x*r*1.5, 0, 0]) {
            cylinder (h, r=r*(1-x)+TOL);
        }
        box ([(r+TOL)*2, (r+TOL)*2, h+1000]);
    }
}

module next () {
    translate ([SHAFT_POS, MOTOR_OUT, 0]) rotate ([0, 0, 360/3]) {
        translate ([-SHAFT_POS, -MOTOR_OUT, 0]) children ();
    }
}

module holder_third () union () {
    difference () {
        translate ([-SHAFT_POS, -MOTOR_OUT, 0]) {
            translate ([-EPS, 0, 0]) cube ([PIN_POS+EPS, WALL_W, MOTOR_H]);

            hull () {
                // HACK: XXX and YYY are chosen so these two cylinders roughly coincide
                XXX = 4.5;
                YYY = 16.5;
                translate ([SHAFT_POS+SHAFT_R+TOL+WALL_W/2, XXX, 0]) cylinder (MOTOR_H, r=WALL_W/2);
                next () translate ([-WALL_W/2, YYY, 0]) cylinder (MOTOR_H, r=WALL_W/2);

                translate ([SHAFT_POS+SHAFT_R+TOL, 0, 0]) cube ([WALL_W, WALL_W, MOTOR_H]);
                translate ([SCREW_POS+SCREW_R+TOL, WALL_W, 0]) cylinder (MOTOR_H, r=WALL_W);
                next () translate ([-WALL_W, 0, 0]) cylinder (MOTOR_H, r=WALL_W);
                next () translate ([-WALL_W, -(MOTOR_W/2+FLAP_W/2+TOL+WALL_W), 0]) cylinder (MOTOR_H, r=WALL_W);
            }
            translate ([0, WALL_W*3/2, 0]) difference () {
                R = SHAFT_POS - SHAFT_R - TOL - WALL_W/2;
                union () {
                    translate ([-EPS, 0, 0]) cube ([R+EPS, R, MOTOR_H]);
                    translate ([R, -WALL_W/2, 0]) cylinder (MOTOR_H, r=WALL_W/2);
                    box ([R, WALL_W, MOTOR_H], [0, 2, 0]);
                }
                translate ([R, R, -EPS]) cylinder (100, r=R);
            }
        }
        translate ([-SHAFT_POS, -MOTOR_OUT, 0]) {
            translate ([SHAFT_POS, 50, MOTOR_H/2]) cylinder_hole (100, r=SHAFT_R+TOL);
            translate ([PIN_POS, PIN_L, MOTOR_H/2]) cylinder_hole (100, r=PIN_R+TOL);
            translate ([SCREW_POS, 0, MOTOR_H/2]) {
                for (z=[-1, 1]) translate ([0, 0, z*SCREW_SEP/2]) {
                    translate ([0, WALL_W*2, 0]) rotate ([90, 0, 0]) rotate ([0, 0, -90]) drop_cylinder (100, r=SCREW_R);
                    translate ([0, NUT_H*2+TOL, 0]) scale ([1, 1, z]) rotate ([90, 0, 0]) rotate ([0, 0, 90]) {
                        hull () for (t=[0, 100]) translate ([t, 0, 0]) {
                            cylinder (NUT_H+TOL, r=NUT_R+TOL, $fn=6);
                        }
                    }
                }
            }
            // Flap
            next () translate ([0, -MOTOR_W/2, MOTOR_H/2-FLAP_S/2]) {
                box ([FLAP_L*2+TOL, FLAP_W+TOL, 100+TOL], [1, 1, 0]);
            }
        }
        // Vertical screw hole
        EXTRA_ANGLE = 0; // HACK: chosen by hand
        rotate ([0, 0, -360/3+EXTRA_ANGLE]) {
            translate ([0, VERTICAL_SCREW_OUT, -EPS]) cylinder (100, r=SCREW_R);
        }
    }
}

module holder () union () {
    sym3 ()
        holder_third ($fn=50);
    difference () {
        cylinder (MOTOR_H/2-SHAFT_R-TOL, r=MOTOR_OUT-WALL_W/2);
        translate ([0, 0, -1]) cylinder (100, r=CENTER_HOLE_R, $fn=50);
        translate ([0, 0, -1]) cylinder (CENTER_FLARE+1, r1=CENTER_HOLE_R+CENTER_FLARE+1, r2=CENTER_HOLE_R, $fn=50);
    }
}

holder ();

// Helpers

module motor_assembly() {
    translate ([0, 0, -19]) {
        translate ([9.25, -25.5, 6.25]) rotate ([0, -90, 0]) color ([1, 1, 0]) {
            import("Geared_Motor.stl", convexity=3);
        }
        scale ([1, 1, -1]) translate ([0, 0, 1]) color ([0, 1, 1]) {
            import ("wheel-adapter.stl", convexity=3);
        }
        translate ([0, 0, -6]) scale ([1, 1, -1]) color ([0, 0, 1]) {
            cylinder (20, r=53/2);
        }
    }
}

// Motors
%sym3 () rotate([0, 0, 90]) {
    translate ([-MOTOR_OUT, 0, 13]) 
    rotate ([0, 90, 0]) motor_assembly();
}

// Tile size ref
%translate ([0, 0, -2]) %difference () {
    cylinder (1, r=100);
    translate ([0, 0, -1]) cylinder (3, r=65);
}

// Octopus board
%translate ([6.5, 3.5, 0]) rotate([0, 0, 30]) cube ([65, 65, 1], center=true);

// Turtle pen
%cylinder (100, d=15, $fn=50);
