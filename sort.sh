#!/bin/bash

##################################################################
# This script sorts generated Zaribo hex files in differnt folders
#
# You can add two arguments <Start_path> <Destiontion_Path>
# <Start_path> defines to folder to be searched
# <Destination_Path> defines the folder where the files will be placed
#
# Example: ./sort.sh ./FW381-Build2869 ../Firmware-381-Build2869
#          The script will search the files in ./FW381-Build2869 and copy them to the destination ../Firmware-381-Build2869
# 
# V1.1
# 
# Change log
# 17 Dec 2019, 3d-gussner, Initial version
# 18 Dec 2019, 3d-gussner, add arguments $1 = Start path and $2 Destination path
#
# Folder tree:
# Zaribo_MK25
# ├── 220
# │   └── BONDTECH
# │       ├── E3DV6
# │       ├── MOSQUITO
# │       └── MOSQUITO_MAGNUM
# ├── 320
# │   └── BONDTECH
# │       ├── E3DV6
# │       ├── MOSQUITO
# │       └── MOSQUITO_MAGNUM
# └── 420
#     └── BONDTECH
#         ├── E3DV6
#         ├── MOSQUITO
#         └── MOSQUITO_MAGNUM
# Zaribo_MK25S
# ├── 220
# │   └── BONDTECH
# │       ├── E3DV6
# │       ├── MOSQUITO
# │       └── MOSQUITO_MAGNUM
# ├── 320
# │   └── BONDTECH
# │       ├── E3DV6
# │       ├── MOSQUITO
# │       └── MOSQUITO_MAGNUM
# └── 420
#     └── BONDTECH
#         ├── E3DV6
#         ├── MOSQUITO
#         └── MOSQUITO_MAGNUM
# Zaribo_MK3
# ├── 220
# │   └── BONDTECH
# │       ├── E3DV6
# │       ├── MOSQUITO
# │       └── MOSQUITO_MAGNUM
# ├── 320
# │   └── BONDTECH
# │       ├── E3DV6
# │       ├── MOSQUITO
# │       └── MOSQUITO_MAGNUM
# └── 420
#     └── BONDTECH
#         ├── E3DV6
#         ├── MOSQUITO
#         └── MOSQUITO_MAGNUM
# Zaribo_MK3S
# ├── 220
# │   └── BONDTECH
# │       ├── E3DV6
# │       ├── MOSQUITO
# │       └── MOSQUITO_MAGNUM
# ├── 320
# │   └── BONDTECH
# │       ├── E3DV6
# │       ├── MOSQUITO
# │       └── MOSQUITO_MAGNUM
# └── 420
#     └── BONDTECH
#         ├── E3DV6
#         ├── MOSQUITO
#         └── MOSQUITO_MAGNUM


# Set arrays for script
# Array of printer types
declare -a TypesArray=( MK3S MK3 MK25S MK25 )
# Array of printer heights
declare -a HeightsArray=( 220 320 420)
# Array of Bondtech folder names
declare -a BondtechArray=( E3DV6 MOSQUITO MOSQUITO_MAGNUM )
# End of set arrays


# Main script

if [ -z "$1" ] ; then
	Start_Path="."
else
	Start_Path=$1
fi

if [ -z "$2" ] ; then
	Destination_Path="."
else
	Destination_Path=$2
fi

echo "Start Path: "$Start_Path
echo "Dest. Path: "$Destination_Path


# Loop for printer types
for TYPE in ${TypesArray[@]}; do
	# Loop for printer heights
	for HEIGHT in ${HeightsArray[@]}; do
		# Loop for Bondtech types
		for BONDTECH_TYPE in ${BondtechArray[@]}; do
			# Create all directories, see Folder tree above
			mkdir -p $Destination_Path/Zaribo_$TYPE/$HEIGHT/BONDTECH/$BONDTECH_TYPE
			# Link files short names to folder long names
			case $BONDTECH_TYPE in
				E3DV6)
					# For Bondtech E3DV6
					BONDTECH_SHORT='BE'
					# At this moment we don't use another version
					BONDTECH_SHORT2='BE'
				;;
				MOSQUITO)
					# For Bondtech MOSQUITO with E3D thermistor
					BONDTECH_SHORT='BM'
					# For Bondtech MOSQUITO with Slice engineering thermistor
					BONDTECH_SHORT2='BMH'
				;;
				MOSQUITO_MAGNUM)
					# For Bondtech MOSQUITO_MAGNUM with E3D thermistor
					BONDTECH_SHORT='BMM'
					# For Bondtech MOSQUITO_MAGNUM with Slice engineering thermistor
					BONDTECH_SHORT2='BMMH'
				;;
			esac
			# Find all Bondtech hex files and copy them to destination folder sorted by Type, Height and Bontech txpe.
			# BONDTECH_SHORT -> Bondtech folder name
			find -L $Start_Path -name "*$TYPE-$BONDTECH_SHORT-$HEIGHT*" -type f -not -path "$Destination_Path/Zaribo_$TYPE/*" -exec cp {} $Destination_Path/Zaribo_$TYPE/$HEIGHT/BONDTECH/$BONDTECH_TYPE \;
			# Find other Bondtech hex files and copy them to destination folder sorted By Type, Height and Bontech txpe.
			# BONDTECH_SHORT2 -> Bondtech folder name
			find -L $Start_Path -name "*$TYPE-$BONDTECH_SHORT2-$HEIGHT*" -type f -not -path "$Destination_Path/Zaribo_$TYPE/*" -exec cp {} $Destination_Path/Zaribo_$TYPE/$HEIGHT/BONDTECH/$BONDTECH_TYPE \;
			# Find rest hex files and copy them to destination folder sorted by Type and Height
			find -L $Start_Path -name "*$TYPE-$HEIGHT*" -type f -not -path "$Destination_Path/Zaribo_$TYPE/*" -exec cp {} $Destination_Path/Zaribo_$TYPE/$HEIGHT \;
		done
	done
done
