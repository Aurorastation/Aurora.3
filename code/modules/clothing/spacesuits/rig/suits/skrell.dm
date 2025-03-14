/obj/item/clothing/head/helmet/space/rig/skrell
	light_overlay = "helmet_light_nralakk_rig"
	light_color = LIGHT_COLOR_CYAN

/obj/item/rig/skrell
	name = "qukala assault hardsuit control module"
	desc = "A Nralakk-manufactured combat hardsuit, designed for use by elite operatives of the Qukala. Due to their expense and classified design, these suits are rarely seen outside of Qukala hands."
	icon = 'icons/clothing/rig/nralakk.dmi'
	icon_state = "nralakk_rig"
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_MAJOR,
		LASER = ARMOR_LASER_MEDIUM,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.1
	emp_protection = 30
	vision_restriction = TINT_NONE
	slowdown = 0
	offline_slowdown = 3
	species_restricted = list(BODYTYPE_SKRELL)

	helm_type = /obj/item/clothing/head/helmet/space/rig/skrell
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs,/obj/item/material/twohanded/fireaxe)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL

/obj/item/rig/skrell/equipped
	req_access = list(ACCESS_SKRELL)
	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/mounted/ion,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/chem_dispenser/injector,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/recharger,
		/obj/item/rig_module/mounted/skrell_gun
		)

/obj/item/rig/skrell/equipped/merc
	req_access = list(ACCESS_SYNDICATE)

/obj/item/clothing/head/helmet/space/rig/skrell/tup
	light_overlay = "helmet_light_tadpole"

/obj/item/clothing/head/helmet/space/rig/skrell/tup/modern
	light_overlay = "tup2_rig_helmetlight"

/obj/item/rig/skrell/tup
	name = "tupkala infiltration suit control module"
	desc = "An old yet reliable suit control module, designed by the Nralakk Federation for clandestine operations. The best of the best, albeit outdated now."
	icon = 'icons/clothing/rig/tup.dmi'
	icon_state = "tup_rig"
	suit_type = "tup suit"
	emp_protection = 95

	helm_type = /obj/item/clothing/head/helmet/space/rig/skrell/tup

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL

/obj/item/rig/skrell/tup/equipped
	req_access = list(ACCESS_SKRELL)
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/mounted/pulse,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/chem_dispenser/injector,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/device/rfd_c,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/teleporter/skrell,
		/obj/item/rig_module/recharger
		)

/obj/item/rig/skrell/tup/ninja
	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/chem_dispenser/injector,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/teleporter/skrell,
		/obj/item/rig_module/mounted/skrell_gun,
		/obj/item/rig_module/stealth_field
		)

/obj/item/rig/skrell/tup/modern
	name = "tupkala suit control module"
	desc = "This is the suit control module for the Tupkala RIG. It's one of the most advanced pieces of technology in the Spur."
	icon_state = "tup2_rig"
	helm_type = /obj/item/clothing/head/helmet/space/rig/skrell/tup/modern
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_RIFLE,
		LASER = ARMOR_LASER_RIFLE,
		ENERGY = ARMOR_ENERGY_STRONG,
		BOMB = ARMOR_BOMB_RESISTANT,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SHIELDED
		)

/obj/item/rig/skrell/tup/modern/equipped
	req_access = list(ACCESS_SKRELL)
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/mounted/pulse,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/chem_dispenser/injector,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/device/rfd_c,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/teleporter/skrell
		)
