cyan_ace() {
	SoDir
	cp ./vendor/cyanogen/products/cyanogen_ace.mk ./buildspec.mk	
	. build/envsetup.sh
	lunch 50
	echo lunch=50  > ../scripts/device
	extract=device/htc/ace
	startextract
}

cyan_bravo() {
	SoDir
	cp ./vendor/cyanogen/products/cyanogen_bravo.mk ./buildspec.mk	
	. build/envsetup.sh
	lunch 52
	echo lunch=52  > ../scripts/device
	extract=device/htc/bravo
	startextract
}

cyan_bravoc() {
	SoDir
	cp ./vendor/cyanogen/products/cyanogen_bravoc.mk ./buildspec.mk	
	. build/envsetup.sh
	lunch 53
	echo lunch=53  > ../scripts/device
	extract=device/htc/bravoc
	startextract
}

cyan_buzz() {
	SoDir
	cp ./vendor/cyanogen/products/cyanogen_buzz.mk ./buildspec.mk	
	. build/envsetup.sh
	lunch 54
	echo lunch=54  > ../scripts/device
	extract=device/htc/buzz
	startextract
}

cyan_blade() {
	SoDir
	cp ./vendor/cyanogen/products/cyanogen_blade.mk ./buildspec.mk	
	. build/envsetup.sh
	lunch 51
	echo lunch=51  > ../scripts/device
	extract=device/zte/blade
	startextract
}

cyan_crespo() {
	SoDir
	cp ./vendor/cyanogen/products/cyanogen_crespo.mk ./buildspec.mk	
	. build/envsetup.sh
	lunch 55
	echo lunch=55  > ../scripts/device
	extract=device/bn/encore
	startextract
}
