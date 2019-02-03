# spinnaker-arch
Spinnaker SDK installer for Arch Linux

## Requirements
Requires [yay](https://github.com/Jguer/yay) in order to function 
properly. Installs `ffmpeg-compat` and `debtap` from AUR.

## Installation
Copy the scripts in this repository into the Spinnaker SDK installation 
folder (Spinnaker SDK for Ubuntu 18.04). Then run:

`./install_spinnaker_arch.sh`

It could take a while since `ffmpeg-compat` downloads from a very slow 
server.

Make sure you restart your system after the installation.

## Bugs

It installs `dropbox` and `onlyoffice` as dependencies to SpinView, and 
if you try to remove these packages, it will try removing SpinView as 
well. So just live with it.

## License

Of course I'm not affiliated with FLIR, nor Spinnaker or any other FLIR products. FLIR [may own this](reza.hajianpour@queensu.ca), but until then, this piece of code is licensed as FLIR proprietary license, or any other sharedware-like license they might have.

But please, support more platforms. I'm sick of Ubuntu.
