#!/usr/bin/env bash

#ibtool="/Applications/Xcode.app/Contents/Developer/usr/bin/ibtool"
#parameters="--errors --warnings --notices --output-format human-readable-text"
#sdkPath="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS8.3.sdk/"

ibtool="$1"
sdkPath="$2"
name="$3"
outputDir="$4"
parameters="$5"


$ibtool $parameters --compile $outputDir/$name.nib $outputDir/$name.xib --sdk $sdkPath

echo "error code: "$?