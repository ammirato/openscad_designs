include <BOSL2/std.scad>
use <primitives/boxes.scad>
$fn=25;
eps = 0.001;
//

//// Loot/MonsterSpawn + Activation/Corruption + Portal/Objective/Lifebringer/DarknessTracker
//token_magnet_box(
//    width=43, 
//    height=25, 
//    depth=156, 
//    wall_thickness=3.3,
//    hole_radius=2.5*1.10,
//    hole_height=3*1.01,
//    chamfer=0.5,
//    div_locs=[46, 92],
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

//// Treasure + Fire/Ice
//token_magnet_box(
//    width=43, 
//    height=25, 
//    depth=80, 
//    wall_thickness=3.3,
//    hole_radius=2.5*1.10,
//    hole_height=3*1.01,
//    chamfer=0.5,
//    div_locs=[46],
//    div_thickness=1
//);

// Bard + Tinkerers + Pal/Ber/Sha/Nec + playertokens
token_magnet_box(
    width=43, 
    height=25, 
    depth=185, 
    wall_thickness=3.3,
    hole_radius=2.5*1.10,
    hole_height=3*1.01,
    chamfer=0.5,
    div_locs=[62, 104, 140],
    div_thickness=1
);




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