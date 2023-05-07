/obj/item/clothing/head/helmet/space/void/kataphract
	name = "kataphract voidsuit helmet"
	desc = "A tough plated helmet with slits for the eyes, emblazoned paint across the top indicates that it belongs to the Kataphracts of the Unathi Izweski Hegemony."
	icon = 'icons/obj/clothing/species/unathi/hats.dmi'
	icon_override = 'icons/mob/species/unathi/helmet.dmi'
	icon_state = "rig0-kataphract"
	item_state = "rig0-kataphract"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_UNATHI)
	refittable = FALSE

/obj/item/clothing/suit/space/void/kataphract
	name = "kataphract voidsuit"
	desc = "A large suit of spaceproof armor, segmented and worked together expertly. Tabs on the shoulders indicate it belongs to the Kataphracts of the Unathi Izweski Hegemony."
	icon = 'icons/obj/clothing/species/unathi/suits.dmi'
	icon_override = 'icons/mob/species/unathi/suit.dmi'
	icon_state = "rig-kataphract"
	item_state = "rig-kataphract"
	slowdown = 1
	w_class = ITEMSIZE_NORMAL
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_UNATHI)
	refittable = FALSE

/obj/item/clothing/head/helmet/space/void/kataphract/spec
	name = "kataphract specialist voidsuit helmet"
	desc = "A tough plated helmet with slits for the eyes, emblazoned paint across the top indicates that it belongs to the Kataphracts of the Unathi Izweski Hegemony. This one has the markings of a Specialist."
	icon_state = "rig0-kataphract-spec"
	item_state = "rig0-kataphract-spec"

/obj/item/clothing/suit/space/void/kataphract/spec
	name = "kataphract specialist voidsuit"
	desc = "A large suit of spaceproof armor, segmented and worked together expertly. Tabs on the shoulders indicate it belongs to the Kataphracts of the Unathi Izweski Hegemony. This one has the markings of a Specialist."
	icon_state = "rig-kataphract-spec"
	item_state = "rig-kataphract-spec"

/obj/item/clothing/head/helmet/space/void/kataphract/lead
	name = "kataphract knight voidsuit helmet"
	desc = "A tough plated helmet with slits for the eyes, emblazoned paint across the top indicates that it belongs to the Kataphracts of the Unathi Izweski Hegemony. This one has the markings of a Knight."
	icon_state = "rig0-kataphract-lead"
	item_state = "rig0-kataphract-lead"

/obj/item/clothing/suit/space/void/kataphract/lead
	name = "kataphract knight voidsuit"
	desc = "A large suit of spaceproof armor, segmented and worked together expertly. Tabs on the shoulders indicate it belongs to the Kataphracts of the Unathi Izweski Hegemony. This one has the markings of a Knight."
	icon_state = "rig-kataphract-lead"
	item_state = "rig-kataphract-lead"

/obj/item/clothing/head/helmet/space/void/unathi_pirate
	name = "unathi raider helmet"
	desc = "A cheap but effective helmet made to fit with a larger combat assembly."
	icon = 'icons/obj/clothing/voidsuit/unathi_pirate.dmi'
	icon_state = "rig0-unathipirate"
	item_state = "rig0-unathipirate"
	contained_sprite = TRUE
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
	icon = 'icons/obj/clothing/voidsuit/unathi_pirate.dmi'
	icon_state = "rig-unathipirate"
	item_state = "rig-unathipirate"
	contained_sprite = TRUE
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

/obj/item/clothing/suit/space/void/hegemony
	name = "hegemony military voidsuit"
	desc = "A Hephaestus-manufactured armoured voidsuit, made for Unathi. The standard spacefaring attire of the Izweski Hegemony Navy."
	icon = 'icons/obj/clothing/voidsuit/hegemony.dmi'
	icon_override = 'icons/mob/species/unathi/suit.dmi'
	icon_state = "hegemony-voidsuit"
	item_state = "hegemony-voidsuit_item"

	w_class = ITEMSIZE_NORMAL
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	allowed = list(/obj/item/gun,/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/material/sword,/obj/item/melee/hammer,/obj/item/melee/energy)
	species_restricted = list(BODYTYPE_UNATHI)
	refittable = FALSE

/obj/item/clothing/head/helmet/space/void/hegemony
	name = "hegemony military helmet"
	desc = "A Hephaestus-manufactured armoured space helmet, made for Unathi. Usually seen on soldiers of the Izweski Hegemony Navy."
	icon = 'icons/obj/clothing/voidsuit/hegemony.dmi'
	icon_override = 'icons/mob/species/unathi/helmet.dmi'
	icon_state = "hegemony-voidhelm"
	item_state = "hegemony-voidhelm_item"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	light_overlay = "helmet_light_dual_low"
	brightness_on = 6
	species_restricted = list(BODYTYPE_UNATHI)
	refittable = FALSE


/obj/item/clothing/suit/space/void/hegemony/specialist
	name = "hegemony specialist voidsuit"
	desc = "A Hephaestus-manufactured armoured voidsuit, made for Unathi. This one bears a green insignia, marking the wearer as a specialist within the Izweski Navy."
	icon_state = "hegemony-voidsuit-spec"
	item_state = "hegemony-voidsuit-spec_item"

/obj/item/clothing/head/helmet/space/void/hegemony/specialist
	name = "hegemony specialist helmet"
	desc = "A Hephaestus-manufactured armoured space helmet, made for Unathi. This one bears a green insignia, marking the wearer as a specialist within the Izweski Navy."
	icon_state = "hegemony-voidhelm-spec"
	item_state = "hegemony-voidhelm-spec_item"

/obj/item/clothing/suit/space/void/hegemony/captain
	name = "hegemony captain's voidsuit"
	desc = "A Hephaestus-manufactured armoured voidsuit, made for Unathi. This one bears a purple insignia, marking the wearer as a captain within the Izweski Navy."
	icon_state = "hegemony-voidsuit-lead"
	item_state = "hegemony-voidsuit-lead_item"

/obj/item/clothing/head/helmet/space/void/hegemony/captain
	name = "hegemony captain's helmet"
	desc = "A Hephaestus-manufactured armoured space helmet, made for Unathi. This one bears a purple insignia, marking the wearer as a captain within the Izweski Navy."
	icon_state = "hegemony-voidhelm-lead"
	item_state = "hegemony-voidhelm-lead_item"

/obj/item/clothing/suit/space/void/hegemony/priest
	name = "hegemony priest's voidsuit"
	desc = "A Hephaestus-manufactured armoured voidsuit, made for Unathi. This one bears a white insignia, marking the wearer as a Sk'akh priest within the Izweski Navy."
	icon_state = "hegemony-voidsuit-priest"
	item_state = "hegemony-voidsuit-priest_item"

/obj/item/clothing/head/helmet/space/void/hegemony/priest
	name = "hegemony priest's helmet"
	desc = "A Hephaestus-manufactured armoured space helmet, made for Unathi. This one bears a purple insignia, marking the wearer as a Sk'akh priest within the Izweski Navy."
	icon_state = "hegemony-voidhelm-priest"
	item_state = "hegemony-voidhelm-priest_item"
