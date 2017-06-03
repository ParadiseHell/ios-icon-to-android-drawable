#!/bin/bash

#include config
source ./config

#android drawable folder name
drawable_hdpi="drawable-hdpi"
drawable_xhdpi="drawable-xhdpi"
drawable_xxhdpi="drawable-xxhdpi"
drawable_xxxhdpi="drawable-xxxhdpi"

#check if the file is try to convert,default 0 (no)
can_file_convert=0

#the bumber of the image suffix
image_suffix_num=0

#define drawable category
has_x=0
has_xx=0
has_xxx=0

#ios ico naming rule,default 1 (lower camel came)
current_naming_rule=1

#expect image name that android drawable need
expect_image_name=""

createAndroidDrawableFolder(){
	mkdir -p $drawable_hdpi
	if [[ $has_x == 1 ]]
	then
		mkdir -p $drawable_xhdpi
	fi
	if [[ $has_xx == 1 ]]
	then
		mkdir -p $drawable_xxhdpi
	fi
	if [[ $has_xxx == 1 ]]
	then
		mkdir -p $drawable_xxxhdpi
	fi
}

getExpectImageName(){
	#remove all unnecessary string
	dest_image_name=$1
	dest_image_name=${dest_image_name//$xhdpi/}
	dest_image_name=${dest_image_name//$xxhdpi/}
	dest_image_name=${dest_image_name//$xxxhdpi/}
	dest_image_name=${dest_image_name// /}
	#get the expect image name
	expect_image_name=""
	if [[ $current_naming_rule == 1 || $current_naming_rule == 2 || $current_naming_rule == 3 ]]	
	then	
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
	else
		expect_image_name=${dest_image_name//-/_}
	fi
	if [[ $current_naming_rule == 2 || $current_naming_rule == 3 ]]
	then
		expect_image_name=${expect_image_name#*_}
	fi	
}


moveFile(){
	#get the source image path
	source_image_name=${1##*/}
	#get expect image name
	getExpectImageName "$source_image_name"
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
	elif [ $2 == 3 ]
	then
		#move image to speccail android drawable folder
		mv -f -- "$1" "$drawable_xxhdpi"
		#rename file
		mv -f -- "$drawable_xxhdpi/$source_image_name" "$drawable_xxhdpi/$expect_image_name"

	else
		#move image to speccail android drawable folder
		mv -f -- "$1" "$drawable_xxxhdpi"
		#rename file
		mv -f -- "$drawable_xxxhdpi/$source_image_name" "$drawable_xxxhdpi/$expect_image_name"
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
					if [[ $has_x == 1 && "$file" =~ "$xhdpi" ]]
					then
						moveFile "$file" 2
					elif [[ $has_xx == 1 && "$file" =~ "$xxhdpi" ]]
					then
						moveFile "$file" 3
					elif [[ $has_xxx == 1 && "$file" =~ "$xxxhdpi" ]]
					then
						moveFile "$file" 4
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
	drawable_xxxhdpi=$android_drawable_directory/$drawable_xxxhdpi
	image_suffix_num=${#image_suffix[@]}
	
	#xhdpi
	if [[ ! "$xhdpi" == "" ]]
	then
		has_x=1
	fi
	#xxhdpi
	if [[ ! "$xxhdpi" == "" ]]
	then
		has_xx=1
	fi
	#xxxhdpi
	if [[ ! "$xxxhdpi" == "" ]]
	then
		has_xxx=1
	fi

	#naming rule
	if [[ ! $naming_rule == "" && $naming_rule > 0 && $naming_rule < 5 ]]
	then
		current_naming_rule=$naming_rule
	fi
}

main(){
	initConfig
	startConvert
}

main
