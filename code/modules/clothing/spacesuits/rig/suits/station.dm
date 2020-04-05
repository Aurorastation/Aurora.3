/obj/item/clothing/head/helmet/space/rig/industrial
	camera = /obj/machinery/camera/network/mining
	light_overlay = "helmet_light_dual"
	light_color = "#ffcf2f"
	brightness_on = 6

/obj/item/clothing/head/helmet/space/rig/ce
	camera = /obj/machinery/camera/network/engineering

/obj/item/clothing/head/helmet/space/rig/eva
	light_overlay = "helmet_light_dual"
	camera = /obj/machinery/camera/network/engineering

/obj/item/clothing/head/helmet/space/rig/hazmat
	light_overlay = "hardhat_light"
	camera = /obj/machinery/camera/network/research

/obj/item/clothing/head/helmet/space/rig/medical
	camera = /obj/machinery/camera/network/medbay

/obj/item/clothing/head/helmet/space/rig/hazard
	light_overlay = "helmet_light_dual"
	camera = /obj/machinery/camera/network/security

/obj/item/rig/internalaffairs
	name = "augmented tie"
	suit_type = "augmented suit"
	desc = "Prepare for paperwork."
	icon_state = "internalaffairs_rig"
	armor = null
	siemens_coefficient = 0.9
	slowdown = 0
	offline_slowdown = 0
	offline_vision_restriction = TINT_HEAVY

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/storage/briefcase,/obj/item/storage/secure/briefcase)

	req_access = list()
	req_one_access = list()

	glove_type = null
	helm_type = null
	boot_type = null

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA

/obj/item/rig/internalaffairs/equipped

	req_access = list(access_lawyer)

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/device/paperdispenser,
		/obj/item/rig_module/device/pen,
		/obj/item/rig_module/device/stamp
		)

	glove_type = null
	helm_type = null
	boot_type = null

/obj/item/rig/industrial
	name = "industrial suit control module"
	suit_type = "industrial hardsuit"
	desc = "A heavy, powerful hardsuit used by construction crews and mining corporations."
	icon_state = "industrial_rig"
	armor = list(melee = 60, bullet = 40, laser = 30, energy = 15, bomb = 30, bio = 100, rad = 50)
	siemens_coefficient = 0.35
	slowdown = 2
	offline_slowdown = 7
	offline_vision_restriction = TINT_HEAVY
	emp_protection = -20

	helm_type = /obj/item/clothing/head/helmet/space/rig/industrial
	chest_type = /obj/item/clothing/suit/space/rig/industrial

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/storage/bag/ore,/obj/item/pickaxe, /obj/item/gun/custom_ka,/obj/item/material/twohanded/fireaxe,/obj/item/gun/energy/vaurca/thermaldrill)

	req_access = list()
	req_one_access = list()

	allowed_module_types = MODULE_GENERAL | MODULE_UTILITY

/obj/item/clothing/suit/space/rig/industrial
	flags_inv = HIDETAIL

/obj/item/rig/industrial/equipped

	initial_modules = list(
		/obj/item/rig_module/mounted/plasmacutter,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/device/orescanner,
		/obj/item/rig_module/device/rfd_c,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/actuators
		)

/obj/item/rig/industrial/syndicate

	helm_type = /obj/item/clothing/head/helmet/space/rig

/obj/item/rig/eva
	name = "EVA suit control module"
	suit_type = "EVA hardsuit"
	desc = "A light hardsuit for repairs and maintenance to the outside of habitats and vessels."
	icon_state = "eva_rig"
	armor = list(melee = 30, bullet = 10, laser = 20, energy = 25, bomb = 20, bio = 100, rad = 100)
	slowdown = 0
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY

	helm_type = /obj/item/clothing/head/helmet/space/rig/eva
	glove_type = /obj/item/clothing/gloves/rig/eva

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/storage/toolbox,/obj/item/storage/briefcase/inflatable,/obj/item/device/t_scanner,/obj/item/rfd/construction,/obj/item/material/twohanded/fireaxe)

	req_access = list()
	req_one_access = list()

	allowed_module_types = MODULE_GENERAL | MODULE_UTILITY

/obj/item/rig/eva/equipped

	req_access = list(access_engine_equip)

	initial_modules = list(
		/obj/item/rig_module/device/basicdrill,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/rfd_c,
		/obj/item/rig_module/vision/meson
		)

/obj/item/clothing/gloves/rig/eva
	siemens_coefficient = 0

/obj/item/rig/ce

	name = "advanced voidsuit control module"
	suit_type = "advanced voidsuit"
	desc = "An advanced voidsuit that protects against hazardous, low pressure environments. Shines with a high polish."
	icon_state = "ce_rig"
	armor = list(melee = 40, bullet = 10, laser = 30,energy = 25, bomb = 40, bio = 100, rad = 100)
	slowdown = 0
	offline_slowdown = 3
	offline_vision_restriction = 0
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE / 1.5 // Good against fires, but not as good as a proper firesuit / atmos voidsuit

	helm_type = /obj/item/clothing/head/helmet/space/rig/ce
	glove_type = /obj/item/clothing/gloves/rig/ce

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/storage/bag/ore,/obj/item/device/t_scanner,/obj/item/pickaxe,/obj/item/material/twohanded/fireaxe,/obj/item/rfd/construction)

	req_access = list()
	req_one_access = list()

	allowed_module_types = MODULE_GENERAL | MODULE_UTILITY

/obj/item/rig/ce/equipped

	req_access = list(access_ce)

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/device/rfd_c,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/actuators
		)

/obj/item/clothing/gloves/rig/ce
	siemens_coefficient = 0

/obj/item/rig/hazmat

	name = "AMI control module"
	suit_type = "hazmat hardsuit"
	desc = "An Anomalous Material Interaction hardsuit that protects against the strangest energies the universe can throw at it."
	icon_state = "hazmat_rig"
	armor = list(melee = 45, bullet = 5, laser = 40, energy = 65, bomb = 60, bio = 100, rad = 100)
	siemens_coefficient = 0.50
	offline_vision_restriction = TINT_HEAVY
	emp_protection = 40

	helm_type = /obj/item/clothing/head/helmet/space/rig/hazmat

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/stack/flag,/obj/item/storage/box/excavation,/obj/item/pickaxe,/obj/item/device/healthanalyzer,/obj/item/device/measuring_tape,/obj/item/device/ano_scanner,/obj/item/device/depth_scanner,/obj/item/device/core_sampler,/obj/item/device/gps,/obj/item/device/beacon_locator,/obj/item/device/radio/beacon,/obj/item/pickaxe/hand,/obj/item/storage/bag/fossils,/obj/item/material/twohanded/fireaxe,/obj/item/device/breath_analyzer)

	req_access = list()
	req_one_access = list()

	allowed_module_types = MODULE_GENERAL | MODULE_UTILITY

/obj/item/rig/hazmat/equipped

	req_access = list(access_rd)

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/anomaly_scanner
		)

/obj/item/rig/medical
	name = "rescue suit control module"
	suit_type = "rescue hardsuit"
	desc = "A durable suit designed for medical rescue in high risk areas."
	icon_state = "medical_rig"
	armor = list(melee = 30, bullet = 15, laser = 20, energy = 60, bomb = 30, bio = 100, rad = 100)
	siemens_coefficient = 0.50
	slowdown = 0
	offline_slowdown = 2
	offline_vision_restriction = TINT_HEAVY

	helm_type = /obj/item/clothing/head/helmet/space/rig/medical

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/storage/firstaid,/obj/item/device/healthanalyzer,/obj/item/stack/medical,/obj/item/roller,/obj/item/material/twohanded/fireaxe,/obj/item/device/breath_analyzer)

	req_access = list()
	req_one_access = list()

	allowed_module_types = MODULE_GENERAL | MODULE_MEDICAL

/obj/item/rig/medical/equipped

	req_access = list(access_paramedic)

	initial_modules = list(
		/obj/item/rig_module/chem_dispenser/injector/paramedic,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/vision/medhud,
		/obj/item/rig_module/actuators
		)

/obj/item/rig/hazard
	name = "hazard hardsuit control module"
	suit_type = "hazard hardsuit"
	desc = "A security hardsuit designed for prolonged EVA in dangerous environments."
	icon_state = "hazard_rig"
	armor = list(melee = 60, bullet = 45, laser = 30, energy = 15, bomb = 60, bio = 100, rad = 45)
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY

	helm_type = /obj/item/clothing/head/helmet/space/rig/hazard

	allowed = list(/obj/item/gun,/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/melee/baton)

	req_access = list()
	req_one_access = list()

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT

/obj/item/rig/hazard/equipped

	req_access = list(access_brig)

	initial_modules = list(
		/obj/item/rig_module/vision/sechud,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/mounted/taser
		)

/obj/item/rig/hazard/equipped/pirate
	req_access = list(access_syndicate)
	helm_type = /obj/item/clothing/head/helmet/space/rig/hazard/pirate

/obj/item/clothing/head/helmet/space/rig/hazard/pirate
	camera = /obj/machinery/camera/network/mercenary

/obj/item/rig/diving
	name = "diving suit control module"
	suit_type = "diving suit"
	desc = "A heavy hardsuit designated for operations under the water, you are not sure what it is doing here however."
	icon_state = "diving_rig"
	armor = list(melee = 30, bullet = 10, laser = 20, energy = 25, bomb = 20, bio = 100, rad = 100)
	slowdown = 3
	offline_slowdown = 4
	offline_vision_restriction = TINT_HEAVY

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/storage/toolbox,/obj/item/storage/briefcase/inflatable,/obj/item/device/t_scanner,/obj/item/rfd/construction)

	req_access = list()
	req_one_access = list()

	species_restricted = list("Human")
