/obj/item/clothing/head/helmet/space/rig/industrial
	camera = /obj/machinery/camera/network/mining
	light_overlay = "helmet_light_dual"
	light_color = "#ffcf2f"
	brightness_on = 6

/obj/item/clothing/head/helmet/space/rig/industrial/himeo
	light_overlay = "helmet_light_himeo"

/obj/item/clothing/suit/space/rig/industrial/himeo
	flags_inv = HIDEEARS|BLOCKHEADHAIR|HIDETAIL

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
	icon = 'icons/clothing/rig/tie.dmi'
	icon_state = "internalaffairs_rig"
	icon_supported_species_tags = null
	armor = null
	siemens_coefficient = 0.9
	slowdown = 0
	offline_slowdown = 0
	offline_vision_restriction = TINT_HEAVY

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/storage/briefcase,/obj/item/storage/secure/briefcase)

	req_access = list()
	req_one_access = list()

	helm_type = null
	suit_type = null
	glove_type = null
	boot_type = null

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA

/obj/item/rig/internalaffairs/equipped

	req_access = list(ACCESS_LAWYER)

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
	icon = 'icons/clothing/rig/industrial.dmi'
	icon_state = "industrial_rig"
	icon_supported_species_tags = list("ipc", "skr", "taj", "una")
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	siemens_coefficient = 0.35
	slowdown = 2
	offline_slowdown = 7
	offline_vision_restriction = TINT_HEAVY
	emp_protection = -20
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	min_pressure_protection = 0

	helm_type = /obj/item/clothing/head/helmet/space/rig/industrial
	chest_type = /obj/item/clothing/suit/space/rig/industrial

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/storage/bag/ore,/obj/item/pickaxe, /obj/item/gun/custom_ka,/obj/item/material/twohanded/fireaxe,/obj/item/gun/energy/vaurca/thermaldrill,/obj/item/storage/backpack/cell,/obj/item/rfd/mining)

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
		/obj/item/rig_module/actuators
		)

/obj/item/rig/industrial/syndicate

	helm_type = /obj/item/clothing/head/helmet/space/rig

/obj/item/rig/industrial/himeo
	name = "himean industrial suit control module"
	suit_type = "himean industrial hardsuit"
	desc = "A variant of the industrial suit used by the United Syndicates of Himeo."
	desc_extended = "A little too clunky, a little too slow; the Type-86 \"Cicada\" industrial hardsuit was released about a decade too late to be competitive. \
	Still, it enjoys modest popularity among those dissatisfied with the limits of the Type-76 'Fish Fur', such as Guard sappers or asteroid miners."
	icon_supported_species_tags = list("taj")
	icon = 'icons/clothing/rig/himeo_industrial.dmi'
	icon_state = "himeo_rig"
	species_restricted = list(BODYTYPE_HUMAN, BODYTYPE_IPC, BODYTYPE_TAJARA)

	helm_type = /obj/item/clothing/head/helmet/space/rig/industrial/himeo
	chest_type = /obj/item/clothing/suit/space/rig/industrial/himeo

/obj/item/rig/eva
	name = "EVA suit control module"
	suit_type = "EVA hardsuit"
	desc = "A light hardsuit for repairs and maintenance to the outside of habitats and vessels."
	icon = 'icons/clothing/rig/eva.dmi'
	icon_state = "eva_rig"
	icon_supported_species_tags = list("ipc", "skr", "taj", "una")
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_MINOR,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	slowdown = 0
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY

	helm_type = /obj/item/clothing/head/helmet/space/rig/eva
	glove_type = /obj/item/clothing/gloves/rig/eva

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/storage/bag/inflatable,/obj/item/device/t_scanner,/obj/item/rfd/construction,/obj/item/material/twohanded/fireaxe,/obj/item/storage/backpack/cell)

	req_access = list()
	req_one_access = list()

	allowed_module_types = MODULE_GENERAL | MODULE_UTILITY

/obj/item/rig/eva/equipped

	req_access = list(ACCESS_ENGINE_EQUIP)

	initial_modules = list(
		/obj/item/rig_module/device/basicdrill,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/rfd_c
		)

/obj/item/clothing/gloves/rig/eva
	siemens_coefficient = 0

/obj/item/rig/eva/equipped/pirate
	req_access = list(ACCESS_SYNDICATE)
	helm_type = /obj/item/clothing/head/helmet/space/rig/eva/pirate

/obj/item/clothing/head/helmet/space/rig/eva/pirate
	camera = /obj/machinery/camera/network/mercenary

/obj/item/rig/eva/pilot
	name = "pilot suit control module"
	suit_type = "Pilot hardsuit"
	desc = "A light hardsuit issued to SCC pilots, known as the wyvern hardsuit. It features light armor designed to protect the wearer from flak and shrapnel."
	icon = 'icons/clothing/rig/pilotsuit.dmi'
	icon_state = "pilot_rig"
	icon_supported_species_tags = list("ipc", "skr", "taj", "una")
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)

/obj/item/rig/eva/pilot/equipped

	req_access = list(ACCESS_BRIDGE_CREW)

	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/rig/ce
	name = "advanced voidsuit control module"
	suit_type = "advanced voidsuit"
	desc = "An advanced voidsuit that protects against hazardous, low pressure environments. Shines with a high polish."
	icon = 'icons/clothing/rig/ce.dmi'
	icon_state = "ce_rig"
	icon_supported_species_tags = list("ipc", "skr", "taj", "una")
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	slowdown = 0
	offline_slowdown = 3
	offline_vision_restriction = 0
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE / 1.5 // Good against fires, but not as good as a proper firesuit / atmos voidsuit
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	min_pressure_protection = 0

	helm_type = /obj/item/clothing/head/helmet/space/rig/ce
	glove_type = /obj/item/clothing/gloves/rig/ce
	boot_type = /obj/item/clothing/shoes/magboots/advance

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/storage/bag/ore,/obj/item/device/t_scanner,/obj/item/pickaxe,/obj/item/material/twohanded/fireaxe,/obj/item/rfd/construction,/obj/item/storage/backpack/cell,/obj/item/storage/toolbox,/obj/item/storage/bag/inflatable)

	req_access = list()
	req_one_access = list()

	allowed_module_types = MODULE_GENERAL | MODULE_UTILITY

/obj/item/rig/ce/equipped

	req_access = list(ACCESS_CE)

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/device/rfd_c,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/actuators
		)

/obj/item/clothing/gloves/rig/ce
	siemens_coefficient = 0

/obj/item/rig/hazmat
	name = "AMI control module"
	suit_type = "hazmat hardsuit"
	desc = "An Anomalous Material Interaction hardsuit that protects against the strangest energies the universe can throw at it."
	icon = 'icons/clothing/rig/hazmat.dmi'
	icon_state = "hazmat_rig"
	icon_supported_species_tags = list("ipc", "skr", "taj", "una")
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_PISTOL,
		energy = ARMOR_ENERGY_STRONG,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	siemens_coefficient = 0.50
	offline_vision_restriction = TINT_HEAVY
	emp_protection = 40

	helm_type = /obj/item/clothing/head/helmet/space/rig/hazmat

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/stack/flag,/obj/item/storage/box/excavation,/obj/item/pickaxe,/obj/item/device/healthanalyzer,/obj/item/device/measuring_tape,/obj/item/device/ano_scanner,/obj/item/device/depth_scanner,/obj/item/device/core_sampler,/obj/item/device/gps,/obj/item/device/beacon_locator,/obj/item/device/radio/beacon,/obj/item/pickaxe/hand,/obj/item/storage/bag/fossils,/obj/item/material/twohanded/fireaxe,/obj/item/device/breath_analyzer)

	req_access = list()
	req_one_access = list()

	allowed_module_types = MODULE_GENERAL | MODULE_UTILITY
	anomaly_protection = TRUE

/obj/item/rig/hazmat/equipped

	req_access = list(ACCESS_RD)

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/anomaly_scanner
		)

/obj/item/rig/medical
	name = "rescue suit control module"
	suit_type = "rescue hardsuit"
	desc = "A durable suit designed for medical rescue in high risk areas."
	icon = 'icons/clothing/rig/medical.dmi'
	icon_state = "medical_rig"
	icon_supported_species_tags = list("ipc", "skr", "taj", "una")
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	siemens_coefficient = 0.50
	slowdown = 1
	offline_slowdown = 2
	offline_vision_restriction = TINT_HEAVY

	helm_type = /obj/item/clothing/head/helmet/space/rig/medical

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/storage/firstaid,/obj/item/device/healthanalyzer,/obj/item/stack/medical,/obj/item/roller,/obj/item/material/twohanded/fireaxe,/obj/item/device/breath_analyzer,/obj/item/reagent_containers/blood)

	req_access = list()
	req_one_access = list()

	allowed_module_types = MODULE_GENERAL | MODULE_MEDICAL

/obj/item/rig/medical/equipped

	req_access = list(ACCESS_FIRST_RESPONDER)

	initial_modules = list(
		/obj/item/rig_module/chem_dispenser/injector/paramedic,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/vision/medhud,
		/obj/item/rig_module/actuators,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/rig/hazard
	name = "hazard hardsuit control module"
	suit_type = "hazard hardsuit"
	desc = "A security hardsuit designed for prolonged EVA in dangerous environments."
	icon = 'icons/clothing/rig/hazard.dmi'
	icon_state = "hazard_rig"
	icon_supported_species_tags = list("ipc", "skr", "taj", "una")
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY

	helm_type = /obj/item/clothing/head/helmet/space/rig/hazard

	allowed = list(/obj/item/gun,/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/melee/baton)

	req_access = list()
	req_one_access = list()

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT

/obj/item/rig/hazard/equipped

	req_access = list(ACCESS_BRIG)

	initial_modules = list(
		/obj/item/rig_module/vision/sechud,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/mounted/taser
		)

/obj/item/rig/hazard/equipped/pirate
	req_access = list(ACCESS_SYNDICATE)
	helm_type = /obj/item/clothing/head/helmet/space/rig/hazard/pirate

/obj/item/clothing/head/helmet/space/rig/hazard/pirate
	camera = /obj/machinery/camera/network/mercenary

/obj/item/rig/diving
	name = "diving suit control module"
	suit_type = "diving suit"
	desc = "A heavy hardsuit designated for operations under the water, you are not sure what it is doing here however."
	icon = 'icons/clothing/rig/diving.dmi'
	icon_state = "diving_rig"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	slowdown = 3
	offline_slowdown = 4
	offline_vision_restriction = TINT_HEAVY

	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/storage/bag/inflatable,/obj/item/device/t_scanner,/obj/item/rfd/construction)

	req_access = list()
	req_one_access = list()

	species_restricted = list(BODYTYPE_HUMAN)
