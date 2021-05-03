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
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_RESISTANT,
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
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_RESISTANT,
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