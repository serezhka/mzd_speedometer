#!/bin/sh

# this is bad
mount -o rw,remount /

watch -n 1 ./get-vehicle-speed.sh &