include <BOSL2/std.scad>
use <primitives/boxes.scad>
$fn=25;
eps = 0.001;
//

// Regular Mob box
 box_with_corner_magnets(
    width=114, 
    height=32, 
    depth=114, 
    wall_thickness=3.3,
    hole_radius=2.5*1.10,
    hole_height=3*1.01,
    chamfer=0.5
);
//
//magnet_stand(
//    width=20,
//    stand_height=15,
//    stand_thickness=2.5,
//    base_depth=10,
//    base_thickness=2
//);

default_magnet_radius=2.5*1.1;
default_magnet_height=2*1.125;

// Fallen Angels and Demons
//magnet_stand(
//    width=80,
//    stand_height=153,
//    stand_thickness=2.5,
//    base_depth=50,
//    base_thickness=5,
//    magnet_locs=[
//        [27, 32],
//        [22, 80],
//        [23, 113],
//        [59, 41],
//        [58, 81],
//        [52, 123]
//    ]
//);



module magnet_stand(
    width,
    stand_height,
    stand_thickness,
    base_depth,
    base_thickness,
    magnet_locs=[[10, 10]]
){
    /*
    
    Args:
        magnet_locs: List of lists. Length of outer list is number of 
            magnets. Each inner list should be length 2, the position
            of the magnet. Positions are (x, y), where (0,0) is the
            bottom left of the stand. the x axis is along the width,
            the y axis is along the height. 
    */
difference(){
    union(){
        //base
        translate([width/2,base_depth/2,base_thickness/2]){
            cube([width, base_depth, base_thickness], center=true);
        }
        
        //stand
        translate([width/2,stand_thickness/2 + base_depth*0.8,stand_height/2 + base_thickness - eps]){
            cube([width, stand_thickness, stand_height], center=true); 
        }
    }
    
    for (magnet_loc = magnet_locs){
        translate([magnet_loc[0], base_depth*0.8 + stand_thickness - default_magnet_height, magnet_loc[1]]){
            vertical_magnet_cylinder();
        }      
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
        
        x_trans_left = hole_radius*1.2;//wall_thickness/2*1.15;
        x_trans_right = width + wall_thickness*2 - hole_radius*1.2;//wall_thickness + wall_thickness/2*0.85;
        y_trans_front =  hole_radius*1.2;//wall_thickness/2*1.15;
        y_trans_back = depth + wall_thickness*2 - hole_radius*1.2;// + wall_thickness/2*0.85;
        //top
        translate([x_trans_left, y_trans_front, hole_trans_z_top]){
            cylinder(h=hole_height, r=hole_radius, center=true);
        }
        translate([x_trans_right, y_trans_front, hole_trans_z_top]){
            cylinder(h=hole_height, r=hole_radius, center=true);
        }
        translate([x_trans_left, y_trans_back, hole_trans_z_top]){
            cylinder(h=hole_height, r=hole_radius, center=true);
        }
        translate([x_trans_right, y_trans_back, hole_trans_z_top]){
            cylinder(h=hole_height, r=hole_radius, center=true);
        }
        //bottom
        translate([x_trans_left, y_trans_front, hole_trans_z_bottom]){
            cylinder(h=hole_height, r=hole_radius, center=true);
        }
        translate([x_trans_right, y_trans_front, hole_trans_z_bottom]){
            cylinder(h=hole_height, r=hole_radius, center=true);
        }
        translate([x_trans_left, y_trans_back, hole_trans_z_bottom]){
            cylinder(h=hole_height, r=hole_radius, center=true);
        }
        translate([x_trans_right, y_trans_back, hole_trans_z_bottom]){
            cylinder(h=hole_height, r=hole_radius, center=true);
        }
        
    } 
}
    

