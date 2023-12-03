include <BOSL2/std.scad>

eps = 0.001;
// // dime radius is 8.955 mm

//num_ones = 10;
//num_threes = 6;
//num_fives = 2;
//
//for (idx=[0:num_fives-1]){
//    translate([0, 20*idx, 0])
//        damage_counter(value="5", radius=9);
//}
//
//for (idx=[0:num_threes-1]){
//    translate([30, 15*idx, 0])
//        damage_counter(value="3", radius=7);
//}
//
//for (idx=[0:5]){
//    translate([50, 11*idx, 0])
//    damage_counter(value="1", radius=5);
//}
//for (idx=[0:5]){
//    translate([70, 11*idx, 0])
//    damage_counter(value="1", radius=5);
//}

//num_lore_ones = 10;
//num_lore_threes = 6;
//num_lore_tens = 2;
//
//for (idx=[0:num_lore_tens-1]){
//    translate([150, 33*idx, 0])
//        lore_counter(value="10", width=20, text_size=4.25);
//}
//
//for (idx=[0:num_lore_threes-1]){
//    translate([130, 24*idx, 0])
//        lore_counter(value="3", width=16, text_size=5.25);
//}
//
//for (idx=[0:5]){
//    translate([100, 20*idx, 0])
//        lore_counter(value="1", width=13, text_size=4.65);
//}
//for (idx=[0:5]){
//    translate([80, 20*idx, 0])
//        lore_counter(value="1", width=13, text_size=4.65);
//}

//cant_quest_width = 38;
//cant_quest_depth = 11;
//reminder_rect(
//    text="Can't Quest",
//    width=cant_quest_width,
//    depth=cant_quest_depth
//);
//
//cant_ready_width = 39;
//cant_ready_depth = 11;
//translate([50, 0, 0])
//reminder_rect(
//    text="Can't Ready",
//    width=cant_ready_width,
//    depth=cant_ready_depth
//);
//
//reckless_width = 31;
//reckless_depth = 11;
//translate([100, 0, 0])
//reminder_rect(
//    text="Reckless",
//    width=reckless_width,
//    depth=reckless_depth
//);
//
evasive_width = 28;
evasive_depth = 11;
translate([0, 0, 0])
reminder_rect(
    text="Evasive",
    width=evasive_width,
    depth=evasive_depth
);

ward_width = 20;
ward_depth = 11;
translate([30, 0, 0])
reminder_rect(
    text="Ward",
    width=ward_width,
    depth=ward_depth
);

bodyguard_width = 35;
bodyguard_depth = 11;
translate([53, 0, 0])
reminder_rect(
    text="Bodyguard",
    width=bodyguard_width,
    depth=bodyguard_depth
);


//_damage_symbol(radius=10, thickness=1);
//minus_damage_token(
//    width=18,
//    depth=15
//);



module lore_counter(
    value, 
    width=40, 
    thickness=3, 
    text_thickness=0.5,
    text_size=-1
){      
    union(){
        text_size = text_size > 0 ? text_size : width/5;
        //base
        _lore_base(width=width, thickness=thickness);
        
        //outline
        outline_width = width*0.85;
        outline_sub_width = outline_width*0.85;
        outline_thickness = text_thickness;///2;
        translate([0,0,thickness]){
        translate([(width - outline_width)/2, (width - outline_width)/1.9, 0]){
            difference(){
                    _lore_base(width=outline_width, thickness=outline_thickness);
                    translate([(outline_width - outline_sub_width)/2, (outline_width - outline_sub_width)/2, 0])
                        _lore_base(width=outline_sub_width, thickness=outline_thickness);
               }
            }
        }
        
        //text
        translate([width/2,width * 5/8,thickness]){
            linear_extrude(text_thickness){
                text(
                    value, 
                    size=text_size, 
                    font="Helvetica:style=Bold", 
                    halign="center", valign="center", 
                    spacing=1
                );
            }
        }
    }
}

module damage_counter(
    value, 
    radius,
    thickness=3,
    text_thickness=0.5,
){
    union(){
        
        // base
        translate([radius, 0,0])
        cylinder(h=thickness, r=radius, anchor=BOTTOM+FRONT);
        
        //outline
        translate([radius, radius, thickness]){
            linear_extrude(text_thickness){
                stroke(circle(r=radius*0.85), width=radius/20, closed=true);
            }
        }
        
        // value
        translate([radius, radius, thickness]){
                rotate([0, 0, 0]){
                    linear_extrude(text_thickness){
                        text(
                            value, 
                            size=radius, 
                            font="Helvetica:style=Bold", 
                            halign="center", valign="center", 
                            spacing=1
                        );
                    }
                }
            }
    }
}

module reminder_rect(
    text,
    width,
    depth,
    thickness=3,
    text_thickness=0.5,
    text_size=3.5
){
    
    border_width = width * 0.04;
    inner_width = width - border_width*2;
    inner_depth = depth - border_width*2;
    inner_wall_thickness = width * 0.025;
    
    inner_trans_x = width/2;
    inner_trans_y = depth/2;
    inner_trans_z = thickness-eps;
    
    union(){
        cuboid([width, depth, thickness], chamfer=0.5,  except=[BOT], anchor=BOTTOM + LEFT + FRONT);
        translate([inner_trans_x, inner_trans_y, inner_trans_z]){
            rect_tube(
                size=[inner_width, inner_depth], 
                wall=inner_wall_thickness, 
                h=text_thickness,
                //rounding=3,
                anchor=BOTTOM
            );
            linear_extrude(text_thickness){
                        text(
                            text, 
                            size=text_size, 
                            font="Helvetica:style=Bold", 
                            halign="center", valign="center", 
                            spacing=1.1
                        );
            }
        }
    }
}

module minus_damage_token(
    width,
    depth,
    thickness=3,
    text_thickness=0.5,
    text_size=4.5
){
    
    border_width = width * 0.04;
    inner_width = width*0.95 - border_width*2;
    inner_depth = depth*0.95 - border_width*2;
    inner_wall_thickness = width * 0.025;
    
    inner_trans_x = width/2;
    inner_trans_y = depth/2;
    inner_trans_z = thickness-eps;
    
    text_trans_x = width * 0.2;
    text_trans_y = depth/2;
    text_trans_z = thickness-eps;
    
    symbol_radius = width/2 * 0.4;
    symbol_trans_x = width*0.6 - symbol_radius;
    symbol_trans_y = depth/2 - symbol_radius;
    symbol_trans_z = thickness-eps;
    
    union(){
        cuboid([width, depth, thickness], chamfer=0.5,  except=[BOT], anchor=BOTTOM + LEFT + FRONT);
        translate([inner_trans_x, inner_trans_y, inner_trans_z]){
            rect_tube(
                size=[inner_width, inner_depth], 
                wall=inner_wall_thickness, 
                h=text_thickness,
                anchor=BOTTOM
            );
        }
        translate([text_trans_x, text_trans_y, text_trans_z]){
            linear_extrude(text_thickness){
                        text(
                            "-", 
                            size=text_size, 
                            font="Helvetica:style=Bold", 
                            halign="center", valign="center", 
                            spacing=1.1
                        );
            }
        }
        translate([symbol_trans_x,symbol_trans_y,symbol_trans_z]){
            _damage_symbol(
                radius=symbol_radius, 
                thickness=text_thickness, 
                wall=width/40
            );
        }
    }
}




module _lore_base(width, thickness){   
    point=0.001;
    minor_radius = width/2 - point;
    major_radius= width*2 - minor_radius - point;   
    linear_extrude(thickness){
        round2d(r=width/30){
            difference(){
                square([width, width*2], center=false);
                circle(r=minor_radius);
                translate([width, 0, 0])
                    circle(r=minor_radius);
                translate([0, width*2, 0]){
                    ellipse(r=[minor_radius, major_radius]);
                }
                translate([width+point, width*2, 0]){
                    ellipse(r=[minor_radius, major_radius]);
                }
            }
        }  
    } 
}

module _damage_symbol(radius, thickness, wall=1){
    translate([radius, radius, 0]){
        union(){
            tube(
                h=thickness, 
                or=radius, 
                wall=wall,
                anchor=CENTER + BOTTOM
            );
            rotate([0,0,45]){
                square_side = radius*2;
                rect_tube(
                    size=[square_side, square_side], 
                    wall=wall, 
                    h=thickness,
                    anchor=CENTER + BOTTOM
                );
            }
            rotate([0,0, 90]){
                square_side = radius*2;
                rect_tube(
                    size=[square_side, square_side], 
                    wall=wall, 
                    h=thickness,
                    anchor=CENTER + BOTTOM
                );
            }
        }
    }
}