/datum/gear/utility
	display_name = "clipboard"
	path = /obj/item/weapon/clipboard
	sort_category = "Utility"

/datum/gear/utility/storage
	display_name = "briefcase"
	path = /obj/item/weapon/storage/briefcase
	cost = 2

/datum/gear/utility/storage/secure
	display_name = "secure briefcase"
	path = /obj/item/weapon/storage/secure/briefcase

/datum/gear/utility/clipboard
	display_name = "clipboard"
	path = /obj/item/weapon/clipboard

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

/datum/gear/utility/smallstore
	display_name = "wallet, orange"
	path = 	/obj/item/weapon/storage/wallet
	cost = 3/2 // small storage item

/datum/gear/utility/smallstore/wallet_colourable
	display_name = "wallet, colourable"
	path = /obj/item/weapon/storage/wallet/colourable

/datum/gear/utility/smallstore/wallet_colourable/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/utility/smallstore/wallet_purse
	display_name = "wallet, purse"
	path = /obj/item/weapon/storage/wallet/purse

/datum/gear/utility/smallstore/wallet_purse/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/utility/smallstore/lanyard
	display_name = "lanyard"
	path = /obj/item/weapon/storage/wallet/lanyard

/datum/gear/utility/smallstore/lanyard/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice


/datum/gear/utility/cheaptablet
	display_name = "cheap tablet computer"
	path = /obj/item/modular_computer/tablet/preset/custom_loadout/cheap
	cost = 2 // equivalent to a storage item

/datum/gear/utility/normaltablet
	display_name = "tablet computer"
	path = /obj/item/modular_computer/tablet/preset/custom_loadout/advanced
	cost = 4 // equivalent to two storage items


/datum/gear/utility/recorder
	display_name = "universal recorder"
	path = 	/obj/item/device/taperecorder

/datum/gear/utility/camera
	display_name = "camera"
	path = 	/obj/item/device/camera

/datum/gear/utility/smallstore/fannypack
	display_name = "fannypack selection"
	path = /obj/item/weapon/storage/belt/fannypack

/datum/gear/utility/smallstore/fannypack/New()
	..()
	var/list/fannys = list()
	for(var/fanny in typesof(/obj/item/weapon/storage/belt/fannypack))
		var/obj/item/weapon/storage/belt/fannypack/fanny_type = fanny
		fannys[initial(fanny_type.name)] = fanny_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(fannys))