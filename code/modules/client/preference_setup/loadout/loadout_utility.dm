/datum/gear/utility
	display_name = "clipboard"
	path = /obj/item/weapon/clipboard
	sort_category = "Utility"

/datum/gear/utility/briefcase
	display_name = "briefcase selection"
	path = /obj/item/weapon/storage/briefcase

/datum/gear/utility/briefcase/New()
	..()
	var/briefcases = list()
	briefcases["brown briefcase"] = /obj/item/weapon/storage/briefcase
	briefcases["black briefcase"] = /obj/item/weapon/storage/briefcase/black
	briefcases["metal briefcase"] = /obj/item/weapon/storage/briefcase/aluminium
	briefcases["NT briefcase"] = /obj/item/weapon/storage/briefcase/nt

/datum/gear/utility/secure
	display_name = "secure briefcase"
	path = /obj/item/weapon/storage/secure/briefcase
	cost = 2

/datum/gear/utility/folder
	display_name = "folders"
	path = /obj/item/weapon/folder

/datum/gear/utility/folder/New()
	..()
	var/folders = list()
	folders["blue folder"] = /obj/item/weapon/folder/blue
	folders["grey folder"] = /obj/item/weapon/folder
	folders["red folder"] = /obj/item/weapon/folder/red
	folders["white folder"] = /obj/item/weapon/folder/white
	folders["yellow folder"] = /obj/item/weapon/folder/yellow
	gear_tweaks += new/datum/gear_tweak/path(folders)

/datum/gear/utility/paicard
	display_name = "personal AI device"
	path = /obj/item/device/paicard

/datum/gear/utility/wallet
	display_name = "wallet"
	path = 	/obj/item/weapon/storage/wallet

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

/datum/gear/utility/fannypack
	display_name = "fannypack selection"
	cost = 2
	path = /obj/item/weapon/storage/belt/fannypack

/datum/gear/utility/fannypack/New()
	..()
	var/list/fannys = list()
	for(var/fanny in typesof(/obj/item/weapon/storage/belt/fannypack))
		var/obj/item/weapon/storage/belt/fannypack/fanny_type = fanny
		fannys[initial(fanny_type.name)] = fanny_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(fannys))