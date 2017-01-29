height = 12;
width = 50;
link_pivot_angle1 = 0;
link_pivot_angle2 = 45;
tight_clearance = 0.2;
loose_clearance = 0.5;



arm_dia = 6;
arm_pin_length = 10;
wall_thickness = 2;
center_dia = 5;




link_width = height + arm_dia;
link_length = link_width * 2;//2 radius ends 0.5w each plus 2w between axes
lesser_dia = link_width - 2*wall_thickness;

$fn = 50;

link_external_wHole();

translate ([link_width + arm_dia + 1,0])
link_external_wPin ();


module link_external_wPin () {
union () {
link ();
arm_pin(0);
mirror([1,0])
arm_pin(0);
}
}

module link_external_wHole () {
mirror([1,0])
difference () {
link ();
arm_pin(1);
mirror([1,0])
arm_pin(1);
}
}

module arm_pins (shape) {
    arm_pin(shape);
    mirror([1,0])
    arm_pin(shape);
}

module arm_pin (shape){/*0- pin, 1 - hole*/
translate ([0,0,width/2-shape*arm_pin_length])
linear_extrude(arm_pin_length)
translate ([link_width/2,0])
circle(d=arm_dia/2+tight_clearance);
}


/*translate ([0,0,width/2])
linear_extrude(arm_pin_length)
translate ([link_width/2,0])
circle(d=arm_dia/2+tight_clearance);
*/

module link () {
linear_extrude(wall_thickness)
base ();
translate([0,0,wall_thickness])
linear_extrude(wall_thickness)
union () {
intersection () {
difference () {
base ();
translate ([0,link_width])
circle(d=lesser_dia);
translate ([0,-link_width])
circle(d=lesser_dia);
}

union () {
pivot_cutout ();
mirror ([0,1])
pivot_cutout ();
}
}

translate([0,link_width])
circle(d=center_dia);
translate([0,-link_width])
circle(d=center_dia);
}

linear_extrude(width*0.5)
union() {
translate([link_width*0.5,0])
circle(d=arm_dia);
translate([-link_width*0.5,0])
circle(d=arm_dia);
}
}

module base () {
union () {
square([link_width,link_length],true);
translate ([0,link_width])
    circle(d=link_width);
translate ([0,-link_width])
    circle(d=link_width);
}
}

//defines angles joints would pivot
module pivot_cutout () {
polygon(points = [[link_width,link_width-link_width/2*tan(link_pivot_angle1)],[0,link_width],[-link_width,link_width-link_width/2*tan(link_pivot_angle2)],[-link_width,0],[link_width,0]]);
}