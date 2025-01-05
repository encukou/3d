linear_extrude(2) hull () import ("drawing.svg", id="perim");
linear_extrude(2+2) import ("drawing.svg", id="perim");
linear_extrude(2+2+8+1) import ("drawing.svg", id="walls");

translate ([60, 0, 4]) rotate ([0, 180, 0]) difference () {
    linear_extrude(2+2) hull () import ("drawing.svg", id="perim");
    translate ([0, 0, -.01]) {
        linear_extrude(2) offset (delta=.5, chamfer=true) import ("drawing.svg", id="walls");
        linear_extrude(2) offset (delta=.5, chamfer=true) import ("drawing.svg", id="cutout");
        linear_extrude(20) import ("drawing.svg", id="hole");
    }
}
