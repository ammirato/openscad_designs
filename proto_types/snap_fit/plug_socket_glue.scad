
cube_h = 10;
cube_w = 8;
cube_d = 10;

plug_width = 5;
plug_depth = 2;
plug_height = 5;
tol=0.1;

union(){
    cube([cube_w, cube_d, cube_h], center=false);
    translate([1, 4, cube_h]){
        cube([plug_width, plug_depth, plug_height], center=false);
    }
}


translate([cube_w*1.5, 0, 0]){
difference() {
    cube([cube_w, cube_d, cube_h], center=false);
    translate([1, 4, 0]){
            cube([plug_width+tol, plug_depth+tol, plug_height+2*tol], center=false);
        }
    }
}