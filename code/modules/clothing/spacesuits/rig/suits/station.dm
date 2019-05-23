/obj/item/clothing/head/helmet/space/rig/industrial
	camera_networks = list(NETWORK_MINE)

/obj/item/clothing/head/helmet/space/rig/ce
	camera_networks = list(NETWORK_ENGINEERING)

/obj/item/clothing/head/helmet/space/rig/eva
	light_overlay = "helmet_light_dual"
	camera_networks = list(NETWORK_ENGINEERING)

/obj/item/clothing/head/helmet/space/rig/hazmat
	light_overlay = "hardhat_light"
	camera_networks = list(NETWORK_RESEARCH)

/obj/item/clothing/head/helmet/space/rig/medical
	camera_networks = list(NETWORK_MEDICAL)

/obj/item/clothing/head/helmet/space/rig/hazard
	light_overlay = "helmet_light_dual"
	camera_networks = list(NETWORK_SECURITY)

/obj/item/weapon/rig/internalaffairs
	name = "augmented tie"
	suit_type = "augmented suit"
	desc = "Prepare for paperwork."
	icon_state = "internalaffairs_rig"
	armor = null
	siemens_coefficient = 0.9
	slowdown = 0
	offline_slowdown = 0
	offline_vision_restriction = TINT_HEAVY

	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/briefcase,/obj/item/weapon/storage/secure/briefcase)

	req_access = list()
	req_one_access = list()

	glove_type = null
	helm_type = null
	boot_type = null

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA

/obj/item/weapon/rig/internalaffairs/equipped

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

/obj/item/weapon/rig/industrial
	name = "industrial suit control module"
	suit_type = "industrial hardsuit"
	desc = "A heavy, powerful rig used by construction crews and mining corporations."
	icon_state = "industrial_rig"
	armor = list(melee = 60, bullet = 40, laser = 30, energy = 15, bomb = 30, bio = 100, rad = 50)
	slowdown = 2
	offline_slowdown = 7
	offline_vision_restriction = TINT_HEAVY
	emp_protection = -20

	helm_type = /obj/item/clothing/head/helmet/space/rig/industrial

	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/bag/ore,/obj/item/weapon/pickaxe, /obj/item/weapon/gun/custom_ka, /obj/item/weapon/gun/energy/vaurca/thermaldrill)

	req_access = list()
	req_one_access = list()

	allowed_module_types = MODULE_GENERAL | MODULE_UTILITY

/obj/item/weapon/rig/industrial/equipped

	initial_modules = list(
		/obj/item/rig_module/mounted/plasmacutter,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/device/orescanner,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/actuators
		)

/obj/item/weapon/rig/industrial/syndicate

	helm_type = /obj/item/clothing/head/helmet/space/rig

/obj/item/weapon/rig/eva
	name = "EVA suit control module"
	suit_type = "EVA hardsuit"
	desc = "A light rig for repairs and maintenance to the outside of habitats and vessels."
	icon_state = "eva_rig"
	armor = list(melee = 30, bullet = 10, laser = 20, energy = 25, bomb = 20, bio = 100, rad = 100)
	slowdown = 0
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY

	helm_type = /obj/item/clothing/head/helmet/space/rig/eva
	glove_type = /obj/item/clothing/gloves/rig/eva

	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/toolbox,/obj/item/weapon/storage/briefcase/inflatable,/obj/item/device/t_scanner,/obj/item/weapon/rcd)

	req_access = list()
	req_one_access = list()

	allowed_module_types = MODULE_GENERAL | MODULE_UTILITY

/obj/item/weapon/rig/eva/equipped

	req_access = list(access_engine_equip)

	initial_modules = list(
		/obj/item/rig_module/device/basicdrill,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/vision/meson
		)

/obj/item/clothing/gloves/rig/eva
	siemens_coefficient = 0

/obj/item/weapon/rig/ce

	name = "advanced voidsuit control module"
	suit_type = "advanced voidsuit"
	desc = "An advanced voidsuit that protects against hazardous, low pressure environments. Shines with a high polish."
	icon_state = "ce_rig"
	armor = list(melee = 40, bullet = 10, laser = 30,energy = 25, bomb = 40, bio = 100, rad = 100)
	slowdown = 0
	offline_slowdown = 3
	offline_vision_restriction = 0
	max_heat_protection_temperature = 7500

	helm_type = /obj/item/clothing/head/helmet/space/rig/ce
	glove_type = /obj/item/clothing/gloves/rig/ce

	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/bag/ore,/obj/item/device/t_scanner,/obj/item/weapon/pickaxe, /obj/item/weapon/rcd)

	req_access = list()
	req_one_access = list()

	allowed_module_types = MODULE_GENERAL | MODULE_UTILITY

/obj/item/weapon/rig/ce/equipped

	req_access = list(access_ce)

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/actuators
		)

/obj/item/clothing/gloves/rig/ce
	siemens_coefficient = 0

/obj/item/weapon/rig/hazmat

	name = "AMI control module"
	suit_type = "hazmat hardsuit"
	desc = "An Anomalous Material Interaction hardsuit that protects against the strangest energies the universe can throw at it."
	icon_state = "hazmat_rig"
	armor = list(melee = 45, bullet = 5, laser = 40, energy = 65, bomb = 60, bio = 100, rad = 100)
	offline_vision_restriction = TINT_HEAVY
	emp_protection = 40

	helm_type = /obj/item/clothing/head/helmet/space/rig/hazmat

	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/stack/flag,/obj/item/weapon/storage/box/excavation,/obj/item/weapon/pickaxe,/obj/item/device/healthanalyzer,/obj/item/device/measuring_tape,/obj/item/device/ano_scanner,/obj/item/device/depth_scanner,/obj/item/device/core_sampler,/obj/item/device/gps,/obj/item/device/beacon_locator,/obj/item/device/radio/beacon,/obj/item/weapon/pickaxe/hand,/obj/item/weapon/storage/bag/fossils, /obj/item/device/breath_analyzer)

	req_access = list()
	req_one_access = list()

	allowed_module_types = MODULE_GENERAL | MODULE_UTILITY

/obj/item/weapon/rig/hazmat/equipped

	req_access = list(access_rd)

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/anomaly_scanner
		)

/obj/item/weapon/rig/medical
	name = "rescue suit control module"
	suit_type = "rescue hardsuit"
	desc = "A durable suit designed for medical rescue in high risk areas."
	icon_state = "medical_rig"
	armor = list(melee = 30, bullet = 15, laser = 20, energy = 60, bomb = 30, bio = 100, rad = 100)
	slowdown = 0
	offline_slowdown = 2
	offline_vision_restriction = TINT_HEAVY

	helm_type = /obj/item/clothing/head/helmet/space/rig/medical

	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/firstaid,/obj/item/device/healthanalyzer,/obj/item/stack/medical,/obj/item/roller, /obj/item/device/breath_analyzer )

	req_access = list()
	req_one_access = list()

	allowed_module_types = MODULE_GENERAL | MODULE_MEDICAL

/obj/item/weapon/rig/medical/equipped

	req_access = list(access_paramedic)

	initial_modules = list(
		/obj/item/rig_module/chem_dispenser/injector/paramedic,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/vision/medhud,
		/obj/item/rig_module/actuators
		)

/obj/item/weapon/rig/hazard
	name = "hazard hardsuit control module"
	suit_type = "hazard hardsuit"
	desc = "A security hardsuit designed for prolonged EVA in dangerous environments."
	icon_state = "hazard_rig"
	armor = list(melee = 60, bullet = 45, laser = 30, energy = 15, bomb = 60, bio = 100, rad = 45)
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY

	helm_type = /obj/item/clothing/head/helmet/space/rig/hazard

	allowed = list(/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/melee/baton)

	req_access = list()
	req_one_access = list()

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT

/obj/item/weapon/rig/hazard/equipped

	req_access = list(access_brig)

	initial_modules = list(
		/obj/item/rig_module/vision/sechud,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/mounted/taser
		)

/obj/item/weapon/rig/hazard/equipped/pirate
	req_access = list(access_syndicate)
	helm_type = /obj/item/clothing/head/helmet/space/rig/hazard/pirate

/obj/item/clothing/head/helmet/space/rig/hazard/pirate
	camera_networks = list()

/obj/item/weapon/rig/diving
	name = "diving suit control module"
	suit_type = "diving suit"
	desc = "A heavy rig designated for operations under the water, you are not sure what it is doing here however."
	icon_state = "diving_rig"
	armor = list(melee = 30, bullet = 10, laser = 20, energy = 25, bomb = 20, bio = 100, rad = 100)
	slowdown = 3
	offline_slowdown = 4
	offline_vision_restriction = TINT_HEAVY

	chest_type = /obj/item/clothing/suit/space/rig/diving
	helm_type = /obj/item/clothing/head/helmet/space/rig/diving
	boot_type = /obj/item/clothing/shoes/magboots/rig/diving

	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/toolbox,/obj/item/weapon/storage/briefcase/inflatable,/obj/item/device/t_scanner,/obj/item/weapon/rcd)

	req_access = list()
	req_one_access = list()

/obj/item/clothing/head/helmet/space/rig/diving
	species_restricted = list("Human")

/obj/item/clothing/suit/space/rig/diving
	species_restricted = list("Human")

/obj/item/clothing/shoes/magboots/rig/diving
	species_restricted = list("Human")