use <BOSL2/std.scad>

use <primitives/prisms.scad>
use <primitives/boxes.scad>

eps=0.001;

//main box params
width = 95;
depth = 10;
wall_thickness = 1.5;
chamfer=2.0;
outer_wall_thickness=wall_thickness;
inner_wall_thickness=outer_wall_thickness*2;

bottom_height =35;
bottom_outer_height=bottom_height;
bottom_inner_height = bottom_outer_height*0.8;

lid_height = 20;
lid_outer_height= lid_height;
lid_inner_height = lid_outer_height*0.8;



//snap fit params
snap_male_width=10;
snap_block_height=3;
snap_block_depth=outer_wall_thickness*1.2;
snap_female_tol=1;


// tdiv: the actual divider with text writting on it
tdiv_thickness = 1;
tdiv_extra_width = 1;
tdiv_tol = max(inner_wall_thickness*.1, 0.5);
tdiv_width = width+tdiv_extra_width;
tdiv_text_height = 7;
tdiv_height = 63 + tdiv_text_height;
tdiv_sidebar_width = 10;

//div: the cutout in the bottom box
div_width = width + tdiv_extra_width + tdiv_tol*2;
div_z_indent = 0.4; //how far into bottom div cuts
div_height = bottom_inner_height+ div_z_indent;
div_thickness = tdiv_thickness + tdiv_tol;

box_bottom(center=false, div_locs=[5]);
//////
//////
////lid
//translate([0, width+wall_thickness*3 + 30, 0]){
//    box_lid(center=false);
//}

translate([-50, 0,0])
divider(text="VILLAGE", width=tdiv_width, height=tdiv_height, thickness=tdiv_thickness, text_height=tdiv_text_height, sidebar_width=tdiv_sidebar_width);




//translate([2.5, 65, 9]){
//cube([1,1,3]);
//}

module box_bottom (center=false, div_locs=[]) { 
 
    outer_height = bottom_outer_height;
    inner_height = bottom_inner_height;
    
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

    bottom_full_width = width + 2*(outer_wall_thickness + inner_wall_thickness);
    div_trans_x = bottom_full_width/2 - div_width/2;
    div_trans_y = outer_wall_thickness + inner_wall_thickness;
    div_trans_z = outer_wall_thickness - div_z_indent;

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
            
            
            for (div_loc = div_locs) {
                translate([div_trans_x, div_trans_y + div_loc, div_trans_z]){
                    cube([div_width, div_thickness, div_height]);
                }
            }
        }
        
    }
}

module div_cuts(div_locs){
    
    
}

module box_lid (height, center=false) {

    outer_height = lid_outer_height;
    inner_height = lid_inner_height;
    
    stem_depth = inner_wall_thickness;
    stem_height = ((lid_outer_height - lid_inner_height) + (bottom_outer_height-bottom_inner_height)) + snap_block_height + snap_female_tol/2;
    
        
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


module divider(text, width, height, thickness, text_height, sidebar_width) {
    div_width = width;
    div_height = height;
    div_thickness = thickness;
    text_height=text_height;
    div_sidebar_width = sidebar_width;
    
    
    text_thickness = div_thickness*1.1; //div_thickness/2;
    text_buffer = max(1.5, text_height/10);
    text_spacing = max(1.2, 1 + text_buffer/10);
    
    
    
    empty_width = div_width - div_sidebar_width*2;
    empty_height = div_height - max(text_height + text_buffer*2, div_sidebar_width)*2;
    
    text_trans_y = div_height/2 - text_height/2 - text_buffer;
    text_trans_z = text_thickness/2 * -1;

    difference() {
        cube([div_width,div_height,div_thickness], center=true);
        translate([0, text_trans_y, text_trans_z]){
            linear_extrude(text_thickness)
            text(text, size=text_height, font="Helvetica:style=Bold", halign="center", valign="center", spacing=text_spacing);
        }
        cube([empty_width, empty_height, div_thickness], center=true);
    }
    
}
