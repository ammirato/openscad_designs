
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
wheel();   



//union(){
//    translate([0, 50, 0]){
//sphere(r=10);
//translate([10, 0, 0])
//    sphere(r=10);
//    }
//}
//
//
//translate([0, 0, 50]){
//difference(){  
//sphere(r=10);
//translate([10, 0, 0])
//    sphere(r=10);
// translate([0, -12, 0])
//    sphere(r=10);
//    }
//}
//
//
//translate([100, 0, 0]){
//intersection(){
//sphere(r=10);
//translate([10, 0, 0])
//    sphere(r=10);
// //translate([0, -12, 0])
//   // sphere(r=10);
//}
//}