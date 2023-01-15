//$fa = 1;
//$fs = 0.4;

//  body
base_height = 5;
top_height = 8;
top_trans_z = base_height/2 + top_height/2;
rotate([5,0,0]) {
    cube([60, 20, base_height], center=true);
translate([0,0,top_trans_z - 0.001])
    cube([30, 20, top_height], center=true);
}


// axles
axle_height = 35;
translate([20, 0, 0])
    rotate([90, 0, 0])
    cylinder(h=axle_height, r=1, center=true);
translate([-20, 0, 0])
    rotate([90, 0, 0])
    cylinder(h=axle_height, r=1, center=true);
    
// wheels
wheel_radius = 8;
wheel_scale = [1.0, 1.0, 0.3];
wheel_base_trans_y = axle_height/2;
translate([-20, -wheel_base_trans_y, 0])
    rotate([0, 0,0])  
    wheel();
translate([-20, wheel_base_trans_y, 0])
    rotate([0, 0,0])  
    wheel();
translate([20, wheel_base_trans_y, 0])
    rotate([0, 0, -20])  
    wheel();
translate([20, -wheel_base_trans_y, 0])
    rotate([0, 0, -20])  
    wheel();


module wheel(){
    
    wheel_radius = 8;
    side_spheres_radius= 50;
    hub_thickness = 4;
    side_offset = side_spheres_radius +hub_thickness/2;

    hole_thickness = 1.5;
    hole_offset = 3;
    
    difference(){
        sphere(r=wheel_radius, center=true);
        
        //cut to size
        translate([0, side_offset, 0]){
            sphere(r=side_spheres_radius, center=true);
        }
        translate([0,-side_offset,0]) {
            sphere(r=side_spheres_radius, center=true);
        } 
       
        //holes
        translate([hole_offset, 0, hole_offset]){
                rotate([90, 0, 0]){
        cylinder(r=hole_thickness, h=hub_thickness*2, center=true);
            
            }
        }
        translate([-hole_offset, 0, hole_offset]){
                rotate([90, 0, 0]){
        cylinder(r=hole_thickness, h=hub_thickness*2, center=true);
            
            }
        }
        translate([-hole_offset, 0, -hole_offset]){
                rotate([90, 0, 0]){
        cylinder(r=hole_thickness, h=hub_thickness*2, center=true);
            
            }
        }
        translate([hole_offset, 0, -hole_offset]){
                rotate([90, 0, 0]){
        cylinder(r=hole_thickness, h=hub_thickness*2, center=true);
            
            }
        }
    }
}

module wheel2(){
    //cylinder(h=3, r=wheel_radius, center=true);
    rotate([90, 0,0])
    scale(wheel_scale)
    sphere(r=wheel_radius, center=True);
}
