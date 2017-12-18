/datum/gear/utility
	display_name = "briefcase"
	path = /obj/item/storage/briefcase
	sort_category = "Utility"
	
/datum/gear/utility/secure
	display_name = "secure briefcase"
	path = /obj/item/storage/secure/briefcase
	cost = 2

/datum/gear/utility/clipboard
	display_name = "clipboard"
	path = /obj/item/clipboard

/datum/gear/utility/folder
	display_name = "folders"
	path = /obj/item/folder

/datum/gear/utility/folder/New()
	..()
	var/folders = list()
	folders["blue folder"] = /obj/item/folder/blue
	folders["grey folder"] = /obj/item/folder
	folders["red folder"] = /obj/item/folder/red
	folders["white folder"] = /obj/item/folder/white
	folders["yellow folder"] = /obj/item/folder/yellow
	gear_tweaks += new/datum/gear_tweak/path(folders)

/datum/gear/utility/paicard
	display_name = "personal AI device"
	path = /obj/item/device/paicard

/datum/gear/utility/wallet
	display_name = "wallet"
	path = 	/obj/item/storage/wallet

/*
/datum/gear/utility/cheaptablet
	display_name = "cheap tablet computer"
	path = /obj/item/modular_computer/tablet/preset/custom_loadout/cheap
	cost = 3

/datum/gear/utility/normaltablet
	display_name = "tablet computer"
	path = /obj/item/modular_computer/tablet/preset/custom_loadout/advanced
	cost = 4
*/

/datum/gear/utility/recorder
	display_name = "universal recorder"
	path = 	/obj/item/device/taperecorder

/datum/gear/utility/camera
	display_name = "camera"
	path = 	/obj/item/device/camera
