use <boxes/dominion_set_box_2.scad>
use <BOSL2/std.scad>


cards = [
["Copper", 60],
["Silver", 40],
["Gold", 30],
["Platinum", 12],
["Estate", 20,],
["Duchy", 12,],
["Province", 12],
["Colony", 12],
//["Curse", 30],
];

num_piles=len(cards);

// unsleeved card: 0.35
// sleeved card: .47

card_thickness = 0.35 * 1.3;
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
box_bottom_magnets(
    depth=depth,
    div_locs=div_locs,
    div_thickness=div_thickness,
    center=false
//    name_text="base"
);


//translate([0, depth*1.2, 0]){
 translate([102,0,81])
 rotate([180, 0, 180]){
    box_top_magnets(
        bot_depth=depth,
        div_thickness=div_thickness
        //name_text="base"
    );
}
//
//div_idx_start = 8;
//div_idx_end = 8;
//for (idx=[div_idx_start:div_idx_end]) {
//    translate([200, 90*1.1*idx, 0]){
//        divider(text=cards[idx][0], thickness=1.0);
//    }
//}
