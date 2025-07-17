//Syndicate rig
/obj/item/clothing/head/helmet/space/void/merc
	name = "blood-red voidsuit helmet"
	desc = "An advanced helmet designed for work in special operations. Property of Hammertail Smiths."
	icon = 'icons/obj/clothing/voidsuit/mercenary.dmi'
	icon_state = "syndie_helm"
	item_state = "syndie_helm"
	contained_sprite = TRUE
	icon_supported_species_tags = list("skr", "taj", "una", "ipc")
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_IPC, BODYTYPE_UNATHI, BODYTYPE_SKRELL)
	armor = list(
		MELEE = ARMOR_MELEE_RESISTANT,
		BULLET = ARMOR_BALLISTIC_MEDIUM,
		LASER = ARMOR_LASER_PISTOL,
		ENERGY = ARMOR_ENERGY_MINOR,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)
	light_overlay = "merc_voidsuit_lights"
	camera = /obj/machinery/camera/network/mercenary
	brightness_on = 6
	light_color = "#ffffff"

/obj/item/clothing/suit/space/void/merc
	name = "blood-red voidsuit"
	desc = "An advanced suit that protects against injuries during special operations. Property of Hammertail Smiths."
	icon = 'icons/obj/clothing/voidsuit/mercenary.dmi'
	icon_state = "syndie"
	item_state = "syndie"
	contained_sprite = TRUE
	icon_supported_species_tags = list("skr", "taj", "una", "ipc")
	slowdown = 1
	w_class = WEIGHT_CLASS_NORMAL
	armor = list(
		MELEE = ARMOR_MELEE_RESISTANT,
		BULLET = ARMOR_BALLISTIC_MEDIUM,
		LASER = ARMOR_LASER_PISTOL,
		ENERGY = ARMOR_ENERGY_MINOR,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SMALL
	)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_SKRELL)
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_IPC, BODYTYPE_UNATHI, BODYTYPE_SKRELL)

/obj/item/clothing/head/helmet/space/void/merc/unathi
	refit_initialize = BODYTYPE_UNATHI

/obj/item/clothing/suit/space/void/merc/unathi
	refit_initialize = BODYTYPE_UNATHI
