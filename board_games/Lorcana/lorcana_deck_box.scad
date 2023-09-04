include <BOSL2/std.scad>

use <primitives/prisms.scad>
use <primitives/boxes.scad>
use <snap_joints/cantilever.scad>

eps=0.001;
//card dimensions are:
// width: 64mm
// height: 89mm
// thickness: ?? but dominion is ~0.35
card_width = 64;
card_height = 89;
card_thickness = 0.35 * 1.1;
depth = card_thickness * 60 + card_thickness*10;

//
////translate([0,0,33])
//box_bottom(depth=depth);
//
//translate([card_width + 20, 0, 0])
////translate([card_width + +2+6, 0, card_height*0.2 + 3 + 33 +card_height*0.8+ 10 + 3 + 5])
////rotate([180, 0, 180])
//box_lid(bot_depth=depth);

translate([(card_width + 20)*2,0,0])
rotate([0,0,0])
tray_bottom(depth=depth);

tray_bottom_alt(depth=depth);

//box bottom params
default_width=card_width + 2;
default_outer_height=card_height*0.8;
default_inner_height=default_outer_height - 9; 
default_inner_wall_thickness=3;
default_outer_wall_thickness=3;
default_snap_plug_block_height=3; 
default_snap_plug_width=15;
default_snap_socket_tol=1.0;
default_chamfer=2.0;
default_extra_bottom_thickness=0; 
default_tray_connection_height=10;

//box lid params
lid_height_tol = 1.5; //had been 2 in prev versions
default_lid_height = card_height * 0.2 + 5;
default_lid_stem_plug_taper = 1.0;


//tray bottom params
default_tray_outer_height = 30;
default_tray_inner_height = default_tray_outer_height - 5;
default_stem_extra_height = default_tray_connection_height/2 + default_snap_plug_block_height/2 + default_snap_socket_tol/8;
default_stem_taper = 1.0;





module box_bottom (
depth,
width=default_width,
outer_height=default_outer_height, 
inner_height=default_inner_height, 
inner_wall_thickness=default_inner_wall_thickness, 
outer_wall_thickness=default_outer_wall_thickness, 
snap_plug_block_height=default_snap_plug_block_height, 
snap_plug_width=default_snap_plug_width, 
snap_socket_tol=default_snap_socket_tol,
chamfer=default_chamfer,
extra_bottom_thickness=default_extra_bottom_thickness,
tray_connection_height=default_tray_connection_height,
center=false,
) 
{ 
    full_width = width + outer_wall_thickness*2;
    full_depth = depth + outer_wall_thickness*2 + inner_wall_thickness;
    full_height = outer_height + extra_bottom_thickness + outer_wall_thickness;
    full_outer_height = outer_height + extra_bottom_thickness;

    cut_depth = inner_wall_thickness + outer_wall_thickness+2*eps;
    cut_height =  snap_plug_block_height + snap_socket_tol;
    cut_width = snap_plug_width + snap_socket_tol;
    
    cut_trans_x = full_width/2 - cut_width/2;
    cut_trans_y = 0;
    cut_trans_z = inner_height + outer_wall_thickness + tray_connection_height;// + extra_bottom_thickness/2;//  - cut_height/2 +eps ;
    
    tray_cut_trans_x_left = cut_depth;// full_width/2 - cut_width/2;
    tray_cut_trans_x_right = width+cut_depth;
   // tray_cut_trans_left_y = 0;
    tray_cut_trans_y = full_depth/2 - cut_width/2;
   // tray_cut_trans_right_y = full_depth - cut_depth/2;
    tray_cut_trans_z = tray_connection_height/2 - cut_height/2;
    
    center_trans_x = center ? -1*(full_width/2) : 0;
    center_trans_y = center ? -1*(full_depth/2) : 0;
    center_trans_z = center ? -1*(full_height/2) : 0;

    extra_bottom_trans_x = (outer_wall_thickness);
    extra_bottom_trans_y = (outer_wall_thickness + inner_wall_thickness);
    extra_bottom_trans_z = outer_wall_thickness - eps;

    main_trans_z = tray_connection_height + extra_bottom_thickness/2;
    
    translate([center_trans_x, center_trans_y, center_trans_z]){
        difference() {
            union () {
                translate([0,0,main_trans_z]){
                    closed_box_with_hinge_bottom(width=width, depth=depth, outer_height=full_outer_height, inner_height=inner_height, outer_wall_thickness=outer_wall_thickness, inner_wall_thickness=inner_wall_thickness, chamfer=2.0, center=false);
//                    translate([extra_bottom_trans_x, extra_bottom_trans_y, extra_bottom_trans_z]) {
//                        cube([width + eps, depth + eps, extra_bottom_thickness], center=false);
//                    }
                }
                open_box(
                    width=width + eps, 
                    depth=depth + inner_wall_thickness + eps, 
                    height=tray_connection_height + outer_wall_thickness + eps,
                    wall_thickness=outer_wall_thickness,
                    chamfer=chamfer,
                    bottomless=true
               ); 
                
            }
            
            //cut openings for top snap fit first
            translate([cut_trans_x, cut_trans_y, cut_trans_z]) {
                rotate([0, 0, 0]){
                    cube([cut_width, cut_depth,cut_height], center=false);
                }
            }
            // now cut openings for tray snap fits
            translate([tray_cut_trans_x_left, tray_cut_trans_y, tray_cut_trans_z]) {
                rotate([0, 0, 90]){
                    cube([cut_width, cut_depth,cut_height], center=false);
                }
            }
            translate([tray_cut_trans_x_right, tray_cut_trans_y, tray_cut_trans_z]) {
                rotate([0, 0, 90]){
                    cube([cut_width, cut_depth,cut_height], center=false);
                }
            }
        }     
    }
}


module box_lid (
bot_depth,
height=default_lid_height,
bot_width=default_width,
bot_inner_height=default_inner_height,
bot_outer_height=default_outer_height,
inner_wall_thickness=default_inner_wall_thickness, 
outer_wall_thickness=default_outer_wall_thickness, 
snap_plug_block_height=default_snap_plug_block_height, 
snap_plug_width=default_snap_plug_width, 
snap_socket_tol=default_snap_socket_tol,
chamfer=default_chamfer,
extra_bottom_thickness=default_extra_bottom_thickness, 
center=false,
stem_plug_taper=default_lid_stem_plug_taper,
extra_height=0,
) {

    height = height + extra_height;
    stem_extra_height = bot_outer_height - bot_inner_height;
    echo(bot_outer_height, bot_inner_height);
    stem_height = height  + stem_extra_height - snap_socket_tol/2;// +  snap_plug_block_height;// + snap_socket_tol*1.5;
    echo(height, stem_extra_height, snap_plug_block_height, stem_height);
    full_width = bot_width + outer_wall_thickness*2;
    full_depth = bot_depth + outer_wall_thickness*2 + inner_wall_thickness;
    stem_stick_out_height = (stem_height - height) > 0 ? (stem_height - height) : 0;
    full_height = height + outer_wall_thickness + stem_stick_out_height;

    snap_plug_block_depth = outer_wall_thickness*0.4;
    stem_depth = inner_wall_thickness - snap_plug_block_depth*.8;
        
    snap_trans_x = full_width/2 - snap_plug_width/2;
    snap_trans_y = outer_wall_thickness+stem_depth*.95;// - snap_plug_block_depth;
    snap_trans_z = outer_wall_thickness;//  +  stem_height/2 - eps; 
    
    indent_width = full_width / 4;
    indent_width_2 = indent_width / 2;
    indent_height = height;
    indent_depth = outer_wall_thickness*0.5;
    indent_trans_z = indent_height + outer_wall_thickness + eps;
    indent_trans_x = full_width/2 - indent_width/2;
    
    center_trans_x = center ? -1*(full_width/2) : 0;
    center_trans_y = center ? -1*(full_depth/2) : 0;
    center_trans_z = center ? -1*(full_height/2) : 0;

    translate([center_trans_x, center_trans_y, center_trans_z]){
        difference(){
            union(){
                closed_box_with_hinge_top(height=height, bot_width=bot_width, bot_depth=bot_depth, bot_outer_height=bot_outer_height, bot_inner_height=bot_inner_height, bot_outer_wall_thickness=outer_wall_thickness, bot_inner_wall_thickness=inner_wall_thickness, chamfer=2.0, center=false);

                //add snap fit plugs
                translate([snap_trans_x, snap_trans_y, snap_trans_z]){
                    rotate([0, 0, -90])
                    snap_fit_plug(width=snap_plug_width, stem_height=stem_height, stem_depth=stem_depth, block_height=snap_plug_block_height, block_depth=snap_plug_block_depth, center=false, taper=stem_plug_taper);
                }
               
            }
            translate([indent_trans_x, 0, indent_trans_z])
            rotate([-90, 0,0])
            prismoid(
                size1=[indent_width, indent_height],
                size2=[indent_width_2, indent_height],
                height=indent_depth,
                anchor=BOT+LEFT+FRONT
            ); 
        } 
    }
} 







module tray_bottom (
depth, 
width=default_width,
outer_height=default_tray_outer_height, 
inner_height=default_tray_inner_height, 
inner_wall_thickness=default_inner_wall_thickness, 
outer_wall_thickness=default_outer_wall_thickness, 
snap_plug_block_height=default_snap_plug_block_height,
snap_plug_width=default_snap_plug_width,
stem_taper=default_stem_taper,
stem_extra_height=default_stem_extra_height,
chamfer=default_chamfer,
extra_bottom_thickness=default_extra_bottom_thickness, 
center=false
) 
{  
    width = width - inner_wall_thickness*2; 
    depth = depth + inner_wall_thickness;
    full_width = width + outer_wall_thickness*2;
    full_depth = depth + outer_wall_thickness*2;// + inner_wall_thickness;
    full_height = outer_height + extra_bottom_thickness + outer_wall_thickness;
    full_outer_height = outer_height + extra_bottom_thickness;
    full_inner_height = inner_height + extra_bottom_thickness;

    center_trans_x = center ? -1*(full_width/2) : 0;
    center_trans_y = center ? -1*(full_depth/2) : 0;
    center_trans_z = center ? -1*(full_height/2) : 0;

    extra_bottom_trans_x = outer_wall_thickness + inner_wall_thickness;
    extra_bottom_trans_y = outer_wall_thickness;//+ inner_front_wall_thickness);
    extra_bottom_trans_z = outer_wall_thickness - eps;
    
    snap_trans_x_left = outer_wall_thickness + inner_wall_thickness -eps*2;
    snap_trans_x_right = width + outer_wall_thickness + inner_wall_thickness +eps*2;
    snap_trans_y_left = snap_plug_width/2 +outer_wall_thickness + depth/2;
    snap_trans_y_right = outer_wall_thickness + (depth - snap_plug_width)/2;
    snap_trans_z = outer_wall_thickness + full_inner_height - eps;
    stem_depth = inner_wall_thickness;
    stem_height = outer_height - inner_height + stem_extra_height;
    snap_plug_block_depth = outer_wall_thickness*0.4;
    //stem_depth = inner_wall_thickness - snap_plug_block_depth*.8;
    
    indent_width = full_width / 4;
    indent_width_2 = indent_width / 2;
    indent_height = outer_height;
    indent_depth = outer_wall_thickness*0.5;
    indent_trans_z =  indent_height + outer_wall_thickness + eps;
    indent_trans_x_left = 0;// full_width/2 - indent_width/2;
    indent_trans_x_right = width + outer_wall_thickness*2 + inner_wall_thickness*2 + eps;
    indent_trans_y = snap_trans_y_left;
    indent_trans_y_right = snap_trans_y_right;
    
    translate([center_trans_x, center_trans_y, center_trans_z]){
        difference(){
            union () {
                open_box_with_lip(
                    width=width, 
                    depth=depth, 
                    outer_height=full_outer_height, 
                    inner_height=full_inner_height, 
                    outer_wall_thickness=outer_wall_thickness, 
                    inner_wall_thickness=inner_wall_thickness,
                    back_inner_wall_thickness=0,
                    front_inner_wall_thickness=0,
                    chamfer=2.0, 
                    center=false
                );
//                translate([extra_bottom_trans_x, extra_bottom_trans_y, extra_bottom_trans_z]) {
//                    cube([width + eps, depth + eps, extra_bottom_thickness], center=false);
//                }
                //add snap fit plugs
                translate([snap_trans_x_left, snap_trans_y_left, snap_trans_z]){
                    rotate([0, 0, -180])
                    snap_fit_plug(
                        width=snap_plug_width, 
                        stem_height=stem_height, 
                        stem_depth=stem_depth, 
                        block_height=snap_plug_block_height, 
                        block_depth=snap_plug_block_depth, 
                        center=false, 
                        taper=stem_taper
                    );
                }
                translate([snap_trans_x_right, snap_trans_y_right, snap_trans_z]){
                    rotate([0, 0, 0])
                    snap_fit_plug(
                        width=snap_plug_width, 
                        stem_height=stem_height, 
                        stem_depth=stem_depth, 
                        block_height=snap_plug_block_height, 
                        block_depth=snap_plug_block_depth, 
                        center=false, 
                        taper=stem_taper
                    );
                }
           
             
            }
            translate([indent_trans_x_left, indent_trans_y, indent_trans_z])
            rotate([-90, 0,-90])
            prismoid(
                size1=[indent_width, indent_height],
                size2=[indent_width_2, indent_height],
                height=indent_depth,
                anchor=BOT+LEFT+FRONT
            );
            translate([indent_trans_x_right, indent_trans_y_right, indent_trans_z])
            rotate([-90, 0,90])
            prismoid(
                size1=[indent_width, indent_height],
                size2=[indent_width_2, indent_height],
                height=indent_depth,
                anchor=BOT+LEFT+FRONT
            );  
        }   
    }
}


module tray_bottom_alt(
depth, 
width=default_width,
outer_height=default_tray_outer_height, 
inner_height=default_tray_inner_height, 
inner_wall_thickness=default_inner_wall_thickness, 
outer_wall_thickness=default_outer_wall_thickness, 
snap_plug_block_height=default_snap_plug_block_height,
snap_plug_width=default_snap_plug_width,
stem_taper=default_stem_taper,
stem_extra_height=default_stem_extra_height,
chamfer=default_chamfer,
extra_bottom_thickness=default_extra_bottom_thickness, 
center=false
) 
{  
    depth = depth - inner_wall_thickness*2 + inner_wall_thickness; 
    //depth = depth + inner_wall_thickness;
    full_width = width + outer_wall_thickness*2;
    full_depth = depth + outer_wall_thickness*2 + inner_wall_thickness;
    full_height = outer_height + extra_bottom_thickness + outer_wall_thickness;
    full_outer_height = outer_height + extra_bottom_thickness;
    full_inner_height = inner_height + extra_bottom_thickness;

    center_trans_x = center ? -1*(full_width/2) : 0;
    center_trans_y = center ? -1*(full_depth/2) : 0;
    center_trans_z = center ? -1*(full_height/2) : 0;

    extra_bottom_trans_x = outer_wall_thickness + inner_wall_thickness;
    extra_bottom_trans_y = outer_wall_thickness;//+ inner_front_wall_thickness);
    extra_bottom_trans_z = outer_wall_thickness - eps;
    
    stem_depth = inner_wall_thickness;
    stem_height = outer_height - inner_height + stem_extra_height;
    snap_plug_block_depth = outer_wall_thickness*0.4;
    snap_trans_x_left = full_width/2 - snap_plug_width/2;
    snap_trans_x_right = snap_trans_x_left + snap_plug_width;
    snap_trans_y_left = outer_wall_thickness + inner_wall_thickness - eps;
    snap_trans_y_right = full_depth - inner_wall_thickness + eps;
    snap_trans_z = outer_wall_thickness + full_inner_height - eps;
        
    indent_width = full_width / 4;
    indent_width_2 = indent_width / 2;
    indent_height = outer_height;
    indent_depth = outer_wall_thickness*0.5;
    indent_trans_z =  indent_height + outer_wall_thickness + eps;
    indent_trans_x_left = full_width/2 - indent_width/2;
    indent_trans_x_right = full_width/2 - indent_width/2 + indent_width;// + outer_wall_thickness*2 + inner_wall_thickness*2 + eps;
    indent_trans_y = 0;
    indent_trans_y_right = full_depth + indent_depth*2 +eps;
    
    translate([center_trans_x, center_trans_y, center_trans_z]){
        difference(){
            union () {
                open_box_with_lip(
                    width=width, 
                    depth=depth, 
                    outer_height=full_outer_height, 
                    inner_height=full_inner_height, 
                    outer_wall_thickness=outer_wall_thickness, 
                    inner_wall_thickness=inner_wall_thickness,
                    right_inner_wall_thickness=0,
                    left_inner_wall_thickness=0,
                    chamfer=2.0, 
                    center=false
                );
//                translate([extra_bottom_trans_x, extra_bottom_trans_y, extra_bottom_trans_z]) {
//                    cube([width + eps, depth + eps, extra_bottom_thickness], center=false);
//                }
                //add snap fit plugs
                translate([snap_trans_x_left, snap_trans_y_left, snap_trans_z]){
                    rotate([0, 0, -90])
                    snap_fit_plug(
                        width=snap_plug_width, 
                        stem_height=stem_height, 
                        stem_depth=stem_depth, 
                        block_height=snap_plug_block_height, 
                        block_depth=snap_plug_block_depth, 
                        center=false, 
                        taper=stem_taper
                    );
                }
                translate([snap_trans_x_right, snap_trans_y_right, snap_trans_z]){
                    rotate([0, 0, 90])
                    snap_fit_plug(
                        width=snap_plug_width, 
                        stem_height=stem_height, 
                        stem_depth=stem_depth, 
                        block_height=snap_plug_block_height, 
                        block_depth=snap_plug_block_depth, 
                        center=false, 
                        taper=stem_taper
                    );
                }
            
             
            }
            translate([indent_trans_x_left, indent_trans_y, indent_trans_z])
            rotate([-90, 0,0])
            prismoid(
                size1=[indent_width, indent_height],
                size2=[indent_width_2, indent_height],
                height=indent_depth,
                anchor=BOT+LEFT+FRONT
            );
            translate([indent_trans_x_right, indent_trans_y_right, indent_trans_z])
            rotate([-90, 0,180])
            prismoid(
                size1=[indent_width, indent_height],
                size2=[indent_width_2, indent_height],
                height=indent_depth,
                anchor=BOT+LEFT+FRONT
            );  
        }   
    }
}