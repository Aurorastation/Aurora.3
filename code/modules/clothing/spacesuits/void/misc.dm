/obj/item/clothing/head/helmet/space/void/sol
	name = "gargoyle voidsuit helmet"
	desc = "A sleek and waspish composite-armored voidsuit helmet, issued to the personnel of the Sol Alliance's military."
	icon = 'icons/obj/clothing/voidsuit/sol.dmi'
	icon_state = "sol_helmet"
	item_state = "sol_helmet"
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
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)

	brightness_on = 6
	refittable = FALSE

/obj/item/clothing/suit/space/void/sol
	name = "gargoyle voidsuit"
	desc = "A midweight Zavodskoi-manufactured voidsuit designed for the Solarian Armed Forces, the Type-4 \"Gargoyle\" is the primary armored voidsuit in use by the Alliance military."
	icon = 'icons/obj/clothing/voidsuit/sol.dmi'
	icon_state = "sol_suit"
	item_state = "sol_suit"
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
	slowdown = 1
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)
	refittable = FALSE

/obj/item/clothing/head/helmet/space/void/coalition
	name = "coalition vulture voidsuit helmet"
	desc = "A helmet resembling an avian, built for the All-Xanu Grand Army and the Frontier Rangers. Heavy and plated with plasteel across its faces."
	desc_extended = "The dNAXS-02 \"Vulture\" suit (formerly designated the dNXS-2) was designed by de Namur Defense Systems on Xanu in 2291, to provide the All-Xanu Grand Army with a modern voidsuit using the lessons learned from the then-recently ended Interstellar War. This model of voidsuit, designed to look like an avian, has been extremely successful and has been exported across the Coalition of Colonies and beyond. These wildly successful voidsuits are still produced to this day by de Namur's successor company, d.N.A Defense & Aerospace."
	icon = 'icons/obj/clothing/voidsuit/coalition.dmi'
	icon_state = "vulture_helmet"
	item_state = "vulture_helmet"
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
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP)
	icon_supported_species_tags = list("ipc", "skr", "taj")
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_IPC, BODYTYPE_SKRELL)


	brightness_on = 6

/obj/item/clothing/suit/space/void/coalition
	name = "coalition vulture voidsuit"
	desc = "An iconic voidsuit of Xanan make, designed after the Interstellar War. It sees use to this day all throughout the Coalition of Colonies."
	desc_extended = "The dNAXS-02 \"Vulture\" suit (formerly designated the dNXS-2) was designed by de Namur Defense Systems on Xanu in 2291, to provide the All-Xanu Grand Army with a modern voidsuit using the lessons learned from the then-recently ended Interstellar War. This model of voidsuit, designed to look like an avian, has been extremely successful and has been exported across the Coalition of Colonies and beyond. These wildly successful voidsuits are still produced to this day by de Namur's successor company, d.N.A Defense & Aerospace."
	icon = 'icons/obj/clothing/voidsuit/coalition.dmi'
	icon_state = "vulture"
	item_state = "vulture"
	contained_sprite = TRUE
	slowdown = 1
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP, BODYTYPE_SKRELL)
	icon_supported_species_tags = list("ipc", "skr", "taj")
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_IPC, BODYTYPE_SKRELL)

/obj/item/clothing/head/helmet/space/void/coalition/xanu
	name = "\improper Xanan eagle voidsuit helmet"
	desc = "An advanced voidsuit helmet, designed specifically for the All-Xanu Armed Forces as a major upgrade to the iconic vulture voidsuit. Its armor has been upgraded, but it feels no heavier than a vulture."
	desc_extended = "The dNAXS-24 \"Eagle\" suit was commissioned by the All-Xanu Armed Forces as an upgrade to the aging vulture voidsuit in 2437. Having met all the requirements set out and more, the suit has been adopted by the majority of the Xanan armed forces, with only the National Militia still using the older vulture suits regularly. Despite the upgrades however, these suits have rarely been exported out of Xanu, due to its high cost."
	icon_state = "xanu_void_helmet"
	item_state = "xanu_void_helmet"
	siemens_coefficient = 0.35
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_CARBINE,
		laser = ARMOR_LASER_KEVLAR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP, BODYTYPE_IPC_INDUSTRIAL)

	light_overlay = "helmet_light_xanu_voidsuit"
	brightness_on = 6

/obj/item/clothing/suit/space/void/coalition/xanu
	name = "\improper Xanan eagle voidsuit"
	desc = "An advanced voidsuit, designed specifically for the All-Xanu Armed Forces as a major upgrade to the iconic vulture voidsuit. Its armor has been upgraded, but it feels no heavier than a vulture."
	desc_extended = "The dNAXS-24 \"Eagle\" suit was commissioned by the All-Xanu Armed Forces as an upgrade to the aging vulture voidsuit in 2437. Having met all the requirements set out and more, the suit has been adopted by the majority of the Xanan armed forces, with only the National Militia still using the older vulture suits regularly. Despite the upgrades however, these suits have rarely been exported out of Xanu, due to its high cost."
	icon_state = "xanu_voidsuit"
	item_state = "xanu_voidsuit"
	contained_sprite = TRUE
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_CARBINE,
		laser = ARMOR_LASER_KEVLAR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	slowdown = 1
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP, BODYTYPE_IPC_INDUSTRIAL)

/obj/item/clothing/suit/space/void/coalition/himeo
	name = "\improper Himean buzzard voidsuit"
	desc = "A hardy voidsuit designed specifically for the Himean Planetary Guard. Based on the iconic Vulture voidsuit, and modelled after the Eagle, it boasts improved armor at the cost of weight."
	desc_extended = "While the Vulture remains the most popular voidsuit in the Coalition, the Free Consortium of Defense and Aerospace Manufacturers has long sought improvements. As the Xanan \"Eagle\" remains costly to import, the \
	Type-97 \"Buzzard\" provides outstanding protections against the rigors of void combat at the cost of maneuverability. Naval boarding teams are fond of it; the inhuman faceplate and intimidating stature have led to more than \
	one surrender without a single shot being fired."
	icon_state = "himeo_voidsuit"
	item_state = "himeo_voidsuit"
	slowdown = 1.5
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_CARBINE,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/melee/baton,
		/obj/item/melee/energy/sword,
		/obj/item/handcuffs
	)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP, BODYTYPE_IPC)
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_IPC)
	icon_supported_species_tags = list("taj")

/obj/item/clothing/head/helmet/space/void/coalition/himeo
	name = "\improper Himean buzzard helmet"
	desc = "A hardy voidsuit helmet designed specifically for the Himean Planetary Guard. Based on the iconic Vulture voidsuit, and modelled after the Eagle, it boasts improved armor at the cost of weight."
	desc_extended = "While the Vulture remains the most popular voidsuit in the Coalition, the Free Consortium of Defense and Aerospace Manufacturers has long sought improvements. As the Xanan \"Eagle\" remains costly to import, the \
	Type-97 \"Buzzard\" provides outstanding protections against the rigors of void combat at the cost of maneuverability. Naval boarding teams are fond of it; the inhuman faceplate and intimidating stature have led to more than \
	one surrender without a single shot being fired."
	icon_state = "himeo_void_helmet"
	item_state = "himeo_void_helmet"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_CARBINE,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_IPC)
	icon_supported_species_tags = list("taj")
	brightness_on = 6
	light_color = "#ffce01"

/obj/item/clothing/head/helmet/space/void/coalition/galatea
	name = "\improper Galatean jackdaw helmet"
	desc = "An unusual voidsuit helmet designed for Galatean naval forces. Features an advanced environmental shielding module and strengthened biohazard protocols."
	desc_extended = "The Federal Technocracy of Galatea is unusual in that they did not base their voidsuit on the Vulture model, opting to start fresh with the \"Jackdaw\". Based on softsuit \
	designs from the days of the Galatea Project, the Jackdaw has an incredibly advanced 'user protection suite' that shields the occupant from radiation, biohazards, and exotic particles, at the cost of \
	combat protection."
	icon_state = "galatea_void_helmet"
	item_state = "galatea_void_helmet"
	slowdown = 0.65
	permeability_coefficient = 0
	gas_transfer_coefficient = 0
	siemens_coefficient = 0.75
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_STRONG,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP, BODYTYPE_IPC)
	refittable = FALSE

/obj/item/clothing/suit/space/void/coalition/galatea
	name = "\improper Galatean jackdaw voidsuit"
	desc = "An unusual voidsuit designed for Galatean naval forces. Features an advanced environmental shielding module and strengthened biohazard protocols."
	desc_extended = "The Federal Technocracy of Galatea is unusual in that they did not base their voidsuit on the Vulture model, opting to start fresh with the \"Jackdaw\". Based on softsuit \
	designs from the days of the Galatea Project, the Jackdaw has an incredibly advanced 'user protection suite' that shields the occupant from radiation, biohazards, and exotic particles, at the cost of \
	combat protection."
	icon_state = "galatea_voidsuit"
	item_state = "galatea_voidsuit"
	slowdown = 0.65
	permeability_coefficient = 0
	gas_transfer_coefficient = 0
	siemens_coefficient = 0.75
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_STRONG,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/melee/baton,
		/obj/item/melee/energy/sword,
		/obj/item/handcuffs
	)
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP, BODYTYPE_IPC)
	refittable = FALSE

/obj/item/clothing/head/helmet/space/void/cruiser
	name = "cruiser voidsuit helmet"
	desc = "A silvery chrome, single visor space helmet with built-in peripherals and very bright fore lighting. A favorite of bounty hunters."
	icon = 'icons/obj/clothing/voidsuit/megacorp.dmi'
	icon_state = "cruiser_helm"
	item_state = "cruiser_helm"
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
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)
	w_class = ITEMSIZE_NORMAL
	brightness_on = 6
	refittable = FALSE

/obj/item/clothing/suit/space/void/cruiser
	name = "cruiser voidsuit"
	desc = "A silvery chrome voidsuit with neon highlights. Utilized by Eridani private military and police."
	icon = 'icons/obj/clothing/voidsuit/megacorp.dmi'
	icon_state = "cruiser"
	item_state = "cruiser"
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
	slowdown = 1
	allowed = list(/obj/item/tank,/obj/item/device/flashlight,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)
	refittable = FALSE

/obj/item/clothing/head/helmet/space/void/valkyrie
	name = "valkyrie voidsuit helmet"
	desc = "A slot-eyed space helmet, sleek and designed for military purposes. Colored in Elyran military camouflage."
	icon_state = "valkyrie_helmet"
	item_state = "valkyrie_helmet"
	icon = 'icons/obj/clothing/voidsuit/elyra.dmi'
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
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE + 10000
	brightness_on = 6
	icon_supported_species_tags = list("ipc")
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_IPC)

/obj/item/clothing/suit/space/void/valkyrie
	name = "valkyrie voidsuit"
	desc = "A pricey specialist voidsuit designed for atmospheric long jumping and combat. Colored in Elyran military camouflage."
	icon_state = "valkyrie"
	item_state = "valkyrie"
	icon = 'icons/obj/clothing/voidsuit/elyra.dmi'
	contained_sprite = TRUE
	slowdown = 1
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	allowed = list(/obj/item/tank,/obj/item/device/flashlight,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)
	icon_supported_species_tags = list("ipc")
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_IPC)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE + 10000

/obj/item/clothing/head/helmet/space/void/lancer
	name = "lancer voidsuit helmet"
	desc = "A sleek helmet with a bright yellow visor, expertly made in and colored in the iconic branding of Ceres' Lance."
	icon = 'icons/obj/clothing/voidsuit/megacorp.dmi'
	icon_state = "lancer_helm"
	item_state = "lancer_helm"
	icon_supported_species_tags = list("una")
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
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_UNATHI)

/obj/item/clothing/head/helmet/space/void/lancer/unathi/Initialize()
	. = ..()
	desc = "A sleek helmet with a bright yellow visor, expertly made in and colored in the iconic branding of Ceres' Lance. This one is fitted to Unathi."
	refit_contained(BODYTYPE_UNATHI)

/obj/item/clothing/suit/space/void/lancer
	name = "lancer voidsuit"
	desc = "A bulky void suit with heavy plating. Looks to be colored in the branding of Ceres' Lance."
	icon = 'icons/obj/clothing/voidsuit/megacorp.dmi'
	icon_state = "lancer"
	item_state = "lancer"
	icon_supported_species_tags = list("una")
	contained_sprite = TRUE
	slowdown = 1
	w_class = ITEMSIZE_NORMAL
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_UNATHI)

/obj/item/clothing/suit/space/void/lancer/unathi/Initialize()
	. = ..()
	desc = "A bulky void suit with heavy plating. Looks to be colored in the branding of Ceres' Lance. This one is fitted to Unathi."
	refit_contained(BODYTYPE_UNATHI)

//Einstein Engines espionage voidsuit
/obj/item/clothing/head/helmet/space/void/einstein
	name = "banshee infiltration suit helmet"
	desc = "A sleek, menacing voidsuit helmet with the branding of Taipei Engineering Industrial's private military contractors."
	icon = 'icons/obj/clothing/voidsuit/megacorp.dmi'
	icon_state = "bansheehelm"
	item_state = "bansheehelm"
	contained_sprite = 1

	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP)
	light_overlay = "helmet_light_banshee"
	brightness_on = 6
	light_color = "#7ffbf7"
	desc_extended = "An easily recognized Einstein Engines-made PMC voidsuit piece. It is a telltale mark of corporate espionage and more often than not ends up buried with its user."
	icon_supported_species_tags = list("skr", "ipc")
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_IPC, BODYTYPE_SKRELL)

/obj/item/clothing/suit/space/void/einstein
	name = "banshee infiltration suit"
	desc = "A tightly-fitting suit manufactured with shimmering, ablative plating. Looks almost weightless."
	icon = 'icons/obj/clothing/voidsuit/megacorp.dmi'
	icon_state = "banshee"
	item_state = "banshee"
	contained_sprite = 1

	slowdown = 1
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP)
	desc_extended = "An easily recognized Einstein Engines-made PMC voidsuit piece. It is a telltale mark of corporate espionage and more often than not ends up buried with its user."
	icon_supported_species_tags = list("skr", "ipc")
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_IPC, BODYTYPE_SKRELL)

//Zeng-Hu Pharmaceuticals espionage voidsuit
/obj/item/clothing/head/helmet/space/void/zenghu
	name = "dragon biohazard suit helmet"
	desc = "A lightweight form-fitting helmet with sparse plating and weird, bug-like goggles."
	icon = 'icons/obj/clothing/voidsuit/megacorp.dmi'
	icon_state = "dragonhelm"
	item_state = "dragonhelm"
	contained_sprite = 1

	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP)
	light_overlay = "helmet_light_dragon"
	brightness_on = 6
	light_color = "#7ffbf7"
	desc_extended = "An easily recognized Zeng-Hu Pharmaceuticals biohazard control suit helmet. Its bug-eyed goggle visor design is unique among its class, alongside cutting-edge radiation protection."
	icon_supported_species_tags = list("skr", "ipc")
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_SKRELL, BODYTYPE_IPC)

/obj/item/clothing/suit/space/void/zenghu
	name = "dragon biohazard control suit"
	desc = "A remarkably lightweight Zeng-Hu Pharmaceuticals suit sporting excellent ambient radiation protection."
	icon = 'icons/obj/clothing/voidsuit/megacorp.dmi'
	icon_state = "dragon"
	item_state = "dragon"
	contained_sprite = 1

	slowdown = 1
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP, BODYTYPE_SKRELL)
	desc_extended = "An easily recognized Zeng-Hu Pharmaceuticals biohazard control suit. It is relatively fragile but has very apparent radiation shielding. Most often seen in the hands of post-disaster cleanup teams and private military contractors."
	icon_supported_species_tags = list("skr", "ipc")
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_SKRELL, BODYTYPE_IPC)

//Hephaestus Industries espionage voidsuit
/obj/item/clothing/head/helmet/space/void/hephaestus
	name = "caiman drop suit helmet"
	desc = "A massively heavy helmet, part of a larger terraforming suit assembly."
	icon = 'icons/obj/clothing/voidsuit/megacorp.dmi'
	icon_state = "caimanhelm"
	item_state = "caimanhelm"
	contained_sprite = 1

	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_BISHOP, BODYTYPE_IPC_ZENGHU)
	light_overlay = "helmet_light_caiman"
	brightness_on = 6
	light_color = "#ffce01"
	desc_extended = "An easily recognized Hephaestus terraforming suit helmet. Its low, protruding brow and heavy plating is useful in the event you happen to be cutting down things. Mostly trees. Hopefully trees."
	icon_supported_species_tags = list("una")
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_UNATHI)

/obj/item/clothing/suit/space/void/hephaestus
	name = "caiman drop suit"
	desc = "A superheavy Hephaestus designed terraforming suit, iconic for its usage in orbital drops onto hostile jungle worlds."
	icon = 'icons/obj/clothing/voidsuit/megacorp.dmi'
	icon_state = "caiman"
	item_state = "caiman"
	contained_sprite = 1

	slowdown = 1
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_BISHOP, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU)
	desc_extended = "An easily recognized Hephaestus terraforming suit. Used often on jungle worlds to handle local wildlife and safely deforest areas in hostile environments. It found recent popularity due to its combat effectiveness that resulted in its proliferation in the hands of Hephaestus private military."
	icon_supported_species_tags = list("una")
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_UNATHI)

//Zavodskoi Interstellar espionage voidsuit
/obj/item/clothing/head/helmet/space/void/zavodskoi
	name = "revenant suit helmet"
	desc = "A scary-looking helmet with blood red optics."
	icon = 'icons/obj/clothing/voidsuit/megacorp.dmi'
	icon_state = "revenanthelm"
	item_state = "revenanthelm"
	contained_sprite = 1

	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)
	light_overlay = "helmet_light_revenant"
	brightness_on = 6
	light_color = "#f65858"
	desc_extended = "An ominous helmet of Zavodskoi Interstellar make with its past veiled in mystery, used for high-end corporate backstabbing and secret operations."

/obj/item/clothing/suit/space/void/zavodskoi
	name = "revenant combat suit"
	desc = "A robust skirmishing suit with lightweight plating. It is branded with Kumar Arms logos, a subsidiary of Zavodskoi Interstellar. It looks very portable."
	icon = 'icons/obj/clothing/voidsuit/megacorp.dmi'
	icon_state = "revenant"
	item_state = "revenant"
	contained_sprite = 1

	w_class = ITEMSIZE_NORMAL
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	slowdown = 1
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)
	desc_extended = "A portable, sleek combat suit utilized in excess by Zavodskoi Interstellar private military contractors. It is known to be utilized by the company's most secretive sectors explicitly for espionage."

//Freelancer voidsuit
/obj/item/clothing/head/helmet/space/void/freelancer
	name = "armored voidsuit helmet"
	desc = "A helmet from a commercial combat voidsuit design. Acceptably well-armored and prolific thoughout the Orion Spur, it can be seen in use by everyone from mercenaries to militia groups to police forces."
	icon = 'icons/obj/clothing/voidsuit/mercenary.dmi'
	icon_state = "freelancer_helm"
	item_state = "freelancer_helm"
	contained_sprite = TRUE
	icon_supported_species_tags = list("skr", "taj", "una", "ipc")
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP)
	light_overlay = "freelancer_light"
	brightness_on = 6
	light_color = "#7ffbf7"
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_IPC, BODYTYPE_UNATHI, BODYTYPE_SKRELL)

/obj/item/clothing/suit/space/void/freelancer
	icon_state = "freelancer"
	name = "armored voidsuit"
	desc = "A suit from a commercial combat voidsuit design. Acceptably well-armored and prolific thoughout the Orion Spur, it can be seen in use by everyone from mercenaries to militia groups to police forces."
	icon = 'icons/obj/clothing/voidsuit/mercenary.dmi'
	icon_state = "freelancer"
	item_state = "freelancer"
	contained_sprite = TRUE
	icon_supported_species_tags = list("skr", "taj", "una", "ipc")
	slowdown = 1
	w_class = ITEMSIZE_NORMAL
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_SKRELL, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP)
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_TAJARA, BODYTYPE_IPC, BODYTYPE_UNATHI, BODYTYPE_SKRELL)

/obj/item/clothing/head/helmet/space/void/dominia
	name = "dominian prejoroub combat helmet"
	desc = "A glamorous, decorated helmet with thick plating across its faces. It holds the emblematic markings of the Empire of Dominia, if its design wasn't unmistakable enough."
	icon = 'icons/obj/clothing/voidsuit/dominia.dmi'
	icon_state = "dvoidsuithelm"
	item_state = "dvoidsuithelm"
	contained_sprite = 1

	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_UNATHI)
	brightness_on = 6
	icon_supported_species_tags = list("una")
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_UNATHI)

/obj/item/clothing/head/helmet/space/void/dominia/voidsman
	name = "dominian voidsman helmet"
	desc = "A Dominian voidsuit helmet issued to imperial fleet voidsmen. Not as flashy as most Dominian equipment tends to be."
	icon_state = "voidsmanhelm"
	item_state = "voidsmanhelm"
	species_restricted = list(BODYTYPE_HUMAN)
	icon_supported_species_tags = null

/obj/item/clothing/suit/space/void/dominia
	name = "dominian prejoroub combat suit"
	desc = "An offshoot of the Coalition's vulture suit design, painted in Dominian colors with portability and maneuverability in mind over its bulkier counterpart."
	icon = 'icons/obj/clothing/voidsuit/dominia.dmi'
	icon_state = "dvoidsuit"
	item_state = "dvoidsuit"
	contained_sprite = 1
	slowdown = 1

	w_class = ITEMSIZE_NORMAL
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN)
	icon_supported_species_tags = list("una")
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_UNATHI)

/obj/item/clothing/suit/space/void/dominia/voidsman
	name = "dominian voidsman suit"
	desc = "A Dominian voidsuit helmet issued to imperial fleet voidsmen. Not as flashy as most Dominian equipment tends to be."
	icon_state = "voidsman"
	item_state = "voidsman"
	species_restricted = list(BODYTYPE_HUMAN)
	icon_supported_species_tags = null
	refittable_species = list(BODYTYPE_HUMAN)

/obj/item/clothing/head/helmet/space/void/golden_deep
	name = "golden helmet"
	desc = "A glamorous, decorated helmet plated with gold. Very hefty."
	icon = 'icons/obj/clothing/voidsuit/golden_deep.dmi'
	icon_state = "goldhelm"
	item_state = "goldhelm"
	contained_sprite = 1

	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP)
	brightness_on = 6

/obj/item/clothing/suit/space/void/golden_deep
	name = "golden suit"
	desc = "A very heavy, gold-plated suit. Fabulous!"
	icon = 'icons/obj/clothing/voidsuit/golden_deep.dmi'
	icon_state = "goldsuit"
	item_state = "goldsuit"
	contained_sprite = 1
	slowdown = 1

	w_class = ITEMSIZE_NORMAL
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP)

/obj/item/clothing/head/helmet/space/void/mining/himeo
	name = "himeo mining voidsuit helmet"
	desc = "A rugged polymer and alloy space helmet with a ballistic glass and polycarbonate visor commonly used by astronauts from Himeo."
	desc_extended = "The Type-78A 'Fish Fur' Helmet is a nearly 80 year old design and is part of a long line of homegrown voidsuits dating to when the planet ejected Hephaestus Industries. The main reason for its long service life\
	is its modularity, with Himean workers often taking the time to make their own improvements to it, ranging all the way from simple morale patches slapped on the top to modern HUD-enabled visors."
	icon_state = "himeo_helm"
	item_state = "himeo_helm"
	item_state_slots = list(
		slot_l_hand_str = "mining_helm",
		slot_r_hand_str = "mining_helm"
		)

	light_overlay = "helmet_light_dual"

/obj/item/clothing/suit/space/void/mining/himeo
	name = "himeo mining voidsuit"
	desc = "A simple but durable softsuit with a set of protective alloy plates commonly used by Himean astronauts. The suit life support console and torso plate contains a Himean flag patch."
	desc_extended = "The Type-78 'Fish Fur' Voidsuit is an aging yet popular design produced only on Himeo. The simple and affordable design means many Himeans are able to own their own spacesuits rather than have one provided to them by their employer.\
	Its modular design means that they're adapted for use everywhere from the depths of Himeo to protect from debris, its surface to protect from the bitter cold, and in orbit, to work in the void. Their similarity to flightsuits have been noted, and the planet\
	enjoys jolly cooperation with fellow designers from Crosk who seek to invent new suits to keep their racers going faster."
	item_state = "himeo"
	icon_state = "himeo"
	item_state_slots = list(
		slot_l_hand_str = "mining",
		slot_r_hand_str = "mining"
		)

/obj/item/clothing/head/helmet/space/void/engineering/himeo
	name = "himeo engineering voidsuit helmet"
	desc = "A rugged polymer and alloy space helmet with a reinforced ballistic glass and polycarbonate goggle-type visor commonly used by astronauts from Himeo."
	desc_extended = "The Type-78A 'Fish Fur' Helmet is a nearly 80 year old design and is part of a long line of homegrown voidsuits dating to when the planet ejected Hephaestus Industries. The main reason for its long service life\
	is its modularity, with Himean workers often taking the time to make their own improvements to it, ranging all the way from simple morale patches slapped on the top to modern HUD-enabled visors."
	item_state = "himeo_helm"
	icon_state = "himeo_helm"
	light_overlay = "helmet_light_dual"
	item_state_slots = list(
		slot_l_hand_str = "engineering_helm",
		slot_r_hand_str = "engineering_helm"
		)

/obj/item/clothing/suit/space/void/engineering/himeo
	name = "himeo engineering voidsuit"
	desc = "A simple but durable softsuit with a set of protective alloy plates commonly used by Himean astronauts. The suit life support console and torso plate contains a Himean flag patch. This particular model seems to have lead lining in it."
	desc_extended = "The Type-78 'Fish Fur' Voidsuit is an aging yet popular design produced only on Himeo. The simple and affordable design means many Himeans are able to own their own spacesuits rather than have one provided to them by their employer.\
	Its modular design means that they're adapted for use everywhere from the depths of Himeo to protect from debris, its surface to protect from the bitter cold, and in orbit, to work in the void. Their similarity to flightsuits have been noted, and the planet\
	enjoys jolly cooperation with fellow designers from Crosk who seek to invent new suits to keep their racers going faster."
	item_state = "himeo"
	icon_state = "himeo"
	item_state_slots = list(
		slot_l_hand_str = "engineering",
		slot_r_hand_str = "engineering"
		)

/obj/item/clothing/head/helmet/space/void/atmos/himeo
	name = "himeo atmospherics voidsuit helmet"
	desc = "A rugged polymer and alloy space helmet with a reinforced ballistic glass and polycarbonate goggle-type visor commonly used by astronauts from Himeo. This particular model appears to have a thicker layer of insulation on it."
	desc_extended = "The Type-78A 'Fish Fur' Helmet is a nearly 80 year old design and is part of a long line of homegrown voidsuits dating to when the planet ejected Hephaestus Industries. The main reason for its long service life\
	is its modularity, with Himean workers often taking the time to make their own improvements to it, ranging all the way from simple morale patches slapped on the top to modern HUD-enabled visors."
	item_state = "himeo_helm"
	icon_state = "himeo_helm"
	item_state_slots = list(
		slot_l_hand_str = "atmos_helm",
		slot_r_hand_str = "atmos_helm"
		)

	light_overlay = "helmet_light_dual"

/obj/item/clothing/suit/space/void/atmos/himeo
	name = "himeo atmospherics voidsuit"
	desc = "A simple but durable softsuit with a set of protective alloy plates commonly used by Himean astronauts. The suit life support console and torso plate contains a Himean flag patch. This particular model seems to have better insulation in it."
	desc_extended = "The Type-78 'Fish Fur' Voidsuit is an aging yet popular design produced only on Himeo. The simple and affordable design means many Himeans are able to own their own spacesuits rather than have one provided to them by their employer.\
	Its modular design means that they're adapted for use everywhere from the depths of Himeo to protect from debris, its surface to protect from the bitter cold, and in orbit, to work in the void. Their similarity to flightsuits have been noted, and the planet\
	enjoys jolly cooperation with fellow designers from Crosk who seek to invent new suits to keep their racers going faster."
	item_state = "himeo"
	icon_state = "himeo"
	item_state_slots = list(
		slot_l_hand_str = "atmos",
		slot_r_hand_str = "atmos"
		)

/obj/item/clothing/head/helmet/space/void/mining/himeo/tajara
	name = "himeo mining voidsuit helmet"
	desc = "A rugged polymer and alloy space helmet with a ballistic glass and polycarbonate visor commonly used by astronauts from Himeo. This helmet looks fit for a Tajara."
	desc_extended = "The Type-78A 'Fish Fur' Helmet is a nearly 80 year old design and is part of a long line of homegrown voidsuits dating to when the planet ejected Hephaestus Industries. The main reason for its long service life\
	is its modularity, with Himean workers often taking the time to make their own improvements to it, ranging all the way from simple morale patches slapped on the top to modern HUD-enabled visors. It quickly found purchase among \
	Himeo's population of Tajaran expatriates, who were shown how to modify and use the voidsuits. Many of the first Tajaran-fitted suits were a product of collaborations between the two species making them all the more sentimental to those who use them."
	icon = 'icons/obj/clothing/voidsuit/himeotaj.dmi'
	icon_state = "rig0-himeotaj"
	item_state = "rig0-himeotaj"
	item_state_slots = list(
		slot_l_hand_str = "mining_helm",
		slot_r_hand_str = "mining_helm"
		)
	contained_sprite = TRUE
	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/suit/space/void/mining/himeo/tajara
	name = "himeo mining voidsuit"
	desc = "A simple but durable softsuit with a set of protective alloy plates commonly used by Himean astronauts. The suit life support console and torso plate contains a Himean flag patch. This suit looks fit for a Tajara."
	desc_extended = "The Type-78 'Fish Fur' Voidsuit is an aging yet popular design produced only on Himeo. The simple and affordable design means many Himeans are able to own their own spacesuits rather than have one provided to them by their employer.\
	Its modular design means that they're adapted for use everywhere from the depths of Himeo to protect from debris, its surface to protect from the bitter cold, and in orbit, to work in the void. Their similarity to flightsuits have been noted, and the planet \
	enjoys jolly cooperation with fellow designers from Crosk who seek to invent new suits to keep their racers going faster. They quickly found purchase among Himeo's population of Tajaran expatriates, who were shown how to modify and use the voidsuits. \
	Many of the first Tajaran-fitted suits were a product of collaborations between the two species making them all the more sentimental to those who use them."
	icon = 'icons/obj/clothing/voidsuit/himeotaj.dmi'
	item_state = "rig-himeotaj"
	icon_state = "rig-himeotaj"
	item_state_slots = list(
		slot_l_hand_str = "mining_hardsuit",
		slot_r_hand_str = "mining_hardsuit"
	)
	contained_sprite = TRUE
	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/head/helmet/space/void/engineering/himeo/tajara
	name = "himeo engineering voidsuit helmet"
	desc = "A rugged polymer and alloy space helmet with a reinforced ballistic glass and polycarbonate goggle-type visor commonly used by astronauts from Himeo. This helmet looks fit for a Tajara."
	desc_extended = "The Type-78A 'Fish Fur' Helmet is a nearly 80 year old design and is part of a long line of homegrown voidsuits dating to when the planet ejected Hephaestus Industries. The main reason for its long service life \
	is its modularity, with Himean workers often taking the time to make their own improvements to it, ranging all the way from simple morale patches slapped on the top to modern HUD-enabled visors. It quickly found purchase among \
	Himeo's population of Tajaran expatriates, who were shown how to modify and use the voidsuits. Many of the first Tajaran-fitted suits were a product of collaborations between the two species making them all the more sentimental to those who use them."
	icon = 'icons/obj/clothing/voidsuit/himeotaj.dmi'
	icon_state = "rig0-himeotaj-engineering"
	item_state = "rig0-himeotaj-engineering"
	item_state_slots = list(
		slot_l_hand_str = "engineering_helm",
		slot_r_hand_str = "engineering_helm"
		)

	contained_sprite = TRUE
	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/suit/space/void/engineering/himeo/tajara
	name = "himeo engineering voidsuit"
	desc = "A simple but durable softsuit with a set of protective alloy plates commonly used by Himean astronauts. The suit life support console and torso plate contains a Himean flag patch. This particular model is fitted for Tajara and seems to have lead lining in it."
	desc_extended = "The Type-78 'Fish Fur' Voidsuit is an aging yet popular design produced only on Himeo. The simple and affordable design means many Himeans are able to own their own spacesuits rather than have one provided to them by their employer.\
	Its modular design means that they're adapted for use everywhere from the depths of Himeo to protect from debris, its surface to protect from the bitter cold, and in orbit, to work in the void. Their similarity to flightsuits have been noted, and the planet \
	enjoys jolly cooperation with fellow designers from Crosk who seek to invent new suits to keep their racers going faster. They quickly found purchase among Himeo's population of Tajaran expatriates, who were shown how to modify and use the voidsuits. \
	Many of the first Tajaran-fitted suits were a product of collaborations between the two species making them all the more sentimental to those who use them."
	icon = 'icons/obj/clothing/voidsuit/himeotaj.dmi'
	item_state = "rig-himeotaj-engineering"
	icon_state = "rig-himeotaj-engineering"
	item_state_slots = list(
		slot_l_hand_str = "engineering_hardsuit",
		slot_r_hand_str = "engineering_hardsuit"
	)
	contained_sprite = TRUE
	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/head/helmet/space/void/atmos/himeo/tajara
	name = "himeo atmospherics voidsuit helmet"
	desc = "A rugged polymer and alloy space helmet with a reinforced ballistic glass and polycarbonate goggle-type visor commonly used by astronauts from Himeo. This particular model is fitted for Tajara and appears to have a thicker layer of insulation on it."
	desc_extended = "The Type-78A 'Fish Fur' Helmet is a nearly 80 year old design and is part of a long line of homegrown voidsuits dating to when the planet ejected Hephaestus Industries. The main reason for its long service life \
	is its modularity, with Himean workers often taking the time to make their own improvements to it, ranging all the way from simple morale patches slapped on the top to modern HUD-enabled visors. It quickly found purchase among \
	Himeo's population of Tajaran expatriates, who were shown how to modify and use the voidsuits. Many of the first Tajaran-fitted suits were a product of collaborations between the two species making them all the more sentimental to those who use them."
	icon = 'icons/obj/clothing/voidsuit/himeotaj.dmi'
	icon_state = "rig0-himeotaj-engineering"
	item_state = "rig0-himeotaj-engineering"
	item_state_slots = list(
		slot_l_hand_str = "atmos_helm",
		slot_r_hand_str = "atmos_helm"
		)

	contained_sprite = TRUE
	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/suit/space/void/atmos/himeo/tajara
	name = "himeo atmospherics voidsuit"
	desc = "A simple but durable softsuit with a set of protective alloy plates commonly used by Himean astronauts. The suit life support console and torso plate contains a Himean flag patch. This particular model is fitted for Tajara and seems to have better insulation in it."
	desc_extended = "The Type-78 'Fish Fur' Voidsuit is an aging yet popular design produced only on Himeo. The simple and affordable design means many Himeans are able to own their own spacesuits rather than have one provided to them by their employer.\
	Its modular design means that they're adapted for use everywhere from the depths of Himeo to protect from debris, its surface to protect from the bitter cold, and in orbit, to work in the void. Their similarity to flightsuits have been noted, and the planet \
	enjoys jolly cooperation with fellow designers from Crosk who seek to invent new suits to keep their racers going faster. They quickly found purchase among Himeo's population of Tajaran expatriates, who were shown how to modify and use the voidsuits. \
	Many of the first Tajaran-fitted suits were a product of collaborations between the two species making them all the more sentimental to those who use them."
	icon = 'icons/obj/clothing/voidsuit/himeotaj.dmi'
	item_state = "rig-himeotaj-engineering"
	icon_state = "rig-himeotaj-engineering"
	item_state_slots = list(
		slot_l_hand_str = "atmos_hardsuit",
		slot_r_hand_str = "atmos_hardsuit"
	)
	contained_sprite = TRUE
	species_restricted = list(BODYTYPE_TAJARA)

/obj/item/clothing/head/helmet/space/void/sol/srf
	name = "solarian restoration front voidsuit helmet"
	desc = "An uparmored variant of the gargoyle voidsuit helmet, with a solid visor and redundant comms antenna. Intended for urban combat operations."
	icon_state = "srf_helmet"
	item_state = "srf_helmet"

/obj/item/clothing/suit/space/void/sol/srf
	name = "solarian restoration front voidsuit"
	desc = "A variant of the Solarian Armed Forces Type-4 \"Gargoyle\" voidsuit, the Type-5 \"Cyclops\" is the urban combat version of the Gargoyle. While practical testing showed it was a marginal improvement over the Type-4 at best, the SRF have taken to using this modification \
	both on account of its intimidating design and in an effort to distinguish its forces from others using the Type-4, warlord or not. This one has the SRF's flag on the breastplate."
	icon_state = "srf_suit"
	item_state = "srf_suit"

/obj/item/clothing/head/helmet/space/void/sol/league
	name = "anti-corporate league voidsuit helmet"
	desc = "A sleek and waspish composite-armored voidsuit helmet, issued to the personnel of the Sol Alliance's military. This one has been modified by the forces of the League of Independent Corporate-Free Systems to match the colors of the Xanusian \"Vulture\" voidsuit, and also features a modified comms antenna."
	icon_state = "league_helmet"
	item_state = "league_helmet"

/obj/item/clothing/suit/space/void/sol/league
	name = "anti-corporate league voidsuit"
	desc = "A midweight Zavodskoi-manufactured voidsuit designed for the Solarian Armed Forces, the Type-4 \"Gargoyle\" is the primary armored voidsuit in use by the Alliance military. This one has been modified by the forces of the League of Independent Corporate-Free Systems to match the colors of the Xanusian \
	\"Vulture\" voidsuit, to make it more easily identified by friendly Coalition forces."
	icon_state = "league_suit"
	item_state = "league_suit"

/obj/item/clothing/head/helmet/space/void/sol/fsf
	name = "free solarian fleets voidsuit helmet"
	desc = "A sleek and waspish composite-armored voidsuit helmet, issued to the personnel of the Sol Alliance's military. This one has been modified by the forces of the Free Solarian Fleets to make it more easily identifiable from other forces using the Type-4, warlord or not."
	icon_state = "fsf_helmet"
	item_state = "fsf_helmet"

/obj/item/clothing/suit/space/void/sol/fsf
	name = "free solarian fleets voidsuit"
	desc = "A midweight Zavodskoi-manufactured voidsuit designed for the Solarian Armed Forces, the Type-4 \"Gargoyle\" is the primary armored voidsuit in use by the Alliance military. This one has been repainted by the forces of the Free Solarian Fleets to make it more easily identifiable \
	from other forces using the Type-4, warlord or not."
	icon_state = "fsf_suit"
	item_state = "fsf_suit"

/obj/item/clothing/head/helmet/space/void/sol/ssmd
	name = "military district voidsuit helmet"
	desc = "A sleek and waspish composite-armored voidsuit helmet, issued to the personnel of the Sol Alliance's military. This one has been modified by the forces of the Southern Solarian Military District to make it more easily identifiable from other forces using the Type-4, warlord or not."
	icon_state = "ssmd_helmet"
	item_state = "ssmd_helmet"
/obj/item/clothing/suit/space/void/sol/ssmd
	name = "military district voidsuit"
	desc = "A midweight Zavodskoi-manufactured voidsuit designed for the Solarian Armed Forces, the Type-4 \"Gargoyle\" is the primary armored voidsuit in use by the Alliance military. This one has been repainted by the forces of the Southern Solarian Military District to make it more easily identifiable \
	from other forces using the Type-4, warlord or not."
	icon_state = "ssmd_suit"
	item_state = "ssmd_suit"

/obj/item/clothing/head/helmet/space/void/sol/spg
	name = "provisional government voidsuit helmet"
	desc = "A sleek and waspish composite-armored voidsuit helmet, issued to the personnel of the Sol Alliance's military. This one has been modified by the forces of the Solarian Provisional Government to make it more easily identifiable from other forces using the Type-4, warlord or not."
	icon_state = "spg_helmet"
	item_state = "spg_helmet"

/obj/item/clothing/suit/space/void/sol/spg
	name = "provisional government voidsuit"
	desc = "A midweight Zavodskoi-manufactured voidsuit designed for the Solarian Armed Forces, the Type-4 \"Gargoyle\" is the primary armored voidsuit in use by the Alliance military. This one has been repainted by the forces of the Solarian Provisional Government to make it more easily identifiable \
	from other forces using the Type-4, warlord or not."
	icon_state = "spg_suit"
	item_state = "spg_suit"

/obj/item/clothing/head/helmet/space/void/sol/mrsp
	name = "shield pact voidsuit helmet"
	desc = "A sleek and waspish composite-armored voidsuit helmet, issued to the personnel of the Sol Alliance's military. This one has been modified by the forces of the Middle Ring Shield Pact to make it more easily identifiable from other forces using the Type-4, warlord or not."
	icon_state = "mrsp_helmet"
	item_state = "mrsp_helmet"

/obj/item/clothing/suit/space/void/sol/mrsp
	name = "shield pact voidsuit"
	desc = "A midweight Zavodskoi-manufactured voidsuit designed for the Solarian Armed Forces, the Type-4 \"Gargoyle\" is the primary armored voidsuit in use by the Alliance military. This one has been repainted by the scant forces of the Middle Ring Shield Pact to make it more easily identifiable \
	from other forces using the Type-4, warlord or not."
	icon_state = "mrsp_suit"
	item_state = "mrsp_suit"

/obj/item/clothing/head/helmet/space/void/sol/sfa
	name = "southern fleet administration voidsuit helmet"
	desc = "A sleek and waspish composite-armored voidsuit helmet, issued to the personnel of the Sol Alliance's military. This one has been modified by the forces of the Southern Fleet Administration to make it more easily identifiable from other forces using the Type-4, warlord or not."
	icon_state = "sfa_helmet"
	item_state = "sfa_helmet"

/obj/item/clothing/suit/space/void/sol/sfa
	name = "southern fleet administration voidsuit"
	desc = "A midweight Zavodskoi-manufactured voidsuit designed for the Solarian Armed Forces, the Type-4 \"Gargoyle\" is the primary armored voidsuit in use by the Alliance military. This one has been repainted by the scant forces of the Southern Fleet Administration to make it more easily identifiable \
	from other forces using the Type-4, warlord or not. Due to poor maintenance, the highlights appear to have gone out."
	icon_state = "sfa_suit"
	item_state = "sfa_suit"

/obj/item/clothing/head/helmet/space/void/coalition/gadpathur
	name = "coalition vulture-GP voidsuit helmet"
	desc = "A helmet resembling an avian. This one has been modified for usage with Gadpathur's navy."
	icon_state = "gadpathur_vulture_helm"
	item_state = "gadpathur_vulture_helm"
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_BISHOP, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_INDUSTRIAL)

	brightness_on = 6

/obj/item/clothing/suit/space/void/coalition/gadpathur
	name = "coalition vulture-GP voidsuit"
	desc = "An iconic voidsuit of Xanan make, designed after the Interstellar War. This one has been modified for usage with Gadpathur's navy."
	icon_state = "gadpathur_vulture"
	item_state = "gadpathur_vulture"
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_BISHOP, BODYTYPE_IPC_ZENGHU, BODYTYPE_SKRELL, BODYTYPE_IPC_INDUSTRIAL)

/obj/item/clothing/head/helmet/space/void/sol/konyang
	name = "konyang aerospace forces voidsuit helmet"
	desc = "A sleek and waspish composite-armored voidsuit helmet, issued to the personnel of the Sol Alliance's military. This one has been painted in the colors of the Konyang Armed Forces."
	icon = 'icons/obj/clothing/voidsuit/coalition.dmi'
	icon_state = "konyang_helmet"
	item_state = "konyang_helmet"
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC, BODYTYPE_IPC_BISHOP, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU)
	icon_supported_species_tags = list("ipc")
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_IPC)
	refittable = TRUE

/obj/item/clothing/suit/space/void/sol/konyang
	name = "konyang aerospace forces voidsuit"
	desc = "A midweight Zavodskoi-manufactured voidsuit designed for the Solarian Armed Forces, the Type-4 \"Gargoyle\" is the primary armored voidsuit in use by the Alliance military.This one has been painted in the colors of the Konyang Armed Forces."
	icon = 'icons/obj/clothing/voidsuit/coalition.dmi'
	icon_state = "konyang_suit"
	item_state = "konyang_suit"
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC, BODYTYPE_IPC_BISHOP, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU)
	icon_supported_species_tags = list("ipc")
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_IPC)
	refittable = TRUE

/obj/item/clothing/suit/space/void/tcaf
	name = "tau ceti armed forces voidsuit"
	desc = "A Zavodskoi-manufactured combat voidsuit designed for the Tau Ceti Armed Forces, the Type-37 \"Aegis\" is now the primary armored voidsuit in use by the Republic of Biesel."
	icon = 'icons/obj/clothing/voidsuit/tcaf.dmi'
	icon_state = "tcaf_suit"
	item_state = "tcaf_suit"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	slowdown = 1
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.35
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_BISHOP, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU, BODYTYPE_SKRELL)
	contained_sprite = TRUE
	icon_supported_species_tags = list("ipc", "skr", "taj", "una", "vau", "vaw")
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_IPC, BODYTYPE_TAJARA, BODYTYPE_UNATHI, BODYTYPE_SKRELL, BODYTYPE_VAURCA)

/obj/item/clothing/head/helmet/space/void/tcaf
	name = "tau ceti armed forces voidsuit helmet"
	desc = "A Zavodskoi-designed armored voidsuit helmet, painted in the colors of the Republic of Biesel. Commonly seen in use by personnel of the Tau Ceti Armed Forces."
	icon = 'icons/obj/clothing/voidsuit/tcaf.dmi'
	icon_state = "tcaf_helmet"
	item_state = "tcaf_helmet"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_BISHOP, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU)
	contained_sprite = TRUE
	icon_supported_species_tags = list("ipc", "skr", "taj", "una", "vau", "vaw")
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_IPC, BODYTYPE_TAJARA, BODYTYPE_UNATHI, BODYTYPE_SKRELL, BODYTYPE_VAURCA)
	brightness_on = 6
	siemens_coefficient = 0.35

/obj/item/clothing/head/helmet/space/void/coalition/assunzione
	name = "\improper Assunzionii rook voidsuit helmet"
	desc = "Based on the common Coalition Vulture design, the ZH-A45 'Rook' has rapidly become commonplace equipment among the Republic of Assunzione's scientific and military forces. In addition to being a servicable combat voidsuit model, it is equipped with state-of-the-art anomalous energy shielding developed by Zeng-Hu Pharmaceuticals."
	desc_extended = "Rook suits are largely seen in the hands of Assunzionii military patrols in Light's Edge, as well as scientific expeditions into the darkness of the Lemurian Sea. The current model was developed in 2412 as a joint effort between Assunzionii government R&D and Zeng-Hu Parmaceuticals."
	icon_state = "assunzione_helmet"
	item_state = "assunzione_helmet"
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP)
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_IPC)
	icon_supported_species_tags = list("ipc")
	anomaly_protection = 0.2
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)

/obj/item/clothing/suit/space/void/coalition/assunzione
	name = "\improper Assunzionii rook voidsuit"
	desc = "Based on the common Coalition Vulture design, the ZH-A45 'Rook' has rapidly become commonplace equipment among the Republic of Assunzione's scientific and military forces. In addition to being a servicable combat voidsuit model, it is equipped with state-of-the-art anomalous energy shielding developed by Zeng-Hu Pharmaceuticals."
	desc_extended = "Rook suits are largely seen in the hands of Assunzionii military patrols in Light's Edge, as well as scientific expeditions into the darkness of the Lemurian Sea. The current model was developed in 2412 as a joint effort between Assunzionii government R&D and Zeng-Hu Parmaceuticals."
	icon_state = "assunzione_suit"
	item_state = "assunzione_suit"
	icon_supported_species_tags = list("ipc")
	anomaly_protection = 0.5
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)

	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC_INDUSTRIAL, BODYTYPE_IPC_ZENGHU, BODYTYPE_IPC_BISHOP, BODYTYPE_IPC, BODYTYPE_SKRELL)
	refittable_species = list(BODYTYPE_HUMAN, BODYTYPE_IPC)
