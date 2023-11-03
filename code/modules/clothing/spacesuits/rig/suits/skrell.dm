/obj/item/clothing/head/helmet/space/rig/skrell
	light_overlay = "helmet_light_nralakk_rig"
	light_color = LIGHT_COLOR_CYAN

/obj/item/rig/skrell
	name = "nralakk suit control module"
	desc = "A suit control module designed by the Nralakk Federation for JFSF operations. It is designed to be sleek and agile, equipped with best protection and technology the Federation has to offer for its elite."
	icon = 'icons/clothing/rig/nralakk.dmi'
	icon_state = "nralakk_rig"
	suit_type = "nralakk suit"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_AP,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
		)
	siemens_coefficient = 0.1
	emp_protection = 30
	vision_restriction = 0
	slowdown = 0
	offline_slowdown = 3
	vision_restriction = TINT_NONE
	species_restricted = list("Skrell")

	helm_type = /obj/item/clothing/head/helmet/space/rig/skrell
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs,/obj/item/material/twohanded/fireaxe)

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
		/obj/item/rig_module/actuators/combat
		)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL

/obj/item/clothing/head/helmet/space/rig/skrell/tup
	light_overlay = "helmet_light_tadpole"

/obj/item/clothing/head/helmet/space/rig/skrell/tup/modern
	light_overlay = "tup2_rig_helmetlight"

/obj/item/rig/skrell/tup
	name = "outdated tupkala suit control module"
	desc = "A suit control module designed by the Nralakk Federation for Tup operations. The best of the best, albeit outdated now."
	icon = 'icons/clothing/rig/tup.dmi'
	icon_state = "tup_rig"
	suit_type = "tup suit"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_RIFLE,
		energy = ARMOR_ENERGY_STRONG,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
		)
	emp_protection = 95

	helm_type = /obj/item/clothing/head/helmet/space/rig/skrell/tup

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

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL

/obj/item/rig/skrell/tup/modern
	name = "tupkala suit control module"
	desc = "This is the suit control module for the Tupkala RIG. It's one of the most advanced pieces of technology in the Spur."
	icon_state = "tup2_rig"
	helm_type = /obj/item/clothing/head/helmet/space/rig/skrell/tup/modern
