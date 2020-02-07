#!/bin/bash

if [ -z "$SCRIPT_PATH" ]; then
	SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
fi

	# Branding
	# set Zaribo url
	sed -i -e 's/"prusa3d.com"/"Zaribo.com"/g' $SCRIPT_PATH/Firmware/ultralcd.cpp
	# set Company name
	sed -i -e 's/"\\n Original Prusa i3\\n   Prusa Research"/"\\n Zaribo Research\\n   and Development"/g' $SCRIPT_PATH/Firmware/Marlin_main.cpp
	# set FRIMWARE_NAME
	sed -i -e 's/"FIRMWARE_NAME:Prusa-Firmware "/"FIRMWARE_NAME:Zaribo-Firmware "/g' $SCRIPT_PATH/Firmware/Marlin_main.cpp
	# set FIRMWARE_URL
	sed -i -e "s/https:\/\/github.com\/prusa3d\/Prusa-Firmware/https:\/\/github.com\/Zaribo\/Zaribo-Firmware/g" $SCRIPT_PATH/Firmware/Marlin_main.cpp
	# set MSG_WIZZARD_WELCOME and WELCOME_MSG
	sed -i -e "s/Original Prusa i3/Zaribo/g" $SCRIPT_PATH/lang/lang_en.txt
	sed -i -e "s/Original Prusa i3/Zaribo/g" $SCRIPT_PATH/lang/lang_en_cz.txt
	sed -i -e "s/Original Prusa i3/Zaribo/g" $SCRIPT_PATH/lang/lang_en_de.txt
	sed -i -e "s/Original Prusa i3/Zaribo/g" $SCRIPT_PATH/lang/lang_en_es.txt
	sed -i -e "s/Original Prusa i3/Zaribo/g" $SCRIPT_PATH/lang/lang_en_fr.txt
	sed -i -e "s/Original Prusa i3/Zaribo/g" $SCRIPT_PATH/lang/lang_en_it.txt
	sed -i -e "s/Original Prusa i3/Zaribo/g" $SCRIPT_PATH/lang/lang_en_nl.txt
	sed -i -e "s/Original Prusa i3/Zaribo/g" $SCRIPT_PATH/lang/lang_en_pl.txt
	# End Branding
