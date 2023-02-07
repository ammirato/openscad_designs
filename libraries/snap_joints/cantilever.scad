
use <primitives/prisms.scad>

eps = 0.001;
//snap_fit_plug(width=3, stem_height=5, stem_depth=1, block_height=1, block_depth=1, taper=0.5, center=false);
double_snap_fit_plug(width=3, stem_height=5, stem_depth=1, block_height=1, block_depth=1, taper=0.5, center=true);

double_snap_fit_socket_inverse(width=3, stem_height=5, stem_depth=1, block_height=1, block_depth=1, taper=0.5, center=false);


module double_snap_fit_socket_inverse(width, stem_height, stem_depth, block_height, block_depth, taper=1.0, center=false){

    empty_space = plug_full_depth/2 + stem_depth/2;
    plug_full_depth = stem_depth + block_depth;
    plug_full_height = stem_height;
    plug_full_width = width;
    
    empty_space = stem_depth;
    
    socket_max_width = (stem_depth + block_depth)*2 + empty_space;
    socket_min_width = socket_max_width - empty_space;
    socket_all_depth = plug_full_width;
    socket_min_height = plug_full_height - block_height;
    socket_max_height = block_height;
    
    
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



module double_snap_fit_plug(width, stem_height, stem_depth, block_height, block_depth, taper=1.0, center=false){


    trans_x = center ? -1*(stem_depth*1.5) : stem_depth;
    trans_y = center ? 0 : width/2;
    trans_z = center ? 0 : stem_height/2;
    empty_space = stem_depth;

    translate([trans_x, trans_y, trans_z]){
        left_trans_x = stem_depth*2 + empty_space;
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