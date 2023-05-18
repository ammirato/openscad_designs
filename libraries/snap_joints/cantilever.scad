
use <primitives/prisms.scad>

eps = 0.001;

width = 3;
stem_height=6;
block_height=2; 
block_depth=1;
taper=0.1;
stem_depth=2;
center=true;

//double_snap_fit_plug(width=width, stem_height=stem_height, stem_depth=stem_depth, block_height=block_height, block_depth=block_depth, taper=taper, center=center);
snap_fit_plug(width=width, stem_height=stem_height, stem_depth=stem_depth, block_height=block_height, block_depth=block_depth, taper=taper, center=center);
translate([0,width + 0.1,0])
double_snap_fit_socket_inverse(width=width, stem_height=stem_height, stem_depth=stem_depth, block_height=block_height, block_depth=block_depth, taper=taper, center=center);


module double_snap_fit_socket_inverse(movement_factor=1.0, tol=0.5, space_diff=1, width, stem_height, stem_depth, block_height, block_depth, taper=1.0, center=false){

    //empty_space = plug_full_depth/2 + stem_depth/2;
    plug_full_depth = stem_depth + block_depth;
    plug_full_height = stem_height;
    plug_full_width = width;
    
    plug_upper_depth = stem_depth * taper;
    block_movement_dist = (stem_depth - plug_upper_depth) * movement_factor;
   
    
    socket_max_width = (stem_depth + block_depth)*2 + space_diff + tol;
    socket_min_width = socket_max_width - block_movement_dist*2 + tol;
    socket_all_depth = plug_full_width + tol;
    socket_min_height = plug_full_height - block_height + tol;
    socket_max_height = block_height + tol;
    
    
    trans_x = center ? 0 : socket_max_width/2;
    trans_y = center ? 0 : socket_all_depth/2;
    trans_z = center ? -1 * socket_max_height/2 : plug_full_height/2 - socket_max_height/2;

    
    translate([trans_x, trans_y, trans_z]){
        cube([socket_min_width, socket_all_depth, socket_min_height], center=true);
        translate([0, 0, socket_min_height/2 + socket_max_height/2]){
            cube([socket_max_width, socket_all_depth, socket_max_height], center=true);
        }
    }  
}



module double_snap_fit_plug(space_diff=1, width, stem_height, stem_depth, block_height, block_depth, taper=1.0, center=false){

    full_depth = stem_depth + block_depth;
    empty_space = min(stem_depth, space_diff);
    trans_x = center ? -1*(full_depth/2 + empty_space/2) : full_depth/2;
    trans_y = center ? 0 : width/2;
    trans_z = center ? 0 : stem_height/2;
    

    translate([trans_x, trans_y, trans_z]){
        left_trans_x = full_depth+ empty_space;
        translate([left_trans_x,0,0]){
            snap_fit_plug(width, stem_height, stem_depth, block_height, block_depth, taper=taper, center=true);
        }
        
        rotate([0,0,180]){
            snap_fit_plug(width, stem_height, stem_depth, block_height, block_depth, taper=taper, center=true);
        }
    }
}

module snap_fit_plug(width, stem_height, stem_depth, block_height, block_depth, taper=1.0, center=false){
    /*Create a plug snap fit.
    
    Args:
    
        taper: Value in [0, 1]. The depth of the top of the stem will be
            stem_depth * taper. 
    
    */


    trans_x = center ? ((stem_depth - block_depth)/2) : stem_depth;
    trans_y = center ? 0 : width/2;
    trans_z = center ? 0 : stem_height/2;

    translate([trans_x, trans_y, trans_z])
    union() {
        //stem
        stem_upper_depth = stem_depth * taper;
        difference() {
            trapezoid_prism(width_lower=stem_depth*2, width_upper=stem_upper_depth*2, depth=width, height=stem_height, center=true, square_right=false);   
            translate([stem_depth/2,0,0]){
            cube([stem_depth, width, stem_height],center=true);
             
            }
        }

        //block
        translate([block_depth/2 - eps,0,stem_height/2 - block_height/2]){
            rotate([0, 90, 0])
                trapezoid_prism(width_lower=block_height, width_upper=block_height/4, depth=width, height=block_depth, center=true, square_right=true);
        }
    }
}