
panes_w = 4;
panes_l = 5;
base_ext_width = 2750;
base_ext_length = 3400;
base_ext_height = 609;
base_backwall_height = 1200;
brick_width = 112;
delta = 5;

corner_post_width = 40;
corner_post_height = 1220;

plinth_width = 120;
plinth_height = 20;
plinth_overlap = 10;

row_post_width = 40;

pane_width = 610;
pane_height = 1220;
pane_thickness = 4;
pane_tollerance_gap = 5;

trim_width = 20;
trim_height = 10;

arch_width = 300;
arch_height = 500;
arch_base_height = 900;

//Calculated
CPW = pane_width + 2* pane_tollerance_gap;
CPH = pane_height + 2* pane_tollerance_gap;

//calculated internal width
CIW = (row_post_width*(panes_w-1))+(CPW*panes_w); 
//calculated internal length
CIL = (row_post_width*(panes_l-1))+(CPW*panes_l); 

CEW = CIW + 2* brick_width;
CEL = CIL + 2* brick_width;

base_door_gap = 2*pane_width +  3*row_post_width;



//TexBase();
color([0.5,0.3,0.20,1])
Verticles();
//color([0.5,0.3,0.20,1])
//Plinth();
//Glass();


module Glass(){
translate([CIW/2 + 40,-CIL/2,base_ext_height+plinth_height])
    for(y = [0 : 1 : panes_l-1]){
        translate([0,y*(CPW+row_post_width),0])
            Pane();
    }
}

module Pane(){
    translate([trim_width,0,0]){
        translate([0,pane_tollerance_gap,pane_tollerance_gap])   
            color([0.7,0.9,0.9], alpha = 0.3)
                %cube([pane_thickness, pane_width, pane_height]);
        
        color([0.5,0.3,0.20,1])  {
        translate([-trim_width,trim_height,0])  
           cube([trim_width, pane_width+2*pane_tollerance_gap -2*trim_height, trim_height]);
            
        translate([-trim_width,trim_height,pane_height+ 2*pane_tollerance_gap -trim_height ])
           cube([trim_width, pane_width+2*pane_tollerance_gap -2*trim_height, trim_height]);
            
        translate([-trim_width,0,0])
           cube([trim_width, trim_height, pane_height+2*pane_tollerance_gap]);

        translate([-trim_width,CPW-trim_height,0])
           cube([trim_width, trim_height, pane_height+2*pane_tollerance_gap]);  
        } 
    }
} 



module Plinth(){  
difference(){
    translate([-CEW/2-plinth_overlap,-CEL/2-plinth_overlap,base_ext_height])
        cube([CEW+2*plinth_overlap, plinth_width, plinth_height]);
 
 
    translate([-base_door_gap/2, -CEL/2 -plinth_overlap - delta,-delta+base_ext_height])
        cube([ base_door_gap, plinth_width+2*delta,plinth_height+2*delta]);
}  

translate([-CEW/2-plinth_overlap,CEL/2+plinth_overlap -plinth_width,base_ext_height])
    cube([CEW+2*plinth_overlap, plinth_width, plinth_height]);
    
translate([CEW/2 - plinth_width + plinth_overlap ,-CEL/2 -plinth_overlap + plinth_width ,base_ext_height])
    cube([plinth_width, CEL+2*plinth_overlap-2*plinth_width, plinth_height]);
}   

module Verticles(){   
//corner supports
//    for(x = [-1 : 2 : 1]){
//    for(y = [-1 : 2 : 1]){
//        translate(
//            [x*(corner_post_width/2 + CIW*0.5) -corner_post_width/2,
//            y*(corner_post_width/2 + CIL*0.5) -corner_post_width/2,
//            base_ext_height+plinth_height])
//            cube([corner_post_width, corner_post_width, corner_post_height]);
//        }
//    }
    
    Post(corner_post_width,corner_post_width,corner_post_height, "lend", 15,7);
 
//side supports
//translate([CIW*0.5,
//-CIL/2+ CPW + 0.5*row_post_width
//,base_ext_height+plinth_height])
//for(y = [0 : 1 : panes_l-2]){
//    translate(
//        [0,
//        y*(row_post_width+CPW)-row_post_width/2,
//        0])
//        cube([
//            corner_post_width,
//            row_post_width,
//            corner_post_height]);
//}


//back supports
//translate([-CIW/2 + pane_width + 0.5*row_post_width, 
//+CIL/2, 
//base_ext_height+plinth_height])
//    for(x = [0 : 1 : panes_w-2])
//        translate([x*(row_post_width+pane_width)-row_post_width/2,0,0])
//            cube([row_post_width, corner_post_width, corner_post_height]);
  
}


module Post(width, depth, height, type, cutWidth, cutDepth){
    difference(){
        
   
        cube([width, depth, height]);
             if (type=="lend"){
                 translate([width-cutWidth,-delta,-delta])   
                    cube([cutWidth+delta, cutDepth+delta, height+2*delta]);
             }else {
                translate([-delta, -delta,-delta])   
                    cube([cutWidth+delta, cutDepth+delta, height+2*delta]);
             }
             
        if (type=="corner"){    
            translate([width-cutDepth, depth-cutWidth,-delta])   
                cube([cutDepth+delta, cutWidth+delta, height+2*delta]);
        }
        
        if (type=="straight"){    
            translate([width-cutWidth,-delta,-delta])   
                cube([cutWidth+delta, cutDepth+delta, height+2*delta]);
        }
    }
}



module TexBase(){
   
    
   color("Gray", 1.0) {
    intersection(){ 
           Slats();
           Base(); 
       }
   }
   translate([1,0,0])
   color("Maroon", 1.0) {
       difference(){ 
           Base(); 
           Slats();
       }
   }
   
         
}

module Slats(){
   union(){ 
       for(z = [0 : 1 : 20]){
            translate([-2500,-2500,z*100])
                cube([5000,5000,10]);
       }
   }   
}

module Base(){
    
    difference(){
        translate([-CEW/2, -CEL/2,0])
            cube([CEW,CEL,base_ext_height]);
            
        translate([-CEW/2 + brick_width, -CEL/2 + brick_width,-delta])
            cube([CEW-2*brick_width,CEL-2*brick_width,base_ext_height+2*delta]);
     
     
        translate([-base_door_gap/2, -CEL/2-delta,-delta])
            cube([ base_door_gap, brick_width+2*delta,base_ext_height+2*delta]);
        

    }

    difference(){
        translate([-CEW/2,-CEL/2 +brick_width,base_ext_height])
            cube([brick_width,CEL-2*brick_width, base_backwall_height]);


        translate([-CEW/2 -delta,0,arch_base_height]){
            union(){
                translate([0,0,arch_height- arch_width/2])
                    rotate([0,90,0])
                        cylinder(r=arch_width/2, h=500);
                translate([0,-arch_width/2,0])
                    cube([500,arch_width,arch_height-arch_width/2]);
            }
        }        
    }
    
}



