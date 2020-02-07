#!/bin/bash

if [ -z "$SCRIPT_PATH" ]; then
	SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
fi

	# Debranding
	# Reset url
	sed -i -e 's/"Zaribo.com"/"prusa3d.com"/g' $SCRIPT_PATH/Firmware/ultralcd.cpp
	# reset Company name
	sed -i -e 's/"\\n Zaribo Research\\n   and Development"/"\\n Original Prusa i3\\n   Prusa Research"/g' $SCRIPT_PATH/Firmware/Marlin_main.cpp
	# reset FRIMWARE_NAME
	sed -i -e 's/"FIRMWARE_NAME:Zaribo-Firmware "/"FIRMWARE_NAME:Prusa-Firmware "/g' $SCRIPT_PATH/Firmware/Marlin_main.cpp
	# reset FIRMWARE_URL
	sed -i -e "s/https:\/\/github.com\/Zaribo\/Zaribo-Firmware/https:\/\/github.com\/prusa3d\/Prusa-Firmware/g" $SCRIPT_PATH/Firmware/Marlin_main.cpp
	# reset MSG_WIZZARD_WELCOME and WELCOME_MSG
	sed -i -e "s/Zaribo/Original Prusa i3/g" $SCRIPT_PATH/Firmware/ultralcd.cpp
	sed -i -e "s/Zaribo/Original Prusa i3/g" $SCRIPT_PATH/lang/lang_en.txt
	sed -i -e "s/Zaribo/Original Prusa i3/g" $SCRIPT_PATH/lang/lang_en_cz.txt
	sed -i -e "s/Zaribo/Original Prusa i3/g" $SCRIPT_PATH/lang/lang_en_de.txt
	sed -i -e "s/Zaribo/Original Prusa i3/g" $SCRIPT_PATH/lang/lang_en_es.txt
	sed -i -e "s/Zaribo/Original Prusa i3/g" $SCRIPT_PATH/lang/lang_en_fr.txt
	sed -i -e "s/Zaribo/Original Prusa i3/g" $SCRIPT_PATH/lang/lang_en_it.txt
	sed -i -e "s/Zaribo/Original Prusa i3/g" $SCRIPT_PATH/lang/lang_en_nl.txt
	sed -i -e "s/Zaribo/Original Prusa i3/g" $SCRIPT_PATH/lang/lang_en_pl.txt
