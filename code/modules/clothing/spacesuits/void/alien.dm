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
	desc = "A sleek skrell voidsuit that slightly shimmers as it moves. This one has a Jargon Federation emblem on it."
	icon = 'icons/clothing/kit/skrell_armor.dmi'
	icon_state = "kala_suit"
	item_state = "kala_suit"
	contained_sprite = TRUE
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	species_restricted = list(BODYTYPE_SKRELL)

/obj/item/clothing/head/helmet/space/void/kala
	name = "qukala voidsuit helmet"
	desc = "A sleek skrell voidsuit helmet that slightly shimmers as it moves. This one has a Jargon Federation emblem on it."
	icon = 'icons/clothing/kit/skrell_armor.dmi'
	icon_state = "kala_helm"
	item_state = "kala_helm"
	contained_sprite = TRUE
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	species_restricted = list(BODYTYPE_SKRELL)

/obj/item/clothing/suit/space/void/kala/med
	name = "qukala medical voidsuit"
	desc = "A sleek skrell voidsuit that slightly shimmers as it moves. This one has a Jargon Federation emblem on it. This one belongs to a Qukala medic."
	icon_state = "kala_med"
	item_state = "kala_med"

/obj/item/clothing/head/helmet/space/void/kala/med
	name = "qukala medical voidsuit helmet"
	desc = "A sleek skrell voidsuit helmet that slightly shimmers as it moves. This one has a Jargon Federation emblem on it. This one belongs to a Qukala medic."
	icon_state = "kala_helm_med"
	item_state = "kala_helm_med"

/obj/item/clothing/suit/space/void/kala/leader
	name = "qukala leader voidsuit"
	desc = "A sleek skrell voidsuit that slightly shimmers as it moves. This one has a Jargon Federation emblem on it. This one belongs to a Qukala leader."
	icon_state = "kala_leader"
	item_state = "kala_leader"

/obj/item/clothing/head/helmet/space/void/kala/leader
	name = "qukala leader voidsuit helmet"
	desc = "A sleek skrell voidsuit helmet that slightly shimmers as it moves. This one has a Jargon Federation emblem on it. This one belongs to a Qukala leader."
	icon_state = "kala_leader_helm"
	item_state = "kala_leader_helm"

/obj/item/clothing/suit/space/void/kala/engineering
	name = "qukala engineer voidsuit"
	desc = "A sleek skrell voidsuit that slightly shimmers as it moves. This one has a Jargon Federation emblem on it. This one belongs to a Qukala engineer."
	icon_state = "kala_eng"
	item_state = "kala_eng"

/obj/item/clothing/head/helmet/space/void/kala/engineering
	name = "qukala engineer voidsuit helmet"
	desc = "A sleek skrell voidsuit helmet that slightly shimmers as it moves. This one has a Jargon Federation emblem on it. This one belongs to a Qukala engineer."
	icon_state = "kala_helm_eng"
	item_state = "kala_helm_eng"

/obj/item/clothing/suit/space/void/pra
	name = "kosmostrelki voidsuit"
	desc = "A tajaran voidsuit used by the crew of the Republican Orbital Fleet."
	icon_state = "cosmo_suit"
	item_state = "cosmo_suit"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	allowed = list(/obj/item/tank,/obj/item/device/flashlight,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	species_restricted = list(BODYTYPE_TAJARA)
	refittable = FALSE
	desc_fluff = "The People's Republic of Adhomai enjoys having the only militarized spaceships of all the factions on Adhomai. Initially they relied on contracting outside \
	protection from NanoTrasen and the Sol Alliance in order to defend their orbit from raiders. However, the Republican Navy has striven to become independent. With the help of \
	contracted engineers, access to higher education abroad and training from Sol Alliance naval advisers, the People's Republic has been able to commission and crew some of its own \
	ships. The Republican Navy's space-arm primarily conducts counter piracy operations in conjunction with fending off raiders."

/obj/item/clothing/head/helmet/space/void/pra
	name = "kosmostrelki voidsuit helmet"
	desc = "A tajaran helmet used by the crew of the Republican Orbital Fleet."
	icon_state = "cosmo_suit"
	item_state = "cosmo_suit"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	species_restricted = list(BODYTYPE_TAJARA)
	refittable = FALSE
	desc_fluff = "The People's Republic of Adhomai enjoys having the only militarized spaceships of all the factions on Adhomai. Initially they relied on contracting outside \
	protection from NanoTrasen and the Sol Alliance in order to defend their orbit from raiders. However, the Republican Navy has striven to become independent. With the help of \
	contracted engineers, access to higher education abroad and training from Sol Alliance naval advisers, the People's Republic has been able to commission and crew some of its own \
	ships. The Republican Navy's space-arm primarily conducts counter piracy operations in conjunction with fending off raiders."

/obj/item/clothing/head/helmet/space/void/unathi_pirate
	name = "unathi raider helmet"
	desc = "A cheap but effective helmet made to fit with a larger combat assembly."
	icon_state = "rig0-unathipirate"
	item_state = "rig0-unathipirate"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	light_overlay = "helmet_light_dual_low"
	brightness_on = 6
	species_restricted = list(BODYTYPE_UNATHI)
	refittable = FALSE

/obj/item/clothing/suit/space/void/unathi_pirate
	name = "unathi raider voidsuit"
	desc = "A well-balanced combat voidsuit made by and for Unathi. The cheap but effective design makes it a popular choice amongst pirates and the likes."
	icon_state = "rig-unathipirate"
	item_state = "rig-unathipirate"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	allowed = list(/obj/item/gun,/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/material/sword,/obj/item/melee/hammer,/obj/item/melee/energy)
	species_restricted = list(BODYTYPE_UNATHI)
	refittable = FALSE

/obj/item/clothing/head/helmet/space/void/unathi_pirate/captain
	name = "unathi raider captain helmet"
	desc = "A decent helmet made to fit with a larger combat assembly."
	icon_state = "rig0-unathipiratecaptain"
	item_state = "rig0-unathipiratecaptain"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_CARBINE,
		laser = ARMOR_LASER_PISTOL,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)

/obj/item/clothing/suit/space/void/unathi_pirate/captain
	name = "unathi raider captain voidsuit"
	desc = "A well-balanced combat voidsuit made by and for Unathi. This one features several improvements and extra adornments, making it fit for a Captain, or some kind of high-ranking crew member."
	icon_state = "rig-unathipiratecaptain"
	item_state = "rig-unathipiratecaptain"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_CARBINE,
		laser = ARMOR_LASER_PISTOL,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
