use <boxes/dominion_set_box.scad>
use <BOSL2/std.scad>


cards = [
["Black Cat", 10],
["sleigh", 10],
["Supplies", 10],
["Camel Train", 10],
["Goatherd", 10],
["Scrap", 10],
["Sheepdog", 10],
["Snowy Village", 10],
["Stockpile", 10],
["Bounty Hunter", 10],
["Cardinal", 10],
["Cavalry", 10],
["Groom", 10],
["Hostelry", 10],
["Village Green", 10],
["Barge", 10],
["Coven", 10],
["Displace", 10],
["Falconer", 10],
["Gatekeeper", 10],
["Hunting Lodge", 10],
["Kiln", 10],
["Livery", 10],
["Mastermind", 10],
["Paddock", 10],
["Sanctuary", 10],
["Fisherman", 10],
["Destrier", 10],
["Wayfarer", 10],
["Animal Fair", 10],
["Horse", 30],
["Events", 20],
["Ways", 20],
["Randomizers", 22],
//["Exile Mats", 60],  TODO: add extra height
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


//
box_bottom_two_halves(
////translate([105, 0, 0]){
//box_bottom(
    depth=depth,
    div_locs=div_locs,
    div_thickness=div_thickness,
    center=false,
    name_text="menagerie"
);

//translate([0, depth*1.2, 0]){
//    box_lid(
//        depth=depth,
//        div_thickness=div_thickness,
//        center=false,
//        name_text="menagerie"
//    );
//}

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
