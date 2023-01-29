/obj/item/clothing/head/helmet/space/rig/merc
	light_overlay = "merc_rig_lights"
	light_color = "#ffffff"
	camera = /obj/machinery/camera/network/mercenary

/obj/item/rig/merc
	name = "crimson hardsuit control module"
	desc = "A blood-red hardsuit featuring some fairly illegal technology."
	icon = 'icons/clothing/rig/merc_crimson.dmi'
	icon_state = "merc_rig"
	icon_supported_species_tags = list("ipc", "skr", "taj", "una")
	suit_type = "crimson hardsuit"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_MAJOR,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.1
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY
	emp_protection = 30

	helm_type = /obj/item/clothing/head/helmet/space/rig/merc
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs,/obj/item/material/twohanded/fireaxe)

	req_access = list(access_syndicate)

	initial_modules = list(
		/obj/item/rig_module/mounted,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/fabricator/energy_net,
		/obj/item/rig_module/actuators/combat
		)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA

//Has most of the modules removed
/obj/item/rig/merc/empty
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/electrowarfare_suite, //might as well
		/obj/item/rig_module/actuators/combat // What the dude above me said.
		)

/obj/item/rig/merc/ninja
	initial_modules = list(
		/obj/item/rig_module/mounted,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/device/door_hack,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/fabricator/energy_net,
		/obj/item/rig_module/actuators/combat
		)

/obj/item/clothing/head/helmet/space/rig/merc/distress
	light_overlay = "helmet_light_rhino"
	light_color = "#7ffbf7"

/obj/item/rig/merc/distress
	name = "rhino hardsuit control module"
	desc = "A combat hardsuit utilized by many private military companies, packing some seriously heavy plating."
	icon = 'icons/clothing/rig/rhino.dmi'
	icon_state = "rhino"
	suit_type = "rhino hardsuit"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_MAJOR,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	siemens_coefficient = 0.1
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY
	emp_protection = 20

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs,/obj/item/material/twohanded/fireaxe)

	helm_type = /obj/item/clothing/head/helmet/space/rig/merc/distress

	req_access = list(access_distress)

	initial_modules = list(
		/obj/item/rig_module/mounted,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/fabricator/energy_net,
		/obj/item/rig_module/actuators/combat
		)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA

/obj/item/rig/merc/distress/ninja
	req_access = null

	initial_modules = list(
		/obj/item/rig_module/mounted,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/fabricator/energy_net,
		/obj/item/rig_module/device/door_hack,
		/obj/item/rig_module/actuators/combat
		)

/obj/item/rig/merc/einstein //For the Einstein Merc kit
	name = "paragon suit control module"
	desc = "A back mounted control mechanism of an Einstein Engines hardsuit. This model is issued to the leaders of security teams in the corporation."
	suit_type = "paragon"
	icon = 'icons/clothing/rig/apotheosis.dmi'
	icon_state = "apotheosis"
	icon_supported_species_tags = null
	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC, BODYTYPE_IPC_BISHOP, BODYTYPE_IPC_ZENGHU)

	initial_modules = list(
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/mounted/ion,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/electrowarfare_suite
		)
