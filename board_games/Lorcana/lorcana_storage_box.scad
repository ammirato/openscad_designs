include <BOSL2/std.scad>
use <primitives/prisms.scad>
use <primitives/boxes.scad>
use <snap_joints/cantilever.scad>
//use <boxes/dominion_set_box.scad>

eps=0.001;

sep_dist = 23;
cards = [
["Amber", sep_dist],
["Amythest", sep_dist],
["Emerald", sep_dist],
["Ruby", sep_dist],
["Sapphire", sep_dist],
["Steel", sep_dist],
["Deck 1", sep_dist],
["Deck 2", sep_dist],
["", sep_dist], // 1
["", sep_dist], // 2
["", sep_dist], // 3
["", sep_dist], // 4
["", sep_dist], // 5
["", sep_dist], // 6
//["", sep_dist], // 7
//["", sep_dist], // 8
//["", sep_dist], // 9
//["", sep_dist], // 10
];

num_piles=len(cards);

// unsleeved card: 0.35
// sleeved card: .47

card_thickness = 0.35 * 1.125;
div_thickness=1.0;
div_full_thickness=2.0;


card_counts = [for  (idx=[0: len(cards)-1]) cards[idx][1]];
echo(card_counts);
total_num_cards = sum(card_counts);

depth = (card_thickness * total_num_cards
            + div_full_thickness * num_piles);


div_sizes_no_start = [ 
    for (idx=[0: len(cards) -2])
        card_thickness * cards[idx][1] + div_full_thickness
    ];
    
div_sizes = concat([0], div_sizes_no_start);
div_locs = cumsum(div_sizes);

//box_bottom_two_halves(
//translate([105, 0, 0]){
//box_bottom(
//    depth=depth,
//    div_locs=div_locs,
//    div_thickness=div_thickness,
//    center=false,
//    name_text=""
//);
//
//translate([0, depth*1.2, 0]){
// translate([93+6,0,69+8+5])
// rotate([180, 0, 180]){
//    box_lid(
//        bot_depth=depth,
//        div_thickness=div_thickness
//        //name_text="base"
//    );
//}
//
div_idx_start = 4;
div_idx_end = 7;
for (idx=[div_idx_start:div_idx_end]) {
    translate([0, 90*1.1*idx, 0]){
        divider_raised(text=cards[idx][0], thickness=1.0, bot_box_height=45);
        //divider(text=cards[idx][0], thickness=1.0, bot_box_height=45);

  }
}
//token_tray(10);

//box params
default_width=93;
default_outer_height=45;
default_inner_height=default_outer_height - 7; 
default_inner_wall_thickness=5;
default_outer_wall_thickness=3;
default_snap_plug_block_height=3; 
default_snap_plug_width=15;
default_snap_socket_tol=1.5;
default_chamfer=2.0;
default_div_thickness=1.0;
default_div_extra_width=1.0;
default_div_tol=0.7;
default_div_tol_thickness=1.0;
default_div_z_indent=0.5;
default_extra_bottom_thickness=1.0; 
default_center=false;
default_name="";

//divider params
default_div_width = default_width + default_div_extra_width +default_div_tol*1.3;
default_div_text_height = 5;
default_div_height = 68 + default_div_text_height;

//lid only params
lid_height_tol = 1.5; //had been 2 in prev versions
default_lid_height = default_div_height - default_outer_height + lid_height_tol;
default_lid_stem_extra_height = default_outer_height - default_inner_height;
default_lid_stem_plug_taper = 1.0;

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
    full_width = width + outer_wall_thickness*2;
    full_depth = depth + outer_wall_thickness*2 + inner_wall_thickness;
    full_height = outer_height + extra_bottom_thickness + outer_wall_thickness;
    full_outer_height = outer_height + extra_bottom_thickness;

    cut_depth = inner_wall_thickness + outer_wall_thickness+2*eps;
    cut_height =  snap_plug_block_height + snap_socket_tol;
    cut_width = snap_plug_width + snap_socket_tol;
    
    cut_trans_x = full_width/2 - cut_width/2;
    cut_trans_y = 0;
    cut_trans_z = inner_height + outer_wall_thickness + extra_bottom_thickness/2  - cut_height/2 +eps ;
    
    center_trans_x = center ? -1*(full_width/2) : 0;
    center_trans_y = center ? -1*(full_depth/2) : 0;
    center_trans_z = center ? -1*(full_height/2) : 0;

    div_width = width + div_extra_width + div_tol*2;
    div_trans_x = full_width/2 - div_width/2;
    div_trans_y = outer_wall_thickness + inner_wall_thickness;
    div_trans_z = outer_wall_thickness + extra_bottom_thickness - div_z_indent;
    div_height = outer_height+ div_z_indent + extra_bottom_thickness;
    div_full_thickness = div_thickness + div_tol_thickness;

    extra_bottom_trans_x = (outer_wall_thickness);
    extra_bottom_trans_y = (outer_wall_thickness + inner_wall_thickness);
    extra_bottom_trans_z = outer_wall_thickness - eps;

    text_depth = outer_wall_thickness;
    
    translate([center_trans_x, center_trans_y, center_trans_z]){
        difference() {
            translate([0,0,extra_bottom_thickness/2]){
                union () {
                    closed_box_with_hinge_bottom(width=width, depth=depth, outer_height=full_outer_height, inner_height=inner_height, outer_wall_thickness=outer_wall_thickness, inner_wall_thickness=inner_wall_thickness, chamfer=2.0, center=false);
                    translate([extra_bottom_trans_x, extra_bottom_trans_y, extra_bottom_trans_z]) {
                        cube([width + eps, depth + eps, extra_bottom_thickness], center=false);
                    }
                }
            }
            
            //cut openings for snap fit first
            translate([cut_trans_x, cut_trans_y, cut_trans_z]) {
                rotate([0, 0, 0]){
                    cube([cut_width, cut_depth,cut_height], center=false);
                }
            }
            
            //text name
            translate([full_width/2, text_depth-eps, 10]){
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
div_thickness=default_div_thickness,
div_extra_width=default_div_extra_width,
div_tol=default_div_tol,
div_tol_thickness=default_div_tol_thickness,
div_z_indent=default_div_z_indent,
extra_bottom_thickness=default_extra_bottom_thickness, 
center=default_center,
//stem_extra_height=default_lid_stem_extra_height,
stem_plug_taper=default_lid_stem_plug_taper,
name_text=default_name,
extra_height=0,
) {

    height = height + extra_height;
    stem_extra_height = bot_outer_height - bot_inner_height;// - snap_socket_tol/2;
    echo(bot_outer_height, bot_inner_height);
    stem_height = height  + stem_extra_height +  snap_plug_block_height;// + snap_socket_tol*1.5;
    echo(height, stem_extra_height, snap_plug_block_height, stem_height);
    full_width = bot_width + outer_wall_thickness*2;
    full_depth = bot_depth + outer_wall_thickness*2 + inner_wall_thickness;
    stem_stick_out_height = (stem_height - height) > 0 ? (stem_height - height) : 0;
    full_height = height + outer_wall_thickness + stem_stick_out_height;

    snap_plug_block_depth = outer_wall_thickness*0.4;
    stem_depth = inner_wall_thickness*0.8 - snap_plug_block_depth*.8;
        
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

module token_tray(
    depth,
    width=default_div_width,
    height=default_outer_height, 
    div_thickness=default_div_thickness,
    div_extra_width=default_div_extra_width,
){
    
    box_width = width - div_extra_width;
    box_height = height*0.8;
    box_depth = depth;
    
    slider_width = div_extra_width;
    slider_height=box_height;
    slider_depth=div_thickness;
    
    union(){
        
        //main box
        translate([slider_width, 0, 0]){
            open_box(
                width=box_width,
                depth=box_depth,
                height=box_height,
                wall_thickness=div_thickness,
                center=false
            );
        }
        
        //sliders
        cube([slider_width, slider_depth, slider_height], center=false);
        translate([0, box_depth + div_thickness, 0])   
            cube([slider_width, slider_depth, slider_height], center=false);
        translate([box_width + div_thickness*2 + slider_width, 0, 0])   
            cube([slider_width, slider_depth, slider_height], center=false);
        translate([box_width + div_thickness*2 + slider_width, box_depth + div_thickness, 0])   
            cube([slider_width, slider_depth, slider_height], center=false);

    }
}

module divider(
text, 
width=default_div_width, 
height=default_div_height, 
bot_box_height=-1,
thickness=default_div_thickness, 
text_height=default_div_text_height, 
top_bar_width_percentage=0.55,
center=False,
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
    second_bottom_bar_trans_y_1 = bottom_bar_trans_y + bottom_bar_height*2;
    second_bottom_bar_trans_y_2 = bottom_bar_trans_y + bot_box_height - bottom_bar_height;
    second_bottom_bar_trans_y = bot_box_height > 0 ? second_bottom_bar_trans_y_2 : second_bottom_bar_trans_y_1;

    //third_bottom_bar_trans_y = bot_box_height > 0 ? (bot_box_height - bottom_bar_height) : second_bottom_bar_trans_y + bottom_bar_height*2;

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
//        translate([0,third_bottom_bar_trans_y,0]){
//            cube([bottom_bar_width, bottom_bar_height, thickness], center=true);
//        }
    }  
}

module divider_raised(
text, 
width=default_div_width, 
height=default_div_height, 
bot_box_height=-1,
thickness=default_div_thickness, 
text_height=default_div_text_height, 
top_bar_width_percentage=0.55
) 
{
    text_thickness = thickness*0.5;
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
    text_trans_z = text_thickness;///2 * -1;
    bottom_bar_trans_y = -1 * (height/2 - bottom_bar_height/2);
    //second_bottom_bar_trans_y = bottom_bar_trans_y + bottom_bar_height*2;
    second_bottom_bar_trans_y_1 = bottom_bar_trans_y + bottom_bar_height*2;
    second_bottom_bar_trans_y_2 = bottom_bar_trans_y + bot_box_height - bottom_bar_height;
    second_bottom_bar_trans_y = bot_box_height > 0 ? second_bottom_bar_trans_y_2 : second_bottom_bar_trans_y_1;




    union() {
        
        translate([0, top_bar_trans_y, 0]) {
            cube([top_bar_width,top_bar_height, thickness], center=true);
        }
        translate([0, text_trans_y, text_trans_z]){
            linear_extrude(text_thickness)
            //text(text, size=text_height, font= "Comic Sans MS:style=Bold", halign="center", valign="center", spacing=text_spacing);
            text(text, size=text_height, font="Helvetica:style=Bold", halign="center", valign="center", spacing=text_spacing);

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