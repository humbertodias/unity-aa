#! /bin/sh

BASE_URL=http://netstorage.unity3d.com/unity

#HASH=649f48bbbf0f
#VERSION=5.4.1f1

HASH=21ae32b5a9cb
VERSION=2017.4.3f1

#HASH=b8cbb5de9840
#VERSION=2018.1.1f1

download() {
  file=$1
  url="$BASE_URL/$HASH/$package"

  echo "Downloading from $url: "
  curl -o `basename "$package"` "$url"
}

install() {
  package=$1
  download "$package"

  echo "Installing "`basename "$package"`
  sudo installer -dumplog -package `basename "$package"` -target /
}

installNative() {
  package=$1
  brew install $package
}


# See $BASE_URL/$HASH/unity-$VERSION-$PLATFORM.ini for complete list
# of available packages, where PLATFORM is `osx` or `win`

# http://netstorage.unity3d.com/unity/21ae32b5a9cb/unity-2017.4.3f1-osx.ini 
# http://netstorage.unity3d.com/unity/b8cbb5de9840/unity-2018.1.1f1-osx.ini 

install "MacEditorInstaller/Unity-$VERSION.pkg"

# <= 2017
# Desktop
install "MacEditorTargetInstaller/UnitySetup-Windows-Support-for-Editor-$VERSION.pkg"
install "MacEditorTargetInstaller/UnitySetup-Mac-Support-for-Editor-$VERSION.pkg"
install "MacEditorTargetInstaller/UnitySetup-Linux-Support-for-Editor-$VERSION.pkg"

install "MacEditorTargetInstaller/UnitySetup-Mac-IL2CPP-Support-for-Editor-$VERSION.pkg"

# Web
install "MacEditorTargetInstaller/UnitySetup-WebGL-Support-for-Editor-$VERSION.pkg"

# Mobile
#install "MacEditorTargetInstaller/UnitySetup-iOS-Support-for-Editor-$VERSION.pkg"
install "MacEditorTargetInstaller/UnitySetup-Android-Support-for-Editor-$VERSION.pkg"

# Cleanup
rm *.pkg

# Aditionals
installNative gradle

export JAVA_HOME=$(/usr/libexec/java_home)

brew cask install android-sdk;
export ANDROID_HOME=/usr/local/share/android-sdk
export ANDROID_SDK_ROOT=/usr/local/share/android-sdk

brew cask install android-ndk;

export ANDROID_NDK_HOME=/usr/local/share/android-ndk

mkdir "$ANDROID_HOME/licenses";
echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > "$ANDROID_HOME/licenses/android-sdk-license";
echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd" > "$ANDROID_HOME/licenses/android-sdk-preview-license";
echo y | $ANDROID_HOME/tools/bin/sdkmanager "platform-tools";
echo y | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;25.0.2";

gradle -v
java -version
sdkmanager --version

echo "JAVA_HOME=$JAVA_HOME"
echo "ANDROID_HOME=$ANDROID_HOME"