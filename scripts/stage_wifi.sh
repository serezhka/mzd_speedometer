#!/bin/sh

# this is bad
mount -o rw,remount /

watch -n 1 /jci/scripts/get-vehicle-speed.sh &
