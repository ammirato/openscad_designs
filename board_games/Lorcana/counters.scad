include <BOSL2/std.scad>

// // dime radius is 8.955 mm

num_ones = 10;
num_threes = 5;
num_fives = 5;

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
//for (idx=[0:num_ones-1]){
//    translate([50, 11*idx, 0])
//    damage_counter(value="1", radius=5);
//}

num_lore_ones = 1;
num_lore_threes = 1;
num_lore_tens = 1;

for (idx=[0:num_lore_tens-1]){
    translate([50, 30*idx, 0])
        lore_counter(value="10", width=17);
}

for (idx=[0:num_lore_threes-1]){
    translate([30, 20*idx, 0])
        lore_counter(value="3", width=13);
}

for (idx=[0:num_lore_ones-1]){
    translate([0, 15*idx, 0])
        lore_counter(value="1", width=10);
}



module lore_counter(
    value, 
    width=40, 
    thickness=3, 
    text_thickness=1
){      
    union(){
        //base
        _lore_base(width=width, thickness=thickness);
        
        //outline
        outline_width = width*0.85;
        outline_sub_width = outline_width*0.85;
        outline_thickness = text_thickness/2;
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
                    size=width/5, 
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
    text_thickness=1,
){
    union(){
        
        // base
        translate([radius, 0,0])
        cylinder(h=thickness, r=radius, anchor=BOTTOM+FRONT);
        
        //outline
        translate([radius, radius, thickness]){
            linear_extrude(text_thickness/2){
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