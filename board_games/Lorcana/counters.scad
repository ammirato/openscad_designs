include <BOSL2/std.scad>

// dime radius is 8.955 mm

//num_ones = 10;
//num_threes = 5;
//num_fives = 5;
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
//for (idx=[0:num_ones-1]){
//    translate([50, 11*idx, 0])
//    damage_counter(value="1", radius=5);
//}


lore_counter(value="1");


module lore_counter(
    value, 
    width=40, 
    thickness=3, 
    text_thickness=1
){   
    point=0.001;
    minor_radius = width/2 - point;
    major_radius= width*2 - minor_radius - point;
    
    union(){
        linear_extrude(thickness){
            round2d(r=.5){
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
        translate([width/2,width * 5/8,thickness]){
            linear_extrude(text_thickness){
                text(
                    value, 
                    size=width/4, 
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
        translate([radius, 0,0])
        cylinder(h=thickness, r=radius, anchor=BOTTOM+FRONT);
        
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
