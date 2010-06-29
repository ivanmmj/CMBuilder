#!/bin/bash

#last edit June 28th 2010 8pm

VERSION="v2.1-alpha"
export PATH=$PATH:~/bin

# Get Working Directory
PWDD=`pwd`

# Set temporary path to adb
export PATH=$PATH:$PWDD

# Past Settings and get Password for Sudo
if [ ! -d ./Source ]
	then
	mkdir ./Source
fi
if [ $? -ne 0 ]
	then
	echo "failed to create the Source directory for an unknown reason"
fi
cd Source
if [ -e devicelunch ]
	then
	sudo echo "Past settings found."
	source devicelunch
	cd $PWDD
else
	cd $PWDD
	sudo echo "Past settings not found."
fi


#########################################################
#			Functions			#
#########################################################

# Check Java Version
checkverjava() {
	REQUIRED_VERSION=sun-java6-jdk
	VERSION=`dpkg --get-selections | awk '/\Winstall/{print $1}' | grep sun-java6-jdk`

	if [ $VERSION = $REQUIRED_VERSION ]
		then
		echo "Required version of Java found."
	else
		installjava
	fi

}

# Check Ubuntu Version
checkubuntu() {
	source /etc/lsb-release
	currentubu=10.04
	if [ $DISTRIB_RELEASE = $currentubu ]; then
		echo Ubuntu 10.04 found. Adding required repository.
		sudo add-apt-repository "deb http://archive.canonical.com/ lucid partner"
		sudo update
	else
		echo "At the moment, the auto installer only supports Ubuntu 10.04."
fi
}

# Install Java
installjava() {
	checkubuntu
	sudo apt-get install sun-java6-jdk

}

# Download with progress bar
dl() {
	wget --progress=bar:force "$1" 2>&1 | zenity --title="File transfer in progress!" --progress --auto-close --auto-kill
}

# Check to see if repo is installed
checkrepo() {
	if [ -e ~/bin/repo ]
		then
		echo "Repo already installed."
	else
		echo "Repo not found!"
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


checkadb() {
	adbfound=0
	find -name adb | grep "tools"
	if [ $? -eq 0 ]
		then
		export PATH={$PATH:`find -name adb | grep "tools"`} 
	fi
required() {
	checkrepo
	
# Install all required "32-bit system" files.
	sudo apt-get install git-core gnupg flex bison gperf libsdl-dev libesd0-dev libwxgtk2.6-dev build-essential zip curl libncurses5-dev zlib1g-dev

# Check to see if you have "64-bit system" and installed required files.
	bit=`getconf LONG_BIT`
	if [ $bit = 64 ]; then
		echo "64bit OS installed."
		echo "Installing required files..."
		sudo apt-get install ia32-libs  g++-multilib gcc-multilib lib32z1-dev lib32ncurses5-dev libc6-dev-i386 x11proto-core-dev libx11-dev lib32readline5-dev lib32z-dev
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
		echo "Java not found."
		installjava
	fi

	mainmenu

}


DownS() {
	#Check to see if directory already exists and thus is already synced.
	cd $PWDD
	if [ -e Source ]
		then
		echo "Preexisting Source found. Ready to sync."
		Source=1
		cd Source
	else
		echo "Source not found."
		Source=0
	fi
}
#If source does not exist...
	while [ $Source -lt 1 ]; do

#Make and enter directory for source.
		mkdir $PWDD/Source
		cd $PWDD/Source
	
#Set up directory for Sync with Cyanogen's github.
		repo init -u git://github.com/cyanogen/android.git -b froyo
		Source=1
	done
	
#Sync with Cyanogen's github.
	repo sync
	cd ..
	mainmenu
}

# Extract proprietary bits
startextract() {
	cd $PWDD/Source
	mkdir vendor
	chmod 777 -R vendor
	cd $PWDD/Source/$extract
	./extract-files.sh
	cd $PWDD
	cd Source
	mainmenu
}




# 32b Devices Setup
dream() {
cd $PWDD/Source
	. build/envsetup.sh
	lunch 3
	echo TARGET_PRODUCT:=full_dream > buildspec.mk
	echo TARGET_BUILD_VARIANT:=eng >> buildspec.mk
	echo TARGET_BUILD_TYPE:=release >> buildspec.mk
	echo "WITH_JIT:=true" >> buildspec.mk
	echo lunch=3 > devicelunch
	extract=device/htc/dream
	startextract
}

# N1 Devices Setup
n1() {
	cd $PWDD/Source
	. build/envsetup.sh
	lunch 6
	echo TARGET_PRODUCT:=full_passion > buildspec.mk
	echo TARGET_BUILD_VARIANT:=eng >> buildspec.mk
	echo TARGET_BUILD_TYPE:=release >> buildspec.mk
	echo lunch=4 > devicelunch
	extract=device/htc/passion
	startextract
}

# Droid Devices Setup
Droid() {
	cd $PWDD/Source
	. build/envsetup.sh
	lunch 8
	echo TARGET_PRODUCT:=generic_sholes > buildspec.mk
	echo TARGET_BUILD_VARIANT:=eng >> buildspec.mk
	echo TARGET_BUILD_TYPE:=release >> buildspec.mk
	echo lunch=6 > devicelunch
	extract=device/motorola/sholes
	startextract
}



#Grab and setup device
setupdevice() {
	device=`zenity --title "Cyanogen Builder ${VERSION} by ivanmmj" --text "*** Welcome to ${VERSION} of Cyanogen Builder! ***\n\n          Please select the device you which to build for." --height 380 --width 250 --list --radiolist --column "" --column "    Please Select An 	Option" False "Dream/Sapphire" False "Nexus One" False "Droid"`
	case $device in
	 	"Dream/Sapphire")dream;;
	 	"Nexus One")N1;;
	 	"Droid")Droid;;
	esac
}



# Set up your device's vendor tree.
device() {

# Check to see if Source already configured to a device.
if [ -e Source/buildspec.mk ]
	then
	echo "Device found."
	mainmenu
else
	setupdevice
	mainmenu
fi



}



makeit() {

	cd $PWDD/Source

# Find out how many CPU cores you have
	cores=`grep -c processor /proc/cpuinfo`
	cores=$(( $cores + 1 ))


# Set Java version if installed before make
	sudo update-java-alternatives -s java-6-sun

#Prepare environment
	. build/envsetup.sh
	lunch $lunch

#Make (into a zip)
	make otapackage -j$cores
	mainmenu

}


makeclean() {
	cd $PWDD/Source
	make clean
	mainmenu
}


mainmenu() {
	device=`zenity --title "Cyanogen Builder ${VERSION} by ivanmmj" --text "*** Welcome to ${VERSION} of Cyanogen Builder! ***\n\nPlease select from the following list of actions." --height 380 --width 250 --list --radiolist --column "" --column "    Please Select An Option" False "Setup required files" False "Download/Update Source" False "Setup Device Configuration" False "Build" False "Make Clean" False "Exit"`
		case $device in
		 	"Setup required files")required;;
		 	"Download/Update Source")DownS;;
			"Setup Device Configuration")device;;
		 	"Build")makeit;;
			"Make Clean")makeclean;;
			"Exit")exit;;
		esac
}



#########################################################
#		     End of Functions			#
#########################################################







mainmenu









