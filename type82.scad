include <knurledFinishLib_v2.scad>;

$fn=100;

keycapColor = "#5d432c";
keyboardColor = "#242424";
highlightKeycapColor = "#3ba8a8";

thickness = 2;
tolerance = 0.5;

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
lidDistance = 50;

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

// Encoder knob bearing (for visualization only)
bearingDOut = 6;
bearingDIn = 3;
bearingW = 2.5;

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
	translate([2*keycapSpacing + keycapW/2 - switchHIn/2 + 2*keycapW, ringDe + keycapSpacing, fingerH - thickness - 1])
		cube([switchHIn, switchHIn, thickness + 2]);
	translate([2*keycapSpacing + keycapW/2 - switchHIn/2 + 3*keycapW, pinkyDe + keycapSpacing, fingerH - thickness - 1])
		cube([switchHIn, switchHIn, thickness + 2]);

	translate([-thickness + sin(thumbAngle)*thickness, -sin(thumbAngle)*thickness, fingerH/2 - switchHIn/2])
					rotate([0, 0, thumbAngle -5])
		cube([thickness + 2, switchHIn, switchHIn]);
}
module case(wall) {
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
module lid() {
	battery();
	chargingReceiver();
	proMicro();

	translate([0, 0, -lidDistance])
	color(keyboardColor) {
		intersection() {
			case(0);
			translate([-thumbDe, -handR, -handR + lidH])
				cube([thumbDe + fingerW, fingerDe + handR, handR]);
		}
	translate([fingerW/2 - proMicroStandoffW/2, -(proMicroStandoffDe + (batteryStandoffDe - batteryDe)/2), lidH])
			proMicroStandoff();
	translate([fingerW/2 - batteryStandoffW/2, -(batteryStandoffDe - batteryDe)/2, lidH])
		batteryStandoff();
	}
}

keycaps();
lid();

// Hollowed out case
color(keyboardColor) {
	difference() {
		case(0);
		case(thickness);
		switchCutouts();
	}
}

