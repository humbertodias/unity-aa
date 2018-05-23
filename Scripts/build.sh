#! /bin/sh

export JAVA_HOME=$(/usr/libexec/java_home)
export ANDROID_HOME=/usr/local/share/android-sdk
export ANDROID_SDK_ROOT=/usr/local/share/android-sdk

echo "ANDROID_SDK_HOME: $ANDROID_SDK_HOME"
echo "JDK_HOME: $JDK_HOME"

project="unity-aa"

echo "Attempting to build $project for OS X"
/Applications/Unity/Unity.app/Contents/MacOS/Unity \
  -batchmode \
  -nographics \
  -silent-crashes \
  -logFile $(pwd)/unity.log \
  -projectPath $(pwd) \
  -buildOSXUniversalPlayer "$(pwd)/Build/osx/$project.app" \
  -quit

echo "Attempting to build $project for Linux"
/Applications/Unity/Unity.app/Contents/MacOS/Unity \
  -batchmode \
  -nographics \
  -silent-crashes \
  -logFile $(pwd)/unity.log \
  -projectPath $(pwd) \
  -buildLinuxUniversalPlayer "$(pwd)/Build/linux/$project.exe" \
  -quit

echo "Attempting to build $project for Windows"
/Applications/Unity/Unity.app/Contents/MacOS/Unity \
  -batchmode \
  -nographics \
  -silent-crashes \
  -logFile $(pwd)/unity.log \
  -projectPath $(pwd) \
  -buildWindowsPlayer "$(pwd)/Build/windows/$project.exe" \
  -quit

echo "Attempting to build $project for WebGL"
/Applications/Unity/Unity.app/Contents/MacOS/Unity \
  -batchmode \
  -nographics \
  -silent-crashes \
  -logFile $(pwd)/unity.log \
  -projectPath $(pwd) \
  -executeMethod PerformBuild.CommandLineBuildWebGL \
  +buildlocation "$(pwd)/Build/webgl/$project" \
  -quit

echo "Attempting to build $project for Android"
#mkdir -p $(pwd)/Build/android
/Applications/Unity/Unity.app/Contents/MacOS/Unity \
  -batchmode \
  -nographics \
  -silent-crashes \
  -logFile $(pwd)/unity.log \
  -projectPath $(pwd) \
  -executeMethod PerformBuild.CommandLineBuildAndroid \
  +buildlocation "$(pwd)/Build/android/$project.apk" \
  -quit

:'
echo "Attempting to build $project for iOS"
/Applications/Unity/Unity.app/Contents/MacOS/Unity \
  -batchmode \
  -nographics \
  -silent-crashes \
  -logFile $(pwd)/unity.log \
  -projectPath $(pwd) \
  -executeMethod PerformBuild.CommandLineBuildiOS \
  +buildlocation "$(pwd)/Build/ios/$project.ipa" \
  -quit
'

echo 'Logs from build'
cat $(pwd)/unity.log

echo 'Attempting to zip builds'
pushd $(pwd)/Build
zip -9 -r linux.zip linux/
zip -9 -r mac.zip osx/
zip -9 -r windows.zip windows/
zip -9 -r webgl.zip webgl/
zip -9 -r android.zip android/
#zip -9 -r ios.zip ios/
popd