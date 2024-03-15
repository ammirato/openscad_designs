include <BOSL2/std.scad>
use <primitives/boxes.scad>
$fn=25;
eps = 0.001;

 box_with_corner_magnets(
    width=20, 
    height=30, 
    depth=30, 
    wall_thickness=5,
    hole_radius=2.5*1.05,
    hole_height=3*1.05,
    chamfer=0.5
);

module box_with_corner_magnets(
    width, 
    depth, 
    height, 
    wall_thickness, 
    hole_radius=2.5,
    hole_height=3,
    center=false, 
    chamfer=0,
 ){
    difference(){
        open_box(
            width=width, 
            depth=depth, 
            height=height, 
            wall_thickness=wall_thickness,
            center=center,
            chamfer=chamfer
        );
        hole_trans_z_top = -1*hole_height/2 + height + wall_thickness + eps;
        hole_trans_z_bottom = hole_height/2 - eps;
        //top
        translate([wall_thickness/2*1.15, wall_thickness/2*1.15, hole_trans_z_top]){
            cylinder(h=hole_height, r=hole_radius, center=true);
        }
        translate([width + wall_thickness + wall_thickness/2*0.85, wall_thickness/2*1.15, hole_trans_z_top]){
            cylinder(h=hole_height, r=hole_radius, center=true);
        }
        
        //bottom
        translate([wall_thickness/2*1.15, wall_thickness/2*1.15, hole_trans_z_bottom]){
            cylinder(h=hole_height, r=hole_radius, center=true);
        }
        translate([width + wall_thickness + wall_thickness/2*0.85, wall_thickness/2*1.15, hole_trans_z_bottom]){
            cylinder(h=hole_height, r=hole_radius, center=true);
        }
        
    } 
}
    

