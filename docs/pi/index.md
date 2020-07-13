# Setup a Raspberry Pi for PiggyBank

We will be assigning the Raspberry Pi (RPi) a static IP address of 192.168.0.42 and referring to that throughout these instructions. You may want to assign a different number, if so the IP mentioned in the instructions should be replaced with your actual number.

## Update and Install Packages

1. Install Raspbian
2. `sudo apt update`
3. `sudo apt upgrade`
4. `sudo apt install python3 python3-flask python3-psycopg2 postgresql apache2`

## Give the RPi a Static IP

`sudo nano /etc/dhcpcd.conf`

Find or create a line like: `static ip_address=192.168.0.42/24`

The RPi will still use DHCP, but will insist that it's IP address is 192.168.0.42. You will need to set this address to something that works with your home network. Usually this will require checking what range your DHCP server will assign to devices on your network. This is probably 
in the settings of your cable modem or DSL router.

## Set up the UCTronics Screen

`wget https://raw.githubusercontent.com/uctronics/uctronics_lcd35_hdmi_rpi/master/install`

`sudo sh install`

`sudo cp ./UCTRONICS_LCD35_HDMI_RPI/uctronics_hdmi/kernel_uc430.img /boot/kernel.img`

`sudo cp ./UCTRONICS_LCD35_HDMI_RPI/uctronics_hdmi/kernel7_uc430.img /boot/kernel7.img`

## Download PiggyBank

From `/home/pi`, clone the git repo: `git clone https://github.com/mlibby/PiggyBank.git`

## Set up Apache as Reverse Proxy

copy file from git repo `rpi/piggybank.conf` to `/etc/apache2/sites-available/`

`a2dissite 000-default`

`a2ensite piggybank`

`sudo systemctl restart apache2`

## Set up Flask app to Start at Boot

copy file from git repo `rpi/piggybank.service` to `/lib/systemd/system/`

`sudo systemctl daemon-reload`

Start up the PiggyBank service: `sudo systemctl start piggybank`

Test that Apache is running and proxying requests to PiggyBank by opening the URL `http://192.168.0.42/` in a web browser.

## Set up the Raspberry Pi to Autostart PiggyBank UI

`sudo nano /etc/xdg/lxsession/LXDE-pi/autostart`

In this file add a line to the end:

`@chromium-browser --start-fullscreen http://127.0.0.1`
