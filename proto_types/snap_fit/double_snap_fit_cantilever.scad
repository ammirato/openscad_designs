use <snap_joints/cantilever.scad>

//cube([10, 10, 10], center=false);
stem_width = 2;
stem_height = 10;
stem_depth = 3;
snap_block_height=2;
snap_block_depth = 1;
cube_size = 20;
cube_h = 15;
cube_w = 12;
cube_d = 15;
space_diff = 1;   
taper=0.25;
movement_factor=0.5;


plug_width = stem_depth*2;
plug_depth = stem_width;
plug_height = stem_height/2;
tol=0.5;

union(){
    cube([cube_w, cube_d, cube_h], center=false);
    //translate([1,0,cube_h]){
    //double_snap_fit_plug(space_diff=space_diff, width=stem_width, stem_height=stem_height, stem_depth=stem_depth, block_height=snap_block_height, block_depth=snap_block_depth, taper=taper, center=false);
    //}
    translate([1,4,cube_h])
    double_snap_fit_plug(space_diff=space_diff, width=stem_width, stem_height=stem_height, stem_depth=stem_depth, block_height=snap_block_height, block_depth=snap_block_depth, taper=taper, center=false);

    translate([1, 8, cube_h]){
        cube([plug_width, plug_depth, plug_height], center=false);
    }
}


translate([cube_w*1.5, 0, 0]){
difference() {
    cube([cube_w, cube_d, cube_h], center=false);
    //double_snap_fit_socket_inverse(movement_factor=movement_factor, space_diff=space_diff, width=stem_width, stem_height=stem_height, stem_depth=stem_depth, block_height=snap_block_height, block_depth=snap_block_depth, taper=0.5, center=false);
    translate([1,4,0])
    double_snap_fit_socket_inverse(movement_factor=movement_factor, space_diff=space_diff, width=stem_width, stem_height=stem_height, stem_depth=stem_depth, block_height=snap_block_height, block_depth=snap_block_depth, taper=0.5, center=false);

    translate([1, 8, 0]){
            cube([plug_width+tol, plug_depth+tol, plug_height+tol], center=false);
        }
    }
}