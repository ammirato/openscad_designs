include <BOSL2/std.scad>
use <primitives/boxes.scad>
$fn=25;
eps = 0.001;
//

//// Treasure + Player + Fire/Ice
//token_magnet_box(
//    width=43, 
//    height=25, 
//    depth=113, 
//    wall_thickness=3.3,
//    hole_radius=2.5*1.10,
//    hole_height=3*1.01,
//    chamfer=0.5,
//    div_locs=[41, 82],
//    div_thickness=1
//);

//// Mana + Health
//token_magnet_box(
//    width=43, 
//    height=25, 
//    depth=184, 
//    wall_thickness=3.3,
//    hole_radius=2.5*1.10,
//    hole_height=3*1.01,
//    chamfer=0.5,
//    div_locs=[92],
//    div_thickness=1
//);

//// Portal/obj/life/dt + activation/corruption + loot/spawn
//token_magnet_box(
//    width=43, 
//    height=25, 
//    depth=153, 
//    wall_thickness=3.3,
//    hole_radius=2.5*1.10,
//    hole_height=3*1.01,
//    chamfer=0.5,
//    div_locs=[61, 107],
//    div_thickness=1
//);

//// Bard + Tinkerers + Pal/Ber/Sha/Nec 
token_magnet_box(
    width=43, 
    height=25, 
    depth=138, 
    wall_thickness=3.3,
    hole_radius=2.5*1.10,
    hole_height=3*1.01,
    chamfer=0.5,
    div_locs=[61, 102],
    div_thickness=1
);


//185 + 7 + 80 + 7 + 184 + 7 + 156 + 7

//translate([0, 0, 35.3 ]){
//    box_with_corner_magnets_top(
//        width=90, 
//        height=32, 
//        depth=114, 
//        wall_thickness=3.3,
//        hole_radius=2.5*1.10,
//        hole_height=3*1.01,
//        chamfer=0.5
//    );
//}




module token_magnet_box(
    width,
    height,
    depth,
    wall_thickness,
    hole_radius,
    hole_height,
    chamfer,
    div_locs=[10,150],
    div_thickness=-1
)
{
      
    div_thickness = div_thickness > 0 ? div_thickness: wall_thickness;
    if (div_thickness < -1){
        div_thickness = wall_thickness;
    }
    union(){
        box_with_corner_magnets(
            width=width, 
            height=height, 
            depth=depth, 
            wall_thickness=wall_thickness,
            hole_radius=hole_radius,
            hole_height=hole_height,
            add_fillets=true,
            chamfer=chamfer
        ); 
        
        div_width = width + 2*eps;
        div_height = height;
        div_depth = div_thickness;
        div_trans_x = div_width/2 + wall_thickness;
        div_trans_z = div_height/2 + wall_thickness - eps;
        
        for (div_loc = div_locs) {
            
            div_trans_y = div_depth/2 + wall_thickness + div_loc;
            translate([div_trans_x, div_trans_y, div_trans_z]){
                cube([div_width, div_depth, div_height], center=true);
            }
        }
    }     
}