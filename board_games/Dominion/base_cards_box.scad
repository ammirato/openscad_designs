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
    num_piles * div_thickness
);

div_sizes = [
    card_thickness * num_coppers + div_thickness,
    card_thickness * num_silvers + div_thickness,
    card_thickness * num_gold + div_thickness,
    card_thickness * num_platinum + div_thickness,
    card_thickness * num_estate + div_thickness,
    card_thickness * num_duchy + div_thickness,
    card_thickness * num_province + div_thickness,
    card_thickness * num_colony + div_thickness,
];
div_locs = cumsum(div_sizes);
//div_locs = [  for (idx = [0: 1: len(div_locs_sizes)]) div_locs_sizes[idx]];



box_bottom_two_halves(
    depth=depth,
    div_locs=div_locs,
    div_thickness=div_thickness,
    center=false
); 