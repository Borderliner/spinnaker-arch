#!/bin/bash

set -o errexit

MY_PROMPT='$ '
MY_YESNO_PROMPT='(y/n)$ '

# version of the software
MAJOR_VERSION=1
MINOR_VERSION=7
RELEASE_TYPE=0
RELEASE_BUILD=6
INFORMATIONAL_VERSION=1.7.0.6
RELEASE_TYPE_TEXT=Release

echo "This is a script to assist with installation of the Spinnaker SDK.";
echo "Would you like to continue and install all the Spinnaker SDK packages?";
echo -n "$MY_YESNO_PROMPT"
read confirm

if [ $confirm = "n" ] || [ $confirm = "N" ] || [ $confirm = "no" ] || [ $confirm = "No" ]
then
    exit 0
    break
fi

echo

echo "Installing dependencies via pacman...";

sudo pacman -Syu
sudo pacman -S --noconfirm libusb gtkmm 

echo "Regenerate Arch Linux packages?";
echo -n "$MY_YESNO_PROMPT"
read regen_confirm

if [ $regen_confirm = "y" ] || [ $regen_confirm = "Y" ] || [ $regen_confirm = "yes" ] || [ $regen_confirm = "Yes" ]; then
    echo "Generating Arch Linux tar.xz packages...";
    yay -S --noconfirm ffmpeg-compat-57 debtap

    for f in *.deb; do
        echo "Converting $f debian package to pacman tar.xz package...";
        debtap -Quiet $f
    done
fi

echo

echo "Installing Spinnaker packages...";

sudo pacman -Syu

echo "Preparing the libraries for installation..."

conflicts=(
    "/usr/lib/libQt5Core.so"
    "/usr/lib/libQt5Core.so.5"
    "/usr/lib/libQt5DBus.so"
    "/usr/lib/libQt5DBus.so.5"
    "/usr/lib/libQt5Gui.so"
    "/usr/lib/libQt5Gui.so.5"
    "/usr/lib/libQt5Network.so"
    "/usr/lib/libQt5Network.so.5"
    "/usr/lib/libQt5OpenGL.so"
    "/usr/lib/libQt5OpenGL.so.5"
    "/usr/lib/libQt5Widgets.so"
    "/usr/lib/libQt5Widgets.so.5"
    "/usr/lib/libQt5XcbQpa.so"
    "/usr/lib/libQt5XcbQpa.so.5"
)

for f in ${conflicts[@]}; do
    if [[ -f $f ]]; then
        sudo mv $f $f.bak
    fi
done

for f in *.pkg.tar.xz; do
    sudo pacman -U --noconfirm $f
    for f in ${conflicts[@]}; do
        sudo rm -f $f
    done
done

for f in ${conflicts[@]}; do
    if [[ -f $f ]]; then
        sudo mv $f.bak $f
    fi
done

# Bring back all the original qt5-base libraries
sudo pacman -S qt5-base

echo "Would you like to add a udev entry to allow access to USB hardware?";
echo "If this is not ran then your cameras may be only accessible by running Spinnaker as sudo.";
echo -n "$MY_YESNO_PROMPT"
read confirm

if [ $confirm = "n" ] || [ $confirm = "N" ] || [ $confirm = "no" ] || [ $confirm = "No" ]
then
    echo "Complete";
    exit 0
    break
fi

echo "Launching conf script";
sudo sh spin-conf-arch

echo "Complete";

# Notify server of a linux installation
# wget -T 10 -q --spider
#
#http://www.ptgrey.com/support/softwarereg.asp?text=ProductName+Linux+Spinnaker+$MAJOR_VERSION%2E$MINOR_VERSION+$RELEASE_TYPE_TEXT+$RELEASE_BUILD+%0D%0AProductVersion+$MAJOR_VERSION%2E$MINOR_VERSION%2E$RELEASE_TYPE%2E$RELEASE_BUILD%0D%0A
#
exit 0
