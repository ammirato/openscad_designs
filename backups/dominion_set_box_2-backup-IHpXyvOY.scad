use <boxes/dominion_set_box_2.scad>
use <BOSL2/std.scad>


cards = [
["Artisan", 10],
//["Bandit", 10],
//["Bureaucrat", 10],
["Cellar", 10],
["Chapel", 10],
["Council Room", 10],
["Festival", 10],
["Gardens", 12],
["Harbinger", 10],
["Laboratory", 10],
["Library", 10],
["Market", 10],
["Merchant", 10],
//["Militia", 10],
["Mine", 10],
["Moat", 10],
["Moneylender", 10],
["Poacher", 10],
["Remodel", 10],
["Sentry", 10],
["Smithy", 10],
["Throne Room", 10],
["Vassal", 10],
["Village", 10],
//["Witch", 10],
["Workshop", 10],
["Randomizers", 22],
];

num_piles=len(cards);

card_thickness = 0.35; //*1.3;
div_thickness=1.0;
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
//        center=false
//    );
////}

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

// Parameters
div_idx_start = 16; // Starting index for objects to display
div_idx_end = 19;   // Ending index for objects to display
cols = 2;          // Number of columns in the rectangle (2 for 2x2)

// Loop to render objects in a 2x2 layout
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
            divider_raised_square(text=cards[idx][0], thickness=1.0, bot_box_height=35, fill_bar=true);
        }
        }
    }
}
