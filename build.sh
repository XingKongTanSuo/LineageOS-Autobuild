#!/bin/sh
cd LineageOS-Autobuild

# Prepare
sudo apt update
sudo apt install bc bison build-essential ccache curl flex g++-multilib gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5 libncurses5-dev libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev openjdk-8-jdk wget -y
mkdir -p ~/bin
mkdir -p ~/android/lineage
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
git config --global user.email "action@github.com"
git config --global user.name "Github Action"
export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
ccache -M 50G

# Download codes
cd ~/android/lineage
repo init -u https://github.com/LineageOS/android.git -b cm-14.1

echo "======start repo sync======"
repo sync
while [ $? = 1 ]; do
    echo "======sync failed, re-sync again======"
    sleep 3
    repo sync
done

git clone https://github.com/Jakesoso/android_device_oppo_A37.git -b cm14.1-test --depth=1 device/oppo/A37
git clone https://github.com/peasoft/android_vendor_oppo_A37 --depth=1 vendor/oppo/A37

# Build
source build/envsetup.sh
croot
brunch A37
