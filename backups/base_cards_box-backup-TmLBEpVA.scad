use <boxes/dominion_set_box.scad>
use <BOSL2/std.scad>


num_coppers = 60;
num_silvers = 40;
num_gold = 30;
num_platinum = 12;

num_estate = 20;
num_duchy = 12;
num_province=12;
num_colony = 12;

num_piles = 8;

card_thickness = 0.35;
div_thickness=1.0;
div_full_thickness=1.25;


depth = (
    card_thickness * (
        num_coppers + 
        num_silvers + 
        num_gold + 
        num_platinum + 
        num_estate + 
        num_duchy + 
        num_province +
        num_colony 
    ) +
    num_piles * div_full_thickness
);

div_sizes = [
    0,
    card_thickness * num_coppers + div_full_thickness,
    card_thickness * num_silvers + div_full_thickness,
    card_thickness * num_gold + div_full_thickness,
    card_thickness * num_platinum + div_full_thickness,
    card_thickness * num_estate + div_full_thickness,
    card_thickness * num_duchy + div_full_thickness,
    card_thickness * num_province + div_full_thickness,
    //card_thickness * num_colony + div_thickness,
];
div_locs = cumsum(div_sizes);



//box_bottom_two_halves(
//translate([105, 0, 0]){
//box_bottom(
//    depth=depth,
//    div_locs=div_locs,
//    div_thickness=div_thickness,
//    center=false
//);
//}

difference() {
box_lid(
    depth=depth,
    div_thickness=div_thickness,
    center=false
);
 //cube([500, 100, 100], center=true);   
}

//divider(text="Platinum", thickness=1.0);

//translate([100, 0,0])
//divider(text="Duchy", thickness=1.0);
//
//translate([200, 0,0])
//divider(text="Province", thickness=1.0);
//
//translate([300, 0,0])
//divider(text="Colony", thickness=1.0);
