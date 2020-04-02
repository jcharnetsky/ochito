include <knurledFinishLib_v2.scad>;
// Old cylinder cutout
/*rotate([0,90,0])
    translate([-(1/2 * thumbRadius),0,-(1/2*(thumbRadius - thickness))])
        cylinder(h=thumbWidth - thickness,r=thumbRadius - (1/2 * thickness));
*/
$fn=100;
thickness = 2;
tolerance = 0.5;

fingerWidth = 80;
fingerDepth = 60;
fingerHeight = 20;

thumbWidth = 100;
thumbRadius = 15;

switchHeightOuter = 15.6;
switchHeightInner = 14.6;

pointerDepth = 0.55 * fingerDepth;
middleDepth = 0.70 * fingerDepth;
ringDepth = 0.6 * fingerDepth;
pinkyDepth = 0.35 * fingerDepth;

leftAngle1 = 67;
leftAngle2 = 22;
rightAngle1 = -67;
rightAngle2 = -22;
rightAngleOffset = 10;
leftAngleOffset = 5;

trrsRadius = 2.25;
usbWidth = 8.98;
usbHeight = 2.65;

screwMountRadius = 4;
screwMountHeight = 8;

keycapWidth = 18;
keycapHeight = 9.4;

encoderHeight = fingerWidth - 2*keycapHeight;
encoderDiameter = keycapWidth/3*2;

module switchCutout() {
    cube([switchHeightInner,switchHeightInner,thickness+4]);
}
module switchCutouts() {
    // Pointer finger cutout
    translate([((fingerWidth - 2 * thickness)/8 - switchHeightInner/2) + thickness
    ,pointerDepth,fingerHeight - thickness - 0.2])
        rotate([-5, 0, 0])
            switchCutout();
    
    // Middle finger cutout
    translate([((fingerWidth - 2 * thickness)/4 * 1) + ((fingerWidth - 2 * thickness)/8 - switchHeightInner/2) + thickness
    ,middleDepth,fingerHeight - thickness - 0.2])
        rotate([-5, 0, 0])
            switchCutout();
    
    // Ring finger cutout
    translate([((fingerWidth - 2 * thickness)/4 * 2) + ((fingerWidth - 2 * thickness)/8 - switchHeightInner/2) + thickness
    ,ringDepth,fingerHeight - thickness - 0.2])
        rotate([-5, 0, 0])
            switchCutout();
    
    // Pinky finger cutout
    translate([((fingerWidth - 2 * thickness)/4 * 3) + ((fingerWidth - 2 * thickness)/8 - switchHeightInner/2) + thickness
    ,pinkyDepth,fingerHeight - thickness - 0.2])
        rotate([-5, 0, 0])
            switchCutout();
            
    // Thumb cutout
translate([-((thumbWidth - fingerWidth)/2 + 0.3),-(1/2 * switchHeightInner), fingerHeight/2 + switchHeightInner/2])
        rotate([0,90,0])
            switchCutout();
}

module trrsCutout() {
    translate([thumbWidth - (thumbWidth - fingerWidth)/2 - thickness * 1.19, 0, fingerHeight/2 + trrsRadius/2])
        rotate([0, 90, 0])
            cylinder(h = thickness * 1.2, r = trrsRadius);
}
module usbCutout() {
    translate([thumbWidth - (thumbWidth - fingerWidth)/2 - thickness * 1.19,-(1/2 * usbWidth),0])    
        cube([thickness * 1.2, usbWidth, usbHeight]);
}
module screwMounts() {
    difference() {
    translate([fingerWidth - 2/3 * screwMountRadius, fingerDepth * 0.4, 0])
        cylinder(h = screwMountHeight, r = screwMountRadius);
    translate([fingerWidth - 0.01, fingerDepth * 0.3, -1])
        cube([10,10,12]);
    }
    difference() {
        translate([2/3 * screwMountRadius, fingerDepth * 0.4, 0])
            cylinder(h = screwMountHeight, r = screwMountRadius);
        translate([-9.99, fingerDepth * 0.3, -1])
            cube([10,10,12]);
    }
    difference() {
        translate([1/2 * fingerWidth, fingerDepth - screwMountRadius * 2/3, 0])
            cylinder(h = screwMountHeight, r = screwMountRadius);
        translate([1/2 * fingerWidth - 5, fingerDepth - 0.01, -1])
            cube([10,10,12]);
    }   
}
module fingerBase() {
    hull() {
        difference() {
            // Base
            cube([fingerWidth, fingerDepth, fingerHeight]);
            
            // Left Angles
            translate([0, fingerDepth - leftAngleOffset * 2.5, -0.2])
                rotate([0, 0, leftAngle1])
                    cube([50, 10, fingerHeight + 0.4]);
            translate([0, fingerDepth - leftAngleOffset, -0.2])
                rotate([0,0,leftAngle2])
                    cube([50, 10, fingerHeight + 0.4]);
            
            // Right angles
            translate([fingerWidth - rightAngleOffset, fingerDepth,-0.2])
                rotate([0, 0, rightAngle1])
                    cube([50, 10, fingerHeight + 0.4]);
            translate([fingerWidth - rightAngleOffset * 3, fingerDepth,-0.2])
                rotate([0, 0, rightAngle2])
                    cube([50, 10, fingerHeight + 0.4]);
        }
    }
}
module thumbBase() {
    translate([-(thumbWidth - fingerWidth)/2, 0, (1/2 * fingerHeight)])
        rotate([0, 90, 0])
            cylinder(h = thumbWidth, r = thumbRadius);
}
module fullBase() {
    difference() {
        union() {
            hull() {
                fingerBase();
                translate([0, 0, (1/2 * fingerHeight)])
                    rotate([0, 90, 0])
                        cylinder(h = fingerWidth, r = thumbRadius);
            }
            thumbBase();
            translate([0, 0, fingerHeight + keycapHeight/2])
            rotate([-5, 0, 0])
            encoderEnds();
        }
    }
}
module hollowBase() {
    difference() {
        union() {
            difference() {
                fullBase();
                translate([thickness, 0.1, thickness])
                    scale(v = [(thumbWidth - 2*thickness)/thumbWidth, (fingerDepth + thumbRadius - 2*thickness)/(fingerDepth + thumbRadius), (fingerHeight + keycapWidth/2 - 2*thickness)/(fingerHeight + keycapWidth/2)]) {
                        fullBase();
                    }
            }
            encoderCutout();
        }
        translate([keycapWidth/2 - 0.1, keycapWidth/2, fingerHeight + keycapWidth/4])
            rotate([0, 90, 0])
                cylinder(h = encoderHeight+0.2, d = encoderDiameter + tolerance*2);
    }
}
module lid() {
    intersection() {
        hollowBase();
        translate([1/2 * thickness,1/2*thickness, -(fingerHeight - thickness*2)])
            scale(v = [(fingerWidth - thickness)/fingerWidth, (fingerDepth - thickness)/fingerDepth, (fingerHeight - thickness)/fingerHeight]) {
                fingerBase();
            }
    }
}
module keycap() {
    difference() {
        cube([keycapWidth, keycapWidth, keycapHeight]);

        rotate([80, 0, 0])
            cube([keycapWidth, keycapWidth, keycapHeight]);
        
        translate([keycapWidth, keycapWidth, 0])
            rotate([0, 0, 180])
                rotate([80, 0, 0])
                    cube([keycapWidth, keycapWidth, keycapHeight]);
        
        translate([keycapWidth, 0, 0])
            rotate([0, 0, 90])
                rotate([80, 0, 0])
                    cube([keycapWidth, keycapWidth, keycapHeight]);
        
        translate([0, keycapWidth, 0])
            rotate([0, 0, -90])
                rotate([80, 0, 0])
                    cube([keycapWidth, keycapWidth, keycapHeight]);
    }
}
module dpad() {
    cylinder(h = keycapHeight/2, r = keycapWidth/1.5);
}
module encoder() {
    translate([keycapWidth/2, keycapWidth/2, fingerHeight + keycapWidth/4])
        rotate([0, 90, 0])
            knurled_cyl(encoderHeight, encoderDiameter, 3, 3, 0.5, 2, 0);
}
module keycaps() {
    color("#d4666b") {
        rotate([-5, 0, 0])
            translate([((fingerWidth - 2 * thickness)/8 - keycapWidth/2) + thickness
        , pointerDepth - keycapWidth/5, fingerHeight + thickness*1.4])
                keycap();
        
        rotate([-5, 0, 0])
            translate([((fingerWidth - 2 * thickness)/4 * 1) + ((fingerWidth - 2 * thickness)/8 - keycapWidth/2) + thickness
        , middleDepth - keycapWidth/5, fingerHeight + thickness*1.4])
                keycap();
        
        rotate([-5, 0, 0])
            translate([((fingerWidth - 2 * thickness)/4 * 2) + ((fingerWidth - 2 * thickness)/8 - keycapWidth/2) + thickness
        , ringDepth - keycapWidth/5, fingerHeight + thickness*1.4])
                keycap();
        
        rotate([-5, 0, 0])
            translate([((fingerWidth - 2 * thickness)/4 * 3) + ((fingerWidth - 2 * thickness)/8 - keycapWidth/2) + thickness
        , pinkyDepth - keycapWidth/5, fingerHeight + thickness*1.4])
                keycap();
        
         translate([-(thumbWidth - fingerWidth)/2 - keycapHeight/2 - thickness*0.1, 0, thumbRadius/2 + keycapHeight/4])
            rotate([0, 90, 0])
                dpad();
    }
    color("#dacfcc") {
        encoder();   
       
    }
}
module encoderEnd() {
    difference() {
            keycap();
            translate([keycapWidth/2, 0, -0.1])
                cube([keycapWidth, keycapWidth, 10]);
        }
    }

module encoderEnds(){
    encoderEnd();
    translate([keycapWidth + encoderHeight, keycapWidth, 0])
    rotate([0, 0, 180])
        encoderEnd();
}
module encoderCutout() {
    difference() {
    translate([keycapWidth/2, keycapWidth/2, fingerHeight + keycapWidth/4 - thickness])
        rotate([0, 90, 0])
            cylinder(h = encoderHeight, d = encoderDiameter + thickness*2);
    translate([keycapWidth/4, keycapWidth/2 - encoderDiameter - thickness*2, fingerHeight + keycapWidth/4])
        rotate([-5, 0, 0])
        cube([encoderHeight*2, encoderDiameter*2, encoderDiameter+ thickness*2]); 
    }
 
}



//keycaps();
//lid();

color("#3f667d") {
    // Hollow body with cutouts & screw mounts
    union() {
        difference() {
            hollowBase();
            translate([1/2 * thickness,1/2*thickness, -(fingerHeight - thickness*2)])
                scale(v = [(fingerWidth - thickness)/fingerWidth, (fingerDepth - thickness)/fingerDepth, (fingerHeight - thickness)/fingerHeight]) {
                    fingerBase();
            }
            switchCutouts();
        }
        screwMounts();
    }
}

