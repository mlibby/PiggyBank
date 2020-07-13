# 3D Printing Stuff

A key aspect of the PiggyBank project is that it is a household *appliance*, not just software. As a household appliance, PiggyBank should be a self-contained device that you can plug into the wall. The first part of that goal is achieved by putting the PiggyBank software on a Raspberry Pi (RPi), then pairing the RPi with it's own screen.

Sure, you could just set your RPi and its monitor on a shelf, but how much fun is that? None. That's how much fun that is. And it's not really a household appliance either, since that's not really a self-contained device. So the project also includes an official case to hold the RPi, the screen, and even its own on/off switch!

### Test Raspberry Pi Mount

The first thing to do is make sure your 3D printer is printing the RPi mounts correctly (proper scale, etc). For this purpose [print the test mount STL file](https://github.com/mlibby/PiggyBank/blob/master/3d/test_pi_mounts_M2.5.stl). This file is just the mounting posts and enough base to test your hardware and sizing.

You can mount a Raspberry Pi 3A or 3B to the test plate. The test plate was designed to use M2.5x10mm screws and standard M2.5 hex nuts. Insert the nuts into the square slots, make sure the centers are lined up, then screw in the screws. If everything is working the RPi should fit flush on the posts and have a nice snug fit.

### Test USB Port

The USB port was designed for a generic Micro USB to DIP 2.54mm Adapter 5pin Female Connector Type B PCB Converter that I got off Amazon (https://smile.amazon.com/gp/product/B07T91S7L2) -- there are a number of similar adapter boards out there, so you definitely want to run a test of the USB port and the board mounting before doing a full print.

### Test Toggle Switch Mount

The same thing goes for the toggle switch as for the USB port. I just bought a generic SPST On/Off toggle from Amazon (https://smile.amazon.com/gp/product/B01M3261R) and designed the mounting area for that one. But any On/Off toggle will do, so you may need to adjust the mount to taste.

You could also remove the toggle switch and use a USB power supply cable with a built-in on/off switch... but then you don't get to have the cute pig tail switch on your appliance. :)
