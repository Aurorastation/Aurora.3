//Captain's voidsuit
/obj/item/clothing/head/helmet/space/void/captain
	name = "captain voidsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Only for the most fashionable of military figureheads."
	icon = 'icons/obj/clothing/voidsuit/station/captain.dmi'
	icon_state = "captain_helm"
	item_state = "captain_helm"
	contained_sprite = TRUE
	icon_supported_species_tags = list("skr", "taj", "una", "ipc")
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_PISTOL,
		LASER = ARMOR_LASER_PISTOL,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_RESISTANT,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_RESISTANT
	)
	siemens_coefficient = 0.35
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_IPC, BODYTYPE_UNATHI, BODYTYPE_SKRELL)

/obj/item/clothing/suit/space/void/captain
	name = "captain voidsuit"
	desc = "A bulky, heavy-duty piece of exclusive SCC armor. YOU are in charge!"
	icon = 'icons/obj/clothing/voidsuit/station/captain.dmi'
	icon_state = "captain"
	item_state = "captain"
	contained_sprite = TRUE
	icon_supported_species_tags = list("skr", "taj", "una", "ipc")
	w_class = WEIGHT_CLASS_BULKY
	allowed = list(/obj/item/tank, /obj/item/device/flashlight,/obj/item/gun/energy, /obj/item/gun/projectile, /obj/item/ammo_magazine, /obj/item/ammo_casing, /obj/item/melee/baton,/obj/item/handcuffs)
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_PISTOL,
		LASER = ARMOR_LASER_PISTOL,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_RESISTANT,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_RESISTANT
	)
	siemens_coefficient = 0.35
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_IPC, BODYTYPE_UNATHI, BODYTYPE_SKRELL)
