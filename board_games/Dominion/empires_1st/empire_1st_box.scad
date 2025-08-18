use <boxes/dominion_set_box_2.scad>
use <BOSL2/std.scad>


cards = [
["Archive", 10],
["Capital", 10],
["Castles", 12],
//["Catapult/Rocks", 10],
["Chariot Race", 10],
["Charm", 10],
["City Quarter", 10],
["Crown", 10],
["Encampment/Plunder", 10],
//["Enchantress", 10],
["Engineer", 10],
["Farmers Market", 10],
["Forum", 10],
["Gladiator/Fortune", 10],
["GroundsKeeper", 10],
//["Legionary", 10],
["Overlord", 10],
["Patrician/Emporium", 10],
["Royal Blacksmith", 10],
["Sacrifice", 10],
["Settlers/BustlingVillage", 10],
["Temple", 10],
["Villa", 10],
["Wild Hunt", 10],
["Events", 13],
["Landmarks", 21],
["Tokens", 60],
["Randomizers", 25]
];

num_piles=len(cards);

card_thickness = 0.35; //*1.3;
div_thickness=0.75; //usually 1.0
div_full_thickness=2.0;


card_counts = [for  (idx=[0: len(cards)-1]) cards[idx][1]];
echo(card_counts);
total_num_cards = sum(card_counts);

//depth = (card_thickness * total_num_cards
//            + div_full_thickness * num_piles +1);
movement_depth=25;
depth = (card_thickness * total_num_cards + movement_depth);


//div_sizes_no_start = [ 
//    for (idx=[0: len(cards) -2])
//        card_thickness * cards[idx][1] + div_full_thickness
//    ];
//    
//div_sizes = concat([0], div_sizes_no_start);
div_sizes_no_start = [ 
    for (idx=[1: len(cards) -1])
        card_thickness * cards[idx][1] + div_full_thickness
    ];
div_size_start = card_thickness * cards[0][1];
div_sizes = concat([div_size_start], div_sizes_no_start);
div_locs = cumsum(div_sizes);



//box_bottom_two_halves(
//translate([105, 0, 0]){
//box_bottom_magnets(
//    depth=depth,
////    div_locs=div_locs,
////    div_thickness=div_thickness,
//    center=false
//);

//
//translate([0, depth*1.2, 0]){
// translate([99,0,74.6])
// rotate([180, 0, 180])
//    box_top_magnets(
//        bot_depth=depth,
////        div_thickness=div_thickness,
//        center=false,
//        text="Empires",
//        text2="Debt / Victory Tokens"
//    );
//}

//div_idx_start = 20;
//div_idx_end = 21;
//for (idx=[div_idx_start:div_idx_end]) {
//    translate([200, 90*1.1*idx, 0]){
//        divider(
//            text=cards[idx][0], 
//            thickness=1.0, 
//            top_bar_width_percentage=0.6
//        );
//    }
//}

//div_idx_start = 4;
//div_idx_end = 7;
//for (idx=[div_idx_start:div_idx_end]) {
//    translate([200, 90*1.1*idx, 0]){
//        divider_raised(text=cards[idx][0], thickness=1.0, bot_box_height=35, fill_bar=true);
//    }
//}
// Parameters
div_idx_start = 24; // Starting index for objects to display
div_idx_end =24;   // Ending index for objects to display
cols = 2;          // Number of columns in the rectangle (2 for 2x2)

////// Loop to render objects in a 2x2 layout
for (idx = [div_idx_start:div_idx_end]) {
    row = floor((idx - div_idx_start) / cols);
    col = (idx - div_idx_start) % cols;

    // Determine orientation based on position in the rectangle
    orientation = (row == 0 && col == 0) ? -90    // Top-left: ^
                : (row == 0 && col == 1) ? 0 // Top-right: <
                : (row == 1 && col == 0) ? 0  // Bottom-left: >
                : 90;                          // Bottom-right: ^

    translation_y = (row == 0 && col == 0) ? 0    // Top-left: ^
            : (row == 0 && col == 1) ? -12 // Top-right: <
            : (row == 1 && col == 0) ? 0  // Bottom-left: >
            : -12; 
   
   translation_x = (row == 0 && col == 0) ? 0    // Top-left: ^
            : (row == 0 && col == 1) ? 0 // Top-right: <
            : (row == 1 && col == 0) ? 12  // Bottom-left: >
            : 12;   

    // Translate and rotate objects
    translate([85 * col, 83.5 * row , 0]) {
        translate([translation_x, translation_y, 0]){
        rotate([0, 0, orientation]) {
            divider_raised_square(
                text=cards[idx][0], 
                thickness=div_thickness,
                bot_box_height=35, 
                fill_bar=true,
                text_height=4
            );
        }
        }
    }
}
