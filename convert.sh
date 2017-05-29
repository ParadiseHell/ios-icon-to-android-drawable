#!/bin/bash

ios_icon_path=""
android_drawable_path=""

#android drawable folder name
drawable_hdpi="drawable-hdpi"
drawable_xhdpi="drawable-xhdpi"
drawable_xxhdpi="drawable-xxhdpi"
#regular expression
regular_two="@2x."
regular_three="@3x."
#file
final_image_path=""

checkAndroidPath(){
	#make android root drawable folder
	if [ -e $android_drawable_path ]
	then
		echo ""	
	else
		mkdir -p $android_drawable_path
	fi
	#make android child drawable folder
	mkdir -p $android_drawable_path/$drawable_hdpi
	mkdir -p $android_drawable_path/$drawable_xhdpi
	mkdir -p $android_drawable_path/$drawable_xxhdpi
	#init drawable folder
	drawable_hdpi=$android_drawable_path/$drawable_hdpi
	drawable_xhdpi=$android_drawable_path/$drawable_xhdpi
	drawable_xxhdpi=$android_drawable_path/$drawable_xxhdpi
}

moveFile(){
	#get the source image path
	source_image_name=${1##*/}
	#get the dest image name
	dest_image_name=${source_image_name// /_}
	dest_image_name=${dest_image_name//@2x/}
	dest_image_name=${dest_image_name//@3x/}
	dest_image_name=$(echo $dest_image_name | tr '[A-Z]' '[a-z]')
	if [ $2 == 1 ]
	then
		#move image to speccail android drawable folder	
		mv -f -- "$1" "$drawable_hdpi"
		#rename file
		mv -- "$drawable_hdpi/$source_image_name" "$drawable_hdpi/$dest_image_name"
	elif [ $2 == 2 ]
	then
		#move image to speccail android drawable folder
		mv -f -- "$1" "$drawable_xhdpi"
		#rename file
		mv -- "$drawable_xhdpi/$source_image_name" "$drawable_xhdpi/$dest_image_name"
	else
		#move image to speccail android drawable folder
		mv -f -- "$1" "$drawable_xxhdpi"
		#rename file
		mv -- "$drawable_xxhdpi/$source_image_name" "$drawable_xxhdpi/$dest_image_name"
	fi
}

startConvert(){
	for file in "$ios_icon_path"/*
	do
		if [[ $file =~ $regular_two ]]
		then
			moveFile "$file" 2
		elif [[ $file =~ $regular_three ]]
		then
			moveFile "$file" 3
		else
			moveFile "$file" 1
		fi	
	done 
}

initConfig(){
	ios_icon_path="/home/chengtao/CoresateIcon"
	android_drawable_path="/home/chengtao/CoresateDrawable"
}

main(){
	initConfig
	checkAndroidPath
	startConvert
}

main
