/*************
* Ammunition *
*************/
/datum/uplink_item/item/ammo
	telecrystal_cost = 1
	category = /datum/uplink_category/ammunition

/datum/uplink_item/item/ammo/mc9mm
	name = "9mm Magazine"
	path = /obj/item/ammo_magazine/mc9mm
	desc = "Contains twelve rounds of 9mm bullets."

/datum/uplink_item/item/ammo/mc9mm/polymer
	name = "AP 9mm Magazine"
	path = /obj/item/ammo_magazine/mc9mm/polymer
	desc = "Contains twelve rounds of armor-piercing 9mm bullets."

/datum/uplink_item/item/ammo/darts
	name = "Chemical Darts"
	path = /obj/item/ammo_magazine/chemdart
	desc = "Contains five chemical darts for use with a dart gun."

/datum/uplink_item/item/ammo/fourty_five
	name = ".45 Pistol Magazine"
	path = /obj/item/ammo_magazine/c45m
	desc = "Contains nine rounds of .45 bullets."

/datum/uplink_item/item/ammo/submachinegundrum
	name = "Submachine Gun Drum Magazine (.45)"
	telecrystal_cost = 2
	path = /obj/item/ammo_magazine/submachinedrum
	desc = "Contains fifty rounds of .45 bullets, for use with the vintage submachine gun."

/datum/uplink_item/item/ammo/submachinegunmag
	name = "Submachine Gun Magazine (.45)"
	path = /obj/item/ammo_magazine/submachinemag
	desc = "Contains twenty rounds of .45 bullets, for use with the vintage submachine gun."

/datum/uplink_item/item/ammo/submachinegunmag/assassin
	name = "Submachine Gun Magazine (6mm)"
	path = /obj/item/ammo_magazine/submachinemag/assassin
	desc = "Contains thirty rounds of 6mm caseless ammo. Used by the integrally suppressed machine pistol."

/datum/uplink_item/item/ammo/a357
	name = ".357 Speedloader"
	path = /obj/item/ammo_magazine/a357
	desc = "Contains eight rounds of .357 bullets."

/datum/uplink_item/item/ammo/c38
	name = ".38 Speedloader"
	path = /obj/item/ammo_magazine/c38
	desc = "Contains six rounds of .38 bullets."

/datum/uplink_item/item/ammo/c38/haywire
	name = ".38 Speedloader (Haywire)"
	telecrystal_cost = 2
	path = /obj/item/ammo_magazine/c38/emp
	desc = "Contains six rounds of .38 haywire bullets."

/datum/uplink_item/item/ammo/shotgun_shells
	name = "Box of Shells"
	path = /obj/item/storage/box/shotgunshells
	desc = "Contains eight shotgun buckshot shells."

/datum/uplink_item/item/ammo/government
	name = "Box of .45-70 Govt. ammo"
	telecrystal_cost = 2
	path = /obj/item/storage/box/governmentammo
	desc = "Contains eight .45-70 Govt. bullets."

/datum/uplink_item/item/ammo/plasma_mag
	name = "Plasma Shotgun Magazine"
	telecrystal_cost = 2
	path = /obj/item/ammo_magazine/plasma
	desc = "Contains ten plasma cells."

/datum/uplink_item/item/ammo/rifle_mag
	name = "7.62mm clip"
	path = /obj/item/ammo_magazine/boltaction
	desc = "Contains five rounds of 7.62mm bullets."

/datum/uplink_item/item/ammo/carbine_mag
	name = "5.56 carbine magazine"
	telecrystal_cost = 1
	path = /obj/item/ammo_magazine/a556/carbine
	desc = "Contains 15 rounds of 5.56."

/datum/uplink_item/item/ammo/lmg_drum
	name = "7.62 LMG drum"
	telecrystal_cost = 5
	path = /obj/item/ammo_magazine/a762
	desc = "Contains 50 rounds of 7.62."

/datum/uplink_item/item/ammo/peac
	name = "Anti-materiel Cannon Cartridge"
	path = /obj/item/ammo_casing/peac
	desc = "Contains one AP anti-materiel cannon cartridge."

/datum/uplink_item/item/ammo/peac/he
	name = "HE Anti-materiel Cannon Cartridge"
	telecrystal_cost = 2
	path = /obj/item/ammo_casing/peac/he
	desc = "Contains one HE anti-materiel cannon cartridge."

/datum/uplink_item/item/ammo/peac/shrapnel
	name = "Fragmentation Anti-materiel Cannon Cartridge"
	path = /obj/item/ammo_casing/peac/shrapnel
	desc = "Contains one fragmentation anti-materiel cannon cartridge."

/datum/uplink_item/item/ammo/super_heavy
	name = "K2557 Magazine"
	telecrystal_cost = 2
	path = /obj/item/ammo_magazine/super_heavy
	desc = "A spare magazine, for the super heavy K2557 pistol."

/datum/uplink_item/item/ammo/shotgun_slug
	name = "Shotgun Slug"
	telecrystal_cost = 1
	path = /obj/item/ammo_casing/shotgun
	desc = "A shotgun slug."

/datum/uplink_item/item/ammo/tungsten_ammo_box
	name = "Tungsten Ammo Box"
	telecrystal_cost = 2
	path = /obj/item/ammo_magazine/gauss
	desc = "A tungsten ammo box."

/datum/uplink_item/item/ammo/slug_magazine
	name = "Slug Magazine"
	telecrystal_cost = 8
	path = /obj/item/ammo_magazine/assault_shotgun
	desc = "A magazine for an assault shotgun, loaded with slug shells."

/datum/uplink_item/item/ammo/buckshot_magazine
	name = "Buckshot Magazine"
	telecrystal_cost = 4
	path = /obj/item/ammo_magazine/assault_shotgun/shells
	desc = "A magazine for an assault shotgun, loaded with buckshot shells."

/datum/uplink_item/item/ammo/ar_ammo
	name = "7.62 Assault Rifle magazine"
	telecrystal_cost = 2
	path = /obj/item/ammo_magazine/c762
	desc = "A magazine for an assault rifle."

/datum/uplink_item/item/ammo/sniper_ammo
	name = "7.62 Marksman Magazine"
	telecrystal_cost = 4
	path = /obj/item/ammo_magazine/d762
	desc = "A magazine for a 7.62 marksman rifle."

/datum/uplink_item/item/ammo/bullpup_magazine
	name = "5.56 Rifle Magazine"
	telecrystal_cost = 2
	path = /obj/item/ammo_magazine/a556
	desc = "A magazine for a 5.56 rifle."

/datum/uplink_item/item/ammo/uzi_magazine
	name = ".45 Autopistol Magazine"
	telecrystal_cost = 1
	path = /obj/item/ammo_magazine/c45uzi
	desc = "A magazine for a .45 automatic pistol."

/datum/uplink_item/item/ammo/deagle_magazine
	name = ".50 Pistol Magazine"
	telecrystal_cost = 1
	path = /obj/item/ammo_magazine/a50
	desc = "A magazine for a .50 pistol."
