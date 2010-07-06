# 32b Devices Setup
dream() {
	SoDir
	. build/envsetup.sh
	lunch 17
	echo lunch=17 > ../scripts/devicelunch
	extract=device/htc/dream
	startextract
}

# N1 Devices Setup
n1() {
	SoDir
	. build/envsetup.sh
	lunch 12
	echo lunch=12 > ../scripts/devicelunch
	extract=device/htc/passion
	startextract
}

# Droid Devices Setup
Droid() {
	SoDir
	. build/envsetup.sh
	lunch 16
	echo lunch=16 > ../scripts/devicelunch
	extract=device/motorola/sholes
	startextract
}


