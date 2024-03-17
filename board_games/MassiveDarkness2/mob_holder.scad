include <BOSL2/std.scad>
use <primitives/boxes.scad>
$fn=25;
eps = 0.001;
//
// box_with_corner_magnets(
//    width=20, 
//    height=10, 
//    depth=10, 
//    wall_thickness=5,
//    hole_radius=2.5*1.05,
//    hole_height=3*1.05,
//    chamfer=0.5
//);

magnet_stand(
    width=20,
    stand_height=15,
    stand_thickness=2.5,
    base_depth=10,
    base_thickness=2
);

default_magnet_radius=2.5*1.1;
default_magnet_height=2*1.125;


module magnet_stand(
    width,
    stand_height,
    stand_thickness,
    base_depth,
    base_thickness,
){
difference(){
    union(){
        //base
        translate([width/2,base_depth/2,base_thickness/2]){
            cube([width, base_depth, base_thickness], center=true);
        }
        
        //stand
        translate([width/2,stand_thickness/2 + base_depth*0.7,stand_height/2]){
            cube([width, stand_thickness, stand_height], center=true); 
        }
    }
    translate([width/4,base_depth*0.7 + stand_thickness - default_magnet_height,stand_height/1.3]){
        vertical_magnet_cylinder();
    }
    translate([width*3/4,base_depth*0.7 + stand_thickness - default_magnet_height,stand_height/1.3]){
        vertical_magnet_cylinder();
    }
}
}


module vertical_magnet_cylinder(
    height=default_magnet_height,
    radius=default_magnet_radius,
    center=true
){
    translate([0, height/2, 0]){
    rotate([90, 0, 0]){
    magnet_cylinder(height=height, radius=radius, center=center);
    }
}
}

module magnet_cylinder(
    height=default_magnet_height,
    radius=default_magnet_radius,
    center=true
){
    cylinder(h=height, r=radius, center=center);
}




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
    

