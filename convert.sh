#!/bin/bash

#include config
source ./config

#android drawable folder name
drawable_hdpi="drawable-hdpi"
drawable_xhdpi="drawable-xhdpi"
drawable_xxhdpi="drawable-xxhdpi"

#regular expression
regular_two="@2x."
regular_three="@3x."

#check if the file is try to convert,default 0 (no)
can_file_convert=0

#the bumber of the image suffix
image_suffix_num=0

createAndroidDrawableFolder(){
	mkdir -p $drawable_hdpi
	mkdir -p $drawable_xhdpi
	mkdir -p $drawable_xxhdpi
}

moveFile(){
	#get the source image path
	source_image_name=${1##*/}
	#get the dest image name
	dest_image_name=${source_image_name//@2x/}
	dest_image_name=${dest_image_name//@3x/}
	expect_image_name=""
	for (( i=0; i<${#dest_image_name}; i++ ))
	do
		c=${dest_image_name:$i:1}
		if [[ "$c" =~ [A-Z] ]]
		then
			c=$(echo $c | tr '[A-Z]' '[a-z]')
			c="_"$c
		fi
		expect_image_name=$expect_image_name$c
	done
	#remove and rename
	if [ $2 == 1 ]
	then
		#move image to speccail android drawable folder	
		mv -f -- "$1" "$drawable_hdpi"
		#rename file
		mv -f -- "$drawable_hdpi/$source_image_name" "$drawable_hdpi/$expect_image_name"
	elif [ $2 == 2 ]
	then
		#move image to speccail android drawable folder
		mv -f -- "$1" "$drawable_xhdpi"
		#rename file
		mv -f -- "$drawable_xhdpi/$source_image_name" "$drawable_xhdpi/$expect_image_name"
	else
		#move image to speccail android drawable folder
		mv -f -- "$1" "$drawable_xxhdpi"
		#rename file
		mv -f -- "$drawable_xxhdpi/$source_image_name" "$drawable_xxhdpi/$expect_image_name"
	fi
}

checkFile(){
	i=0
	while(($i < $image_suffix_num ))
	do
		if [[ "$1" =~ "${image_suffix[$i]}" ]]
		then
			can_file_convert=1
			break
		else
			can_file_convert=0
			break
		fi
		let "i++"
	done
}

startConvert(){
	if [ -d "$ios_icon_directory" ]
	then
		if [ "$(ls $ios_icon_directory)" ]
		then
			#create android specail folder
			createAndroidDrawableFolder
			#loop all file	
			for file in "$ios_icon_directory"/*
			do
				checkFile "$file"
				if [ $can_file_convert == 1 ]
				then
					if [[ "$file" =~ "$regular_two" ]]
					then
						moveFile "$file" 2
					elif [[ "$file" =~ "$regular_three" ]]
					then
						moveFile "$file" 3
					else
						moveFile "$file" 1
					fi	
				fi
			done
		else
			echo "empty ios icon directory : $ios_icon_directory"
		fi
	else
		echo "no such ios icon directory : $ios_icon_directory , please check the config file [ios_icon_directory]"
	fi	
}

initConfig(){
	#init absolute android drawable path
	drawable_hdpi=$android_drawable_directory/$drawable_hdpi
	drawable_xhdpi=$android_drawable_directory/$drawable_xhdpi
	drawable_xxhdpi=$android_drawable_directory/$drawable_xxhdpi
	image_suffix_num=${#image_suffix[@]}
}

main(){
	initConfig
	startConvert
}

main
