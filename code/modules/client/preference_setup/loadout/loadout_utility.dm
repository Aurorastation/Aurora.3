/datum/gear/utility
	display_name = "briefcase"
	sort_category = "Utility"
	
/datum/gear/utility/secure
	display_name = "secure briefcase"
	cost = 2

/datum/gear/utility/clipboard
	display_name = "clipboard"

/datum/gear/utility/folder
	display_name = "folders"

/datum/gear/utility/folder/New()
	..()
	var/folders = list()
	gear_tweaks += new/datum/gear_tweak/path(folders)

/datum/gear/utility/paicard
	display_name = "personal AI device"
	path = /obj/item/device/paicard

/datum/gear/utility/wallet
	display_name = "wallet"

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
