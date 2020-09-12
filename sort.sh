#!/bin/bash

##################################################################
# This script sorts generated Caribou hex files in differnt folders
#
# You can add two arguments <Start_path> <Destiontion_Path>
# <Start_path> defines to folder to be searched
# <Destination_Path> defines the folder where the files will be placed
#
# Example: ./sort.sh ../PF-build-hex/FW381-Build2869 ../PF-build-hex/Firmware-381-Build2869
#          The script will search the files in ./FW381-Build2869 and copy them to the destination ../Firmware-381-Build2869
# 
# V1.2
# 
# Change log
# 17 Dec 2019, 3d-gussner, Initial version
# 18 Dec 2019, 3d-gussner, add arguments $1 = Start path and $2 Destination path
# 17 May 2020, 3d-gussner, Sorting of stock Prusa + OLED was missing thanks to @n4mb3r0n3
# 09 Sep 2020, 3d-gussner, Rebranding Caribou3d
# 10 Sep 2020, 3d-gussner, fix some sorting issues due to new naming convention
#
# Folder tree:
#.
#├── Caribou220
#│   ├── MK25
#│   │   └── BONDTECH
#│   │       ├── E3DV6
#│   │       ├── MOSQUITO
#│   │       └── MOSQUITO_MAGNUM
#│   ├── MK25S
#│   │   └── BONDTECH
#│   │       ├── E3DV6
#│   │       ├── MOSQUITO
#│   │       └── MOSQUITO_MAGNUM
#│   ├── MK3
#│   │   └── BONDTECH
#│   │       ├── E3DV6
#│   │       ├── MOSQUITO
#│   │       └── MOSQUITO_MAGNUM
#│   └── MK3S
#│       └── BONDTECH
#│           ├── E3DV6
#│           ├── MOSQUITO
#│           └── MOSQUITO_MAGNUM
#├── Caribou320
#│   ├── MK25
#│   │   └── BONDTECH
#│   │       ├── E3DV6
#│   │       ├── MOSQUITO
#│   │       └── MOSQUITO_MAGNUM
#│   ├── MK25S
#│   │   └── BONDTECH
#│   │       ├── E3DV6
#│   │       ├── MOSQUITO
#│   │       └── MOSQUITO_MAGNUM
#│   ├── MK3
#│   │   └── BONDTECH
#│   │       ├── E3DV6
#│   │       ├── MOSQUITO
#│   │       └── MOSQUITO_MAGNUM
#│   └── MK3S
#│       └── BONDTECH
#│           ├── E3DV6
#│           ├── MOSQUITO
#│           └── MOSQUITO_MAGNUM
#├── Caribou420
#│   ├── MK25
#│   │   └── BONDTECH
#│   │       ├── E3DV6
#│   │       ├── MOSQUITO
#│   │       └── MOSQUITO_MAGNUM
#│   ├── MK25S
#│   │   └── BONDTECH
#│   │       ├── E3DV6
#│   │       ├── MOSQUITO
#│   │       └── MOSQUITO_MAGNUM
#│   ├── MK3
#│   │   └── BONDTECH
#│   │       ├── E3DV6
#│   │       ├── MOSQUITO
#│   │       └── MOSQUITO_MAGNUM
#│   └── MK3S
#│       └── BONDTECH
#│           ├── E3DV6
#│           ├── MOSQUITO
#│           └── MOSQUITO_MAGNUM
#└── Prusa210
#    ├── MK25
#    │   └── BONDTECH
#    │       ├── E3DV6
#    │       ├── MOSQUITO
#    │       └── MOSQUITO_MAGNUM
#    ├── MK25S
#    │   └── BONDTECH
#    │       ├── E3DV6
#    │       ├── MOSQUITO
#    │       └── MOSQUITO_MAGNUM
#    ├── MK3
#    │   └── BONDTECH
#    │       ├── E3DV6
#    │       ├── MOSQUITO
#    │       └── MOSQUITO_MAGNUM
#    └── MK3S
#        └── BONDTECH
#            ├── E3DV6
#            ├── MOSQUITO
#            └── MOSQUITO_MAGNUM
#
# Set arrays for script
# Array of companies
declare -a CompanyArray=( "Caribou" "Prusa" )
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
for COMPANY in ${CompanyArray[@]}; do
	echo "Start $COMPANY"
	for TYPE in ${TypesArray[@]}; do
		# Loop for printer heights
		if [ $COMPANY == "Prusa" ]; then
			declare -a HeightsArray=( 210 )
		fi
		for HEIGHT in ${HeightsArray[@]}; do
			# Loop for Bondtech types
			for BONDTECH_TYPE in ${BondtechArray[@]}; do
				# Create all directories, see Folder tree above
				mkdir -p $Destination_Path/$COMPANY$HEIGHT/$TYPE/BONDTECH/$BONDTECH_TYPE
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
				find -L $Start_Path -name "*$COMPANY$HEIGHT-$TYPE-$BONDTECH_SHORT-Build*" -type f -not -path "$Destination_Path/$COMPANY$HEIGHT/$TYPE/*" -exec cp {} $Destination_Path/$COMPANY$HEIGHT/$TYPE/BONDTECH/$BONDTECH_TYPE \;
				# Find other Bondtech hex files and copy them to destination folder sorted By Type, Height and Bontech txpe.
				# BONDTECH_SHORT2 -> Bondtech folder name
				find -L $Start_Path -name "*$COMPANY$HEIGHT-$TYPE-$BONDTECH_SHORT2-Build*" -type f -not -path "$Destination_Path/$COMPANY$HEIGH-$TYPE/*" -exec cp {} $Destination_Path/$COMPANY$HEIGHT/$TYPE/BONDTECH/$BONDTECH_TYPE \;
				# Find rest hex files and copy them to destination folder sorted by Type and Height
				find -L $Start_Path -name "*$COMPANY$HEIGHT-$TYPE-Build*" -type f -not -path "$Destination_Path/$COMPANY$HEIGHT/$TYPE/*" -exec cp {} $Destination_Path/$COMPANY$HEIGHT/$TYPE \;
			done
		done
	done
done
