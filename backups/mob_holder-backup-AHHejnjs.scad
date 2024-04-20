include <BOSL2/std.scad>
use <primitives/boxes.scad>
$fn=25;
eps = 0.001;
//

// Regular Mob box
token_magnet_box(
    width=90, 
    height=32, 
    depth=114, 
    wall_thickness=3.3,
    hole_radius=2.5*1.10,
    hole_height=3*1.01,
    chamfer=0.5
);

//translate([0, 0, 35.3 ]){
//    box_with_corner_magnets_top(
//        width=90, 
//        height=32, 
//        depth=114, 
//        wall_thickness=3.3,
//        hole_radius=2.5*1.10,
//        hole_height=3*1.01,
//        chamfer=0.5
//    );
//}




module token_magnet_box(
    width,
    height,
    depth,
    wall_thickness,
    hole_radius,
    hole_height,
    chamfer,
)
{
       
    box_with_corner_magnets(
        width=width, 
        height=height, 
        depth=depth, 
        wall_thickness=wall_thickness,
        hole_radius=hole_radius,
        hole_height=hole_height,
        add_fillets=true,
        chamfer=chamfer
    ); 
    
//    fillet_trans_x_left = wall_thickness;
//    fillet_trans_y = depth/2 + wall_thickness;
//    fillet_trans_z = wall_thickness;
//    translate([fillet_trans_x_left, fillet_trans_y, fillet_trans_z]){
//        rotate([90, 0, 0]){
//            fillet(l=depth, r=height, ang=90);
//        }
//    }
//    fillet_trans_x_right = wall_thickness + width;
//    translate([fillet_trans_x_right, fillet_trans_y, fillet_trans_z]){
//        rotate([90, 0, 180]){
//            fillet(l=depth, r=height, ang=90);
//        }
//    }
        
}