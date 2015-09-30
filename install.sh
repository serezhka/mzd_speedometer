#!/bin/sh

mount -o rw,remount /

# Disable watchdogs in /jci/sm/sm.conf to avoid boot loops if smthing goes wrong
sed -i 's/watchdog_enable="true"/watchdog_enable="false"/g' /jci/sm/sm.conf
sed -i 's|args="-u /jci/gui/index.html"|args="-u /jci/gui/index.html --noWatchdogs"|g' /jci/sm/sm.conf

# Enable userjs and allow file XMLHttpRequest in /jci/opera/opera_home/opera.ini
sed -i 's/User JavaScript=0/User JavaScript=1/g' /jci/opera/opera_home/opera.ini
count=$(grep -c "Allow File XMLHttpRequest=" /jci/opera/opera_home/opera.ini)
if [ "$count" = "0" ]; then
    sed -i '/User JavaScript=.*/a Allow File XMLHttpRequest=1' /jci/opera/opera_home/opera.ini
else
    sed -i 's/Allow File XMLHttpRequest=.*/Allow File XMLHttpRequest=1/g' /jci/opera/opera_home/opera.ini
fi

# Copy userjs file
cp userjs/speedometer.js /jci/opera/opera_dir/userjs/

# Copy fonts, images, css to web dir (/jci/gui/)
cp speedometer/ /jci/gui/ -R

# Copy scripts and make them executable
oldscript=$(ps | grep "get-vehicle-speed" | awk 'NR == 1{print$1}') 
if [ "$oldscript" != "" ]; then
    kill -9 $oldscript > /dev/null
fi
cp scripts/* /jci/scripts/
chmod 755 /jci/scripts/stage_wifi.sh
chmod 755 /jci/scripts/get-vehicle-speed.sh

# Speedometer installed.
/jci/tools/jci-dialog --title="Speedometer" --text="Install Succeeded. Reboot your system!" --ok-label="Ok" --no-cancel &
