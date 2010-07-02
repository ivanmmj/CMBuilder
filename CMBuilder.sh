#!/bin/bash

VERSION="v2.1-alpha"


# Export to PATH
export PATH=$PATH:~/bin

# Get Working Directory
PWDD=`pwd`


#########################################################
#			Functions			#
#########################################################


# Download with progress bar
dl() {
	wget --progress=bar:force "$1" 2>&1 | zenity --title="File transfer in progress!" --progress --auto-close --auto-kill
}

# Pull Past Settings
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
fi
if [ ! -d ./Source ]
	then
	echo "Cannot cd to Source; directory does not exist."
fi
if [ -e devicelunch ]
	then
	echo "Past settings found."
	source devicelunch
	cd $PWDD
else
	cd $PWDD
	echo "Past settings not found."
fi




# Go to Source directory
SoDir() {
cd $PWDD/Source
}




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
		sudo apt-get update
	else
		echo "At the moment, the auto installer only supports Ubuntu 10.04."
fi
}

# Install Java
installjava() {
	checkubuntu
	sudo apt-get install sun-java6-jdk

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
	which adb &>/dev/null

if [ $? -eq 0 ]
then echo "it exists"
if [ -x $(which adb) ]
then
echo "it is executable"

else
echo "it is *not* executable"
fi

else
echo "Cannot find adb."
echo "Downloading adb..."
dl http://justkitchen.info/CMBuilder/adb
mv ./adb ~/bin/adb
chmod 755 ~/bin/adb  #we dont need to sudo chmod adb
fi
}


required() {
	checkadb
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
	#Check to see if directory has files and thus has already being init.
	SoDir
	if [ $(ls -1A | wc -l) -eq 0 ]
		then
		echo "Source directory empty."
		repo init -u git://github.com/cyanogen/android.git -b froyo
	else
		echo "Preexisting Source found. Ready to sync."
	fi

	
#Sync with Cyanogen's github.
	repo sync
	SoDir
if [ -e vendor/cyanogen/proprietary/RomManager.apk ]
	then
	echo "RomManager found."
	else
	echo "RomManager not found."
	echo "Downloading RomManager..."
	cd $PWDD/Source/vendor/cyanogen
	./get-rommanager
fi
	mainmenu
}

# Extract proprietary bits
startextract() {
	SoDir
	mkdir vendor
	chmod 777 -R vendor
	cd $extract
	./extract-files.sh
	SoDir
	mainmenu
}




# 32b Devices Setup
dream() {
	SoDir
	. build/envsetup.sh
	lunch 16
	echo lunch=16 > devicelunch
	extract=device/htc/dream
	startextract
}

# N1 Devices Setup
n1() {
	SoDir
	. build/envsetup.sh
	lunch 12
	echo lunch=12 > devicelunch
	extract=device/htc/passion
	startextract
}

# Droid Devices Setup
Droid() {
	SoDir
	. build/envsetup.sh
	lunch 15
	echo lunch=15 > devicelunch
	extract=device/motorola/sholes
	startextract
}



#Grab and setup device
device() {
	device=`zenity --title "Cyanogen Builder ${VERSION} by ivanmmj" --text "*** Welcome to ${VERSION} of Cyanogen Builder! ***\n\n          Please select the device you which to build for." --height 380 --width 250 --list --radiolist --column "" --column "    Please Select An 	Option" False "Dream/Sapphire" False "Nexus One" False "Droid"`
	case $device in
	 	"Dream/Sapphire")dream;;
	 	"Nexus One")N1;;
	 	"Droid")Droid;;
	esac
}







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








advanced() {
	advancedopt=`zenity --title "Cyanogen Builder ${VERSION} by ivanmmj" --text "Advanced Menu" --height 380 --width 250 --list --radiolist --column "" --column "Please Select An Option" False "Force JIT" False "Make Clean" False "Make [Force Single Core]" True "Back to Main Menu"`
		case $advancedopt in
			"Force JIT")jit;;
			"Make Clean")makeclean;;
			"Back to Main Menu")mainmenu;;
			"Make [Force Single Core]")makeitsingle;;
		esac
}











# Check to see if JIT if forced. If not, Force.
jit() {

advanced
}



makeclean() {
	SoDir
	make installclean
	make clean
	mainmenu
}


mainmenu() {
	device=`zenity --title "Cyanogen Builder ${VERSION} by ivanmmj" --text "*** Welcome to ${VERSION} of Cyanogen Builder! ***\n\nPlease select from the following list of actions." --height 380 --width 250 --list --radiolist --column "" --column "    Please Select An Option" False "Setup required files" True "Download/Update Source" False "Setup Device Configuration" False "Build" False "Advanced Functions" False "Exit"`
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









