include <knurledFinishLib_v2.scad>;

$fn=100;

keycapColor = "#5d432c";
keyboardColor = "#242424";
highlightKeycapColor = "#3ba8a8";

thickness = 2;
tolerance = 0.2;

// W -> width, De -> Depth, Di -> Diameter, H -> Height, R -> Radius

// Keycaps (for visualization only)
keycapW = 18;
keycapH = 9.4;
keycapSpacing = 1;

// Area where fingers rest
fingerW = 4*keycapW + 5*keycapSpacing;
fingerDe = 60;
fingerH = keycapW + 5;

// Radius of cylinder made by arched hand
handR = fingerW/2;

// Extension for thumb controlled dpad
thumbW = 10;
thumbDe = 36;
thumbH = fingerH;
thumbAngle = 20;

// Mechanical keyboard switch
switchHOut = 15.6;
switchHIn = 14.6;

// Depth each finger reaches into finger area
pointerDe = 0.55 * fingerDe;
middleDe = fingerDe - keycapW;
ringDe = 0.6 * fingerDe;
pinkyDe = 0.43 * fingerDe;

// Thickness of bottom lid
lidH = 3;
// Distance from keyboard to render lid
lidDistance = lidH;

// Rechargable battery (for visualization only)
batteryW = 60;
batteryDe = 36;
batteryH = 7;

// Arms that hold onto battery
batteryStandoffW = batteryW + 4;
batteryStandoffDe = batteryDe + 4;
batteryStandoffH = batteryH + 2;

// Micro-controller (for visualization only)
proMicroW = 36;
proMicroDe = 17.6;
proMicroH = 5.3;

// Sled that holds onto micro-controller
proMicroStandoffW = proMicroW + 4;
proMicroStandoffDe = proMicroDe + 4;
proMicroStandoffH = proMicroH - 0.1;

// Wireless charging receiver and chip (for visualization only)
chargerW = 48;
chargerDe = 32;
chargerH = 0.5;
chargerChipW = 11.5;
chargerChipDe = 36;
chargerChipH = 0.3;

// Screw standoffs to connect lid to case
screwD = 2;
screwStandoffH = 10;
screwStandoffD = screwD + 2;
counterSinkH = 1;
screwHeadD = 4;

// Base to attach keyboard to chair
baseH = 15;
baseIndent = 4;

// Quick release mechanism
quickReleaseArmDi = 7.14 + tolerance;
quickReleaseArmH = 10;
quickReleaseButtonDi = quickReleaseArmDi;
quickReleaseButtonHeadDi = quickReleaseButtonDi - 2;
quickReleaseButtonHeadH = 8;
quickReleaseButtonH = 10;
quickReleaseSpringH = 12.7;

// Channel to hold keyboard in place on base
rightSideChannelDe = 0.5*fingerW;
leftSideChannelDe = 0.6*fingerW;
sideChannelW = thickness/2 + tolerance;

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
    cylinder(h = keycapH/2, d = keycapW);
}

// All keycaps (for visualization only)
module keycaps() {
    color(keycapColor) {
            translate([keycapSpacing, pointerDe - keycapSpacing, fingerH + thickness*1.4])
                keycap();
        
            translate([2*keycapSpacing + keycapW, middleDe - keycapSpacing, fingerH + thickness*1.4])
                keycap();
        
            translate([3*keycapSpacing + 2*keycapW, ringDe - keycapSpacing, fingerH + thickness*1.4])
                keycap();
        
            translate([4*keycapSpacing + 3*keycapW, pinkyDe - keycapSpacing, fingerH + thickness*1.4])
                keycap();
    }

    color(highlightKeycapColor) {
		translate([-(thickness + sin(thumbAngle - 4)*keycapW), sin(thumbAngle - 4)*keycapW, fingerH/2])
			rotate([0, 90, thumbAngle - 4])
				dpad();
    }
}

// Micro-controller (for visualization only)
module proMicro() {
    color("#000080") {
		translate([fingerW/2 - proMicroW/2, -(proMicroStandoffDe/2 + (batteryStandoffDe - batteryDe)/2) - proMicroDe/2, -lidDistance + lidH])
            cube([proMicroW, proMicroDe, proMicroH]);
    }
}

// Standoff to hold micro-controller in place
module proMicroStandoff() {
	difference() {
		cube([proMicroStandoffW, proMicroStandoffDe, proMicroStandoffH]);
		translate([-1, proMicroStandoffDe/2 - proMicroDe/2 + 1, 0.1])
			cube([proMicroStandoffW + 2, proMicroDe - 2, proMicroH]);
		translate([-1, proMicroStandoffDe/2 - proMicroDe/2, 1])
			cube([proMicroStandoffW + 2, proMicroDe, 2]);
	}
}

// Rechargable battery (for visualization only)
module battery() {
    color("#000000") {
        translate([fingerW/2 - batteryW/2, 0, -lidDistance + lidH + chargerH])
			cube([batteryW, batteryDe, batteryH]);
    }
}

// Standoff to hold battery in place
module batteryStandoff() {
	difference() {
		cube([batteryStandoffW, batteryStandoffDe, batteryStandoffH]);
		translate([-1, batteryStandoffDe/2 -batteryDe/2 + 1, 0.1])
			cube([batteryStandoffW + 2, batteryDe - 2, batteryStandoffH]);
		translate([-1, batteryStandoffDe/2 - batteryDe/2, 0])
			cube([batteryStandoffW + 2, batteryDe, batteryH + chargerH]);
	}
}

// Wireless charging receiver (for visualization only)
module chargingReceiver() {
    color("#b87333") {
        translate([fingerW/2 - (chargerW + chargerChipW)/2, 0, -lidDistance + lidH])
        union() {
            translate([chargerChipW, 0, 0])
                cube([chargerW, chargerDe, chargerH]);
			cube([chargerChipW, chargerChipDe, chargerChipH]);
        }
    }
}

// Cutouts for the five mechanical switches
module switchCutouts() {
	translate([keycapSpacing + keycapW/2 - switchHIn/2, pointerDe + keycapSpacing, fingerH - thickness - 1])
		cube([switchHIn, switchHIn, thickness + 2]);
	translate([2*keycapSpacing + keycapW/2 - switchHIn/2 + keycapW, middleDe + keycapSpacing, fingerH - thickness - 1])
		cube([switchHIn, switchHIn, thickness + 2]);
	translate([3*keycapSpacing + keycapW/2 - switchHIn/2 + 2*keycapW, ringDe + keycapSpacing, fingerH - thickness - 1])
		cube([switchHIn, switchHIn, thickness + 2]);
	translate([4*keycapSpacing + keycapW/2 - switchHIn/2 + 3*keycapW, pinkyDe + keycapSpacing, fingerH - thickness - 1])
		cube([switchHIn, switchHIn, thickness + 2]);

	translate([-thickness + sin(thumbAngle)*thickness, -sin(thumbAngle)*thickness, fingerH/2 - switchHIn/2])
					rotate([0, 0, thumbAngle -5])
		cube([thickness + 2, switchHIn, switchHIn]);
}

module case(wall = 0) {
	difference() {
	hull() {
		// Palm rest
		translate([fingerW/2, 0, 0])
		difference() {
			sphere(r = handR - wall);
			translate([-handR, -handR, -2*handR])
				cube([handR*2 - wall, handR*2 - wall, handR*2 - wall]);
		}

		difference() {
			union() {
				// Finger base
				translate([wall, 0, 0])
				cube([fingerW - 2*wall, fingerDe - wall, fingerH - wall]);
				// Thumb extension
				translate([-thumbW + sin(thumbAngle)*(thumbDe + wall) + tolerance, -sin(thumbAngle)*(thumbW - 2*wall), 0])
					rotate([0, 0, thumbAngle])
						cube([thumbW - 2*wall, thumbDe - wall, thumbH - wall]);
			}

			// Finger end cutouts
			translate([-tolerance, pointerDe + keycapW - wall, -tolerance/2])
				cube([keycapW + keycapSpacing + tolerance, fingerDe - pointerDe - keycapW + tolerance, fingerH + tolerance]);

			translate([2*keycapW + 3*keycapSpacing, ringDe + keycapW - wall, -tolerance/2])
				cube([keycapW + keycapSpacing, fingerDe - ringDe - keycapW + tolerance, fingerH + tolerance]);
			translate([3*keycapW + 4*keycapSpacing - 0.005, pinkyDe + keycapW - wall, -tolerance/2])
				cube([keycapW + keycapSpacing + tolerance, fingerDe - pinkyDe - keycapW + tolerance, fingerH + tolerance]);

		}
	}

	// Keycap cutouts
	translate([keycapSpacing/2 - wall, pointerDe - 1.5*keycapSpacing - wall, fingerH - wall])
		cube([keycapW + keycapSpacing + 0.001 + 2*wall, fingerDe, keycapH]);
	translate([keycapW + 3/2*keycapSpacing - 0.001 - wall, middleDe - 1.5*keycapSpacing - wall, fingerH - wall])
		cube([keycapW + keycapSpacing + 0.001 + 2*wall, fingerDe, keycapH]);
	translate([2*keycapW + 5/2*keycapSpacing - 0.001 - wall, ringDe - 1.5*keycapSpacing - wall, fingerH - wall])
		cube([keycapW + keycapSpacing + 0.001 + 2*wall, fingerDe, keycapH]);
	translate([3*keycapW + 7/2*keycapSpacing - 0.001 - wall, pinkyDe - 1.5*keycapSpacing - wall, fingerH - wall])
		cube([keycapW + keycapSpacing + 2*wall, fingerDe, keycapH]);
	}
}

module screws(height, diameter) {
		translate([fingerW/2 - screwStandoffD/2, -handR + screwStandoffD*7/8, 0])
			cylinder(h = height, d = diameter);
		translate([thickness, pointerDe + keycapW - thickness, 0])
			cylinder(h = height, d = diameter);
		translate([4.6*thickness, -fingerW/4, 0])
			cylinder(h = height, d = diameter);
		translate([fingerW - thickness - 0.01, pinkyDe + keycapW - thickness, 0])
			cylinder(h = height, d = diameter);
}

module lid() {
	battery();
	chargingReceiver();
	proMicro();

	translate([0, 0, -lidDistance])
	color(keyboardColor) {
		difference() {
			intersection() {
				case(0);
				translate([-thumbDe, -handR, -handR + lidH])
					cube([thumbDe + fingerW, fingerDe + handR, handR]);
			}
			translate([0, 0, -(lidH + 0.01)])
				screws(screwStandoffH, screwD);
			translate([0, 0, -0.01])
				screws(counterSinkH, screwHeadD);

			// Channel cutouts
			translate([sin(thumbAngle - 5)*leftSideChannelDe - 8.1, -leftSideChannelDe + pinkyDe, lidH/2 - sideChannelW/2])
				rotate([0, 0, thumbAngle - 5])
					cube([sideChannelW, leftSideChannelDe, sideChannelW]);
			translate([fingerW - sideChannelW + 0.05, -rightSideChannelDe + pinkyDe, lidH/2 - sideChannelW/2])
				cube([sideChannelW, rightSideChannelDe, sideChannelW]);
		}
		translate([fingerW/2 - proMicroStandoffW/2, -(proMicroStandoffDe + (batteryStandoffDe - batteryDe)/2), lidH])
			proMicroStandoff();
		translate([fingerW/2 - batteryStandoffW/2, -(batteryStandoffDe - batteryDe)/2, lidH])
			batteryStandoff();
	}
}

module base() {
	translate([-(fingerW*1.1 - fingerW)/2, -((fingerDe + handR)*1.1 - (fingerDe + handR))/4, -baseH + baseIndent - lidH])
	difference() {
		scale([1.1, 1.1, 1.1])
			case();
		translate([-400, -400, baseH])
			cube([1000, 1000, 1000]);

		// Indent
		translate([2*(fingerW*1.02 - fingerW), ((fingerDe + handR)*1.02 - (fingerDe + handR)), baseH - baseIndent])
			scale([1.02, 1.02, 1.02])
				case();

		// Front opening to slide in case
		translate([-fingerW/2, fingerDe - 1.5*keycapW, baseH - baseIndent])
			cube([2*fingerW, 2*(fingerDe + handR), baseIndent + 1]);

		// Quick release channel
		translate([1.1*fingerW - quickReleaseButtonH - quickReleaseArmH - quickReleaseSpringH - 3, 0, baseH - baseIndent - quickReleaseArmDi/2 - tolerance])
			rotate([0, 90, 0])
				cylinder(h = quickReleaseArmH + quickReleaseButtonH + quickReleaseSpringH + 2*tolerance, d = quickReleaseArmDi + tolerance);

		// Top opening to channel
		translate([1.1*fingerW - quickReleaseButtonH - quickReleaseArmH - 3, -(quickReleaseArmDi/2 + tolerance), baseH - baseIndent - quickReleaseArmDi/2 + 0.1])
			cube([quickReleaseArmH + 2*tolerance, 2*(quickReleaseArmDi/2 + tolerance), quickReleaseArmDi]);

		// Button hole
		translate([1.1*fingerW - 3, 0, baseH - baseIndent - quickReleaseArmDi/2 - tolerance])
			rotate([0, 90, 0])
				cylinder(h = 4, d = quickReleaseButtonHeadDi + tolerance);
	}
	translate([-sin(thumbAngle - 17)*leftSideChannelDe + 5.34, -leftSideChannelDe + pinkyDe, -lidDistance + lidH/2 - sideChannelW/2])
		rotate([0, 0, thumbAngle - 5])
			cube([2*sideChannelW, leftSideChannelDe, sideChannelW - tolerance]);
	translate([fingerW - sideChannelW + 0.05 + tolerance, -rightSideChannelDe + pinkyDe, -lidDistance + lidH/2 - sideChannelW/2])
		cube([2*sideChannelW - tolerance, rightSideChannelDe, sideChannelW - tolerance]);

}

module keyboard() {
	color(keyboardColor) {
		// Hollow out screw standoffs
		difference() {
			// Add screw standoffs
			union() {
				// Hollowed out case with switch cutouts
				difference() {
					case();
					case(thickness);
					switchCutouts();
				}

				// Screw standoffs
				screws(screwStandoffH, screwStandoffD);
			}

			translate([0, 0, -2])
			screws(screwStandoffH, screwD);
		}
	}
}

module quickRelease() {
	translate([fingerW*1.1 - thickness - 4.7, -((fingerDe + handR)*1.1 - (fingerDe + handR))/4, -quickReleaseArmDi])
	union() {
		translate([-quickReleaseArmH - quickReleaseButtonH, 0, 0])
			rotate([0, 90, 0])
				cylinder(h = quickReleaseArmH, d = quickReleaseArmDi);
		translate([-quickReleaseArmH/2 - quickReleaseButtonH, 0, 0])
			cylinder(h = quickReleaseArmH/1.2, d = quickReleaseArmDi/1.5);
		translate([-quickReleaseButtonH, 0, 0])
			rotate([0, 90, 0])
				cylinder(h = quickReleaseButtonH, d = quickReleaseButtonDi);
		rotate([0, 90, 0])
			cylinder(h = quickReleaseButtonHeadH, d = quickReleaseButtonHeadDi);
	}
}

keyboard();
keycaps();
lid();
//base();
