// all dims in mm

// the frame
frame_width  = 360;
frame_length = 235;
frame_height = 15;

// color("white", 0.1) cube([width, length, frame_height]);

// the keyboard, comoposed of several parts
tray_width  = 309.5;
tray_length = 114;
tray_height = 5.4;

module tab(x, y, big_width, small_witdh, direction, length, height, three_dee) {
    width_dist  = (tray_tab_big_width - tray_tab_small_width) / 2;

    translate([x, y, 0]) {
        if (three_dee == 1) {
            linear_extrude(height)
                polygon([ [0, 0], [big_width, 0],
                          [big_width - width_dist, direction * length],
                          [width_dist, direction * length] ]);
        } else {
            polygon([ [0, 0], [big_width, 0],
                      [big_width - width_dist, direction * length],
                      [width_dist, direction * length] ]);
        }
    }
}

// TODO: real values
tray_tab_big_width   = 10;
tray_tab_small_width = 5;
tray_tab_length      = 5;
tray_tab_height      = 2;

// there are five of such tabs, plus a smaller one
// for the moment, model them as the same
tray_tab_xs = [ 10, 80, 120, 190, 230, 290 ];

// TODO: real values
screw_tab_big_width   = 10;
screw_tab_small_width = 8;
screw_tab_width_dist  = (screw_tab_big_width - screw_tab_small_width) / 2;
screw_tab_length      = 8;
screw_tab_height      = 2;

screw_tab_xs = [ 90, 260 ];


FFC_min_width = 26.4;  // B
FFC_max_width = 39.0;
FFC_length    = 67.5;
FFC_distance_from_tray_border = 133.5;
FFC_insertion = 2;

// the electronics board
// teensy
teensy_pins = 40;
teensy_board_width  = 18.4;
teensy_board_length = teensy_pins / 2 * 2.54;
teensy_board_height = 1.57;

teensy_padding_x = 5;
teensy_padding_y = 10;

// teensy usb connector
usb_connector_width  = 7.5;
usb_connector_length = 5;
usb_connector_height = 2.5;

// board
board_width  = 75;
board_extrusion = teensy_board_width + teensy_padding_y;
board_length = tray_length - FFC_length - FFC_insertion + board_extrusion;
board_height = 1.6;

// the connector
// see https://www.mouser.fr/datasheet/2/909/6200-1381185.pdf
connector_width  = 31.45;  // C
connector_length = 6.6;
connector_height = 2.9;
border_to_pin_center_x = 2.9;
border_to_pin_center_y = 2.2; // assuming the pins are round

// the button
// we don have the dimms for the button casing, so we'll do with the button itself
button_width  = 3;
button_length = 2.2; // these will be radiuses, really
button_height = 2.5;

button_body_width  = 3.4;  // eye of good barrel maker/seller
button_body_length = 2.6;
button_body_height = 1.8;

boss_distance = 4.5;  // see SMT with bosses

lateral_extrusion = 3.7 - 2.9;
frontal_extrusion = 6.6 - 6.3;

extrusion_radius = connector_length - boss_distance;
extrusion_center_x = extrusion_radius - lateral_extrusion;
extrusion_center_y = extrusion_radius - frontal_extrusion;

body_width  = connector_width  - 2 * lateral_extrusion;
body_length = connector_length - frontal_extrusion;

// (C-B-le)/2
// TODO: recalculate
FFC_to_conector_body_side = (connector_width - FFC_min_width - lateral_extrusion) / 2;

// keyboard
tray_x = (frame_width - tray_width) / 2;
tray_y = frame_length - 10 - board_extrusion;
tray_z = frame_height - tray_height;
echo(tray_x=tray_x, tray_y=tray_y, tray_z=tray_z, depth_from_top=frame_height - tray_z);

board_surface = tray_z - connector_height;

// connector
// align the left border of the connector mouth with the FFC
connector_x = tray_x + FFC_distance_from_tray_border - FFC_to_conector_body_side;
connector_y = tray_y + FFC_length - FFC_insertion;
connector_z = board_surface;
// dimms for the circuit
echo(connector_x=connector_x - board_x, connector_y=connector_y - board_y);
// for kicad, add border_to_pin_center offset
echo(connector_x=connector_x - board_x + border_to_pin_center_x,
     connector_y=connector_y - board_y + connector_length - border_to_pin_center_y);

// board
board_x = (frame_width - board_width) / 2;
board_y = connector_y;
board_z = board_surface - board_height;
echo(board_x=board_x, board_y=board_y, board_z=board_z,
     depth_from_top=frame_height - board_z);
echo(board_width=board_width, board_length=board_length);

// teensy
spacer_height = 2.54;
// the teensy is rotated 90 degrees
// align the teensy with the right border of the board
teensy_x = board_x + board_width - teensy_board_length - teensy_padding_x;
teensy_y = board_y + FFC_insertion + board_length - (teensy_padding_y / 2) - teensy_board_width;
teensy_z = board_surface + spacer_height;
teensy_board_surface = teensy_board_height;
// dimms for the circuit
echo(teensy_x=teensy_x - board_x, teensy_y=teensy_y - board_y);

// relative to the teensy board
usb_connector_x = 0;
usb_connector_y = (teensy_board_width - usb_connector_width) / 2;
usb_connector_z = teensy_board_surface;

button_centre = 1.27 + (teensy_board_length - 35.56 + 29.97);
echo(button_centre=button_centre);

button_x = button_centre - button_length / 2;
button_y = (teensy_board_width - button_width) / 2;
button_z = teensy_board_surface;
echo(button_x=button_x, button_y=button_y);

button_body_x = button_centre - button_body_length / 2;
button_body_y = (teensy_board_width - button_body_width) / 2;
button_body_z = teensy_board_surface;
echo(button_body_x=button_body_x, button_body_y=button_body_y);


translate([tray_x, tray_y, tray_z]) {
    // the tray
    cube([tray_width, tray_length, tray_height]);
    color ("purple")
        square([tray_width, tray_length]);

    // the tabs
    for(index = [0:len(tray_tab_xs) - 1]) {
        tab(tray_tab_xs[index], 0, tray_tab_big_width, tray_tab_small_width,
            -1, tray_tab_length, tray_tab_height, 1);

        color ("purple")
            tab(tray_tab_xs[index], 0, tray_tab_big_width, tray_tab_small_width,
                -1, tray_tab_length, tray_tab_height, 0);
    }

    for(index = [0:len(screw_tab_xs) - 1]) {
        tab(screw_tab_xs[index], tray_length, screw_tab_big_width, screw_tab_small_width,
            1, screw_tab_length, screw_tab_height, 1);

        color ("purple")
            tab(screw_tab_xs[index], tray_length, screw_tab_big_width, screw_tab_small_width,
                1, screw_tab_length, screw_tab_height, 0);
    }

    // the FFC
    translate([FFC_distance_from_tray_border, 0, 0]) {
        color("blue")
            polygon([ [0, 0], [FFC_max_width, 0],
                      [FFC_min_width, FFC_max_width-FFC_min_width],
                      [FFC_min_width, FFC_length], [0, FFC_length] ]);
    }
}

translate([board_x, board_y, board_z]) {
    color("red")
        cube([board_width, board_length, board_height]);
}

translate([board_x, board_y - 25, board_z]) {
    color("purple")
        square([board_width, board_length + 25]);
}

translate([connector_x, connector_y, connector_z]) {
    color("green") {
        cube([body_width, body_length, connector_height]);

        /*
        // TODO: correct the extrusion centers
        translate([extrusion_center_x, extrusion_center_y]) {
            cylinder(connector_height, extrusion_radius, extrusion_radius);
        }

        translate([connector_width-extrusion_center_x, extrusion_center_y]) {
            cylinder(connector_height, extrusion_radius, extrusion_radius);
        }
        */
    }
}

translate([teensy_x, teensy_y, teensy_z]) {
    // board
    color("green")
        cube([teensy_board_length, teensy_board_width, teensy_board_height]);

    color("blue") {
        // usb connector
        // it's rotated 90 degrees
        translate([usb_connector_x, usb_connector_y, usb_connector_z])
            cube([usb_connector_length, usb_connector_width, usb_connector_height]);
    }

    color("blue") {
        // button body
        // it's rotated 90 degrees
        translate([button_body_x, button_body_y, button_body_z])
            cube([button_body_length, button_body_width, button_body_height]);
    }

    color("blue") {
        // button
        // it's rotated 90 degrees
        translate([button_x, button_y, button_z])
            linear_extrude(button_height)
                resize([button_length, button_width])
                    circle(button_length);
    }

    // spacers
    translate([0, 0, -2.54])
        cube([teensy_pins / 2 * 2.54, 2.54, 2.54]);
    translate([0, teensy_board_width - 2.54, -2.54])
        cube([teensy_pins / 2 * 2.54, 2.54, 2.54]);
}
