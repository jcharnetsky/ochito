thickness = 2;
tolerance = 0.5;
thumbRadius = 15 + thickness/2;
thumbDepth = 10;

jointRadius = 20;
jointOffsetMultiplier = 5/4;

armLength = 300;
armWidth = jointRadius;
armDepth = jointRadius;

chairBaseHeight = 100;
chairBaseWidth = 2*jointRadius + 80;
chairBaseDepth = 4/3*chairBaseHeight;
chairBaseThickness = 20;

screwRadius = 8;
screwMargin = 10;


module ballJoint() {
    difference() {
        sphere(r = jointRadius);
        sphere(r = jointRadius - thickness/2);
        translate([0, 0, -jointRadius*jointOffsetMultiplier])
        cube([jointRadius * 2, jointRadius * 2, jointRadius * 2], center = true);
    }
}
module keyboardBase() {
    difference() {
        cylinder(h = thumbDepth + thickness + jointRadius, r = thumbRadius);
        translate([0, 0, thickness + jointRadius + 0.01])
            cylinder(h = thumbDepth, r = thumbRadius - thickness/2);
    }
    translate([0, 0, -thumbDepth])
    ballJoint();

}

module arm() {
    translate([0, 0, -jointRadius])
        sphere(r = jointRadius - thickness/2 - tolerance);
    translate([0, 0, -(jointRadius + armLength/2)])
        cube([armWidth, armDepth, armLength], center = true);
    translate([0, 0, -(jointRadius + armLength)])
        sphere(r = jointRadius - thickness/2 - tolerance);
}

module chairBase() {
    difference() {
        translate([0, -(chairBaseDepth/2), -(armLength + chairBaseHeight/2)])
            cube([chairBaseWidth, chairBaseDepth, chairBaseHeight], center = true);
        
        translate([chairBaseThickness, -(chairBaseDepth/2), -(armLength + chairBaseHeight/2)])
            cube([chairBaseWidth, chairBaseDepth - 2*chairBaseThickness, chairBaseHeight + 2], center = true);
    }
}

module chairBasePlate() {
    translate([chairBaseThickness/2, -(chairBaseDepth/2), -(armLength + chairBaseHeight/2)])
        cube([chairBaseThickness, chairBaseDepth - 2*chairBaseThickness - 2*tolerance, chairBaseHeight], center = true);
}

module screws() {
    translate([0, -(chairBaseThickness + screwRadius + screwMargin + 2*tolerance), -(armLength + chairBaseHeight - screwRadius - screwMargin)])
        rotate([0, 90, 0])
            cylinder(h = chairBaseWidth + 0.1, r = screwRadius, center = true);
    translate([0, -(chairBaseThickness + screwRadius + screwMargin + 2*tolerance), -(armLength + screwRadius + screwMargin)])
        rotate([0, 90, 0])
            cylinder(h = chairBaseWidth + 0.1, r = screwRadius, center = true);
    translate([0, -(chairBaseDepth - chairBaseThickness - screwRadius - screwMargin - 2*tolerance), -(armLength + chairBaseHeight - screwRadius - screwMargin)])
        rotate([0, 90, 0])
            cylinder(h = chairBaseWidth + 0.1, r = screwRadius, center = true);
    translate([0, -(chairBaseDepth - chairBaseThickness - screwRadius - screwMargin - 2*tolerance), -(armLength + screwRadius + screwMargin)])
        rotate([0, 90, 0])
            cylinder(h = chairBaseWidth + 0.1, r = screwRadius, center = true);
}
translate([0, 0, 40])
keyboardBase();
arm();

translate([0, 0, -2*jointRadius])
difference() {
    chairBase();
    screws();
}

translate([0, 0, -2*jointRadius])
difference() {
    chairBasePlate();
    screws();
}