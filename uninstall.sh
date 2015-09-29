#!/bin/sh

mount -o rw,remount /

# Remove userjs file
rm /jci/opera/opera_dir/userjs/speedometer.js

# Remove fonts, images, css to web dir (/jci/gui/)
rm /jci/gui/speedometer/ -R

# Remove scripts
oldscript=$(ps | grep "get-vehicle-speed" | awk 'NR == 1{print$1}') 
if [ "$oldscript" != "" ]; then
    kill -9 $oldscript > /dev/null
fi
echo "#!/bin/sh" > /jci/scripts/stage_wifi.sh
rm /jci/scripts/get-vehicle-speed.sh

# Speedometer uninstalled.
/jci/tools/jci-dialog --title="Speedometer" --text="Uninstall Succeeded. Reboot your system!" --ok-label="Ok" --no-cancel &
