include <BOSL2/std.scad>
use <snap_joints/cantilever.scad>
include <BOSL2/hinges.scad>
$fn=32;
eps=0.001;


open_box(
    width=10, depth=15, height=5, 
    wall_thickness=1, 
    left_wall_thickness=5,
    front_wall_thickness=0,
    bottomless=true, chamfer=0, center=true
);

//translate([25, 0, 0]){
//difference (){
//open_box_with_lip(
//    width=10, depth=15, 
//    outer_height=8, 
//    inner_height=4, 
//    outer_wall_thickness=2, 
//    inner_wall_thickness=5, 
//    chamfer=.5, 
//    center=false
//);
//translate([0, -1 * 10, 0])
//cube([20, 5, 10], center=true);
//}

//closed_box_with_hinge_bottom(
//    width=60, 
//    depth=15, 
//    outer_height=10, 
//    inner_height=4, 
//    outer_wall_thickness=2, 
//    inner_wall_thickness=5,
//    back_outer_wall_thickness=3.5,
//    chamfer=.5, 
//    center=false
//);
//
//translate([60 + 2 + 2, 0, 14 + 2 + 10 + 2 ])
//rotate([0, 180, 0])
////translate([70, 0, 0])
//closed_box_with_hinge_top(
//    height=14,
//    bot_width=60, 
//    bot_depth=15, 
//    bot_outer_height=10, 
//    bot_inner_height=4, 
//    bot_outer_wall_thickness=2,
//    bot_inner_wall_thickness=5,
//    bot_back_outer_wall_thickness=3.5, 
//    chamfer=.5, 
//    center=false
//);


//cuboid([20,40,2])
//  position(TOP+RIGHT) orient(anchor=RIGHT)
//    knuckle_hinge(length=35, segs=3, offset=3, arm_height=0,
//          arm_angle=90, pin_fn=8, clear_top=true);

//cuboid([outer_wall_thickness,width,inner_height]){
//          yflip_copy()
//            position(TOP+RIGHT+FRONT) orient(anchor=RIGHT)
//              knuckle_hinge(length=12, segs=2, offset=2, arm_height=2,
//                    anchor=BOT+LEFT);
//        //  attach(TOP,TOP) color("green")
//        //    cuboid([2,40,15],anchor=TOP)
//        //      yflip_copy()
//        //        position(TOP+LEFT+FRONT) orient(anchor=LEFT)
//        //          knuckle_hinge(length=12, segs=2, offset=2, arm_height=0,
//        //                inner=true, anchor=BOT+RIGHT);
//         }


//translate([19.5, 12, 5])
//cube([5, 5, 5], center=true);



module closed_box_with_hinge_bottom(
    width, 
    depth, 
    outer_height, 
    inner_height, 
    outer_wall_thickness, 
    inner_wall_thickness,
    back_outer_wall_thickness=0, 
    center=false, 
    pin_diam=1.75 + 0.5,
    hinge_top_clearance=0.0,
    filler_clearance=0,
    chamfer=0
) {
    back_inner_wall_thickness = 0; //DONT CHANGE: top doesn't know about this
    back_outer_wall_thickness = back_outer_wall_thickness > 0 ? back_outer_wall_thickness : outer_wall_thickness;
    full_width = width + outer_wall_thickness*2;
    full_depth = depth + outer_wall_thickness + back_outer_wall_thickness + inner_wall_thickness + back_inner_wall_thickness;
    full_height = outer_height + outer_wall_thickness;
    
    outer_box_width = width;
    outer_box_depth = depth + inner_wall_thickness + back_inner_wall_thickness;
    outer_box_height = outer_height;
    
    hinge_offset=3;
    knuckle_diam = 5;
    hinge_height = knuckle_diam+ (hinge_offset - (knuckle_diam/2));
    
    full_trans_x = center ? -1*full_width/2 : 0;
    full_trans_y = center ? -1*full_depth/2 : 0;
    full_trans_z = center ? -1*full_height/2 : 0;
    
    translate([full_trans_x, full_trans_y, full_trans_z]){
        union(){
            difference(){
                open_box(
                    width=outer_box_width,
                    depth=outer_box_depth,
                    height=outer_box_height,
                    wall_thickness=outer_wall_thickness,
                    back_wall_thickness=back_outer_wall_thickness,
                    chamfer=chamfer,
                    center=false
                );
                
                back_chop_width = full_width + eps*3;
                back_chop_depth = back_outer_wall_thickness  +eps*2;
                back_chop_height = hinge_height + hinge_top_clearance + eps*2;//outer_height - inner_height + eps;
                back_chop_trans_x = 0;
                back_chop_trans_y = full_depth - back_chop_depth + eps;
                back_chop_trans_z = outer_height + outer_wall_thickness - back_chop_height + eps;//inner_height + outer_wall_thickness;
                translate([back_chop_trans_x, back_chop_trans_y, back_chop_trans_z]){
                    cube([back_chop_width, back_chop_depth, back_chop_height], center=false);
                }
            }
            
            inner_box_width = width;
            inner_box_depth = depth;
            inner_box_height = inner_height;
            inner_trans_x = outer_wall_thickness;
            inner_trans_y = outer_wall_thickness;
            inner_trans_z = outer_wall_thickness;
            translate([inner_trans_x, inner_trans_y, inner_trans_z]){
                open_box(
                    width=inner_box_width,
                    depth=inner_box_depth,
                    height=inner_box_height,
                    wall_thickness=inner_wall_thickness,
                    left_wall_thickness=0,
                    right_wall_thickness=0,
                    back_wall_thickness=back_inner_wall_thickness,
                    bottomless=true,
                    chamfer=0,
                    center=false
                );
            }
            
            hinge_width=width/4;
            hinge_trans_x_1 = outer_wall_thickness/2;//full_width - outer_wall_thickness;
            hinge_trans_x_2 = full_width - (outer_wall_thickness/2) - hinge_width;
            //hinge_trans_x = full_width - outer_wall_thickness;
            hinge_trans_y = depth + outer_wall_thickness + inner_wall_thickness + back_inner_wall_thickness - eps;
            hinge_trans_z = outer_height + outer_wall_thickness - hinge_height - hinge_top_clearance - eps;//inner_height + outer_wall_thickness - eps;
            translate([hinge_trans_x_1, hinge_trans_y, hinge_trans_z]){
                //rotate([0, 0, 180])
                knuckle_hinge(
                    length=hinge_width, 
                    knuckle_diam=knuckle_diam,
                    pin_diam=pin_diam,
                    segs=3, 
                    offset=3, 
                    arm_height=0,
                    arm_angle=90, 
                    pin_fn=8, 
                    clear_top=true, 
                    anchor=FRONT+LEFT+BOTTOM
                );
            }
            translate([hinge_trans_x_2, hinge_trans_y, hinge_trans_z]){
                //rotate([0, 0, 180])
                knuckle_hinge(
                    length=hinge_width,
                    knuckle_diam=knuckle_diam,
                    pin_diam=pin_diam,
                    segs=3, 
                    offset=3, 
                    arm_height=0,
                    arm_angle=90, 
                    pin_fn=8, 
                    clear_top=true, 
                    anchor=FRONT+LEFT+BOTTOM
                );
            }
            filler_width = full_width - hinge_width*2 - (outer_wall_thickness/2)*2 - filler_clearance + eps*2;
            filler_depth = back_outer_wall_thickness + back_inner_wall_thickness;
            filler_height = knuckle_diam;
            filler_trans_x = full_width/2 - filler_width/2;
            filler_trans_y = depth + outer_wall_thickness + inner_wall_thickness + back_inner_wall_thickness;
            filler_trans_z = outer_height + outer_wall_thickness - hinge_height - hinge_top_clearance - eps;//inner_height + outer_wall_thickness - eps;
            translate([filler_trans_x, filler_trans_y, filler_trans_z]){
                cube([filler_width, filler_depth, filler_height], center=false);
            }
        }
    }
}

module closed_box_with_hinge_top(
    height,
    bot_width, 
    bot_depth, 
    bot_outer_height, 
    bot_inner_height, 
    bot_outer_wall_thickness, 
    bot_inner_wall_thickness,
    bot_back_outer_wall_thickness=0,
    center=false, 
    pin_diam=1.75 + 0.35,
    bot_hinge_top_clearance=0.0,
    chamfer=0
) {
    
    bot_back_outer_wall_thickness = bot_back_outer_wall_thickness > 0 ? bot_back_outer_wall_thickness : bot_outer_wall_thickness;

    full_width = bot_width + bot_outer_wall_thickness*2;
    full_depth = bot_depth + bot_inner_wall_thickness*2 + bot_outer_wall_thickness + bot_back_outer_wall_thickness;
    full_height = height + 5; //todo
    
    box_width = bot_width;
    box_depth = bot_depth + bot_inner_wall_thickness;
    box_height = height;
    
    full_trans_x = center ? -1*full_width/2 : 0;
    full_trans_y = center ? -1*full_depth/2 : 0;
    full_trans_z = center ? -1*full_height/2 : 0;
    
    translate([full_trans_x, full_trans_y, full_trans_z]){ 
        union(){
            open_box(
                width=box_width,
                depth=box_depth,
                height=box_height,
                wall_thickness=bot_outer_wall_thickness,
                back_wall_thickness=bot_back_outer_wall_thickness,
                chamfer=chamfer,
                center=false
            );
            
            bot_hinge_offset = 3; //TODO: un hard code
            bot_knuckle_diam = 4;
            bot_hinge_height = bot_knuckle_diam+ (bot_hinge_offset - (bot_knuckle_diam/2));

            knuckle_diam = 5;
            hinge_offset = 0.5 + bot_hinge_top_clearance + knuckle_diam/2;
            hinge_width = bot_width/4;
            //how much to extend above top walls
            //hinge_extension_height = (bot_outer_height + bot_outer_wall_thickness-1) - (bot_inner_height + bot_outer_wall_thickness - eps);
            hinge_trans_x_1 = bot_outer_wall_thickness/2;//bot_width + bot_outer_wall_thickness;
            hinge_trans_x_2 = full_width - bot_outer_wall_thickness/2 - hinge_width;
            hinge_trans_y = bot_depth + bot_outer_wall_thickness + bot_inner_wall_thickness -eps;
            hinge_trans_z = height + bot_outer_wall_thickness;// - (hinge_offset - hinge_extension_height);
            translate([hinge_trans_x_1, hinge_trans_y, hinge_trans_z]){
                //rotate([0,0,0])
                knuckle_hinge(
                    length=hinge_width,
                    knuckle_diam=knuckle_diam,
                    pin_diam=pin_diam,
                    segs=3,
                    offset=hinge_offset, 
                    arm_height=0,
                    arm_angle=90, 
                    pin_fn=8,
                    clear_top=true, 
                    anchor=FRONT+LEFT+BOTTOM, 
                    inner=true
                );
            }
            translate([hinge_trans_x_2, hinge_trans_y, hinge_trans_z]){
                //rotate([0,0,0])
                knuckle_hinge(
                    length=hinge_width,
                    knuckle_diam=knuckle_diam,
                    pin_diam=pin_diam,
                    segs=3,
                    offset=hinge_offset, 
                    arm_height=0,
                    arm_angle=90, 
                    pin_fn=8,
                    clear_top=true, 
                    anchor=FRONT+LEFT+BOTTOM, 
                    inner=true
                );
            }
            
        }
    }
}


module box_with_corner_magnets(
    width, 
    depth, 
    height, 
    wall_thickness, 
    hole_radius=2.5,
    hole_height=3,
    center=false, 
    add_fillets=false,
    chamfer=0,
 ){
    difference(){
        open_box(
            width=width, 
            depth=depth, 
            height=height, 
            wall_thickness=wall_thickness,
            center=center,
            add_fillets=add_fillets,
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

module box_with_corner_magnets_top(
    width, 
    depth, 
    height, 
    wall_thickness, 
    hole_radius=2.5,
    hole_height=3,
    center=false, 
    add_fillets=false,
    chamfer=0,
 ){
     
    full_width = width + wall_thickness*2;
    full_depth = depth + wall_thickness*2;

    difference(){
        translate([full_width/2, full_depth/2, wall_thickness/2]){
            cuboid([full_width, full_depth, wall_thickness], chamfer=chamfer);
        }
        hole_trans_z_bottom = hole_height/2 - eps;
        
        x_trans_left = hole_radius*1.2;//wall_thickness/2*1.15;
        x_trans_right = width + wall_thickness*2 - hole_radius*1.2;//wall_thickness + wall_thickness/2*0.85;
        y_trans_front =  hole_radius*1.2;//wall_thickness/2*1.15;
        y_trans_back = depth + wall_thickness*2 - hole_radius*1.2;// + wall_thickness/2*0.85;
        
        
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



module open_box_with_lip(
    width, 
    depth, 
    outer_height, 
    inner_height, 
    outer_wall_thickness, 
    inner_wall_thickness,
    left_inner_wall_thickness=-1,
    right_inner_wall_thickness=-1,
    back_inner_wall_thickness=-1,
    front_inner_wall_thickness=-1,
    center=false, 
    chamfer=0
) {
    right_inner_wall_thickness = right_inner_wall_thickness >= 0 ? right_inner_wall_thickness : inner_wall_thickness;
    left_inner_wall_thickness = left_inner_wall_thickness >= 0 ? left_inner_wall_thickness : inner_wall_thickness;
    front_inner_wall_thickness = front_inner_wall_thickness >= 0 ? front_inner_wall_thickness : inner_wall_thickness;
    back_inner_wall_thickness = back_inner_wall_thickness >= 0 ? back_inner_wall_thickness : inner_wall_thickness;
    
    full_width = width + outer_wall_thickness*2 + left_inner_wall_thickness + right_inner_wall_thickness;
    full_depth = depth + outer_wall_thickness*2 + back_inner_wall_thickness + front_inner_wall_thickness;
    full_height = outer_height + outer_wall_thickness;
        
    inner_trans_x = outer_wall_thickness;
    inner_trans_y = outer_wall_thickness;
    inner_trans_z = outer_wall_thickness;
    
    center_trans_x = center ? full_width/2 : 0;
    center_trans_y = center ? full_depth/2 : 0;
    center_trans_z = center ? full_height/2 : 0;
    
    outer_width = width + left_inner_wall_thickness + right_inner_wall_thickness;
    outer_depth = depth + back_inner_wall_thickness + front_inner_wall_thickness;
    
    translate([center_trans_x, center_trans_y, center_trans_z])
    union() {
        open_box(
            width=outer_width, 
            depth=outer_depth, 
            height=outer_height, 
            wall_thickness=outer_wall_thickness, 
            chamfer=chamfer, 
            center=false
        );
        translate([inner_trans_x, inner_trans_y, inner_trans_z])
            open_box(
                width=width + eps, 
                depth=depth+ eps, 
                height=inner_height, 
                wall_thickness=inner_wall_thickness,
                left_wall_thickness=left_inner_wall_thickness,
                right_wall_thickness=right_inner_wall_thickness,
                back_wall_thickness=back_inner_wall_thickness,
                front_wall_thickness=front_inner_wall_thickness,
                chamfer=0, 
                bottomless=true, 
                center=false
            );
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
    bottomless=false,
    add_fillets=false
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
    
    global_width = full_width;
    global_depth = full_depth;
    global_height = bottomless ? (full_height - bottom_wall_thickness) : full_height;

    actual_height = bottomless ? full_height - bottom_wall_thickness*2 : full_height - bottom_wall_thickness;
    bottomless_shift = bottomless ? -1*bottom_wall_thickness : 0;
    full_shift_x = center ? -1*full_width/2 : 0;
    full_shift_y = center ? -1*full_depth/2 : 0;
    center_shift_z = center ? -1*actual_height/2 : 0; 
    full_shift_z = center_shift_z + bottomless_shift;
    
    translate([full_shift_x, full_shift_y, full_shift_z])
    {
        union(){
            difference(){    
                cuboid(
                    [full_width, full_depth, full_height], 
                    chamfer=chamfer, 
                    anchor=FRONT + BOTTOM + LEFT
                );
                
                //cut out middle
                mid_chop_shift_x = full_width/2 + (left_wall_thickness - right_wall_thickness)/2;
                mid_chop_shift_y = full_depth/2 + (front_wall_thickness - back_wall_thickness)/2;
                mid_chop_shift_z = height/2 + bottom_wall_thickness;
                translate([mid_chop_shift_x, mid_chop_shift_y, mid_chop_shift_z]){
                    cube([width+eps, depth+eps, height+eps], anchor=CENTER);
                }
                
                //chop off top
                top_chop_shift_x = full_width/2;
                top_chop_shift_y = full_depth/2;
                top_chop_shift_z = bottom_wall_thickness/2 + full_height - bottom_wall_thickness;
                translate([top_chop_shift_x, top_chop_shift_y, top_chop_shift_z]){
                    cube([full_width+eps, full_depth+eps, bottom_wall_thickness+eps],anchor=CENTER);
                }
                
                // chop off bottom
                if (bottomless) {
                    bot_chop_shift_x = full_width/2;
                    bot_chop_shift_y = full_depth/2;
                    bot_chop_shift_z = bottom_wall_thickness/2;
                    translate([bot_chop_shift_x, bot_chop_shift_y, bot_chop_shift_z]){
                        cube([full_width, full_depth, wall_thickness + eps],anchor=CENTER);
                    }
                
                } 
            }
            if (add_fillets){
                    fillet_trans_x_left = wall_thickness;
                    fillet_trans_y = depth/2 + wall_thickness;
                    fillet_trans_z = wall_thickness;
                    translate([fillet_trans_x_left, fillet_trans_y, fillet_trans_z]){
                        rotate([90, 0, 0]){
                            fillet(l=depth, r=height*0.5, ang=90);
                        }
                    }
                    fillet_trans_x_right = wall_thickness + width;
                    translate([fillet_trans_x_right, fillet_trans_y, fillet_trans_z]){
                        rotate([90, 0, 180]){
                            fillet(l=depth, r=height*0.5, ang=90);
                        }
                    }          
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


