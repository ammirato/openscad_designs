include <BOSL2/std.scad>
use <primitives/boxes.scad>
$fn=25;
eps = 0.001;


//finger_cut_out(
//width=20,
//height=40,
//thickness=1
//);

card_box(
    width=10,
    depth=10,
    height=10,
    wall_thickness=1,
    div_locs=[5]
);

module card_box(
    width, 
    depth, 
    height, 
    wall_thickness, 
    center=false, 
    chamfer=0,
    div_locs=[],
 ){
    cut_width = width*0.5;
    cut_height=height*0.75;
    cut_trans_x = width/2 + wall_thickness;
    cut_trans_y_front = wall_thickness/2 + eps;
    cut_trans_y_back = wall_thickness*1.5 + depth + eps;
    cut_trans_z = cut_height/2 + height-cut_height + wall_thickness + eps;
     
    difference(){    
        union(){
            open_box(
                width=width, 
                depth=depth, 
                height=height, 
                wall_thickness=wall_thickness,
                center=center,
                chamfer=chamfer
            );
            div_trans_x = wall_thickness-eps;
            div_trans_y = 0;
            div_trans_z = wall_thickness;
            div_cut_trans_x = width/2;
            div_cut_trans_z = cut_height/2 + height-cut_height + eps;
            // cut divider cutouts
            for (div_loc = div_locs) {
                translate([div_trans_x, div_trans_y + div_loc, div_trans_z]){
                    difference(){
                        cube([width + eps*2, wall_thickness, height]);
                        translate([div_cut_trans_x,cut_trans_y_front,div_cut_trans_z]){
                            finger_cut_out(
                                width=cut_width,
                                height=cut_height,
                                thickness=wall_thickness + eps*2
                            );
                        }
                    }
                }
            }
        }
        translate([cut_trans_x,cut_trans_y_front,cut_trans_z]){
            finger_cut_out(
                width=cut_width,
                height=cut_height,
                thickness=wall_thickness + eps*2
            );
        }
        translate([cut_trans_x,cut_trans_y_back,cut_trans_z]){
            finger_cut_out(
                width=cut_width,
                height=cut_height,
                thickness=wall_thickness + eps*2
            );
        }
    }
}

module finger_cut_out(
    width,
    height,
    thickness,
){
    radius=width/2;
    cap_height = height - radius;
    rotate([90,0,0]){
        translate([0, radius - height/2, -1*thickness/2]){
            linear_extrude(thickness){
                teardrop2d(r=radius, ang=0.1, cap_h=cap_height);
            }
        }
    }
}
    



