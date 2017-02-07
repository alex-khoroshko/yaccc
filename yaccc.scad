height = 13;
width = 52;
link_pivot_angle1 = 0;
link_pivot_angle2 = 45;
tight_clearance = 0.2;
loose_clearance = 0.7;



arm_dia = 10;
arm_pin_length = arm_dia;
arm_pin_dia = arm_dia * 2 / 3;
wall_thickness = 3;
center_dia = 7;




link_width = height + arm_dia;
link_length = link_width * 2;//2 radius ends 0.5w each plus 2w between axes
lesser_dia = link_width - 2*wall_thickness;

$fn = 50;

link_external_wHole();

translate ([link_width + arm_dia + 1,0])
link_external_wPin ();

translate ([(link_width + arm_dia + 1.0)*2,0])
link_internal ();

translate ([(link_width + arm_dia + 1.0)*3,0])
link_internal ();


module link_external_wPin () {
union () {
link ();
arm_pin(0,0);
mirror([1,0])
arm_pin(0,0);
}
}

module link_external_wHole () {
mirror([1,0])
difference () {
link ();
arm_pin(1,0);
mirror([1,0])
arm_pin(1,0);
}
}

module arm_pins (shape) {
    arm_pin(shape,0);
    mirror([1,0])
    arm_pin(shape,0);
}

module arm_pin (shape, len_t){
    /*shape: 0- pin, 1 - hole*/
    /*len_t: 0- normal, 1 - short*/
translate ([0,0,width/2-shape*arm_pin_length - (len_t * (loose_clearance*0.5 + wall_thickness))])
linear_extrude(arm_pin_length - loose_clearance * (1-shape))
translate ([link_width/2,0])
if (shape) {
   circle(d=arm_pin_dia+tight_clearance); 
} else {
hex(d=arm_pin_dia+tight_clearance*shape);
}
}


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

arm_base (0);
}

module arm_base (len_t) {
linear_extrude(width*0.5 - (len_t * (0.5*loose_clearance + wall_thickness)))
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
polygon(points = [[link_width*0.5,link_width-link_width/2*tan(link_pivot_angle1)],[0,link_width],[-link_width*0.5,link_width-link_width/2*tan(link_pivot_angle2)],[-link_width*0.5,0],[link_width*0.5,0]]);
}

module base_internal () {
linear_extrude(wall_thickness)
difference () {
union () {
square([link_width,link_length],true);
translate ([0,link_width])
circle(d=lesser_dia-loose_clearance);
translate ([0,-link_width])
circle(d=lesser_dia-loose_clearance);
}
translate ([0,link_width])
circle(d=center_dia+loose_clearance);
translate ([0,-link_width])
circle(d=center_dia+loose_clearance);
}    
}

module link_internal () {
base_internal ();
difference () {
arm_base (1);
arm_pin(1,1);
}
//link ();
mirror([1,0])
arm_pin(0,1);
}

module hex (d){
    hex_rad = d / 2;
polygon(points = [[hex_rad,0],[hex_rad*cos(60),-hex_rad*sin(60)],[-hex_rad*cos(60),-hex_rad*sin(60)],[-hex_rad,0],[-hex_rad*cos(60),hex_rad*sin(60)],[hex_rad*cos(60),hex_rad*sin(60)]]);
}