
rm -rf build

cp build.properties.dist build.properties
perl -pi -e "s|\<replace_with_titanium_home_path\>|$TITANIUM_LOCATION|" build.properties
perl -pi -e "s|\<replace_with_android_sdk_path\>|$ANDROIDSDK_LOCATION|" build.properties
perl -pi -e "s|\<replace_with_android_ndk_path\>|$ANDROIDNDK_LOCATION|" build.properties

ant
