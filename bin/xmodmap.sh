#!/bin/sh 
# tbh this shouldn't be needed because of the xsession
# but then again, neither should any of this script
#setxkbmap -layout "gb(mac)" -option "caps:swapescape;ctrl:nocaps"
setxkbmap -layout "gb(mac)" -option "ctrl:nocaps"
if [ "$1" == "--help" ]; then
  echo -e "Sets keys how I want. Shift keys are parens, caps is escape, and alt and meta are swapped.\n\nUse --keep-meta to not swap meta and alt"
  exit 0
fi
xmodmap -e 'keycode   9 = Multi_key' 
xmodmap -e 'clear Lock'

# Doing this because we still need an escape mapping
# https://github.com/alols/xcape
xmodmap -e 'keycode 255 = Escape'
                                                                                            
#swap win key and alt key for Dell XPS


if [ "$1" != "--keep-meta" ]; then
  #need to remove first
  xmodmap -e 'remove mod1 = Alt_L'
  xmodmap -e 'remove mod4 = Super_L'
  xmodmap -e 'clear mod1'
  xmodmap -e 'clear mod2'
  xmodmap -e 'clear mod3'
  xmodmap -e 'clear mod4'
  xmodmap -e 'clear mod5'

  #reassign keycodes
  xmodmap -e 'keycode 133 = Alt_L Meta_L Alt_L Meta_L'
  xmodmap -e 'keycode 64 = Super_L'
  xmodmap -e 'keycode 108 = Super_L'

  #then apply back to how it was
  xmodmap -e 'add mod4 = Super_L'
  xmodmap -e 'add mod1 = Alt_L'
fi

#if you just swap mod1 mod4 then keybindings don't work in e.g. firefox

xmodmap -e 'keycode 12 = 3 numbersign 3 numbersign sterling numbersign sterling numbersign'
xmodmap -e 'keycode  49 = grave asciitilde grave asciitilde bar brokenbar bar'


xmodmap -e 'keycode  37 = Control_L' 


#this gets rid of the hissing on XPS 13
#amixer -c PCH cset 'name=Headphone Mic Boost Volume' 1 
# TODO lookup pulseaudio alternative


#this maps the touchscreen only to the  
xinput --map-to-output $(xinput list --id-only "ELAN Touchscreen") eDP-1

# double the sensitivity of the logitech mouse
xinput --set-prop 'Logitech USB Optical Mouse' 'Coordinate Transformation Matrix' 2 0 0 0 2 0 0 0 1 2>/dev/null
xinput --set-prop 'DLL075B:01 06CB:76AF Touchpad' 'Coordinate Transformation Matrix' 4.0 0 0 0 4.0 0 0 0 1.0>/dev/null
xinput --set-prop 'ELAN Touchscreen' 'libinput Calibration Matrix' 1.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 1.0
xinput --set-prop 'pointer:Logitech MX Master' 'Coordinate Transformation Matrix' 2.0 0 0 0 2.0 0 0 0 1.0 >/dev/null

# ms before doing something, amount of times per second
xset r rate 220 40

xsetroot -cursor_name left_ptr
# scrolling is really slow now for some reason??
#PROP_TO_SET="$(xinput --list | grep DLL | grep Touchpad | cut -f 2 | cut -d "=" -f 2)"
#xinput set-prop $PROP_TO_SET 'Trackpad Scroll Distance' 20
#??????
 $(systemctl is-active --quiet wpa_supplicant-wlp58s0.service) || sudo systemctl restart wpa_supplicant-wlp58s0.service.service
killall xcape 2>/dev/null 
xcape -e "Shift_L=parenleft;Shift_R=parenright;Control_L=Escape"
