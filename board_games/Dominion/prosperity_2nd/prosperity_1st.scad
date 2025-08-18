use <boxes/dominion_set_box.scad>
use <BOSL2/std.scad>


cards = [
["Bank", 10],
["Bishop", 10],
["City", 10],
["Contraband", 10],
["Counting House", 10],
["Expand", 10],
["Forge", 10],
//["Goons", 10],
["Grand Market", 10],
["Hoard", 10],
["King's Court", 10],
["Loan", 10],
["Mint", 10],
["Monument", 10],
//["Mountebank", 10],
["Peddler", 10],
["Quarry", 10],
//["Rabble", 10],
["Royal Seal", 10],
["Talsiman", 10],
["Trade Route", 10],
["Vault", 10],
["Venture", 10],
["Watchtower", 10],
["Worker's Village", 10],
["Randomizers", 22],
["Victory Tokens", 60], 
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
//    center=false,
//    name_text="prosperity"
//);


translate([0, depth*1.2, 0]){
    box_lid(
        depth=depth,
        div_thickness=div_thickness,
        center=false,
        name_text="prosperity"
    );
}

//div_idx_start = 20;
//div_idx_end = 23;
//for (idx=[div_idx_start:div_idx_end]) {
//    translate([200, 90*1.1*idx, 0]){
//        divider(
//            text=cards[idx][0], 
//            thickness=1.0, 
//            top_bar_width_percentage=0.7
//        );
//    }
//}
