/datum/gear/utility
	display_name = "clipboard"
	path = /obj/item/clipboard
	sort_category = "Utility"

/datum/gear/utility/briefcase
	display_name = "briefcase selection"
	description = "A selection of briefcases."
	path = /obj/item/storage/briefcase

/datum/gear/utility/briefcase/New()
	..()
	var/briefcases = list()
	briefcases["brown briefcase"] = /obj/item/storage/briefcase
	briefcases["black briefcase"] = /obj/item/storage/briefcase/black
	briefcases["metal briefcase"] = /obj/item/storage/briefcase/aluminium
	briefcases["NT briefcase"] = /obj/item/storage/briefcase/nt
	gear_tweaks += new/datum/gear_tweak/path(briefcases)

/datum/gear/utility/secure
	display_name = "secure briefcase"
	path = /obj/item/storage/secure/briefcase
	cost = 2

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

/datum/gear/utility/fountainpen
	display_name = "fountain pen selection"
	description = "A selection of fountain pens."
	path = /obj/item/pen/fountain
	cost = 1

/datum/gear/utility/fountainpen/New()
	..()
	var/fountainpens = list()
	fountainpens["black fountain pen"] = /obj/item/pen/fountain/black
	fountainpens["grey fountain pen"] = /obj/item/pen/fountain
	fountainpens["silver fountain pen"] = /obj/item/pen/fountain/silver
	fountainpens["white fountain pen"] = /obj/item/pen/fountain/white
	gear_tweaks += new/datum/gear_tweak/path(fountainpens)

/datum/gear/utility/hearing_aid
	display_name = "hearing aid selection"
	path = /obj/item/device/hearing_aid
	cost = 1

/datum/gear/utility/hearing_aid/New()
	..()
	var/hearingaids = list()
	hearingaids["hearing aid, skrell design"] = /obj/item/device/hearing_aid
	hearingaids["hearing aid, human design"] = /obj/item/device/hearing_aid/human
	gear_tweaks += new/datum/gear_tweak/path(hearingaids)

/datum/gear/utility/paicard
	display_name = "personal AI device"
	path = /obj/item/device/paicard

/datum/gear/utility/laptop
	display_name = "laptop"
	path = /obj/item/modular_computer/laptop/preset
	cost = 3

/datum/gear/utility/wallet
	display_name = "wallet, orange"
	path = /obj/item/storage/wallet

/datum/gear/utility/wallet_colourable
	display_name = "wallet, colourable"
	path = /obj/item/storage/wallet/colourable

/datum/gear/utility/wallet_colourable/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/utility/wallet_purse
	display_name = "wallet, purse"
	path = /obj/item/storage/wallet/purse

/datum/gear/utility/wallet_purse/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/utility/lanyard
	display_name = "lanyard"
	path = /obj/item/storage/wallet/lanyard

/datum/gear/utility/lanyard/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

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
	path = /obj/item/storage/belt/fannypack

/datum/gear/utility/fannypack/New()
	..()
	var/list/fannys = list()
	for(var/fanny in typesof(/obj/item/storage/belt/fannypack))
		var/obj/item/storage/belt/fannypack/fanny_type = fanny
		fannys[initial(fanny_type.name)] = fanny_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(fannys))

/datum/gear/utility/toolbelt_alt
	display_name = "tool-belt, alt"
	cost = 0
	path = /obj/item/storage/belt/utility/alt

/datum/gear/utility/guns
	display_name = "sidearms"
	description = "A selection of sidearms."
	path = /obj/item/gun

/datum/gear/utility/guns/New()
	..()
	var/guns = list()
	guns["vintage .45 pistol"] = /obj/item/gun/projectile/colt
	guns[".45 pistol"] = /obj/item/gun/projectile/sec/lethal
	guns["9mm pistol"] = /obj/item/gun/projectile/pistol
	guns["service pistol"] = /obj/item/gun/projectile/pistol/sol
	guns["adhomian service pistol"] = /obj/item/gun/projectile/pistol/adhomai
	guns["revolver"] = /obj/item/gun/projectile/revolver/detective
	guns["adhomian service revolver"] = /obj/item/gun/projectile/revolver/adhomian
	guns["blaster pistol"] = /obj/item/gun/energy/blaster
	guns["blaster revolver"] = /obj/item/gun/energy/blaster/revolver
	guns["energy pistol"] = /obj/item/gun/energy/pistol
	guns["hegemony energy pistol"] = /obj/item/gun/energy/pistol/hegemony
	guns["taser gun"] = /obj/item/gun/energy/taser
	guns["stun revolver"] = /obj/item/gun/energy/stunrevolver
	gear_tweaks += new/datum/gear_tweak/path(guns)

/datum/gear/utility/ammunition1
	display_name = "ammunition one"
	description = "A selection of magazines."
	path = /obj/item/ammo_magazine
	cost = 1

/datum/gear/utility/ammunition1/New()
	..()
	var/ammo1 = list()
	ammo1["magazine (.45)"] = /obj/item/ammo_magazine/c45m
	ammo1["magazine (9mm)"] = /obj/item/ammo_magazine/mc9mm
	ammo1["speed loader (.38)"] = /obj/item/ammo_magazine/c38
	gear_tweaks += new/datum/gear_tweak/path(ammo1)

/datum/gear/utility/ammunition2
	display_name = "ammunition two"
	description = "A selection of magazines."
	path = /obj/item/pen/fountain
	cost = 1

/datum/gear/utility/ammunition2/New()
	..()
	var/ammo2 = list()
	ammo2["magazine (.45)"] = /obj/item/ammo_magazine/c45m
	ammo2["magazine (9mm)"] = /obj/item/ammo_magazine/mc9mm
	ammo2["speed loader (.38)"] = /obj/item/ammo_magazine/c38
	gear_tweaks += new/datum/gear_tweak/path(ammo2)


/datum/gear/utility/melee
	display_name = "melee weapons"
	description = "A selection of melee weapons."
	path = /obj/item

/datum/gear/utility/melee/New()
	..()
	var/melee = list()
	melee["energy utility knife"] = /obj/item/melee/energy/sword/knife
	melee["tactical knife"] = /obj/item/material/knife/tacknife
	melee["trench knife"] = /obj/item/material/knife/trench
	melee["butterfly knife"] = /obj/item/material/knife/butterfly
	melee["switchblade"] = /obj/item/material/knife/butterfly/switchblade
	melee["bat"] = /obj/item/material/twohanded/baseballbat
	melee["duelling knife"] = /obj/item/material/hatchet/unathiknife
	melee["police baton"] = /obj/item/melee/classic_baton
	gear_tweaks += new/datum/gear_tweak/path(melee)