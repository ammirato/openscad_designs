use <BOSL2/std.scad>
use <snap_joints/cantilever.scad>
eps=0.001;

//translate([0, 0,0])
//open_box(width=10, depth=15, height=20, wall_thickness=1, chamfer=0, center=true, bottomless=false);

//translate([-5,0,0])
//open_box(width=10, depth=15, height=5, wall_thickness=1, bottomless=true, chamfer=0);

//translate([25, 0, 0]){
//difference (){
//open_box_with_lip(width=10, depth=15, outer_height=8, inner_height=4, outer_wall_thickness=2, inner_wall_thickness=5, chamfer=.5, center=false);
//translate([0, -1 * 10, 0])
//cube([20, 5, 10], center=true);
//}
//}

closed_box_with_hinge(
    width=10, 
    depth=15, 
    outer_height=8, 
    inner_height=4, 
    outer_wall_thickness=2, 
    inner_wall_thickness=5, 
    chamfer=.5, 
    center=false
);



//translate([19.5, 12, 5])
//cube([5, 5, 5], center=true);



module closed_box_with_hinge(width, depth, outer_height, inner_height, outer_wall_thickness, inner_wall_thickness, center=false, chamfer=0) {
    
    outer_wall_offset = (inner_wall_thickness*2);
    
    inner_trans_z_center = -1* ((outer_height - inner_height) /2  + eps);
    inner_trans_z_no_center = outer_wall_thickness  + eps;
    inner_trans_z = center ? inner_trans_z_center : inner_trans_z_no_center;
    
    inner_trans_x = center ? 0 : outer_wall_thickness;
    inner_trans_y = center ? 0 : outer_wall_thickness;
    
    union() {
        open_box(width=width, depth=depth+outer_wall_offset, height=outer_height, wall_thickness=outer_wall_thickness, chamfer=chamfer, center=center);
        translate([inner_trans_x, inner_trans_y, inner_trans_z])
        open_box(
            width=width + eps, 
            depth=depth+ eps, 
            height=inner_height, 
            wall_thickness=inner_wall_thickness, 
            chamfer=0, 
            bottomless=true, 
            left_wall_thickness=0,
            right_wall_thickness=0,
            center=center
        );

    }
    }


module open_box_with_lip(width, depth, outer_height, inner_height, outer_wall_thickness, inner_wall_thickness, center=false, chamfer=0) {
    
    outer_wall_offset = (inner_wall_thickness*2);
    
    inner_trans_z_center = -1* ((outer_height - inner_height) /2  + eps);
    inner_trans_z_no_center = outer_wall_thickness  + eps;
    inner_trans_z = center ? inner_trans_z_center : inner_trans_z_no_center;
    
    inner_trans_x = center ? 0 : outer_wall_thickness;
    inner_trans_y = center ? 0 : outer_wall_thickness;
    
    union() {
        open_box(width=width+outer_wall_offset, depth=depth+outer_wall_offset, height=outer_height, wall_thickness=outer_wall_thickness, chamfer=chamfer, center=center);
        translate([inner_trans_x, inner_trans_y, inner_trans_z])
        open_box(width=width + eps, depth=depth+ eps, height=inner_height, wall_thickness=inner_wall_thickness, chamfer=0, bottomless=true, center=center);

    }
    }




module open_box(
    width, 
    depth, 
    height, 
    wall_thickness, 
    center=false, 
    chamfer=0,
    right_wall_thickness=-1,
    left_wall_thickness=-1,
    front_wall_thickness=-1,
    back_wall_thickness=-1,
    bottom_wall_thickness=-1, 
    bottomless=false
){
/* A box without a top (or optionally without a bottom).
    
    width: width of the inside (not the outside walls)
    depth: same as width.
    height: same as height
    wall_thickness: 
*/
    
    right_wall_thickness = right_wall_thickness >= 0 ? right_wall_thickness : wall_thickness;
    left_wall_thickness = left_wall_thickness >= 0 ? left_wall_thickness : wall_thickness;
    front_wall_thickness = front_wall_thickness >= 0 ? front_wall_thickness : wall_thickness;
    back_wall_thickness = back_wall_thickness >= 0 ? back_wall_thickness : wall_thickness;
    bottom_wall_thickness = bottom_wall_thickness >= 0 ? bottom_wall_thickness : wall_thickness;    
    
    full_width = width + left_wall_thickness + right_wall_thickness + eps;
    full_depth =  depth + front_wall_thickness + back_wall_thickness + eps;
    full_height = height + bottom_wall_thickness*2 + eps;
    
    trans_z_no_center = bottomless ? (full_height/2 - bottom_wall_thickness) : (full_height/2);
    trans_z_center = bottomless ? 0 : bottom_wall_thickness/2;
    trans_z = center ? trans_z_center : trans_z_no_center;
    
    trans_x = center ? 0 : full_width/2;
    trans_y = center ? 0 : full_depth/2;

    translate([trans_x,trans_y,trans_z])
    difference() { 
        //this is centered by default.
         cuboid([full_width, full_depth, full_height], chamfer=chamfer);
        
        //cut out middle
        shift_x = (left_wall_thickness - right_wall_thickness)/2;
        shift_y = (back_wall_thickness - front_wall_thickness)/2;
        translate([shift_x, shift_y, 0]){
            cube([width+eps, depth+eps, height+eps], center=true);
        }
        
        
        chop_trans_z = height/2 + bottom_wall_thickness/2 ;
        //chop off top
        translate([0,0,chop_trans_z]){
            cube([full_width, full_depth, bottom_wall_thickness + eps],center=true);
        }
        
        // chop off bottom
        if (bottomless) {
            translate([0,0, -1 * chop_trans_z]){
                cube([full_width, full_depth, wall_thickness + eps],center=true);
            }
        
        }
    }
}

module translate_pos_neg(x_dist, y_dist, z_dist, pos) {
    
    if (pos){
        translate([x_dist, y_dist, z_dist])
        children();
    }
    else{
        translate([-1*x_dist, -1*y_dist, -1*z_dist])
        children();
    }
}



//    union(){
//        bottom(width=width, depth=depth, wall_thickness=wall_thickness, chamfer=chamfer);
//        depth_side(right=true, height=height, depth=depth, wall_thickness=wall_thickness, box_width=width, chamfer=chamfer);
//        depth_side(right=false, height=height, depth=depth, wall_thickness=wall_thickness, box_width=width, chamfer=chamfer);
//        width_side(front=true, width=width, height=height, wall_thickness=wall_thickness, box_depth=depth, chamfer=chamfer);
//        width_side(front=false, width=width, height=height, wall_thickness=wall_thickness, box_depth=depth, chamfer=chamfer);
//    }
//module bottom(width, depth, wall_thickness, chamfer=0) {
//    cuboid([width + (wall_thickness * 2), depth + (wall_thickness * 2), wall_thickness], chamfer=chamfer);
//}
//
//
//module width_side(front, width, height, wall_thickness, box_depth, chamfer=0) {
//    y_translate_dist = box_depth/2 + wall_thickness/2;
//    translate_pos_neg(x_dist=0, y_dist=y_translate_dist,z_dist=0, pos=front)
//
//    translate([0, 0, (height/2) + wall_thickness/2])
//    rotate([90, 0, 0])
//    cuboid([width + (wall_thickness*2), height, wall_thickness],  chamfer=chamfer);
//}
//
//module depth_side(right, height, depth, wall_thickness, box_width, chamfer=0) {
//    x_translate_dist = box_width/2 + wall_thickness/2;
//    translate_pos_neg(x_dist=x_translate_dist, y_dist=0,z_dist=0, pos=right)
//
//    translate([0, 0, (height/2) + wall_thickness/2])
//    rotate([0, 90, 0])
//    cuboid([height, depth, wall_thickness], chamfer=chamfer);
//}


