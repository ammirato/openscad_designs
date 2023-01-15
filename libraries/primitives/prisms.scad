
trapezoid_prism(width_lower=20, width_upper=5, depth=20, height=5, center=true, square_right=true);

module trapezoid_prism (width_lower, width_upper, depth, height, center, square_right=false) {
    /* Contruct a trapezoid prism.
    
    The prism will have it's base on the x/y plane, and it's
        top in the positive z direction.
    
    Args:
        width_lower: The width of the lower base (x-axis). Must
            be equal or greater than width_upper.
        width_upper: The width of the upper base (x-axis)
        depth: The depth of the prism (y-axis)
        height: The distance of the top from the base (z-axis)
        center: If True, the bounding box of the prism will be
            centered at (0,0,0)
        square_right: If true, the right side will not slop as expected in
            a trapezoid, but instead will be like a rectangle. Useful for 
            snap fit connectors.
    */
    
    // The prisms will twice as wide as needed, but will be 
    // unioned with the main cube to cut them in half.
    triangular_prisms_width = (width_lower - width_upper); 
    
    
    union() {
    //main cube
        cube([width_upper, depth, height], center=center);
        translate([-1 * width_upper/2, 0,0]){
            triangular_prism(width=triangular_prisms_width, depth=depth, height=height, center=center);
        }
        
        if (square_right){
            squared_width = triangular_prisms_width/2;
            translate([width_upper/2 + squared_width/2, 0,0]){
                cube([squared_width, depth, height], center=center);
            }
        }
        else{
            translate([width_upper/2, 0,0]){
                triangular_prism(width=triangular_prisms_width, depth=depth, height=height, center=center);
            }
        }
        
        
        
    }
}



module triangular_prism (width, depth, height, center) {  
    /* Contruct a triangular prism.
    
    The prism will have it's base on the x/y plane, and it's
        point (top) in the positive z direction.
    
    Args:
        width: The width of the base (x-axis)
        depth: The depth of the prism (y-axis)
        height: The distance of the top from the base (z-axis)
        center: If True, the bounding box of the prism will be
            centered at (0,0,0)
    */
    
    bottom_left_x= center ? (-1*(width/2)) : 0;
    bottom_left_y= center ? (-1*(height/2)) : 0;
    z_translate = center ? (-1 * depth/2) : 0;
    
    top_x = bottom_left_x + width/2;
    top_y = bottom_left_y + height;
    
    bottom_right_x = bottom_left_x + width;
    bottom_right_y = bottom_left_y;
    
    if (center){
        translate([width/2, height/2, 0]);
    }
    
    rotate([90, 0, 0]){
        translate([0, 0, z_translate]){
        linear_extrude(height=depth){
            polygon([[bottom_left_x, bottom_left_y], [top_x,top_y], [bottom_right_x, bottom_right_y]]);
        }
    }
    }
        
}