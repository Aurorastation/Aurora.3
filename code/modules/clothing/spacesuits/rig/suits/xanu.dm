/obj/item/rig/xanu
	name = "dNAXS-52 combat hardsuit control module"
	desc = "A sleek and dangerous hardsuit for active combat. This one is a d.N.A Defense design in color scheme and make."
	desc_extended = "The dNAXS-52 combat hardsuit is designed for the All-Xanu Spacefleet's interstellar infantry. It is specially designed for boarding operations, close quarters combat, and demolitions."
	suit_type = "dNAXS-52 combat hardsuit"
	icon_supported_species_tags = null
	icon = 'icons/obj/item/clothing/rig/xanu/xanu_rig.dmi'
	icon_state = "xanu_rig"
	helm_type = /obj/item/clothing/head/helmet/space/rig/combat/xanu

	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_MEDIUM,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SMALL,
	)

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY

	siemens_coefficient = 0.2
	offline_slowdown = 2
	offline_vision_restriction = TINT_HEAVY

	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC, BODYTYPE_IPC_BISHOP, BODYTYPE_IPC_ZENGHU)

/obj/item/clothing/head/helmet/space/rig/combat/xanu
	light_overlay = "helmet_light_xanu"

/obj/item/rig/xanu/equipped
	req_access = list(ACCESS_COALITION_NAVY)
	initial_modules = list(
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/actuators,
		/obj/item/rig_module/mounted/egun,
		)

/obj/item/rig/xanu/equipped/ert //ERT variant
	name = "dNAXS-52E combat hardsuit control module"
	desc = "A heavily-equipped sleek and dangerous hardsuit for active combat. This one is a d.N.A Defense design in color scheme and make."
	initial_modules = list(
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/actuators,
		/obj/item/rig_module/mounted,
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/combat,
		)

/obj/item/rig/zero/xanu
	name = "dNAXS-26 null hardsuit control module"
	suit_type = "dNAXS-26 null hardsuit"
	desc = "A very lightweight suit designed to allow use inside mechs and starfighters, designed specially for the Xanan spacefleet. It feels like you're wearing nothing at all."
	desc_extended = "The dNAXS-26 'null' hardsuit was designed by d.N.A Defense at the request of the All-Xanu Spacefleet, for its spaceborne mech and starfighter pilots. Designed with comfort and mobility in mind, this suit allows pilots their full range of motion, while protecting them from minor radiation hazards and the vacuum of space."
	icon = 'icons/obj/item/clothing/rig/xanu/xanu_zero_suit.dmi'
	icon_state = "xanu_zero"
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC, BODYTYPE_IPC_BISHOP, BODYTYPE_IPC_ZENGHU)
	//This suit has no slowdown. These armor values are intentionally terrible as a result.
	armor = list(
		BOMB = ARMOR_BOMB_MINOR,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_MINOR
	)
	slowdown = 0
	offline_slowdown = 1

	allowed_module_types = MODULE_GENERAL | MODULE_UTILITY

	chest_type = /obj/item/clothing/suit/space/rig/zero/xanu
	helm_type = /obj/item/clothing/head/helmet/space/rig/zero/xanu
	boot_type = null
	glove_type = null
	max_pressure_protection = null
	min_pressure_protection = 0

/obj/item/clothing/head/helmet/space/rig/zero/xanu
	camera = null
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC, BODYTYPE_IPC_BISHOP, BODYTYPE_IPC_ZENGHU)
	desc = "A specially designed helmet, allowing a full range of vision. A state of the art holographic display provides a stream of information."
	light_overlay = "helmet_light_xanu_zero"

//All in one suit
/obj/item/clothing/suit/space/rig/zero/xanu
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC, BODYTYPE_IPC_BISHOP, BODYTYPE_IPC_ZENGHU)
	//Worse protection than most hardsuits, due to no slowdown
	breach_threshold = 18
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/tank,
		/obj/item/device/suit_cooling_unit
	)
