/obj/item/clothing/head/helmet/space/void/kataphract
	name = "kataphract voidsuit helmet"
	desc = "A tough plated helmet with slits for the eyes, emblazoned paint across the top indicates that it belongs to the Kataphracts of the Unathi Izweski Hegemony."
	icon = 'icons/obj/clothing/voidsuit/hegemony.dmi'
	icon_state = "kataphract_helm"
	item_state = "kataphract_helm"
	contained_sprite = TRUE
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
	icon = 'icons/obj/clothing/voidsuit/hegemony.dmi'
	icon_state = "kataphract"
	item_state = "kataphract"
	contained_sprite = TRUE
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
	icon_state = "kataphract-spec_helm"
	item_state = "kataphract-spec_helm"

/obj/item/clothing/suit/space/void/kataphract/spec
	name = "kataphract specialist voidsuit"
	desc = "A large suit of spaceproof armor, segmented and worked together expertly. Tabs on the shoulders indicate it belongs to the Kataphracts of the Unathi Izweski Hegemony. This one has the markings of a Specialist."
	icon_state = "kataphract-spec"
	item_state = "kataphract-spec"

/obj/item/clothing/head/helmet/space/void/kataphract/lead
	name = "kataphract knight voidsuit helmet"
	desc = "A tough plated helmet with slits for the eyes, emblazoned paint across the top indicates that it belongs to the Kataphracts of the Unathi Izweski Hegemony. This one has the markings of a Knight."
	icon_state = "kataphract-lead_helm"
	item_state = "kataphract-lead_helm"

/obj/item/clothing/suit/space/void/kataphract/lead
	name = "kataphract knight voidsuit"
	desc = "A large suit of spaceproof armor, segmented and worked together expertly. Tabs on the shoulders indicate it belongs to the Kataphracts of the Unathi Izweski Hegemony. This one has the markings of a Knight."
	icon_state = "kataphract-lead"
	item_state = "kataphract-lead"

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
	icon_state = "hegemony-voidsuit"
	item_state = "hegemony-voidsuit"

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
	icon_state = "hegemony-voidhelm"
	item_state = "hegemony-voidhelm"
	contained_sprite = TRUE
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
	item_state = "hegemony-voidsuit-spec"

/obj/item/clothing/head/helmet/space/void/hegemony/specialist
	name = "hegemony specialist helmet"
	desc = "A Hephaestus-manufactured armoured space helmet, made for Unathi. This one bears a green insignia, marking the wearer as a specialist within the Izweski Navy."
	icon_state = "hegemony-voidhelm-spec"
	item_state = "hegemony-voidhelm-spec"

/obj/item/clothing/suit/space/void/hegemony/captain
	name = "hegemony captain's voidsuit"
	desc = "A Hephaestus-manufactured armoured voidsuit, made for Unathi. This one bears a purple insignia, marking the wearer as a captain within the Izweski Navy."
	icon_state = "hegemony-voidsuit-lead"
	item_state = "hegemony-voidsuit-lead"

/obj/item/clothing/head/helmet/space/void/hegemony/captain
	name = "hegemony captain's helmet"
	desc = "A Hephaestus-manufactured armoured space helmet, made for Unathi. This one bears a purple insignia, marking the wearer as a captain within the Izweski Navy."
	icon_state = "hegemony-voidhelm-lead"
	item_state = "hegemony-voidhelm-lead"

/obj/item/clothing/suit/space/void/hegemony/priest
	name = "hegemony priest's voidsuit"
	desc = "A Hephaestus-manufactured armoured voidsuit, made for Unathi. This one bears a white insignia, marking the wearer as a Sk'akh priest within the Izweski Navy."
	icon_state = "hegemony-voidsuit-priest"
	item_state = "hegemony-voidsuit-priest"

/obj/item/clothing/head/helmet/space/void/hegemony/priest
	name = "hegemony priest's helmet"
	desc = "A Hephaestus-manufactured armoured space helmet, made for Unathi. This one bears a purple insignia, marking the wearer as a Sk'akh priest within the Izweski Navy."
	icon_state = "hegemony-voidhelm-priest"
	item_state = "hegemony-voidhelm-priest"

/obj/item/clothing/suit/space/void/unathi_pirate/tarwa
	name = "tarwa conglomerate voidsuit"
	desc = "A mishmash of parts taken from Unathi pirate-made raider suits and hardware commonly found in the Southern frontier of the Spur, all held together by Diona bark, a common crafting method among the Unathi fleet of the Tarwa Conglomerate. \
	It's relatively light, and yet appears to protect against a variety of hazards."
	icon_state = "rig-tarwapirate"
	item_state = "rig-tarwapirate"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED //it has diona growing on and in it to absorb rads. if i could make it regenerate breaches that would be neat
	)

/obj/item/clothing/suit/space/void/unathi_pirate/tarwa/captain
	name = "tarwa conglomerate captain's voidsuit"
	desc = "A mishmash of parts taken from Unathi pirate-made raider suits and hardware commonly found in the Southern frontier of the Spur, all held together by Diona bark,  a common crafting method among the Unathi fleet of the Tarwa Conglomerate. \
	It only seems to fit Unathi, it's relatively light, and yet appears to protect against a variety of hazards. This one features various reinforcements, making it probably fit for more important crew."
	icon_state = "rig-tarwacaptain"
	item_state = "rig-tarwacaptain"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_CARBINE,
		laser = ARMOR_LASER_PISTOL,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED //it has diona growing on and in it to absorb rads
	)

/obj/item/clothing/head/helmet/space/void/unathi_pirate/tarwa
	name = "tarwa conglomerate helmet"
	desc = "Metals, electronics and diona bark meet in this strange helmet. Quiet rustling can be heard from within."
	icon_state = "rig-tarwapirate-helmet"
	item_state = "rig-tarwapirate-helmet"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_CARBINE,
		laser = ARMOR_LASER_PISTOL,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED //it has diona growing on and in it to absorb rads
	)
	light_overlay = "helmet_light_green"

/obj/item/clothing/head/helmet/space/void/unathi_pirate/tarwa/captain
	name = "tarwa conglomerate captain's helmet"
	desc = "Metals, electronics and diona bark meet in this strange helmet. Quiet rustling can be heard from within. \
	This one appears to have been reinforced."
	icon_state = "rig-tarwacaptain-helmet"
	item_state = "rig-tarwacaptain-helmet"

/obj/item/clothing/suit/space/void/unathi_pirate/kazu
	name = "techraider voidsuit"
	desc = "This appears to be an Unathi-fitted voidsuit. It has been modified and reinforced with sleeker plates of advanced materials, recognisable to a keen eye as pieces of Solarian and Skrell military-grade suits. It's surprisingly light and quite popular among the members of the Unathi fleet known as Kazu's Techraiders."
	icon_state = "rig-kazupirate"
	item_state = "rig-kazupirate"

/obj/item/clothing/head/helmet/space/void/unathi_pirate/kazu
	name = "techraider helmet"
	desc = "An advanced helmet made to fit in a large assembly. Its multi-optic visor is reminiscent of some Vaurca designs."
	icon_state = "rig-kazupirate-helmet"
	item_state = "rig-kazupirate-helmet"
	light_overlay = "helmet_light_jargon_rig"

/obj/item/clothing/suit/space/void/unathi_pirate/kazu/captain
	name = "techraider captain's voidsuit"
	desc = "This appears to be an Unathi-fitted voidsuit. It has been modified and reinforced with sleeker plates of advanced materials, recognisable to a keen eye as pieces of Solarian and Skrell military-grade suits. It's surprisingly light and quite popular among the members of the Unathi fleet known as Kazu's Techraiders.\
	Various improvements have been made to this specific suit, implying it's probably made for higher-ranking crew."
	icon_state = "rig-kazucaptain"
	item_state = "rig-kazucaptain"

/obj/item/clothing/head/helmet/space/void/unathi_pirate/kazu/captain
	name = "techraider captain's helmet"
	desc = "A reinforced and advanced helmet made to fit in a large assembly. Its multi-optic visor is reminiscent of Vaurca designs."
	icon_state = "rig-kazucaptain-helmet"
	item_state = "rig-kazucaptain-helmet"


/obj/item/clothing/suit/space/void/unathi_pirate/hiskyn
	name = "hiskyn revanchist voidsuit"
	desc = "A bastardized version of an older Dominian voidsuit mixed with parts taken from the infamous Raider suit used by pirate Unathi, popular among members of the Hiskyn Revanchist fleet. The result is a tough and somewhat sluggish suit."
	icon_state = "rig-hiskynpirate"
	item_state = "rig-hiskynpirate"

/obj/item/clothing/head/helmet/space/void/unathi_pirate/hiskyn
	name = "hiskyn revanchist helmet"
	desc = "A mix of older Dominian and homemade Unathi pirate hardware in a single helmet; made to fit in a larger assembly."
	icon_state = "rig-hiskynpirate-helmet"
	item_state = "rig-hiskynpirate-helmet"
	light_overlay = "helmet_light_red"

/obj/item/clothing/suit/space/void/unathi_pirate/hiskyn/captain
	name = "hiskyn revanchist captain's voidsuit"
	desc =  "A bastardized version of an older Dominian voidsuit mixed with parts taken from the infamous Raider suit used by pirate Unathi, popular among members of the Hiskyn Revanchist fleet. The result is a tough and somewhat sluggish suit. This one is even more reinforced, and is probably made for a Captain or some kind of high-ranking crew member"
	icon_state = "rig-hiskyncaptain"
	item_state = "rig-hiskyncaptain"

/obj/item/clothing/head/helmet/space/void/unathi_pirate/hiskyn/captain
	name = "hiskyn revanchist captain's helmet"
	desc =  "A reinforced mix of older Dominian and homemade Unathi pirate hardware in a single helmet; made to fit in a larger assembly."
	icon_state = "rig-hiskyncaptain-helmet"
	item_state = "rig-hiskyncaptain-helmet"
