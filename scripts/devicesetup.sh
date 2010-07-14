# 32b Devices Setup
genericeng() {
	SoDir
	. build/envsetup.sh
	lunch 1
	echo lunch=1  > ../scripts/devicelunch
}

simulator() {
	SoDir
	. build/envsetup.sh
	lunch 2
	echo lunch=2  > ../scripts/devicelunch
}

generic_inc_usr-dbg() {
	SoDir
	. build/envsetup.sh
	lunch 3
	echo lunch=3  > ../scripts/devicelunch
	extract=device/htc/inc
	startextract
}

generic-sholes-usr-dbg() {
	 SoDir
	. build/envsetup.sh
	lunch 4
	echo lunch=4 > ../scripts/devicelunch
	extract=device/motorola/sholes
	startextract
}

# N1 Devices Setup
cyan-n1() {
	SoDir
	. build/envsetup.sh
	lunch 5
	echo lunch=5 > ../scripts/devicelunch
	extract=device/htc/passion
	startextract
}

cyan-inc() {
	SoDir
	. build/envsetup.sh
	lunch 6
	echo lunch=6 > ../scripts/devicelunch
	extract=device/htc/inc
	startextract
}

cyan-hero() {
	SoDir
	. build/envsetup.sh
	lunch 7
	echo lunch=7 > ../scripts/devicelunch
	extract=device/htc/hero
	startextract
}

# Droid Devices Setup
cyan-droid() {
	SoDir
	. build/envsetup.sh
	lunch 8
	echo lunch=8 > ../scripts/devicelunch
	extract=device/motorola/sholes
	startextract
}

cyan-dream() {
	SoDir
	. build/envsetup.sh
	lunch 9
	echo lunch=9 > ../scripts/devicelunch
	extract=device/htc/dream_sapphire
	startextract
}

cyan-bravo() {
	SoDir
	. build/envsetup.sh
	lunch 10
	echo lunch=10 > ../scripts/devicelunch
	extract=device/htc/bravo
	startextract
}
cyan-espresso() {
	SoDir
	. build/envsetup.sh
	lunch 11
	echo lunch=11 > ../scripts/devicelunch
	extract=device/htc/espresso
	startextract
}

cyan-supersonic() {
	SoDir
	. build/envsetup.sh
	lunch 12
	echo lunch=12 > ../scripts/devicelunch
	extract=device/htc/supersonic
	startextract
}


##THESE ARE NO LONGER IN LUNCH MENU
# bravo-eng() {
# 	SoDir
# 	. build/envsetup.sh
# 	lunch 3
# 	echo lunch=3  > ../scripts/devicelunch
# 	extract=device/htc/bravo
# 	startextract
# }
# bravo-usr-dbg() {
# 	SoDir
# 	. build/envsetup.sh
# 	lunch 4
# 	echo lunch=4  > ../scripts/devicelunch
# 	extract=device/htc/bravo
# 	startextract
# }
# 
# full-dream() {
# 	SoDir
# 	. build/envsetup.sh
# 	lunch 5
# 	echo lunch=5  > ../scripts/devicelunch
# 	extract=device/htc/dream_sapphire
# 	startextract
# }
# 
# generic-espresso-usr-dbg() {
# 	SoDir
# 	. build/envsetup.sh
# 	lunch 6
# 	echo lunch=6  > ../scripts/devicelunch
# 	extract=device/htc/espresso
# 	startextract
# }
# 
# full-hero-usr-dbg() {
# 	SoDir
# 	. build/envsetup.sh
# 	lunch 7
# 	echo lunch=7  > ../scripts/devicelunch
# 	extract=device/htc/hero
# 	startextract
# }
# 
# generic-sholes-usr-dbg() {
# 	 SoDir
# 	. build/envsetup.sh
# 	lunch 10
# 	echo lunch=10 > ../scripts/devicelunch
# 	extract=device/motorola/sholes
# 	startextract
# }
# 
# full-passion-usr-dbg() {
# 	SoDir
# 	. build/envsetup.sh
# 	lunch 9
# 	echo lunch=9  > ../scripts/devicelunch
# 	extract=device/htc/passion
# 	startextract
# }
# 




