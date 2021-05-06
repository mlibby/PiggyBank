module pig_body(){
    translate([10, -5, 0])
    scale([2.25,1.8,0])
    difference() {
        circle(d=100, $fn=180);
    }
};

module pig_body_inner(){
    translate([10, -5, 0])
    scale([2.25,1.8,0])
    difference() {
        circle(d=85, $fn=180);
    }
};

module pig_foot() {
    polygon([[-58,-75],[-66, -110],[-25,-110],[-15, -85]]);        
};

module pig_foot_inner() {
    polygon([[-41,-60],[-51,-100],[-33,-100],[-22,-65]]);
};

module pig_nose() {
    translate([-105,-3,0])
    square([28,48], center = true);
};

module pig_nose_inner() {
    translate([-90,-3,0])
    square([30,25], center = true);
    
};

module pig_ear() {
    polygon([[-52,110],[-58,108],[-60,60],[-15,75]]);
};

module pig_ear_inner() {
    polygon([[-46,86],[-47,45],[-12,55]]);
};

module solid_pig() {
    union () {
        pig_body();
        pig_foot();
        translate([22,0,0])
        mirror([1,0,0])
        pig_foot();
        pig_nose();
        pig_ear();
    };
};

module inner_pig() {
    union() {
        pig_body_inner();
        pig_foot_inner();
        translate([22,0,0])
        mirror([1,0,0])
        pig_foot_inner();
        pig_nose_inner();
        pig_ear_inner();
        }
};

module pig_outline() {
    difference() {
    scale([0.7, 0.7, 1])
        solid_pig();
    scale([0.7, 0.7, 1])
        inner_pig();
    };
};

module air_hole() {
    rotate([90,0,0])
    cylinder(h=20, r=3, $fn=20);    
}

module air_holes() {
    translate([-5,65,11])
    air_hole();
    translate([-5,65,24])
    air_hole();
    translate([8,65,11])
    air_hole();
    translate([8,65,24])
    air_hole();
    translate([21,65,11])
    air_hole();
    translate([21,65,24])
    air_hole();
}

module oinker() {
    translate([21,65,11])
    scale([1.5,1,1.5])
    air_hole();
    translate([21,65,24])
    scale([1.5,1,1.5])
    air_hole();
}

module pig_main() {
    difference() {
        color("seagreen")
        linear_extrude(35)
        pig_outline();
        air_holes();
        translate([34,60,11])
        air_hole();
        translate([34,60,24])
        air_hole();
        translate([0,-115,0])
        air_holes();

        translate([-22,-23,0])
        rotate([0,0,90])
        oinker();  
    };
}

module screw_pole() {
    color("yellow")
    difference() {
        union() {
            cylinder(h=15, r=3.0, $fn=20);
            translate([-5,-5,0])
            cube([10,10,12]);
        }
        translate([0,0,-1])
        cylinder(h=17, r=1.4, $fn=20);
        translate([-2.6,-6.9,8.5])
        cube([5.2,10,2.1]);
    };
}

module _back_side() {
    union() {
        color("lightgreen")
        linear_extrude(3)
        scale([0.7, 0.7, 1])
        solid_pig();

        translate([50,19,0])
        rotate([0,0,180])
        screw_pole();
        translate([50,-29,0])
        screw_pole();
        translate([-8,-29,0])
        screw_pole();
        translate([-8,19,0])
        rotate([0,0,180])
        screw_pole();
    };
};

module bezel() {
    union() {
        translate([0,-0.5,0])
        cube([76,50,0.4]);
        translate([-0.5,-1,0.4])
        cube([77,51,0.4]);
        translate([-1.0,-1.5,0.8])
        cube([78,52,0.4]);
        translate([-1.5,-2,1.2])
        cube([79,53,0.4]);
        translate([-2,-2.5,1.6])
        cube([80,54,0.4]);
        translate([-2.5,-3,2])
        cube([81,55,0.4]); 
        translate([-3,-3.5,2.40])
        cube([82,56,0.4]); 
        translate([-3.5,-4,2.80])
        cube([83,57,0.4]); 
    }
}

module _front_side() {
    difference() {
        color("lightgreen")
        linear_extrude(3)
        scale([0.7, 0.7, 1])
        solid_pig();
        translate([-29.5, -27.5, 0])
        bezel();
    }
}

module screen() {
    color("black")
    cube([85,57,7]);
}

module rasp_pi_a() {
    cube([70,57,20]);
};
    
module hdmi_plug() {
    color("grey")
    cube([16,10,17]);
}
    
module pi_unit(){
    translate([2,0,20])
    screen();
    translate([27,-10,0])
    hdmi_plug();
    color("red")
    rasp_pi_a();
}

module screw_measure() {
    color("blue")
    union() {
        translate([-22,18,-4])
        cube([58,1,1]);    
        translate([-22,-30,-4])
        cube([58,1,1]);
        translate([-22,-30,-4])
        cube([1,49,1]);
        translate([35,-30,-4])
        cube([1,49,1]);
    };    
}

module mount_test() {
    translate([-100,-95,-5])
    cube([200,60,10]);
    translate([-100,35,-5])
    cube([200,60,10]);
    translate([-113,-45,-5])
    cube([90,90,10]);
    translate([49,-45,-5])
    cube([40,90,10]);
    translate([13,0,-5])
    cylinder(h=10, r=30);
}

module _usb_port() {
    translate([3,-1,1.75])
    color("silver")
    cube([8.4,6,3]);
    difference() {
        color("green")
        cube([14.6,16,1.8]);
        translate([3.3,10,-1])
        cylinder(r=1.9,h=4,$fn=30);
        translate([11.1,10,-1])
        cylinder(r=1.9,h=4,$fn=30);
    }
}

module usb_port() {
    rotate([90,0,180])
    translate([-7,-2.05,-40])
    _usb_port();
}

module _usb_ledge() {
    difference() {
        cube([14.6,13,8.2]);
        translate([3.3,10,-1])
        cylinder(r=1.9,h=14,$fn=30);
        translate([11,10,-1])
        cylinder(r=1.92,h=14,$fn=30);
    }
}

module usb_ledge() {
    color("blue")
    rotate([90,0,180])
    translate([-7,-2.05,-48.25])
    _usb_ledge();
}

module usb_port_test() {
    translate([-110,-30,-10])
    cube([200,120,60]);
    translate([-110,-85,-10])
    cube([90,100,60]);
    translate([5,-90,-10])
    cube([90,100,60]);
    translate([-110,-85,-10])
    cube([200,30,60]);
}

module toggle_test() {
    translate([-100,-90,-10])
    cube([140,180,60]);
    translate([35,-90,-10])
    cube([60,90,60]);
}

module edge_grip() {
    color("red")
    linear_extrude(3)
    difference() {
        translate([-8,0,3])
        scale([0.7, 0.7, 1])
        inner_pig();
        translate([-8,0,3])
        scale([0.685, 0.685, 3])
        inner_pig();
    };
}

module back_side() {
    union() {
        edge_grip();
        difference() {
            translate([-8,0,-3])
            _back_side();
            usb_port();
        }
        usb_ledge();
    };
}

module front_side() {
   _front_side();
   translate([8,0,-3])
   edge_grip();
}

module _toggle() {
    union() {
        color("silver")
        translate([4.95,7.6,20])
        cylinder(h=6,r=3.2,$fn=30);
        color("blue")
        cube([10,15,20]);
    }
}

module toggle() {
    translate([46,12,23])
    rotate([0,90,45])
    _toggle();
}

difference() {
//    translate([-16,0,0])
//    pig_main();
//    toggle();
    //toggle_test();
}

difference() {
    //translate([-8,0,0])
    //back_side();
    //usb_port_test();
    //mount_test();
}
//
//translate([40,23,12])
//rotate(180)
//pi_unit();


translate([-16,0,36])
front_side();

//translate([6,6,0])
//screw_measure();