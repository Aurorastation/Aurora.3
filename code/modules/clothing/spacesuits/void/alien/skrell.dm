/obj/item/clothing/head/helmet/space/void/skrell
	name = "skrellian helmet"
	desc = "Smoothly contoured and polished to a shine. Still looks like a fishbowl."
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	species_restricted = list(BODYTYPE_SKRELL,BODYTYPE_HUMAN)
	siemens_coefficient = 0.5
	refittable = FALSE

/obj/item/clothing/head/helmet/space/void/skrell/white
	icon_state = "skrell_helmet_white"

/obj/item/clothing/head/helmet/space/void/skrell/black
	icon_state = "skrell_helmet_black"

/obj/item/clothing/suit/space/void/skrell
	name = "skrellian voidsuit"
	desc = "Seems like a wetsuit with reinforced plating seamlessly attached to it. Very chic."
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/storage/bag/ore,/obj/item/device/t_scanner,/obj/item/pickaxe, /obj/item/rfd/construction)
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	species_restricted = list(BODYTYPE_SKRELL,BODYTYPE_HUMAN)
	siemens_coefficient = 0.5
	refittable = FALSE

/obj/item/clothing/suit/space/void/skrell/white
	icon_state = "skrell_suit_white"
	item_state = "skrell_suit_white"

/obj/item/clothing/suit/space/void/skrell/black
	icon_state = "skrell_suit_black"
	item_state = "skrell_suit_black"

/obj/item/clothing/suit/space/void/kala
	name = "qukala voidsuit"
	desc = "A sleek skrell voidsuit that slightly shimmers as it moves. This one has a Nralakk Federation emblem on it."
	icon = 'icons/clothing/kit/skrell_armor.dmi'
	icon_state = "kala_suit"
	item_state = "kala_suit"
	contained_sprite = TRUE
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	species_restricted = list(BODYTYPE_SKRELL)
	refittable = FALSE

/obj/item/clothing/head/helmet/space/void/kala
	name = "qukala voidsuit helmet"
	desc = "A sleek skrell voidsuit helmet that slightly shimmers as it moves. This one has a Nralakk Federation emblem on it."
	icon = 'icons/clothing/kit/skrell_armor.dmi'
	icon_state = "kala_helm"
	item_state = "kala_helm"
	contained_sprite = TRUE
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	species_restricted = list(BODYTYPE_SKRELL)
	refittable = FALSE

/obj/item/clothing/suit/space/void/kala/med
	name = "qukala medical voidsuit"
	desc = "A sleek skrell voidsuit that slightly shimmers as it moves. This one has a Nralakk Federation emblem on it. This one belongs to a Qukala medic."
	icon_state = "kala_med"
	item_state = "kala_med"

/obj/item/clothing/head/helmet/space/void/kala/med
	name = "qukala medical voidsuit helmet"
	desc = "A sleek skrell voidsuit helmet that slightly shimmers as it moves. This one has a Nralakk Federation emblem on it. This one belongs to a Qukala medic."
	icon_state = "kala_helm_med"
	item_state = "kala_helm_med"

/obj/item/clothing/suit/space/void/kala/leader
	name = "qukala leader voidsuit"
	desc = "A sleek skrell voidsuit that slightly shimmers as it moves. This one has a Nralakk Federation emblem on it. This one belongs to a Qukala leader."
	icon_state = "kala_leader"
	item_state = "kala_leader"

/obj/item/clothing/head/helmet/space/void/kala/leader
	name = "qukala leader voidsuit helmet"
	desc = "A sleek skrell voidsuit helmet that slightly shimmers as it moves. This one has a Nralakk Federation emblem on it. This one belongs to a Qukala leader."
	icon_state = "kala_leader_helm"
	item_state = "kala_leader_helm"

/obj/item/clothing/suit/space/void/kala/engineering
	name = "qukala engineer voidsuit"
	desc = "A sleek skrell voidsuit that slightly shimmers as it moves. This one has a Nralakk Federation emblem on it. This one belongs to a Qukala engineer."
	icon_state = "kala_eng"
	item_state = "kala_eng"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)

/obj/item/clothing/head/helmet/space/void/kala/engineering
	name = "qukala engineer voidsuit helmet"
	desc = "A sleek skrell voidsuit helmet that slightly shimmers as it moves. This one has a Nralakk Federation emblem on it. This one belongs to a Qukala engineer."
	icon_state = "kala_helm_eng"
	item_state = "kala_helm_eng"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
