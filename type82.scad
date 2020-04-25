include <knurledFinishLib_v2.scad>;

$fn=100;

keycapColor = "#5d432c";
keyboardColor = "#242424";
highlightKeycapColor = "#3ba8a8";

thickness = 2;
tolerance = 0.5;

// W -> width, De -> Depth, Di -> Diameter, H -> Height, R -> Radius

// Area where fingers rest
fingerW = 80;
fingerDe = 60;
fingerH = 20;

// Main horizontal cylinder containing thumb dpad
thumbW = fingerW + 20;
thumbR = 3/4 * fingerH;

// Mechanical keyboard switch
switchHOut = 15.6;
switchHIn = 14.6;

// Depth each finger reaches into finger area
pointerDe = 0.55 * fingerDe;
middleDe = 0.70 * fingerDe;
ringDe = 0.6 * fingerDe;
pinkyDe = 0.35 * fingerDe;

// Angles for corners of finger area
leftAngle1 = 67;
leftAngle2 = 22;
rightAngle1 = -67;
rightAngle2 = -22;
rightAngleOffset = 10;
leftAngleOffset = 5;

// Screw mounts between lid and main body
screwMountR = 4;
screwMountH = 8;

// Keycaps (for visualization only)
keycapW = 18;
keycapH = 9.4;

// Rechargable battery (for visualization only)
batteryW = 60;
batteryDe = 36;
batteryH = 7;

// Arms that hold onto battery
batteryStandoffW = 5;
batteryStandoffDe = 10;
batteryStandoffH = batteryH + 2.5;

// Micro-controller (for visualization only)
proMicroW = 36;
proMicroDe = 17.6;
proMicroH = 5.3;

// Sled that holds onto micro-controller
proMicroStandoffW = proMicroW + 4;
proMicroStandoffDe = proMicroH + 10;
proMicroStandoffH = proMicroDe + 10;

// Wireless charging receiver and chip (for visualization only)
chargerW = 48;
chargerDe = 32;
chargerH = 0.5;
chargerChipW = 11.5;
chargerChipDe = 36;
chargerChipH = 0.3;

// Encoder knob bearing (for visualization only)
bearingDOut = 6;
bearingDIn = 3;
bearingW = 2.5;

// Single cutout of mechanical switch
module switchCutout() {
    cube([switchHIn,switchHIn,thickness+4]);
}
// Four cutouts for mechanical switches, placed at appropriate finger depths
module switchCutouts() {
    // Pointer finger cutout
    translate([((fingerW - 2 * thickness)/8 - switchHIn/2) + thickness
    ,pointerDe,fingerH - thickness - 0.2])
        rotate([-5, 0, 0])
            switchCutout();
    
    // Middle finger cutout
    translate([((fingerW - 2 * thickness)/4 * 1) + ((fingerW - 2 * thickness)/8 - switchHIn/2) + thickness
    ,middleDe,fingerH - thickness - 0.2])
        rotate([-5, 0, 0])
            switchCutout();
    
    // Ring finger cutout
    translate([((fingerW - 2 * thickness)/4 * 2) + ((fingerW - 2 * thickness)/8 - switchHIn/2) + thickness
    ,ringDe,fingerH - thickness - 0.2])
        rotate([-5, 0, 0])
            switchCutout();
    
    // Pinky finger cutout
    translate([((fingerW - 2 * thickness)/4 * 3) + ((fingerW - 2 * thickness)/8 - switchHIn/2) + thickness
    ,pinkyDe,fingerH - thickness - 0.2])
        rotate([-5, 0, 0])
            switchCutout();
            
    // Thumb cutout
translate([-((thumbW - fingerW)/2 + 0.3),-(1/2 * switchHIn), fingerH/2 + switchHIn/2])
        rotate([0,90,0])
            switchCutout();
}
// Cylinders to house screws mounting lid to base
module screwMounts() {
    difference() {
    translate([fingerW - 2/3 * screwMountR, fingerDe * 0.4, 0])
        cylinder(h = screwMountH, r = screwMountR);
    translate([fingerW - 0.01, fingerDe * 0.3, -1])
        cube([10,10,12]);
    }
    difference() {
        translate([2/3 * screwMountR, fingerDe * 0.4, 0])
            cylinder(h = screwMountH, r = screwMountR);
        translate([-9.99, fingerDe * 0.3, -1])
            cube([10,10,12]);
    }
    difference() {
        translate([1/2 * fingerW, fingerDe - screwMountR * 2/3, 0])
            cylinder(h = screwMountH, r = screwMountR);
        translate([1/2 * fingerW - 5, fingerDe - 0.01, -1])
            cube([10,10,12]);
    }   
}
// Area containing main switches
module fingerBase() {
    hull() {
        difference() {
            // Base
            cube([fingerW, fingerDe, fingerH]);
            
            // Left Angles
            translate([0, fingerDe - leftAngleOffset * 2.5, -0.2])
                rotate([0, 0, leftAngle1])
                    cube([50, 10, fingerH + 0.4]);
            translate([0, fingerDe - leftAngleOffset, -0.2])
                rotate([0,0,leftAngle2])
                    cube([50, 10, fingerH + 0.4]);
            
            // Right angles
            translate([fingerW - rightAngleOffset, fingerDe,-0.2])
                rotate([0, 0, rightAngle1])
                    cube([50, 10, fingerH + 0.4]);
            translate([fingerW - rightAngleOffset * 3, fingerDe,-0.2])
                rotate([0, 0, rightAngle2])
                    cube([50, 10, fingerH + 0.4]);
        }
    }
}
// Main cylinder containing thumb d-pad
module thumbBase() {
    translate([-(thumbW - fingerW)/2, 0, (1/2 * fingerH)])
        rotate([0, 90, 0])
            cylinder(h = thumbW, r = thumbR);
}
// Union of finger and thumb base
module fullBase() {
    difference() {
        union() {
            hull() {
                fingerBase();
                translate([0, 0, (1/2 * fingerH)])
                    rotate([0, 90, 0])
                        cylinder(h = fingerW, r = thumbR);
            }
            thumbBase();
        }
    }
}
// Full base hollowed out to house electronics
module hollowBase() {
    difference() {
        union() {
            // Hollow base
            difference() {
                fullBase();
                translate([thickness, 0.1, thickness])
                    scale(v = [(thumbW - 2*thickness)/thumbW, (fingerDe + thumbR - 2*thickness)/(fingerDe + thumbR), (fingerH + keycapW/2 - 2*thickness)/(fingerH + keycapW/2)]) {
                        fullBase();
                    }
            }

        }
    }
    // Hand attachment
    translate([fingerW - 10, -thumbR + 5, thumbR + fingerH/2 - 5])
      cube([10, 20, 20]);
    translate([0, -thumbR + 5, thumbR + fingerH/2 - 5])
      cube([10, 20, 20]);

    translate([fingerW - 10, -thumbR + 5, thumbR + fingerH/2 - 5 + 20 - sin(10)*10])
    rotate([0, -10, 0])
      cube([10, 20, 10]);
    translate([0, -thumbR + 5, thumbR + fingerH/2 - 5 + 20])
    rotate([0, 10, 0])
      cube([10, 20, 10]);

    translate([fingerW - 10 - sin(10)*7, -thumbR + 5, thumbR + fingerH/2 - 5 + 30 - sin(20)*10])
    rotate([0, -20, 0])
      cube([10, 20, 10]);
    translate([sin(10)*10, -thumbR + 5, thumbR + fingerH/2 - 5 + 30])
    rotate([0, 20, 0])
      cube([10, 20, 10]);

    translate([5, -thumbR + 5, thumbR + 35])
    cube([fingerW - 10, 20, 10]);
}
// Single keycap (for visualization only)
module keycap() {
    difference() {
        cube([keycapW, keycapW, keycapH]);

        rotate([80, 0, 0])
            cube([keycapW, keycapW, keycapH]);
        
        translate([keycapW, keycapW, 0])
            rotate([0, 0, 180])
                rotate([80, 0, 0])
                    cube([keycapW, keycapW, keycapH]);
        
        translate([keycapW, 0, 0])
            rotate([0, 0, 90])
                rotate([80, 0, 0])
                    cube([keycapW, keycapW, keycapH]);
        
        translate([0, keycapW, 0])
            rotate([0, 0, -90])
                rotate([80, 0, 0])
                    cube([keycapW, keycapW, keycapH]);
    }
}
// Keycap covering d-pad
module dpad() {
    cylinder(h = keycapH/2, r = keycapW/1.5);
}
// All keycaps (for visualization only)
module keycaps() {
    color(keycapColor) {
        rotate([-5, 0, 0])
            translate([((fingerW - 2 * thickness)/8 - keycapW/2) + thickness
        , pointerDe - keycapW/5, fingerH + thickness*1.4])
                keycap();
        
        rotate([-5, 0, 0])
            translate([((fingerW - 2 * thickness)/4 * 1) + ((fingerW - 2 * thickness)/8 - keycapW/2) + thickness
        , middleDe - keycapW/5, fingerH + thickness*1.4])
                keycap();
        
        rotate([-5, 0, 0])
            translate([((fingerW - 2 * thickness)/4 * 2) + ((fingerW - 2 * thickness)/8 - keycapW/2) + thickness
        , ringDe - keycapW/5, fingerH + thickness*1.4])
                keycap();
        
        rotate([-5, 0, 0])
            translate([((fingerW - 2 * thickness)/4 * 3) + ((fingerW - 2 * thickness)/8 - keycapW/2) + thickness
        , pinkyDe - keycapW/5, fingerH + thickness*1.4])
                keycap();
    }
    color(highlightKeycapColor) {
         translate([-(thumbW - fingerW)/2 - keycapH/2 - thickness*0.1, 0, thumbR/2 + keycapH/4])
            rotate([0, 90, 0])
                dpad();
    }
}
// Micro-controller (for visualization only)
module proMicro() {
    color("#000080") {
        translate([fingerW/2 - proMicroW/2, -thumbR/2, 0])
            cube([proMicroW, proMicroH, proMicroDe]);
    }
}
// Sled which hold micro-controller in place
module proMicroStandoff() {
    difference() {
        intersection() {
            translate([fingerW/2 - proMicroStandoffW/2, -thumbR, -5])
                cube([proMicroStandoffW, proMicroStandoffDe,proMicroStandoffH]);
            thumbBase();
        }
        translate([fingerW/2 - proMicroStandoffW/2 - 0.01, -proMicroH + 0.02, -tolerance])
            cube([proMicroW + 12, proMicroH + 2*tolerance, proMicroDe + 2*tolerance]);
    }
}
// Bottom lid of keyboard
module lid() {
    translate([0, 0, -40])
        color(keyboardColor) {
            intersection() {
                hollowBase();
                translate([1/2 * thickness,1/2*thickness, -(fingerH - thickness*2)])
                    scale(v = [(fingerW - thickness)/fingerW, (fingerDe - thickness)/fingerDe, (fingerH - thickness)/fingerH]) {
                        fingerBase();
                    }
            }
            batteryStandoff();
        }
}
// Rechargable battery (for visualization only)
module battery() {
    color("#000000") {
        translate([fingerW/2 - batteryW/2, 0, -42.3])
            rotate([5, 0, 0])
                cube([batteryW, batteryDe, batteryH]);
    }
}
// Arms which hold battery in place
module batteryStandoff() {
    translate([fingerW/2 - batteryW/2 - 5, batteryDe/4 - 5, -batteryStandoffH/4])
        rotate([5, 0, 0])
            union() {
                difference() {
                    cube([batteryStandoffW, batteryStandoffDe, batteryStandoffH]);
                    translate([batteryStandoffW - tolerance, -tolerance, 0])
                        cube([batteryW + 2*tolerance, batteryDe + tolerance, batteryH + 2*tolerance]);
                }
                difference() {
                    translate([batteryW + batteryStandoffW, 0, 0])
                    cube([batteryStandoffW, batteryStandoffDe, batteryStandoffH]);
                                        translate([batteryStandoffW - tolerance, -tolerance, 0])
                    cube([batteryW + 2*tolerance, batteryDe + tolerance, batteryH + 2*tolerance]);
                }
            }

}
// Wireless charging receiver (for visualization only)
module chargingReceiver() {
    color("#b87333") {
        translate([fingerW/2 - (chargerW + chargerChipW)/2, 0, -42.6])
        union() {
            rotate([5, 0, 0])
            translate([chargerChipW, 0, 0])
                cube([chargerW, chargerDe, chargerH]);
            rotate([5, 0, 0])
                cube([chargerChipW, chargerChipDe, chargerChipH]);
        }
    }
}
// Encoder knob ball bearing (for visualization only)
module ballBearing() {
    color("#c0c0c0") {
        translate([knobH + keycapW/2 - bearingW, keycapW/2, fingerH + keycapW/4])
        rotate([0, 90, 0])
        difference() {
            cylinder(h = bearingW, d = bearingDOut);
            translate([0, 0, -0.1])
            cylinder(h = bearingW + 0.2, d = bearingDIn);
        }
    }
}

keycaps();
//lid();
//battery();
//chargingReceiver();
proMicro();

color(keyboardColor) {
    // Hollow body with cutouts & screw mounts
    union() {
        difference() {
            hollowBase();
            translate([1/2 * thickness,1/2*thickness, -(fingerH - thickness*2)])
                scale(v = [(fingerW - thickness)/fingerW, (fingerDe - thickness)/fingerDe, (fingerH - thickness)/fingerH]) {
                    fingerBase();
            }
            switchCutouts();
        }
        screwMounts();
    }
}
