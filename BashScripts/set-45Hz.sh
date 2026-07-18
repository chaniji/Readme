#!/bin/bash
xrandr --newmode "1920x1080_45.00" 125.50 1920 2016 2216 2512 1080 1083 1088 1111 -hsync +vsync
xrandr --addmode eDP "1920x1080_45.00"
xrandr --output eDP --mode "1920x1080_45.00"
