#!/bin/bash

# This script was created by ivanmmj and improved by ivanmmj and jamezelle of xda-developers.com.
# It is a joint effort in making our lives easier, one script at a time...

# Current Contributers:
# ivanmmj of xda-developers.com
# jamezelle of xda-developers.com

VERSION="v3-alpha"

# Export to PATH
export PATH=$PATH:~/bin

# Get Working Directory
PWDD=`pwd`

# Set Function Sources
if [ ! -d scripts ]
	then
	echo "cannot find scripts folder"
fi
if [ ! -e scripts/device ]
	then
	touch ./scripts/device
fi
if [ -e scripts/index.sh ]
	then
	source scripts/index.sh
else
	echo "cannot find ./scripts/index.sh EXITING..."
	sleep 1
	exit
fi

# Make sure folder is created. If not, create.
if [ ! -d ./Source ]
	then
	mkdir ./Source
fi
if [ $? -ne 0 ]
	then
	echo "failed to create the Source directory for an unknown reason"
fi
if [ -d ./Source ] 
	then
	cd Source
else
	echo "Cannot cd to Source; directory does not exist."
	exit
fi





#########################################################
#			Functions			#
#########################################################

# Go to Source directory
SoDir() {
cd $PWDD/Source
}

#########################################################

# Download with progress bar
dl() {
	wget --progress=bar:force "$1" 2>&1 | zenity --title="File transfer in progress!" --progress --auto-close --auto-kill
}

#########################################################

# Check Java Version
checkverjava() {
	REQUIRED_VERSION=sun-java6-jdk
	VERSION=`dpkg --get-selections | awk '/\Winstall/{print $1}' | grep sun-java6-jdk`

	if [ $VERSION = $REQUIRED_VERSION ]
		then
		echo "Required version of Java detected."
	else
		installjava
	fi

}

#########################################################

# Check Ubuntu Version
checkubuntu() {
	source /etc/lsb-release
	currentubu=10.04
	if [ $currentubu -ge $DISTRIB_RELEASE ]; then
		zenity --title "CMBuilder ${VERSION}" --text "The script has detected that you are running Ubuntu 10.04 or higher. Press OK to add the lucid repository required to install Java6." --info
		sudo add-apt-repository ppa:sun-java-community-team/sun-java6
		sudo apt-get update
fi
}

#########################################################

# Install Java
installjava() {
	checkubuntu
	sudo apt-get -y install sun-java6-jdk
}

#########################################################

# Check to see if repo is installed
checkrepo() {
	if [ -e ~/bin/repo ]
		then
		echo "Repo already installed."
	else
		echo "Repo not detected!"
		echo ""
		echo "Installing Repo..."
		echo "Please wait..."
		mkdir ~/bin
		cd ~/bin
		dl http://android.git.kernel.org/repo
		chmod a+x repo
		cd $PWDD
		echo Repo Installed.
		export PATH=$PATH:~/bin
	fi
}

#########################################################

# Check to see if adb is alrady here and executable, if not downaload, chmod and chown it
checkadb() {
	which adb &>/dev/null

if [ $? -eq 0 ]
then echo "it exists"
if [ -x $(which adb) ]
	then
	echo "it is executable"
	ADBOWNER=
	if [ `ls -l $(which adb) | grep root` -eq 1 ] 
		then
		sudo chown root:root `ls $(which adb)`
		if [ `ls -l $(which adb) | grep root` -eq 1 ] 
			then 
			echo "Chowned adb root:root"
		fi
	fi 
else
echo "it is *not* executable"
fi

else
echo "Cannot find adb."
echo "Downloading adb..."
dl http://justkitchen.info/CMBuilder/adb
mv ./adb ~/bin/adb
chmod 755 ~/bin/adb  
sudo chown root:root ~/bin/adb
fi
}

#########################################################

required() {
	checkadb
	checkrepo	
# Install all required "32-bit system" files.
	sudo apt-get -y install git-core gnupg flex bison gperf libsdl-dev libesd0-dev libwxgtk2.6-dev build-essential zip curl libncurses5-dev zlib1g-dev

# Check to see if you have "64-bit system" and installed required files.
	bit=`getconf LONG_BIT`
	if [ $bit = 64 ]; then
		echo "64bit OS installed."
		echo "Installing required files..."
		sudo apt-get -y install ia32-libs  g++-multilib gcc-multilib lib32z1-dev lib32ncurses5-dev libc6-dev-i386 x11proto-core-dev libx11-dev lib32readline5-dev lib32z-dev
	else
		echo "32bit OS installed."
		echo "Nothing else is required."
	fi


# Check to see if Java is installed.
	havejava=`which java`
	if [ $havejava = "/usr/bin/java" ]; then
		echo "Java installed."
		echo "Checking what version you have."
		checkverjava
	else
		echo "Java not detected."
		installjava
	fi

	mainmenu

}

#########################################################

# Set up and download source. If source already synced, sync to the newest version.
DownS() {
	#Check to see if directory has files and thus has already being init.
	SoDir
	if [ $(ls -1A | wc -l) -eq 0 ]
		then
		echo "Source directory empty."
		repo init -u git://github.com/CyanogenMod/android.git -b gingerbread
	else
		echo "Preexisting Source detected. Ready to sync."
	fi

	
#Sync with Cyanogen's github.
	repo sync -j4
	SoDir
if [ -e vendor/cyanogen/proprietary/RomManager.apk ]
	then
	echo "RomManager detected."
	else
	echo "RomManager not detected."
	echo "Downloading RomManager..."
	cd $PWDD/Source/vendor/cyanogen
	./get-rommanager
fi
	mainmenu
}

#########################################################

# Check if device is plugged in.
checkdevice() {
	if [ `adb devices | wc -w` -gt 4 ] 
		then
		echo "Device attatched"
		DEVICEATTATCHED=1
		sleep 1
	elif [ `adb shell | wc -w` -eq 4  ] || [ `adb devices| wc -w` -lt 6 ]
		then
	zenity --title "CMBuilder ${VERSION}" --text "The script has detected that your phone it not attached.\nPlease attach your phone and then press ok." --info 
		echo "Device NOT attatched"
		sleep 1
		DEVICEATTATCHED=0
	fi
}
	
#########################################################

# Extract proprietary bits
startextract() {
	checkdevice
	if [ $DEVICEATTATCHED -eq 1 ]
		then
		SoDir
		mkdir vendor
		chmod 777 -R vendor
		cd $extract
		./extract-files.sh
		SoDir
		mainmenu
	else
		echo "No Device attatched plug in device and start script again."
		mainmenu
	fi
}

#########################################################

#Grab and setup device
device() {
	device=`zenity --title "CMBuilder ${VERSION} by ivanmmj" --text "*** Welcome to ${VERSION} of CMBuilder! ***\n\n          Please select the device you which to build for." --height 380 --width 250 --list --radiolist --column "" --column "    Please Select An 	Option" False "Dream/Sapphire" False "Nexus One" False "Incredible" False "Hero" False "Bravo" False "Espresso" False "Droid" False "Supersonic"`
	case $device in
		
	 	"Dream/Sapphire")cyan-dream;;
		"Incredible")cyan-inc;;
		"Hero")cyan-hero;;
	 	"Nexus One")cyan-n1;;
		"Bravo")cyan-bravo;;
		"Espresso")cyan-espresso;;
	 	"Droid")cyan-droid;;
		"Supersonic")cyan-supersonic;;
	esac
}

#########################################################

makeit() {

SoDir

# Find out how many CPU cores you have
	cores=`grep -c processor /proc/cpuinfo`
	cores=$(( $cores + 1 ))


# Set Java version if installed before make
	sudo update-java-alternatives -s java-6-sun

#Prepare environment
	. build/envsetup.sh
	lunch $lunch

#Make (into a zip)
	make bacon -j$cores | zenity --progress --pulsate --auto-close --width=500 --title="Compiling...";
	mainmenu

}

#########################################################

makeitsingle() {

SoDir

# Set Java version if installed before make
	sudo update-java-alternatives -s java-6-sun

#Prepare environment
	. build/envsetup.sh
	lunch $lunch

#Make (into a zip)
	make bacon | zenity --progress --pulsate --auto-close --width=500 --title="Compiling...";
	mainmenu

}

#########################################################

advanced() {
	advancedopt=`zenity --title "CMBuilder ${VERSION} by ivanmmj" --text "Advanced Menu" --height 380 --width 250 --list --radiolist --column "" --column "Please Select An Option" False "Optimize ROM" False "Make Clean" False "Make [Force Single Core]" True "Back to Main Menu"`
		case $advancedopt in
			"Optimize ROM")opti;;
			"Make Clean")makeclean;;
			"Back to Main Menu")mainmenu;;
			"Make [Force Single Core]")makeitsingle;;
		esac
}

#########################################################

# Optimize ROM.
opti() {
SoDir
cd Source
. vendor/cyanogen/tools/squisher
advanced
}



#########################################################

makeclean() {
	SoDir
	make installclean
	mainmenu
}

#########################################################

mainmenu() {
	device=`zenity --title "CMBuilder ${VERSION} by ivanmmj" --text "*** Welcome to ${VERSION} of CMBuilder! ***\n\nPlease select from the following list of actions." --height 380 --width 250 --list --radiolist --column "" --column "    Please Select An Option" False "Setup required files" True "Download/Update Source" False "Setup Device Configuration" False "Build" False "Advanced Functions" False "Exit"`
		case $device in
		 	"Setup required files")required;;
		 	"Download/Update Source")DownS;;
			"Setup Device Configuration")device;;
		 	"Build")makeit;;
			"Advanced Functions")advanced;;
			"Exit")exit;;
		esac
}



#########################################################
#		     End of Functions			#
#########################################################







mainmenu





