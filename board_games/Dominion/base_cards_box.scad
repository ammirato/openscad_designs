use <boxes/dominion_set_box.scad>

num_coppers = 60;
num_silvers = 40;
num_gold = 30;
num_platinum = 12;

num_estate = 20;
num_duchy = 12;
num_province=12;
num_colony = 12;

card_width = 0.35;




box_bottom_two_halves(
    width=width,
    depth=depth,
    outer_height=bottom_outer_height, 
    inner_height=bottom_inner_height, 
    inner_wall_thickness=inner_wall_thickness, 
    outer_wall_thickness=outer_wall_thickness, 
    snap_plug_block_height=snap_block_height, 
    snap_plug_width=snap_plug_width, 
    div_locs=[0], 
    extra_bottom_thickness=extra_bottom_thickness, 
    center=false
); 