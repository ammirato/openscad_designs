use <BOSL2/std.scad>

use <primitives/prisms.scad>
use <primitives/boxes.scad>
use <snap_joints/cantilever.scad>

eps=0.001;

//box_bottom_two_halves(depth=25, div_locs=[0, 10, 20]);
//box_bottom(depth=25, div_locs=[0, 10, 20], name_text="prosperity");

box_lid(depth=25, name_text="test_text");

//translate([-0.50 + 93 + 1.5 + 3.75 + 3.75, 20, 20]){
//cube([1,1,1], center=true);
//}

//box params
default_width=93;
default_outer_height=35;
default_inner_height=28; 
default_inner_wall_thickness=3.75;
default_outer_wall_thickness=1.5;
default_snap_plug_block_height=3; 
default_snap_plug_width=7;
default_snap_socket_tol=1.0;
default_chamfer=2.0;
default_div_thickness=1.0;
default_div_extra_width=1.0;
default_div_tol=0.7;
default_div_tol_thickness=0.25;
default_div_z_indent=0.5;
default_extra_bottom_thickness=1.0; 
default_center=false;
default_name="";



//divider params
default_div_width = default_width + default_div_extra_width;
default_div_text_height = 5;
default_div_height = 63 + default_div_text_height;

//lid only params
lid_height_tol = 1.5; //had been 2 in prev versions
default_lid_height = default_div_height - default_outer_height + lid_height_tol;
default_lid_stem_extra_height = default_outer_height - default_inner_height;
default_lid_stem_plug_taper = 1.0;


module box_bottom_two_halves (
depth,
div_locs, 
width=default_width,
outer_height=default_outer_height, 
inner_height=default_inner_height, 
inner_wall_thickness=default_inner_wall_thickness, 
outer_wall_thickness=default_outer_wall_thickness, 
snap_plug_block_height=default_snap_plug_block_height, 
snap_plug_width=default_snap_plug_width, 
snap_socket_tol=default_snap_socket_tol,
chamfer=default_chamfer,
div_thickness=default_div_thickness,
div_extra_width=default_div_extra_width,
div_tol=default_div_tol,
div_tol_thickness=default_div_tol_thickness,
div_z_indent=default_div_z_indent,
extra_bottom_thickness=default_extra_bottom_thickness, 
center=default_center,
name_text=default_name,
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
                div_tol_thickness=div_tol_thickness,
                div_z_indent=div_z_indent,
                extra_bottom_thickness=extra_bottom_thickness, 
                center=center,
                name_text=name_text
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
                center=center,
                name_text=name_text
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
div_locs, 
width=default_width,
outer_height=default_outer_height, 
inner_height=default_inner_height, 
inner_wall_thickness=default_inner_wall_thickness, 
outer_wall_thickness=default_outer_wall_thickness, 
snap_plug_block_height=default_snap_plug_block_height, 
snap_plug_width=default_snap_plug_width, 
snap_socket_tol=default_snap_socket_tol,
chamfer=default_chamfer,
div_thickness=default_div_thickness,
div_extra_width=default_div_extra_width,
div_tol=default_div_tol,
div_tol_thickness=default_div_tol_thickness,
div_z_indent=default_div_z_indent,
extra_bottom_thickness=default_extra_bottom_thickness, 
center=default_center,
name_text=default_name,
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
    div_full_thickness = div_thickness + div_tol_thickness;

    extra_bottom_trans_x = (outer_wall_thickness + inner_wall_thickness);
    extra_bottom_trans_y = (outer_wall_thickness + inner_wall_thickness);
    extra_bottom_trans_z = outer_wall_thickness- eps;

    text_depth = outer_wall_thickness;
    
    
    
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
            
            //text name
            translate([bottom_full_width/2, text_depth-eps, 10]){
                rotate([90, 0, 0]){
                    linear_extrude(text_depth){
                        text(
                            name_text, 
                            size=6, 
                            font="Helvetica:style=Bold", 
                            halign="center", valign="center", 
                            spacing=1
                        );
                    }
                }
            }
                    
            
            // cut divider cutouts
            for (div_loc = div_locs) {
                translate([div_trans_x, div_trans_y + div_loc, div_trans_z]){
                    cube([div_width, div_full_thickness, div_height]);
                }
            }
        }     
    }
}


module box_lid (
depth, 
width=default_width,
height=default_lid_height, 
inner_wall_thickness=default_inner_wall_thickness, 
outer_wall_thickness=default_outer_wall_thickness, 
snap_plug_block_height=default_snap_plug_block_height, 
snap_plug_width=default_snap_plug_width, 
snap_socket_tol=default_snap_socket_tol,
chamfer=default_chamfer,
div_thickness=default_div_thickness,
div_extra_width=default_div_extra_width,
div_tol=default_div_tol,
div_tol_thickness=default_div_tol_thickness,
div_z_indent=default_div_z_indent,
extra_bottom_thickness=default_extra_bottom_thickness, 
center=default_center,
stem_extra_height=default_lid_stem_extra_height,
stem_plug_taper=default_lid_stem_plug_taper,
name_text=default_name,
) {

    
    
    //stem_height1 = (outer_height - inner_height)*2 + inner_height + snap_plug_block_height + snap_socket_tol/2;
    //stem_height1 = height + height*.2 +  snap_plug_block_height + snap_socket_tol;
    stem_height = height + stem_extra_height +  snap_plug_block_height + snap_socket_tol*1.5;

    snap_plug_block_depth = outer_wall_thickness*1.5;
    stem_depth = inner_wall_thickness - snap_plug_block_depth*.8;
        
    snap_trans_x_left = 0 + outer_wall_thickness + stem_depth/2 - snap_plug_block_depth/2 -eps;
    snap_trans_x_right = width + inner_wall_thickness*2 + outer_wall_thickness + 0.18;// - stem_depth/2 - snap_plug_block_depth/2 -eps;
    snap_trans_y = depth/4  + inner_wall_thickness + outer_wall_thickness;
    snap_trans_y_2 = depth*3/4  + inner_wall_thickness + outer_wall_thickness;
    //snap_trans_z = inner_height + outer_wall_thickness  +  stem_height/2 - eps; 
    snap_trans_z = outer_wall_thickness  +  stem_height/2 - eps; 
    
    center_trans_x = center ? -1*(width/2 + outer_wall_thickness + inner_wall_thickness) : 0;
    center_trans_y = center ? -1*(depth/2 + outer_wall_thickness + inner_wall_thickness) : 0;
    center_trans_z = center ? -1*(height/2 + outer_wall_thickness/2) : 0;

    translate([center_trans_x, center_trans_y, center_trans_z]){
        difference(){
            union(){
                //open_box_with_lip(width=width, depth=depth, outer_height=outer_height, inner_height=inner_height, outer_wall_thickness=outer_wall_thickness, inner_wall_thickness=inner_wall_thickness, chamfer=2.0);
                open_box(width=width + inner_wall_thickness*2, depth=depth + inner_wall_thickness*2, height=height, wall_thickness=outer_wall_thickness, chamfer=2.0);
                
    //            translate([snap_trans_x_right -1 +1.85, 18, 35]){
    //                cube([2,2,2], center=true);
    //             }

    //            //add snap fit plugs
                translate([snap_trans_x_left, snap_trans_y, snap_trans_z]){
                    rotate([0, 0, 180])
                    snap_fit_plug(width=snap_plug_width, stem_height=stem_height, stem_depth=stem_depth, block_height=snap_plug_block_height, block_depth=snap_plug_block_depth, center=true, taper=stem_plug_taper);
                }
                translate([snap_trans_x_left, snap_trans_y_2, snap_trans_z]){
                    rotate([0, 0, 180])
                    snap_fit_plug(width=snap_plug_width, stem_height=stem_height, stem_depth=stem_depth, block_height=snap_plug_block_height, block_depth=snap_plug_block_depth, center=true, taper=stem_plug_taper);
                }
                translate([snap_trans_x_right, snap_trans_y ,snap_trans_z]){
                    rotate([0, 0, 0])
                    snap_fit_plug(width=snap_plug_width, stem_height=stem_height, stem_depth=stem_depth, block_height=snap_plug_block_height, block_depth=snap_plug_block_depth, center=true, taper=stem_plug_taper);
                }
                translate([snap_trans_x_right, snap_trans_y_2,snap_trans_z]){
                    rotate([0, 0, 0])
                    snap_fit_plug(width=snap_plug_width, stem_height=stem_height, stem_depth=stem_depth, block_height=snap_plug_block_height, block_depth=snap_plug_block_depth, center=true, taper=stem_plug_taper);
                }    
            }
            //text name
            text_depth = outer_wall_thickness/3;
            box_full_depth = depth + outer_wall_thickness*2 + inner_wall_thickness*2;
            wall_offset = 1.1*(outer_wall_thickness + inner_wall_thickness);
            translate([wall_offset, box_full_depth/2, text_depth-eps]){
                rotate([180, 0, 90]){
                    linear_extrude(text_depth){
                        text(
                            name_text, 
                            size=5, 
                            font="Helvetica:style=Bold", 
                            halign="center", valign="center", 
                            spacing=1
                        );
                    }
                }
            }
        } 
    }
} 


module divider(
text, 
width=default_div_width, 
height=default_div_height, 
thickness=default_div_thickness, 
text_height=default_div_text_height, 
top_bar_width_percentage=0.55
) 
{
    text_thickness = thickness*0.80;
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

