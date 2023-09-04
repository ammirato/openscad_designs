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


lore_counter();


module lore_counter(){
    //teardrop2d(r=30, angle=30);
    //star(n=4, ir=15, or=30);
    square([40, 80], center=false);
    circle(r=20);
    circle(r=20
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
