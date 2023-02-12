
$fa = 10;
$fs = 5;
translate([0,0,2.5]){
    cube([10, 10, 5], center=true);
}
buckle_plug(10, 10, 5);

module buckle_plug(width, depth, height){
    
    original_w = 80;
    original_d = 80;
    original_h = 20;
    
    scale([width/original_w, depth/original_d, height/original_h]){
        import ("buckle1_plug.stl", $fn=1);
    }
  
}



