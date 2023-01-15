use <BOSL2/std.scad>

use <primitives/prisms.scad>

eps=0.001;

//main box params
width = 10;
depth = 20;
height = 10;
wall_thickness = 1;
chamfer=0;
outer_height=height;
inner_height= 0.8*outer_height;
outer_wall_thickness=wall_thickness;
inner_wall_thickness=wall_thickness;


//snap fit params
snap_male_width=2;
stem_height=6;
stem_depth=1;
snap_block_height=1.5;
snap_block_depth=outer_wall_thickness;
snap_female_tol=0.5;
stem_in_lid_dist=0;
stem_in_bottom_dist = stem_height - stem_in_lid_dist- snap_block_height- snap_female_tol/2;



rotate([0,0,90]){
box_bottom();
}

//lid
//translate([0, width+wall_thickness*3 + 30, 0]){
//    rotate([0,0,90]){
//        box_lid();
//    }
//}

//translate([0,width + wall_thickness*3 + 30,0])
translate([0, width*2+10, wall_thickness/2])
 rotate([0,0,90]){
        box_lid();
    }



module box_bottom () {
    
difference() {
    //open_box_with_lip(width=width, depth=depth, height=height, wall_thickness=wall_thickness, chamfer=chamfer);
    open_box_with_lip(width=width, depth=depth, outer_height=outer_height, inner_height=inner_height, outer_wall_thickness=outer_wall_thickness, inner_wall_thickness=inner_wall_thickness, chamfer=chamfer);

    
    cut_depth = inner_wall_thickness + outer_wall_thickness;
    cut_height =  snap_block_height + snap_female_tol ;
    cut_trans_x = width/2 + cut_depth/2;
    cut_trans_z = inner_height - cut_height/2 + inner_wall_thickness/2;// - wall_thickness/2 - stem_in_bottom_dist;//-wall_thickness-snap_female_tol - stem_in_bottom_dist;
    //cut openings for snap fit
    translate([cut_trans_x, 0, cut_trans_z]) {
        rotate([0, 0, 90]){
            cube([snap_male_width + snap_female_tol, cut_depth,cut_height], center=true);
        }
    }
    translate([-1*(cut_trans_x), 0, cut_trans_z]) {
        rotate([0, 0, 90]){
            cube([snap_male_width + snap_female_tol, cut_depth, cut_height ], center=true);
        }
    }
}
}


module box_lid () {

union(){
    open_box_with_lip(width=width, depth=depth, outer_height=outer_height, inner_height=inner_height, outer_wall_thickness=outer_wall_thickness, inner_wall_thickness=inner_wall_thickness, chamfer=chamfer);

    
    snap_trans_x = width/2 + stem_depth/2 + eps;// + inner_wall_thickness - stem_depth/2 + eps;
    snap_trans_z = inner_height+ stem_height/2 - stem_in_lid_dist + wall_thickness/2;
    
    translate([snap_trans_x, 0, snap_trans_z]){
        rotate([0, 0, -90])
        snap_fit_male(width=snap_male_width, stem_height=stem_height, stem_depth=stem_depth, block_height=snap_block_height, block_depth=snap_block_depth);
    }
    translate([-1*snap_trans_x, 0,snap_trans_z]){
        rotate([0, 0, 90])
        snap_fit_male(width=snap_male_width, stem_height=stem_height, stem_depth=stem_depth, block_height=snap_block_height, block_depth=snap_block_depth);
    }
}
} 
   


module open_box_with_lip(width, depth, outer_height, inner_height, outer_wall_thickness, inner_wall_thickness, chamfer=0) {
    
union() {
    open_box(width=width+(inner_wall_thickness*2), depth=depth+(inner_wall_thickness*2), height=outer_height, wall_thickness=outer_wall_thickness, chamfer=chamfer);
    //open_box(width=width-outer_wall_thickness, depth=depth-outer_wall_thickness, height=inner_height, wall_thickness=inner_wall_thickness, chamfer=chamfer);
    open_box(width=width, depth=depth, height=inner_height, wall_thickness=inner_wall_thickness, chamfer=chamfer);

}
}




module open_box(width, depth, height, wall_thickness, chamfer=0){

    union(){
        bottom(width=width, depth=depth, wall_thickness=wall_thickness, chamfer=chamfer);
        depth_side(right=true, height=height, depth=depth, wall_thickness=wall_thickness, box_width=width, chamfer=chamfer);
        depth_side(right=false, height=height, depth=depth, wall_thickness=wall_thickness, box_width=width, chamfer=chamfer);
        width_side(front=true, width=width, height=height, wall_thickness=wall_thickness, box_depth=depth, chamfer=chamfer);
        width_side(front=false, width=width, height=height, wall_thickness=wall_thickness, box_depth=depth, chamfer=chamfer);
    }
}

module bottom(width, depth, wall_thickness, chamfer=0) {
    cuboid([width + (wall_thickness * 2), depth + (wall_thickness * 2), wall_thickness], chamfer=chamfer);
}


module width_side(front, width, height, wall_thickness, box_depth, chamfer=0) {
    y_translate_dist = box_depth/2 + wall_thickness/2;
    translate_pos_neg(x_dist=0, y_dist=y_translate_dist,z_dist=0, pos=front)

    translate([0, 0, (height/2) + wall_thickness/2])
    rotate([90, 0, 0])
    cuboid([width + (wall_thickness*2), height, wall_thickness],  chamfer=chamfer);
}

module depth_side(right, height, depth, wall_thickness, box_width, chamfer=0) {
    x_translate_dist = box_width/2 + wall_thickness/2;
    translate_pos_neg(x_dist=x_translate_dist, y_dist=0,z_dist=0, pos=right)

    translate([0, 0, (height/2) + wall_thickness/2])
    rotate([0, 90, 0])
    cuboid([height, depth, wall_thickness], chamfer=chamfer);
}



module snap_fit_male(width, stem_height, stem_depth, block_height, block_depth){

union() {
    //stem
    cube([width, stem_depth, stem_height], center=true);

    translate([0, block_depth/2 + stem_depth/2, stem_height/2 - block_height/2]){
        rotate([0,0,90])
        rotate([0, 90, 0])
            trapezoid_prism(width_lower=block_height, width_upper=block_height/2, depth=width, height=block_depth, center=true, square_right=true);
    }
}
}

//module snap_fit_female (width, height, depth) {
//    
//}




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


//old

module box_lid_no_lip () {

union(){
    open_box(width=width, depth=depth, height=height, wall_thickness=wall_thickness, chamfer=chamfer);

    
    snap_trans_x = width/2 + wall_thickness - stem_depth/2 + eps;
    snap_trans_z = height+ stem_height/2 - stem_in_lid_dist + wall_thickness/2;
    
    translate([snap_trans_x, 0, snap_trans_z]){
        rotate([0, 0, -90])
        snap_fit_male(width=snap_male_width, stem_height=stem_height, stem_depth=stem_depth, block_height=snap_block_height, block_depth=snap_block_depth);
    }
    translate([-1*snap_trans_x, 0,snap_trans_z]){
        rotate([0, 0, 90])
        snap_fit_male(width=snap_male_width, stem_height=stem_height, stem_depth=stem_depth, block_height=snap_block_height, block_depth=snap_block_depth);
    }
}
} 

module box_bottom_no_lip (width, depth, height, wall_thickness, chamfer=0) {
    
difference() {
    open_box(width=width, depth=depth, height=height, wall_thickness=wall_thickness, chamfer=chamfer);
    
    cut_height =  snap_block_height + snap_female_tol ;
    cut_trans_z = height - wall_thickness/2 - stem_in_bottom_dist;//-wall_thickness-snap_female_tol - stem_in_bottom_dist;
    //cut openings for snap fit
    translate([width/2 + wall_thickness/2, 0, cut_trans_z]) {
        rotate([0, 0, 90]){
            cube([snap_male_width + snap_female_tol, wall_thickness,cut_height], center=true);
        }
    }
    translate([-1*(width/2 + wall_thickness/2), 0, cut_trans_z]) {
        rotate([0, 0, 90]){
            cube([snap_male_width + snap_female_tol, wall_thickness, cut_height ], center=true);
        }
    }
}
}