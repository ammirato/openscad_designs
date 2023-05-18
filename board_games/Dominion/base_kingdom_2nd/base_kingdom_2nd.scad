use <boxes/dominion_set_box.scad>
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

card_thickness = 0.35;
div_thickness=1.0;
div_full_thickness=1.25;


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
//    center=false
//);

//
translate([0, depth*1.2, 0]){
    box_lid(
        depth=depth,
        div_thickness=div_thickness,
        center=false
    );
}

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
