use <BOSL2/std.scad>

use <primitives/prisms.scad>
use <primitives/boxes.scad>
use <snap_joints/cantilever.scad>

eps=0.001;

box_bottom_two_halves(depth=25, div_locs=[0, 10, 20]);

module box_bottom_two_halves (
depth,
div_locs, 
width=93,
outer_height=35, 
inner_height=28, 
inner_wall_thickness=3.75, 
outer_wall_thickness=1.5, 
snap_plug_block_height=3, 
snap_plug_width=7, 
snap_socket_tol=1.0,
chamfer=2.0,
div_thickness=1.0,
div_extra_width=1.0,
div_tol=0.7,
div_z_indent=0.5,
extra_bottom_thickness=1.0, 
center=false,
) 
{ 
    
    full_width = width + outer_wall_thickness*2 + inner_wall_thickness*2;
    full_depth = depth + outer_wall_thickness*2 + inner_wall_thickness*2+ 0.1;
    full_height = outer_height +outer_wall_thickness + extra_bottom_thickness;
    
 
    join_plug_depth = 5;
    join_plug_width = inner_wall_thickness * 0.5;
    join_plug_height = 4;
    join_socket_tol = 0.1;
    join_socket_depth = join_plug_depth + join_socket_tol;
    join_socket_width = join_plug_width + join_socket_tol*2;
    join_socket_height = join_plug_height + join_socket_tol;
    
    
    left_plug_trans_x = outer_wall_thickness/2 + inner_wall_thickness/2;
    right_plug_trans_x = full_width - outer_wall_thickness/2 - inner_wall_thickness/2;
    plug_trans_y = full_depth/2 - join_plug_depth/2 + eps;

    full_inner_height = inner_height + outer_wall_thickness + extra_bottom_thickness;
    plug_trans_z_0 = full_inner_height*.70;
    plug_trans_z_1 = full_inner_height*.35;

    
    
    union () {
        //first half
        difference(){
            box_bottom(
                depth=depth,
                width=width,
                outer_height=outer_height, 
                inner_height=inner_height, 
                inner_wall_thickness=inner_wall_thickness, 
                outer_wall_thickness=outer_wall_thickness, 
                snap_plug_block_height=snap_plug_block_height, 
                snap_plug_width=snap_plug_width, 
                snap_socket_tol=snap_socket_tol,
                div_locs=div_locs, 
                div_thickness=div_thickness,
                div_extra_width=div_extra_width,
                div_tol=div_tol,
                div_z_indent=div_z_indent,
                extra_bottom_thickness=extra_bottom_thickness, 
                center=center
            ); 
            //cut in half
            cube([full_width*1.2, full_depth/2, full_height*1.2], center=false);
        }
        
        //join plugs
        translate([left_plug_trans_x, plug_trans_y, plug_trans_z_0]){
            cube([join_plug_width, join_plug_depth, join_plug_height], center=true);
        }
        translate([left_plug_trans_x, plug_trans_y, plug_trans_z_1]){
            cube([join_plug_width, join_plug_depth, join_plug_height], center=true);
        }
        translate([right_plug_trans_x, plug_trans_y, plug_trans_z_0]){
            cube([join_plug_width, join_plug_depth, join_plug_height], center=true);
        }
        translate([right_plug_trans_x, plug_trans_y, plug_trans_z_1]){
            cube([join_plug_width, join_plug_depth, join_plug_height], center=true);
        }
    }
    
    
    
    //second half
    translate([full_width*1.1,0,0]){
        
        difference(){
            box_bottom(
                depth=depth,
                width=width,
                outer_height=outer_height, 
                inner_height=inner_height, 
                inner_wall_thickness=inner_wall_thickness, 
                outer_wall_thickness=outer_wall_thickness, 
                snap_plug_block_height=snap_plug_block_height, 
                snap_plug_width=snap_plug_width, 
                div_locs=div_locs, 
                div_thickness=div_thickness,
                div_extra_width=div_extra_width,
                div_tol=div_tol,
                div_z_indent=div_z_indent,
                snap_socket_tol=snap_socket_tol,
                extra_bottom_thickness=extra_bottom_thickness, 
                center=center
            );
            //cut in half
            translate([0,full_depth/2,0]){
                cube([full_width*1.2, full_depth/2, full_height*1.2], center=false);
            }
            
            //join sockets
            translate([left_plug_trans_x, plug_trans_y, plug_trans_z_0]){
                cube([join_socket_width, join_socket_depth, join_socket_height], center=true);
            }
            translate([left_plug_trans_x, plug_trans_y, plug_trans_z_1]){
                cube([join_socket_width, join_socket_depth, join_socket_height], center=true);
            }
            translate([right_plug_trans_x, plug_trans_y, plug_trans_z_0]){
                cube([join_socket_width, join_socket_depth, join_socket_height], center=true);
            }
            translate([right_plug_trans_x, plug_trans_y, plug_trans_z_1]){
                cube([join_socket_width, join_socket_depth, join_socket_height], center=true);
            }
        }
    }

}

module box_bottom (
depth,
width,
outer_height, 
inner_height, 
inner_wall_thickness, 
outer_wall_thickness, 
snap_plug_block_height, 
snap_plug_width, 
snap_socket_tol,
div_thickness,
div_extra_width,
div_tol,
div_z_indent,
chamfer,
div_locs=[], 
extra_bottom_thickness=0, 
center=false
) 
{ 
 
    full_outer_height = outer_height + extra_bottom_thickness;
    
    cut_depth = inner_wall_thickness + outer_wall_thickness+2*eps;
    cut_height =  snap_plug_block_height + snap_socket_tol;
    cut_width = snap_plug_width + snap_socket_tol;
    
    cut_trans_x_left = 0 + cut_depth/2;
    cut_trans_x_right = width + inner_wall_thickness + outer_wall_thickness + cut_depth/2;
    cut_trans_y = depth/4  + inner_wall_thickness + outer_wall_thickness;
    cut_trans_y_2 = depth*3/4  + inner_wall_thickness + outer_wall_thickness;

    cut_trans_z = inner_height + outer_wall_thickness + extra_bottom_thickness/2  - cut_height/2 +eps ;
    
    
    center_trans_x = center ? -1*(width/2 + outer_wall_thickness + inner_wall_thickness) : 0;
    center_trans_y = center ? -1*(depth/2 + outer_wall_thickness + inner_wall_thickness) : 0;
    center_trans_z = center ? -1*(full_outer_height/2 + outer_wall_thickness/2 + extra_bottom_thickness/2) + eps : eps;

    bottom_full_width = width + 2*(outer_wall_thickness + inner_wall_thickness);
    div_width = width + div_extra_width + div_tol*2;
    div_trans_x = bottom_full_width/2 - div_width/2;
    div_trans_y = outer_wall_thickness + inner_wall_thickness;
    div_trans_z = outer_wall_thickness + extra_bottom_thickness - div_z_indent;
    div_height = inner_height+ div_z_indent + extra_bottom_thickness;


    extra_bottom_trans_x = (outer_wall_thickness + inner_wall_thickness);
    extra_bottom_trans_y = (outer_wall_thickness + inner_wall_thickness);
    extra_bottom_trans_z = outer_wall_thickness- eps;

    
    translate([center_trans_x, center_trans_y, center_trans_z]){
        difference() {
            translate([0,0,extra_bottom_thickness/2]){
                union () {
                    open_box_with_lip(width=width, depth=depth, outer_height=full_outer_height, inner_height=inner_height, outer_wall_thickness=outer_wall_thickness, inner_wall_thickness=inner_wall_thickness, chamfer=2.0, center=false);
                    translate([extra_bottom_trans_x, extra_bottom_trans_y, extra_bottom_trans_z]) {
                        cube([width + eps, depth + eps, extra_bottom_thickness], center=false);
                    }
                }
            }
            
            //cut openings for snap fit first
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
            //cut openings for snap fit second
            translate([cut_trans_x_left, cut_trans_y_2, cut_trans_z]) {
                rotate([0, 0, 90]){
                    cube([cut_width, cut_depth,cut_height], center=true);
                }
            }
            translate([(cut_trans_x_right), cut_trans_y_2, cut_trans_z]) {
                rotate([0, 0, 90]){
                    cube([cut_width, cut_depth, cut_height ], center=true);
                }
            }
            
            
            // cut divider cutouts
            for (div_loc = div_locs) {
                translate([div_trans_x, div_trans_y + div_loc, div_trans_z]){
                    cube([div_width, div_thickness*1.1, div_height]);
                }
            }
        }     
    }
}


//module box_lid (height, center=false) {
//
//    outer_height = lid_outer_height;
//    inner_height = lid_inner_height;
//    
//    stem_depth = inner_wall_thickness;
//    stem_height = ((lid_outer_height - lid_inner_height) + (outer_height-inner_height)) + snap_block_height + snap_socket_tol/2;
//    
//        
//    snap_trans_x_left = 0 + outer_wall_thickness + stem_depth/2 -eps;
//    snap_trans_x_right = width + inner_wall_thickness + outer_wall_thickness + stem_depth/2 +eps;
//    snap_trans_y = depth/2  + inner_wall_thickness + outer_wall_thickness;
//    snap_trans_z = inner_height + outer_wall_thickness  +  stem_height/2 - eps; 
//    
//    
//    center_trans_x = center ? -1*(width/2 + outer_wall_thickness + inner_wall_thickness) : 0;
//    center_trans_y = center ? -1*(depth/2 + outer_wall_thickness + inner_wall_thickness) : 0;
//    center_trans_z = center ? -1*(height/2 + outer_wall_thickness/2) : 0;
//
//    translate([center_trans_x, center_trans_y, center_trans_z]){
//        union(){
//            open_box_with_lip(width=width, depth=depth, outer_height=outer_height, inner_height=inner_height, outer_wall_thickness=outer_wall_thickness, inner_wall_thickness=inner_wall_thickness, chamfer=2.0);
//
//            translate([snap_trans_x_left, snap_trans_y, snap_trans_z]){
//                rotate([0, 0, 90])
//                snap_fit_plug(width=snap_plug_width, stem_height=stem_height, stem_depth=stem_depth, block_height=snap_block_height, block_depth=snap_block_depth);
//            }
//            translate([snap_trans_x_right, snap_trans_y ,snap_trans_z]){
//                rotate([0, 0, -90])
//                snap_fit_plug(width=snap_plug_width, stem_height=stem_height, stem_depth=stem_depth, block_height=snap_block_height, block_depth=snap_block_depth);
//            }
//        
//        } 
//    }
//} 


module divider2(
text, 
width=94, 
height=68, 
thickness=1, 
text_height=5, 
top_bar_width_percentage=0.55
) 
{
    text_thickness = thickness*0.75;
    text_buffer = max(1.5, text_height/10);
    text_spacing = max(1.15, 1 + text_buffer/10);
    
    top_bar_height = text_height + text_buffer*2;
    top_bar_width = width*top_bar_width_percentage; // TODO: change
    bottom_bar_height = top_bar_height;
    bottom_bar_width = width;
    
       
    middle_bar_height = height - top_bar_height - bottom_bar_height + 0.001;
    middle_bar_width = bottom_bar_height;
    
    top_bar_trans_y = height/2 - top_bar_height/2;
    text_trans_y = top_bar_trans_y;// - text_buffer;
    text_trans_z = (text_thickness - thickness/2)*-1;///2 * -1;
    bottom_bar_trans_y = -1 * (height/2 - bottom_bar_height/2);
    second_bottom_bar_trans_y = bottom_bar_trans_y + bottom_bar_height*2;

    union() {
        difference() {
            translate([0, top_bar_trans_y, 0]) {
                cube([top_bar_width,top_bar_height, thickness], center=true);
            }
            translate([0, text_trans_y, text_trans_z]){
                linear_extrude(text_thickness)
                //text(text, size=text_height, font= "Comic Sans MS:style=Bold", halign="center", valign="center", spacing=text_spacing);
                text(text, size=text_height, font="Helvetica:style=Bold", halign="center", valign="center", spacing=text_spacing);

            }
        }
        cube([middle_bar_width, middle_bar_height, thickness], center=true);

        translate([0,bottom_bar_trans_y,0]){
            cube([bottom_bar_width, bottom_bar_height, thickness], center=true);
        }
        translate([0,second_bottom_bar_trans_y,0]){
            cube([bottom_bar_width, bottom_bar_height, thickness], center=true);
        }
    }  
}

