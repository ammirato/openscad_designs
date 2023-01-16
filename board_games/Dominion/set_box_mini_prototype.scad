use <BOSL2/std.scad>

use <primitives/prisms.scad>
use <primitives/boxes.scad>

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
//stem_height=6;
//stem_depth=1;
snap_block_height=1.5;
snap_block_depth=outer_wall_thickness;
snap_female_tol=0.5;
stem_in_lid_dist=0;
//stem_in_bottom_dist = stem_height - stem_in_lid_dist- snap_block_height- snap_female_tol/2;



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

    
    cut_depth = inner_wall_thickness + outer_wall_thickness+2*eps;
    cut_height =  snap_block_height + snap_female_tol ;
    cut_width = snap_male_width + snap_female_tol;
    cut_trans_x = width/2 + cut_depth/2;
    cut_trans_z = inner_height - outer_height/2 - cut_depth/2;
    
    //cut openings for snap fit
    translate([cut_trans_x, 0, cut_trans_z]) {
        rotate([0, 0, 90]){
            cube([cut_width, cut_depth,cut_height], center=true);
        }
    }
    translate([-1*(cut_trans_x), 0, cut_trans_z]) {
        rotate([0, 0, 90]){
            cube([cut_width, cut_depth, cut_height ], center=true);
        }
    }
}
}


module box_lid () {

union(){
    open_box_with_lip(width=width, depth=depth, outer_height=outer_height, inner_height=inner_height, outer_wall_thickness=outer_wall_thickness, inner_wall_thickness=inner_wall_thickness, chamfer=chamfer);

    stem_depth = inner_wall_thickness;
    stem_height = (outer_height - inner_height) *2;
    
    snap_trans_x = width/2 + stem_depth/2 + eps;// + inner_wall_thickness - stem_depth/2 + eps;
    snap_trans_z = inner_height - outer_height/2 + stem_height/2 - eps;
    
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
