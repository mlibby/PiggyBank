# PiggyBank
The PiggyBank helps manage all your finances

# Software Setup
These directions are notes for installing on WSL/Ubuntu or Raspbian

# Hardware Setup
PiggyBank is designed to run on a Raspberry Pi 3 A+ with an UCTRONICS 3.5 Inch HDMI TFT LCD Display with Touch Screen ([https://www.uctronics.com/index.php/uctronics-3-5-inch-hdmi-tft-lcd-display-with-touch-screen-touch-pen-3-heat-sinks-for-raspberry-pi-3-model-b-pi-2-model-b-pi-b.html])

##Install the UCTRONICS_LCD35_HDMI_RPI Software/Drivers

    wget https://raw.githubusercontent.com/UCTRONICS/UCTRONICS_LCD35_HDMI_RPI/master/install

    sudo sh install 

If you are using the old version UC430, you should run the below command to support it.

    sudo cp /home/pi/UCTRONICS_LCD35_HDMI_RPI/uctronics_hdmi/kernel_uc430.img /boot/kernel.img

    sudo cp /home/pi/UCTRONICS_LCD35_HDMI_RPI/uctronics_hdmi/kernel7_uc430.img /boot/kernel7.img

    sudo reboot

You will certainly want to run `xinput-calibrator` to make sure your stylus is accurate.
