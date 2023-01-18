use <BOSL2/std.scad>

use <primitives/prisms.scad>
use <primitives/boxes.scad>

eps=0.001;

//main box params
width = 10;
depth = 10;
height = 5;
wall_thickness = 1;
chamfer=0;
outer_height=height;
inner_height= 0.7*outer_height;
outer_wall_thickness=wall_thickness;
inner_wall_thickness=outer_wall_thickness*1.1;


//snap fit params
snap_male_width=5;

snap_block_height=1.5;
snap_block_depth=outer_wall_thickness*1.025;
snap_female_tol=0.5;
//stem_height=6;
//stem_depth=1;


//box_bottom(center=false);
//
//
////lid
//translate([0, width+wall_thickness*3 + 30, 0]){
//    box_lid(center=false);
//}

divider("Village");



//translate([2.5, 65, 9]){
//cube([1,1,3]);
//}

module box_bottom (center=false) {    
    cut_depth = inner_wall_thickness + outer_wall_thickness+2*eps;
    cut_height =  snap_block_height + snap_female_tol ;
    cut_width = snap_male_width + snap_female_tol;
    
    cut_trans_x_left = 0 + cut_depth/2;
    cut_trans_x_right = width + inner_wall_thickness + outer_wall_thickness + cut_depth/2;
    cut_trans_y = depth/2  + inner_wall_thickness + outer_wall_thickness;
    cut_trans_z = inner_height + outer_wall_thickness - cut_height/2 +eps;//inner_height - outer_height/2 - cut_depth/2;
    
    
    center_trans_x = center ? -1*(width/2 + outer_wall_thickness + inner_wall_thickness) : 0;
    center_trans_y = center ? -1*(depth/2 + outer_wall_thickness + inner_wall_thickness) : 0;
    center_trans_z = center ? -1*(height/2 + outer_wall_thickness/2) + eps : eps;

    translate([center_trans_x, center_trans_y, center_trans_z]){
        difference() { 

            open_box_with_lip(width=width, depth=depth, outer_height=outer_height, inner_height=inner_height, outer_wall_thickness=outer_wall_thickness, inner_wall_thickness=inner_wall_thickness, chamfer=chamfer, center=false);

            //cut openings for snap fit
            translate([cut_trans_x_left, cut_trans_y, cut_trans_z]) {
                rotate([0, 0, 90]){
                    cube([cut_width, cut_depth,cut_height], center=true);
                }
            }
            translate([(cut_trans_x_right), cut_trans_y, cut_trans_z]) {
                rotate([0, 0, 90]){
                    cube([cut_width, cut_depth, cut_height ], center=true);
                }
            }
        }
    }
}


module box_lid (center=false) {


    stem_depth = inner_wall_thickness;
    stem_height = ((outer_height - inner_height) *2) + snap_block_height + snap_female_tol/2;
    
        
    snap_trans_x_left = 0 + outer_wall_thickness + stem_depth/2 -eps;
    snap_trans_x_right = width + inner_wall_thickness + outer_wall_thickness + stem_depth/2 +eps;
    snap_trans_y = depth/2  + inner_wall_thickness + outer_wall_thickness;
    snap_trans_z = inner_height + outer_wall_thickness  +  stem_height/2 - eps; 
    
    
    center_trans_x = center ? -1*(width/2 + outer_wall_thickness + inner_wall_thickness) : 0;
    center_trans_y = center ? -1*(depth/2 + outer_wall_thickness + inner_wall_thickness) : 0;
    center_trans_z = center ? -1*(height/2 + outer_wall_thickness/2) : 0;

    translate([center_trans_x, center_trans_y, center_trans_z]){
        union(){
            open_box_with_lip(width=width, depth=depth, outer_height=outer_height, inner_height=inner_height, outer_wall_thickness=outer_wall_thickness, inner_wall_thickness=inner_wall_thickness, chamfer=chamfer);

            translate([snap_trans_x_left, snap_trans_y, snap_trans_z]){
                rotate([0, 0, 90])
                snap_fit_male(width=snap_male_width, stem_height=stem_height, stem_depth=stem_depth, block_height=snap_block_height, block_depth=snap_block_depth);
            }
            translate([snap_trans_x_right, snap_trans_y ,snap_trans_z]){
                rotate([0, 0, -90])
                snap_fit_male(width=snap_male_width, stem_height=stem_height, stem_depth=stem_depth, block_height=snap_block_height, block_depth=snap_block_depth);
            }
        
        }
    }
} 
   

module snap_fit_male(width, stem_height, stem_depth, block_height, block_depth){

union() {
    //stem
    cube([width, stem_depth, stem_height], center=true);

    translate([0, block_depth/2 + stem_depth/2 - eps, stem_height/2 - block_height/2]){
        rotate([0,0,90])
        rotate([0, 90, 0])
            trapezoid_prism(width_lower=block_height, width_upper=block_height/2, depth=width, height=block_depth, center=true, square_right=true);
    }
}
}


module divider(text) {
    div_width = 5;
    div_height = 5;
    div_thickness = 1;
    text_thickness = div_thickness/2;
    text_height=div_height/5;
    text_buffer = text_height/5;

    difference() {
        cube([div_width,div_height,div_thickness]);
        translate([text_buffer, div_height-text_height-text_buffer, div_thickness-text_thickness]){
            linear_extrude(div_thickness/2)
            text(text, size=text_height, font="Helvetica:style=Bold");
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
