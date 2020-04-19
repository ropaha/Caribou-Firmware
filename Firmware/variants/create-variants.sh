#!/bin/bash

################################################################################
# Description:
# Creates special variants
# TYPE		= Printer type			: MK25, MK25S, MK3, MK3S
#
# BOARD		= Controller board		: EINSy10a, RAMBo13a
# 
# HEIGHT	= Height of printer		: 210, 220, 320, 420
#
# MOD 		= Modification			: BE   = Bondtech Extruder for Prusa
#                                     BM   = Bondtech Extruder for Prusa with Mosquito Hotend
#                                     BMH  = Bondetch Extruder for Prusa with Mosquito and Slice Hight temp Thermistor
#                                     BMM  = Bondtech Extruder for Prusa with Mosquito Magnum Hotend
#                                     BMMH = Bondetch Extruder for Prusa with Mosquito Magnum and Slice Hight temp Thermistor
# TypesArray is an array of printer types
# HeightsArray is an array of printer hights
# ModArray is an array of printer mods
#
#
# Version 1.0.10
################################################################################
# 3 Jul 2019, vertigo235, Inital varaiants script
# 8 Aug 2019, 3d-gussner, Modified for Zaribo needs
# 14 Sep 2019, 3d-gussner, Added MOD BMSQ and BMSQHT Bondtech Mosquito / High Temperature
# 20 Sep 2019, 3d-gussner, New Naming convention for the variants.
#                          As we just support EINSy10a and RAMBo13a boards
# 01 Oct 2019, 3d-gussner, Fixed MK2.5 issue
# 12 Oct 2019, 3d-gussner, Add OLED display support
# 12 Nov 2019, 3d-gussner, Update Bondtech Extruder variants, as they are longer than Zaribo Extruder
#                          Also implementing Bondtech Mosquito MMU length settings
# 14 Nov 2019, 3d-gussner, Merge OLED as default
# 15 Nov 2019, 3d-gussner, Fix Bondtech Steps on MK25 and MK25s. Thanks to Bernd pointing it out.
# 30 Dec 2019, 3d-gussner, Fix MK2.5 y motor direction
# 08 Feb 2020, 3d-gussner, Add Prusa MK25/s and MK3/s with OLED and with/without Bondtech
# 19 Apr 2020, 3d-gussner, Add #define EXTRUDER_DESIGN R3 in varaiants files for Zaribo, Bear, Bondtech extruder
################################################################################

# Constants
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CURRENTDIR="$( pwd )"
TODAY=$(date +'%Y%m%d')
#

# Set default constants
TYPE="MK3"
MOD=""
BOARD="EINSy10a"
HEIGHT=210
BASE="1_75mm_$TYPE-$BOARD-E3Dv6full.h"
BMGHeightDiff=-3 #Bondtech extruders are bit higher than stock one

# Arrays
declare -a CompanyArray=( "Zaribo" "Prusa" )
declare -a TypesArray=( "MK3" "MK3S" "MK25" "MK25S" )
declare -a HeightsArray=( 220 320 420)
declare -a ModArray=( "BE" "BM" "BMM" "BMH" "BMMH")
#

# Cleanup old Zaribo variants
ls Zaribo*
ls Prusa*
echo " "
echo "Existing Zaribo varaiants will be deleted. Press CRTL+C to stop"
sleep 5
rm Zaribo*
rm Prusa*

##### MK25/MK25S/MK3/MK3S Variants
for COMPANY in ${CompanyArray[@]}; do
	echo "Start $COMPANY"
	for TYPE in ${TypesArray[@]}; do
		echo "Type: $TYPE"
		if [[ "$TYPE" == "MK3" || "$TYPE" == "MK3S" ]]; then
			BOARD="EINSy10a"
		elif [[ $TYPE == "MK25" || $TYPE == "MK25S" ]]; then
			BOARD="RAMBo13a"
		else
			echo "Unsupported controller"
			exit 1
		fi
		BASE="1_75mm_$TYPE-$BOARD-E3Dv6full.h"
		if [ $COMPANY == "Zaribo" ]; then
			declare -a HeightsArray=( 220 320 420)
		elif [ $COMPANY == "Prusa" ]; then
			declare -a HeightsArray=( 210 )
		fi
		for HEIGHT in ${HeightsArray[@]}; do
			VARIANT="$COMPANY-$TYPE-$HEIGHT.h"
			#echo $COMPANY
			#echo $BASE
			#echo $TYPE
			#echo $HEIGHT
			#echo $VARIANT
			#sleep 10
			cp ${BASE} ${VARIANT}
			ls
			# Printer Display Name
			if [ $TYPE == "MK25" ]; then
				PRUSA_TYPE="MK2.5"
			elif [ $TYPE == "MK25S" ]; then
				PRUSA_TYPE="MK2.5S"
			else
				PRUSA_TYPE=$TYPE
			fi
			if [ $COMPANY == "Zaribo" ]; then
				# Modify printer name
				sed -i -e 's/^#define CUSTOM_MENDEL_NAME "Prusa i3 '$PRUSA_TYPE'"*/#define CUSTOM_MENDEL_NAME "'$COMPANY' '$TYPE'-'$HEIGHT'"/g' ${VARIANT}
				# Enable Extruder_Design_R3 for Zaribo
				sed -i -e "s/\/\/#define EXTRUDER_DESIGN_R3*/#define EXTRUDER_DESIGN_R3/g" ${VARIANT}
				# Inverted Y-Motor only for MK3
				if [ $BOARD == "EINSy10a" ]; then
					sed -i -e "s/^#define INVERT_Y_DIR 0*/#define INVERT_Y_DIR 1/g" ${VARIANT}
				fi
				# Printer Height
				sed -i -e "s/^#define Z_MAX_POS 210*/#define Z_MAX_POS ${HEIGHT}/g" ${VARIANT}
				# Disable PSU_Delta
				sed -i -e "s/^#define PSU_Delta*/\/\/#define PSU_Delta/g" ${VARIANT}
			elif [ $COMPANY == "Prusa" ]; then
				# Display Type 
				sed -i -e "s/\/\/#define WEH002004_OLED*/#define WEH002004_OLED/g" ${VARIANT}
			fi
		done
	done
done		
echo "End $COMPANY"

## MODS
echo "Start $COMPANY BE"
MOD="BE" ##Bondtech Prusa Edition Extruder for MK25/MK25S/MK3/MK3S
for COMPANY in ${CompanyArray[@]}; do
	for TYPE in ${TypesArray[@]}; do
		echo "Type: $TYPE Mod: $MOD"
		if [[ "$TYPE" == "MK3" || "$TYPE" == "MK3S" ]]; then
			BOARD="EINSy10a"
		elif [[ $TYPE == "MK25" || $TYPE == "MK25S" ]]; then
			BOARD="RAMBo13a"
		else
			echo "Unsupported controller"
			exit 1
		fi
		if [ $COMPANY == "Zaribo" ]; then
			declare -a HeightsArray=( 220 320 420)
		elif [ $COMPANY == "Prusa" ]; then
			declare -a HeightsArray=( 210 )
		fi
		for HEIGHT in ${HeightsArray[@]}; do
			BASE="$COMPANY-$TYPE-$HEIGHT.h"
			VARIANT="$COMPANY-$TYPE-$MOD-$HEIGHT.h"
			BMGHEIGHT=$(( $HEIGHT + $BMGHeightDiff ))
			#echo $BASE
			#echo $TYPE
			#echo $HEIGHT
			#echo $BMGHEIGHT
			echo $VARIANT
			# Modify printer name
			cp ${BASE} ${VARIANT}
			sed -i -e 's/^#define CUSTOM_MENDEL_NAME "'$COMPANY' '$TYPE'-'$HEIGHT'"*/#define CUSTOM_MENDEL_NAME "'$COMPANY' '$TYPE'-'$MOD'-'$HEIGHT'"/g' ${VARIANT}
			# Enable Extruder_Design_R3 for Zaribo
			sed -i -e "s/\/\/#define EXTRUDER_DESIGN_R3*/#define EXTRUDER_DESIGN_R3/g" ${VARIANT}
			# Printer Height
			sed -i -e "s/^#define Z_MAX_POS ${HEIGHT}*/#define Z_MAX_POS ${BMGHEIGHT}/g" ${VARIANT}
			if [[ "$TYPE" == "MK3" || "$TYPE" == "MK3S" ]]; then
				# E Steps for MK3 and MK3S with Bondetch extruder
				sed -i -e 's/#define DEFAULT_AXIS_STEPS_PER_UNIT   {100,100,3200\/8,280}*/#define DEFAULT_AXIS_STEPS_PER_UNIT   {100,100,3200\/8,415}/' ${VARIANT}
			elif [[ $TYPE == "MK25" || $TYPE == "MK25S" ]]; then
				# E Steps for MK25 and MK25S with Bondetch extruder
				sed -i -e 's/#define DEFAULT_AXIS_STEPS_PER_UNIT   {100,100,3200\/8,133}*/#define DEFAULT_AXIS_STEPS_PER_UNIT   {100,100,3200\/8,415}/' ${VARIANT}
			fi
			# Microsteps
			sed -i -e 's/#define TMC2130_USTEPS_E    32*/#define TMC2130_USTEPS_E    16/' ${VARIANT}
			# Filament Load Distances (BPE gears are farther from the hotend)
			sed -i -e 's/#define FILAMENTCHANGE_FIRSTFEED 70*/#define FILAMENTCHANGE_FIRSTFEED 80/' ${VARIANT}
			sed -i -e 's/#define LOAD_FILAMENT_1 "G1 E70 F400"*/#define LOAD_FILAMENT_1 "G1 E80 F400"/' ${VARIANT}
			sed -i -e 's/#define UNLOAD_FILAMENT_1 "G1 E-80 F7000"*/#define UNLOAD_FILAMENT_1 "G1 E-95 F7000"/' ${VARIANT}
			sed -i -e 's/#define FILAMENTCHANGE_FINALRETRACT -80*/#define FILAMENTCHANGE_FINALRETRACT -95/' ${VARIANT}
			sed -i -e 's/#define FILAMENTCHANGE_FINALFEED 70*/#define FILAMENTCHANGE_FINALFEED 80/' ${VARIANT}
			# Display Type 
			sed -i -e "s/\/\/#define WEH002004_OLED*/#define WEH002004_OLED/g" ${VARIANT}
			# Enable Bondtech E3d MMU settings
			sed -i -e "s/\/\/#define BONDTECH_MK3S*/#define BONDTECH_MK3S/g" ${VARIANT}
		done
	done
done
echo "End $COMPANY BE"

echo "Start $COMPANY BM"
BASE_MOD=BE
MOD="BM" ##Bondtech Prusa Mosquito Edition for MK2.5S and MK3S
declare -a BMArray=( "MK3S" "MK25S")
for COMPANY in ${CompanyArray[@]}; do
	for TYPE in ${BMArray[@]}; do
		echo "Type: $TYPE Base_MOD: $BASE_MOD MOD: $MOD"
		if [[ "$TYPE" == "MK3" || "$TYPE" == "MK3S" ]]; then
			BOARD="EINSy10a"
		elif [[ $TYPE == "MK25" || $TYPE == "MK25S" ]]; then
			BOARD="RAMBo13a"
		else
			echo "Unsupported controller"
			exit 1
		fi
		if [ $COMPANY == "Zaribo" ]; then
			declare -a HeightsArray=( 220 320 420)
		elif [ $COMPANY == "Prusa" ]; then
			declare -a HeightsArray=( 210 )
		fi
		for HEIGHT in ${HeightsArray[@]}; do
			BASE="$COMPANY-$TYPE-$BASE_MOD-$HEIGHT.h"
			VARIANT="$COMPANY-$TYPE-$MOD-$HEIGHT.h"
			#echo $BASE
			#echo $TYPE
			#echo $HEIGHT
			echo $VARIANT
			cp ${BASE} ${VARIANT}
			# Modify printer name
			sed -i -e 's/^#define CUSTOM_MENDEL_NAME "'$COMPANY' '$TYPE'-'$BASE_MOD'-'$HEIGHT'"*/#define CUSTOM_MENDEL_NAME "'$COMPANY' '$TYPE'-'$MOD'-'$HEIGHT'"/g' ${VARIANT}
			# Hotend Type 
			sed -i -e 's/#define NOZZLE_TYPE "E3Dv6full"*/#define NOZZLE_TYPE "Mosquito"/' ${VARIANT}
			# Enable Bondtech Mosquito MMU settings
			sed -i -e "s/#define BONDTECH_MK3S*/\/\/#define BONDTECH_MK3S/g" ${VARIANT}
			sed -i -e "s/\/\/#define BONDTECH_MOSQUITO*/#define BONDTECH_MOSQUITO/g" ${VARIANT}
		done
	done
done
echo "End $COMPANY BM"

echo "Start $COMPANY BMH"
BASE_MOD=BM
MOD="BMH" ##Bondtech Prusa Mosquito Edition for MK2.5S and MK3S with Slice High Temperature Thermistor

for COMPANY in ${CompanyArray[@]}; do
	for TYPE in ${BMArray[@]}; do
		echo "Type: $TYPE Base_MOD: $BASE_MOD MOD: $MOD"
		if [[ "$TYPE" == "MK3" || "$TYPE" == "MK3S" ]]; then
			BOARD="EINSy10a"
		elif [[ $TYPE == "MK25" || $TYPE == "MK25S" ]]; then
			BOARD="RAMBo13a"
		else
			echo "Unsupported controller"
			exit 1
		fi
		if [ $COMPANY == "Zaribo" ]; then
			declare -a HeightsArray=( 220 320 420)
		elif [ $COMPANY == "Prusa" ]; then
			declare -a HeightsArray=( 210 )
		fi
		for HEIGHT in ${HeightsArray[@]}; do
			BASE="$COMPANY-$TYPE-$BASE_MOD-$HEIGHT.h"
			VARIANT="$COMPANY-$TYPE-$MOD-$HEIGHT.h"
			#echo $BASE
			#echo $TYPE
			#echo $HEIGHT
			echo $VARIANT
			cp ${BASE} ${VARIANT}
			# Modify printer name
			sed -i -e 's/^#define CUSTOM_MENDEL_NAME "'$COMPANY' '$TYPE'-'$BASE_MOD'-'$HEIGHT'"*/#define CUSTOM_MENDEL_NAME "'$COMPANY' '$TYPE'-'$MOD'-'$HEIGHT'"/g' ${VARIANT}
			# Enable Slice High Temperature Thermistor
			sed -i -e "s/\/\/#define SLICE_HT_EXTRUDER*/#define SLICE_HT_EXTRUDER/g" ${VARIANT}
			# Change mintemp for Slice High Temperature Thermistor
			sed -i -e "s/#define HEATER_0_MINTEMP 10*/#define HEATER_0_MINTEMP 5/g" ${VARIANT}
		done
	done
done

for TYPE in ${BMQArray[@]}; do
	echo "Type: $TYPE Base_MOD: $BASE_MOD MOD: $MOD"
	if [[ "$TYPE" == "MK3" || "$TYPE" == "MK3S" ]]; then
		BOARD="EINSy10a"
	elif [[ $TYPE == "MK25" || $TYPE == "MK25S" ]]; then
		BOARD="RAMBo13a"
	else
		echo "Unsupported controller"
		exit 1
	fi
	for HEIGHT in ${HeightsArray[@]}; do
		BASE="COMPANY-$TYPE-$BASE_MOD-$HEIGHT.h"
		VARIANT="COMPANY-$TYPE-$MOD-$HEIGHT.h"
		#echo $BASE
		#echo $TYPE
		#echo $HEIGHT
		echo $VARIANT
		cp ${BASE} ${VARIANT}
		# Modify printer name
		sed -i -e 's/^#define CUSTOM_MENDEL_NAME "Zaribo '$TYPE'-'$BASE_MOD'-'$HEIGHT'"*/#define CUSTOM_MENDEL_NAME "Zaribo '$TYPE'-'$MOD'-'$HEIGHT'"/g' ${VARIANT}
		# Enable Slice High Temperature Thermistor
		sed -i -e "s/\/\/#define SLICE_HT_EXTRUDER*/#define SLICE_HT_EXTRUDER/g" ${VARIANT}
		# Change mintemp for Slice High Temperature Thermistor
		sed -i -e "s/#define HEATER_0_MINTEMP 10*/#define HEATER_0_MINTEMP 5/g" ${VARIANT}
	done
done
echo "End $COMPANY BMH"

echo "Start $COMPANY BMM"
BASE_MOD=BM
MOD="BMM" ##Bondtech Prusa Mosquito Magnum Edition for MK2.5S and MK3S
declare -a BMArray=( "MK3S" "MK25S" )
for COMPANY in ${CompanyArray[@]}; do
	for TYPE in ${BMArray[@]}; do
		echo "Type: $TYPE Base_MOD: $BASE_MOD MOD: $MOD"
		if [[ "$TYPE" == "MK3" || "$TYPE" == "MK3S" ]]; then
			BOARD="EINSy10a"
		elif [[ $TYPE == "MK25" || $TYPE == "MK25S" ]]; then
			BOARD="RAMBo13a"
		else
			echo "Unsupported controller"
			exit 1
		fi
		if [ $COMPANY == "Zaribo" ]; then
			declare -a HeightsArray=( 220 320 420)
		elif [ $COMPANY == "Prusa" ]; then
			declare -a HeightsArray=( 210 )
		fi
		for HEIGHT in ${HeightsArray[@]}; do
			BASE="$COMPANY-$TYPE-$BASE_MOD-$HEIGHT.h"
			VARIANT="$COMPANY-$TYPE-$MOD-$HEIGHT.h"
			#echo $BASE
			#echo $TYPE
			#echo $HEIGHT
			echo $VARIANT
			cp ${BASE} ${VARIANT}
			# Modify printer name
			sed -i -e 's/^#define CUSTOM_MENDEL_NAME "'$COMPANY' '$TYPE'-'$BASE_MOD'-'$HEIGHT'"*/#define CUSTOM_MENDEL_NAME "'$COMPANY' '$TYPE'-'$MOD'-'$HEIGHT'"/g' ${VARIANT}
			# Hotend Type 
			sed -i -e 's/#define NOZZLE_TYPE "Mosquito"*/#define NOZZLE_TYPE "Mosquito Magnum"/' ${VARIANT}
			# Enable Bondtech Mosquito MMU settings
			sed -i -e "s/#define BONDTECH_MOSQUITO*/\/\/#define BONDTECH_MOSQUITO/g" ${VARIANT}
			sed -i -e "s/\/\/#define BONDTECH_M_MAGNUM*/#define BONDTECH_M_MAGNUM/g" ${VARIANT}
		done
	done
done
echo "End $COMPANY BMM"

echo "Start $COMPANY BMMH"
BASE_MOD=BMM
MOD="BMMH" ##Bondtech Prusa Mosquito Magnum Edition with Slice High Temperature Thermistor
declare -a BMMArray=( "MK3S" "MK25S" )
for COMPANY in ${CompanyArray[@]}; do
	for TYPE in ${BMMArray[@]}; do
		echo "Type: $TYPE Base_MOD: $BASE_MOD MOD: $MOD"
		if [ "$TYPE" == "MK3S" ]; then
			BOARD="EINSy10a"
		elif [[ $TYPE == "MK25" || $TYPE == "MK25S" ]]; then
			BOARD="RAMBo13a"
		else
			echo "Unsupported controller"
			exit 1
		fi
		if [ $COMPANY == "Zaribo" ]; then
			declare -a HeightsArray=( 220 320 420)
		elif [ $COMPANY == "Prusa" ]; then
			declare -a HeightsArray=( 210 )
		fi
		for HEIGHT in ${HeightsArray[@]}; do
			BASE="$COMPANY-$TYPE-$BASE_MOD-$HEIGHT.h"
			VARIANT="$COMPANY-$TYPE-$MOD-$HEIGHT.h"
			#echo $BASE
			#echo $TYPE
			#echo $HEIGHT
			echo $VARIANT
			cp ${BASE} ${VARIANT}
			sed -i -e 's/^#define CUSTOM_MENDEL_NAME "'$COMPANY' '$TYPE'-'$BASE_MOD'-'$HEIGHT'"*/#define CUSTOM_MENDEL_NAME "'$COMPANY' '$TYPE'-'$MOD'-'$HEIGHT'"/g' ${VARIANT}
			# Enable Slice High Temperature Thermistor
			sed -i -e "s/\/\/#define SLICE_HT_EXTRUDER*/#define SLICE_HT_EXTRUDER/g" ${VARIANT}
			# Change mintemp for Slice High Temperature Thermistor
			sed -i -e "s/#define HEATER_0_MINTEMP 10*/#define HEATER_0_MINTEMP 5/g" ${VARIANT}
		done
	done
done
echo "End $COMPANY BMMH"

