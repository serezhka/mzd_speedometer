#!/bin/sh

dbus-send --print-reply --address=unix:path=/tmp/dbus_service_socket --type=method_call --dest=com.jci.lds.data /com/jci/lds/data com.jci.lds.data.GetPosition | awk 'NR==7{print $2}' > /jci/gui/vehSpd.txt
