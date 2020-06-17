$fn=100;

dpadMX = true;

keycapColor = "#f0c674";
keyboardColor = "#c5c8c6";
highlightKeycapColor = "#f0c674";

thickness = 2;
tolerance = 0.2;

// W -> width, De -> Depth, Di -> Diameter, H -> Height, R -> Radius

// Keycaps (for visualization only)
keycapW = 18;
keycapH = 9.4;
keycapSpacing = 1;

// Area where fingers rest
fingerW = 4*keycapW + 5*keycapSpacing;
fingerDe = 76;
fingerH = keycapW + 5;
pointerH = fingerH;
middleH = fingerH - 3;
ringH = fingerH - 6;
pinkyH = fingerH - 9;

// Radius of cylinder made by arched hand
handR = 45;

// Dpad
dpadH = 12.3;
dpadW = 12.5;
dpadDe = 5;
dpadHeadW = 3.3;

dpadSwitchH = 5;

// Extension for thumb controlled dpad
thumbW = 15;
thumbDe = 36;
thumbH = dpadH*2;
thumbAngle = 8;

// Mechanical keyboard switch
switchHOut = 15.6;
switchHIn = 13.94;

// Depth each finger reaches into finger area
middleDe = fingerDe;
pointerDe = fingerDe - keycapW*0.5;
ringDe = fingerDe - keycapW*0.5;
pinkyDe = fingerDe - keycapW*1;

switchToPcb = 3.3;
pcbH = 1.615 + tolerance;
pcbW = 19 + tolerance;

// Rechargable battery (for visualization only)
batteryW = 60;
batteryDe = 38;
batteryH = 7;

// Arms that hold onto battery
batteryStandoffW = batteryW + 4;
batteryStandoffDe = batteryDe + 4;
batteryStandoffH = batteryH + 2;

// Micro-controller (for visualization only)
proMicroW = 32.4;
proMicroDe = 24.7;
proMicroH = 5.3;

// Sled that holds onto micro-controller
proMicroStandoffW = proMicroW;
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
screwStandoffH = 4;
screwStandoffD = 5.8;
screwD = 3 + tolerance;
counterSinkH = 1;
screwHeadD = 4;

// Quick release mechanism
quickReleaseArmDi = 7.14 + tolerance;
quickReleaseArmH = 10;
quickReleaseButtonDi = quickReleaseArmDi;
quickReleaseButtonHeadDi = quickReleaseButtonDi - 2;
quickReleaseButtonHeadH = 8;
quickReleaseButtonH = 10;
quickReleaseButtonWall = 4;
quickReleaseSpringH = 12.7;
quickReleaseOpeningW = quickReleaseArmH + 2*tolerance;

// Thickness of bottom lid
lidH = thickness*3;

// Base to attach keyboard to chair
baseScale = 1.1;
baseIndentScale = 1.02;
baseH = 15;
baseIndent = lidH/2;

// Distance from keyboard to render lid
lidDistance = lidH;

sideChannelH = baseIndent/2;
lidQuickReleaseChannelDe = handR - (((fingerDe + handR)*baseScale - (fingerDe + handR))/4 - quickReleaseArmDi/2);

// Channel to hold keyboard in place on base
channelScale = baseScale - 0.04;

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
	difference() {
		union() {
			cylinder(h = keycapH/2, d = keycapW);
		    for ( i = [1:4]) {
				translate([0, 0, -i*(keycapH/10)])
					cylinder(h = keycapH/10, d = keycapW - i*3);
			}
		}
		translate([-dpadHeadW/2, -dpadHeadW/2, keycapH/2 - dpadHeadW])
		cube([dpadHeadW, dpadHeadW, dpadHeadW + tolerance]);
	}
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
		translate([-1, proMicroStandoffDe/2 - proMicroDe/2 + 0.5, 0.1])
			cube([proMicroStandoffW + 2, proMicroDe - 1, proMicroH]);
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
	translate([keycapSpacing + keycapW/2 - switchHIn/2, pointerDe - keycapW/2 - switchHIn/2, 0])
		cube([switchHIn, switchHIn, handR]);
	translate([3*keycapSpacing + keycapW/2 - switchHIn/2 + keycapW, middleDe - keycapW/2 - switchHIn/2, 0])
		cube([switchHIn, switchHIn, handR]);
	translate([5*keycapSpacing + keycapW/2 - switchHIn/2 + 2*keycapW, ringDe - keycapW/2 - switchHIn/2, 0])
		cube([switchHIn, switchHIn, handR]);
	translate([7*keycapSpacing + keycapW/2 - switchHIn/2 + 3*keycapW, pinkyDe - keycapW/2 - switchHIn/2, 0])
		cube([switchHIn, switchHIn, handR]);

	translate([-sin(thumbAngle)*(4*switchHIn), cos(thumbAngle)*(switchHIn/16), switchHIn/2])
	    rotate([0, 0, thumbAngle])
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
		translate([fingerW/2, -3*handR/5, 0])
		difference() {
			translate([0, 0, -3*handR/4])
			sphere(r = handR - wall);
			translate([-handR, -handR + wall, -2*handR])
				cube([handR*2 - wall, handR*2 - wall, handR*2 - wall]);
		}

		// Thumb extension
		translate([-sin(thumbAngle)*(thumbDe) + wall, -sin(thumbAngle)*(thumbW - 2*wall), 0])
			rotate([0, 0, thumbAngle])
				cube([thumbW - 2*wall, thumbDe - wall, thumbH + dpadH/2 - wall]);

		// Finger extensions
		translate([wall, -fingerDe + pointerDe - wall, 0])
			cube([keycapW + 2*keycapSpacing + tolerance, fingerDe, pointerH - wall]);

		translate([keycapW + 2*keycapSpacing + tolerance, -fingerDe + middleDe - wall, 0])
			cube([keycapW + 2*keycapSpacing, fingerDe, middleH - wall]);
		translate([2*keycapW + 3*keycapSpacing, -fingerDe + ringDe - wall, 0])
			cube([keycapW + 2*keycapSpacing, fingerDe, ringH - wall]);
		translate([3*keycapW + 5*keycapSpacing - 0.005, -fingerDe/2 + pinkyDe - wall, -tolerance/2])
			cube([keycapW + 2*keycapSpacing + tolerance +thickness - wall, fingerDe/2, pinkyH - wall]);

	}

	// Keycap cutouts
	translate([-wall, pointerDe - keycapW - wall - keycapSpacing, pointerH - wall])
		cube([keycapW + 2*keycapSpacing + 0.001 + 2*wall, fingerDe, handR]);
	translate([keycapW + 2*keycapSpacing - 0.001 - wall, middleDe - keycapW - wall - keycapSpacing, middleH - wall])
		cube([keycapW + 2*keycapSpacing + 0.001 + 2*wall, fingerDe, handR]);
	translate([2*keycapW + 4*keycapSpacing - 0.001 - wall, ringDe - keycapW - wall - keycapSpacing, ringH - wall])
		cube([keycapW + 2*keycapSpacing + 0.001 + 2*wall, fingerDe, handR]);
	translate([3*keycapW + 6*keycapSpacing - 0.001 - wall, pinkyDe - keycapW - wall - keycapSpacing, pinkyH - wall])
		cube([2*keycapW + 2*keycapSpacing + 2*wall, fingerDe, handR]);
	}
}

module screws(height, diameter, cap) {
	translate([-screwStandoffD + 1, thumbDe - screwStandoffD + 2, 0]) {
		cylinder(h = height, d = diameter);
		if (cap) {
			translate([0, 0, height])
			sphere(d = diameter);
		}
	}
	translate([fingerW - keycapW/2 - screwStandoffD/2, pinkyDe + screwStandoffD/2 - 1, 0]) {
		cylinder(h = height, d = diameter);
		if (cap) {
			translate([0, 0, height])
			sphere(d = diameter);
		}
	}
	translate([2*thickness + 0.1, -fingerW/4 - 0.8, 0]) {
		cylinder(h = height, d = diameter);
		if (cap) {
			translate([0, 0, height])
			sphere(d = diameter);
		}
	}
	translate([fingerW - (screwStandoffD+2)/2 + 1, -fingerW/4 - 0.8, 0]) {
		cylinder(h = height, d = diameter);
		if (cap) {
			translate([0, 0, height])
			sphere(d = diameter);
		}
	}
}

module lid() {
	//battery();
	//chargingReceiver();
	//proMicro();

	translate([0, 0, -lidDistance])
	color(keyboardColor) {
		difference() {
			scale([1, 1, lidH*10])
			intersection() {
				case(0);
				translate([-thumbDe, -2*handR, 0])
					cube([thumbDe + 2*fingerW, fingerDe + 2*handR, 0.1]);
			}
			translate([0, 0, -0.01])
				screws(lidH + 0.1, screwD, false);
			translate([0, 0, -0.01])
				screws(counterSinkH, screwHeadD, false);

			// Channel cutouts
			sideChannels(innerScale=0.98, height=sideChannelH);

			quickReleaseChannel();

			// Qi Charger cutout
			translate([fingerW/2 - chargerW/2, pinkyH - pcbH - switchToPcb - 2*thickness - chargerW/3, lidH - chargerH + 0.1])
				cube([chargerW, chargerDe, chargerH + 0.2]);
			translate([fingerW/2, pinkyH - pcbH - switchToPcb - 2*thickness, lidH - chargerH + 0.1])
				cube([handR - thickness, 5, chargerH + 0.2]);
		}
		// ProMicro standoff
		translate([fingerW/2 - proMicroStandoffW/2, pinkyH - pcbH - switchToPcb - 2*thickness - batteryStandoffDe/2 - proMicroStandoffDe, lidH])
			proMicroStandoff();

		// Battery Standoff
		translate([fingerW/2 - batteryStandoffW/2, pinkyH - pcbH - switchToPcb - 2*thickness - batteryStandoffDe/2, lidH])
			batteryStandoff();
	}
}

module sideChannels(innerScale, height) {
	translate([-(fingerW*channelScale - fingerW)/2, 0, baseIndent - height])
	difference() {
		scale([channelScale, channelScale, 1]) {
			intersection() {
				case(0);
				translate([-thumbW, -7*handR/4, -handR + height])
					cube([thumbDe + fingerW, middleDe + 7*handR/4, handR]);
			}
		}
		translate([fingerW*((1-innerScale)/2) - fingerW*((1-channelScale)/2) , 0, -0.01])
		scale([innerScale, innerScale, 100*height]) {
			intersection() {
				case(0);
				translate([-thumbW, -7*handR/4, 0])
					cube([thumbDe + fingerW, middleDe + 7*handR/4, 0.01]);
			}
		}
		translate([-fingerW/2, middleDe, -0.01])
			cube([fingerW*2, fingerDe + 7*handR/4, lidH*channelScale]);
	}
}

module quickReleaseChannel() {
	// Lid channel cutout
	translate([baseScale*fingerW - quickReleaseButtonWall - 2*quickReleaseArmDi - quickReleaseButtonH - quickReleaseArmDi/2 - tolerance, -((fingerDe + handR)*baseScale - (fingerDe + handR))/4 - quickReleaseArmDi/2, -lidH*0.01])
		cube([2*quickReleaseArmDi, quickReleaseArmDi, sideChannelH]);

	translate([baseScale*fingerW - quickReleaseButtonWall - 2*quickReleaseArmDi - quickReleaseButtonH - quickReleaseArmDi/2 - tolerance, -((fingerDe + handR)*baseScale - (fingerDe + handR))/4 - quickReleaseArmDi/2, -lidH*0.01])
	mirror([0, 1, 0])
	rotate([0, 0, -asin((2*quickReleaseArmDi)/lidQuickReleaseChannelDe)])
		cube([quickReleaseArmDi, lidQuickReleaseChannelDe, sideChannelH]);

//	translate([baseScale*fingerW - quickReleaseButtonWall - 2*quickReleaseArmDi - quickReleaseButtonH - quickReleaseArmDi/2 - tolerance, -((fingerDe + handR)*baseScale - (fingerDe + handR))/4 - quickReleaseArmDi/2, -lidH*0.01])
//	mirror([0, 1, 0])
//	rotate([0, 0, -asin((2*quickReleaseArmDi)/lidQuickReleaseChannelDe)/2])
//		cube([quickReleaseArmDi, lidQuickReleaseChannelDe, sideChannelH]);
}

module base() {
	translate([-(fingerW*baseScale - fingerW)/2, -((fingerDe + handR)*baseScale - (fingerDe + handR))/4, -baseH + baseIndent - lidH])
	difference() {
		scale(baseScale)
			case();
		translate([-400, -400, baseH])
			cube([1000, 1000, 1000]);

		// Indent
		translate([2*(fingerW*baseIndentScale - fingerW), (fingerDe + handR)*baseIndentScale - fingerDe - handR, baseH - baseIndent])
			scale(baseIndentScale)
				case();

		// Front opening to slide in case
		translate([-fingerW/2, fingerDe - 1.5*keycapW, baseH - baseIndent])
			cube([2*fingerW, 2*(fingerDe + handR), baseIndent + 1]);

		// Quick release channel
		translate([baseScale*fingerW - quickReleaseButtonH - quickReleaseArmH - quickReleaseSpringH - quickReleaseButtonWall, 0, baseH - baseIndent - quickReleaseArmDi/2 - tolerance])
			rotate([0, 90, 0])
				cylinder(h = quickReleaseArmH + quickReleaseButtonH + quickReleaseSpringH + 2*tolerance, d = quickReleaseArmDi + tolerance);

		// Top opening to channel
		translate([baseScale*fingerW - quickReleaseOpeningW - quickReleaseButtonWall - quickReleaseArmH, -(quickReleaseArmDi/2 + tolerance), baseH - baseIndent - quickReleaseArmDi/2 + 0.1])
			cube([quickReleaseOpeningW, 2*(quickReleaseArmDi/2 + tolerance), quickReleaseArmDi]);

		// Button hole
		translate([baseScale*fingerW - quickReleaseButtonWall*1.05, 0, baseH - baseIndent - quickReleaseArmDi/2 - tolerance])
			rotate([0, 90, 0])
				cylinder(h = quickReleaseButtonWall*1.1, d = quickReleaseButtonHeadDi + tolerance);
	}
	// Side channels
	translate([0, 0, -lidH])
		sideChannels(innerScale=0.99, height=(sideChannelH-2*tolerance));
}

module keyboard() {
	color(keyboardColor) {
		difference() {
			union() {
				// Hollowed out case with switch cutouts
				difference() {
					case();
					case(thickness);
					switchCutouts();
				}

				// PCB holder
				intersection() {
					translate([-thumbDe, pinkyDe - keycapW - thickness - keycapSpacing, pinkyH - pcbH - switchToPcb - 2*thickness])
						cube([4*handR, fingerDe, handR]);
					difference() {
						case();
						switchCutouts();
					}
				}
			}

			union() {
				// PCB rails
				translate([keycapSpacing + keycapW/2 - pcbW/2, pointerDe - 2*keycapW - tolerance + 0.0005 - thickness, pointerH - pcbH - switchToPcb - thickness + 0.001])
					cube([pcbW, 2*keycapW + tolerance, pcbH]);
				translate([keycapW + 3*keycapSpacing + keycapW/2 - pcbW/2, middleDe - 2*keycapW - tolerance + 0.005 - 2*thickness, middleH - pcbH - switchToPcb - thickness + 0.001])
					cube([pcbW, 2*keycapW + tolerance + thickness, pcbH]);
				translate([2*keycapW + 5*keycapSpacing + keycapW/2 - pcbW/2, ringDe - 2*keycapW - tolerance + 0.005 - thickness, ringH - pcbH - switchToPcb - thickness + 0.001])
					cube([pcbW, 2*keycapW + tolerance, pcbH]);
				translate([3*keycapW + 7*keycapSpacing + keycapW/2 - pcbW/2, pinkyDe - 2*keycapW - tolerance + 0.005 - thickness, pinkyH - pcbH - switchToPcb - thickness + 0.001])
					cube([pcbW, 2*keycapW + tolerance, pcbH]);

				// PCB bottom hole
				translate([keycapSpacing + keycapW/2 - pcbW/2 + thickness/2, 0.0005 - thickness, -thickness])
					cube([pcbW - thickness, pointerDe, pointerH]);
				translate([keycapW + 3*keycapSpacing + keycapW/2 - pcbW/2 + thickness/2, 0.005 - thickness, -thickness])
					cube([pcbW - thickness, middleDe, middleH]);
				translate([2*keycapW + 5*keycapSpacing + keycapW/2 - pcbW/2 + thickness/2, 0.005 - thickness, -thickness])
					cube([pcbW - thickness, ringDe, ringH]);
				translate([3*keycapW + 7*keycapSpacing + keycapW/2 - pcbW/2 + thickness/2, 0.005 - thickness, -thickness])
					cube([pcbW - thickness, pinkyDe, pinkyH]);
			}
		}
		difference() {
			// Screw standoffs
			screws(screwStandoffH, screwStandoffD + 2, true);

			translate([0, 0, -2])
				screws(screwStandoffH, screwStandoffD, false);
		}
	}
}

module quickRelease() {
	translate([baseScale*fingerW - 2*quickReleaseButtonWall, -((fingerDe + handR)*baseScale - (fingerDe + handR))/4, -lidH - quickReleaseArmDi/2 - tolerance])
	union() {
		translate([-quickReleaseArmH - quickReleaseButtonH, 0, 0])
			rotate([0, 90, 0])
				cylinder(h = quickReleaseArmH, d = quickReleaseArmDi);
		translate([-quickReleaseArmH - quickReleaseArmDi/2, 0, 0])
			cylinder(h = quickReleaseArmDi/2 + sideChannelH, d = quickReleaseArmDi);
		translate([-quickReleaseButtonH, 0, 0])
			rotate([0, 90, 0])
				cylinder(h = quickReleaseButtonH, d = quickReleaseButtonDi);
		rotate([0, 90, 0])
			cylinder(h = quickReleaseButtonHeadH, d = quickReleaseButtonHeadDi);
	}
}

//keyboard();
//keycaps();
lid();
//base();
//quickRelease();

translate([-40, 0, 0])
rotate([0, 0, 240])
mirror([0, 1, 0]) {
	//keyboard();
	//keycaps();
	//lid();
}
