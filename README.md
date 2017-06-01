# ios-icon-to-android-drawable

a script try to make the ios icons into special android drawable folder.

## ios icon naming rule

- **Camel-Case** ( cameraPick.png )
- **Special icon suffix** (the following is just sample)

		cameraPick.png    ====>  drawable-hdpi
		cameraPick@2.png  ====>  drawable-xhdpi
		cameraPick@3.png  ====>  drawable-xxhdpi
		cameraPick@4.png  ====>  drawable-xxxhdpi
	
In this README file I use **@{number} as special icon** suffix to define different ios icons,of course
you can use the way you like. Such as **${number}** , **#{number}** and so on,but **make sure you can
find the difference between all icons.**

## How to use

1. `git clone https://github.com/ParadiseHell/ios-icon-to-android-drawable.git`
2. `cd ios-icon-to-android-drawable`
3. `chmod 761 ./convert.sh`
4. **Configuration the config file**
5. **Execute convert:** `./convert.sh`

### How to configuration the config file

- **android_drawable_directory:** the path that contain all android drawable folder(the path is **not required to be existed**)
- **iso_icon_directory:** the path that contain all ios incons(the path is **required to be existed**)
- **image_suffix:** an array that contain all image suffix that you want(**be carefal to add .**)

#### Sample of the config file
```sh
  android_drawable_directory="/home/chengtao/drawable"
  ios_icon_directory="/home/chengtao/iso/icons"
  image_suffix=(".png" ".jpg")
  xhdpi="@2"#you can use your own naming rule
  xxhdpi="@3"#you can use your own naming rule
  xxxhdpi="@4"#you can use your own naming rule
```

## License

	Copyright 2017 ChengTao

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at
		
		http://www.apache.org/licenses/LICENSE-2.0
		
	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
