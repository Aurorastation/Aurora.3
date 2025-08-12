/obj/item/clothing/head/helmet/space/rig/ert
	light_overlay = "helmet_light_dual"
	camera = /obj/machinery/camera/network/ert

/obj/item/rig/ert
	name = "ERT-C hardsuit control module"
	desc = "A suit worn by the commander of an Emergency Response Team. Has blue highlights."
	suit_type = "ERT commander"
	icon = 'icons/obj/item/clothing/rig/nt_ert/commander.dmi'
	icon_state = "ert_commander_rig"
	icon_supported_species_tags = list("skr")
	emp_protection = 35
	helm_type = /obj/item/clothing/head/helmet/space/rig/ert
	boot_type =  /obj/item/clothing/shoes/magboots/rig/heavy
	req_access = list(ACCESS_CENT_SPECOPS)
	species_restricted = list(BODYTYPE_SKRELL,BODYTYPE_HUMAN)
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_PISTOL,
		LASER = ARMOR_LASER_SMALL,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SHIELDED
	)
	siemens_coefficient = 0.1
	allowed = list(
	/obj/item/device/flashlight, /obj/item/tank, /obj/item/device/t_scanner, /obj/item/rfd/construction, /obj/item/crowbar, \
	/obj/item/screwdriver, /obj/item/weldingtool, /obj/item/wirecutters, /obj/item/wrench, /obj/item/device/multitool, \
	/obj/item/device/radio, /obj/item/device/analyzer, /obj/item/storage/bag/inflatable, /obj/item/melee/baton, /obj/item/gun, \
	/obj/item/storage/firstaid, /obj/item/reagent_containers/hypospray, /obj/item/roller,/obj/item/material/twohanded/fireaxe)
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/vision/nvg,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/recharger
		)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA

/obj/item/rig/ert/engineer
	name = "ERT-E suit control module"
	desc = "A suit worn by the engineering division of an Emergency Response Team. Has orange highlights. Less armored than the security variant, but offers full radiation protection."
	suit_type = "ERT engineer"
	icon = 'icons/obj/item/clothing/rig/nt_ert/engineer.dmi'
	icon_state = "ert_engineer_rig"
	emp_protection = 30
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_PISTOL,
		LASER = ARMOR_LASER_SMALL,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SHIELDED
	)
	glove_type = /obj/item/clothing/gloves/rig/eva
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/mounted/plasmacutter,
		/obj/item/rig_module/device/rfd_c,
		/obj/item/rig_module/actuators,
		/obj/item/rig_module/recharger
		)
	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_UTILITY

/obj/item/rig/ert/medical
	name = "ERT-M suit control module"
	desc = "A suit worn by the medical division of an Emergency Response Team. Has white highlights. Less armored than the security variant, but offers full radiation protection."
	suit_type = "ERT medic"
	icon = 'icons/obj/item/clothing/rig/nt_ert/medical.dmi'
	icon_state = "ert_medical_rig"
	emp_protection = 30
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_PISTOL,
		LASER = ARMOR_LASER_SMALL,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SHIELDED
	)
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/vision/medhud,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/chem_dispenser/injector,
		/obj/item/rig_module/actuators,
		/obj/item/rig_module/recharger
		)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL

/obj/item/rig/ert/security
	name = "ERT-S suit control module"
	desc = "A suit worn by the security division of an Emergency Response Team. Has red highlights. Trades full radiation protection for a slightly better armor."
	suit_type = "ERT security"
	icon = 'icons/obj/item/clothing/rig/nt_ert/security.dmi'
	icon_state = "ert_security_rig"
	emp_protection = 30
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_PISTOL,
		LASER = ARMOR_LASER_PISTOL,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SHIELDED
	)
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/vision/sechud,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/actuators,
		/obj/item/rig_module/recharger
		)
	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL

/obj/item/rig/ert/scc
	name = "\improper SCC ERT-C hardsuit control module"
	desc = "A suit worn by the commander of an Emergency Response Team sent to crisis situations by the Stellar Corporate Conglomerate. This one features SCC colouring."
	suit_type = "SCC ERT commander"
	icon = 'icons/obj/item/clothing/rig/scc_ert/commander.dmi'
	icon_state = "scc_rig"
	icon_supported_species_tags = null
	species_restricted = list(BODYTYPE_HUMAN)

	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_RIFLE,
		LASER = ARMOR_LASER_RIFLE,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_RESISTANT,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SHIELDED
	)

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/vision/nvg,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/storage,
		/obj/item/rig_module/recharger
		)

/obj/item/rig/ert/scc/engineer
	name = "\improper SCC ERT-E hardsuit control module"
	desc = "A suit worn by the engineer of an Emergency Response Team sent to crisis situations by the Stellar Corporate Conglomerate. This one features SCC colouring."
	suit_type = "SCC ERT engineer"
	icon = 'icons/obj/item/clothing/rig/scc_ert/engineer.dmi'
	icon_state = "scc_rig"

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_UTILITY

/obj/item/rig/ert/scc/medical
	name = "\improper SCC ERT-M hardsuit control module"
	desc = "A suit worn by the medical specialist of an Emergency Response Team sent to crisis situations by the Stellar Corporate Conglomerate. This one features SCC colouring."
	suit_type = "SCC ERT medic"
	icon = 'icons/obj/item/clothing/rig/scc_ert/medic.dmi'
	icon_state = "scc_rig"

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL

/obj/item/rig/ert/scc/security
	name = "\improper SCC ERT-S hardsuit control module"
	desc = "A suit worn by the security specialist of an Emergency Response Team sent to crisis situations by the Stellar Corporate Conglomerate. This one features SCC colouring."
	suit_type = "SCC ERT security"
	icon = 'icons/obj/item/clothing/rig/scc_ert/security.dmi'
	icon_state = "scc_rig"

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL

/obj/item/rig/ert/einstein
	name = "apotheosis suit control module"
	desc = "A heavy suit with Einstein Engines branding coating it, not to mention the obvious colors."
	suit_type = "apotheosis"
	icon = 'icons/obj/item/clothing/rig/apotheosis.dmi'
	icon_state = "apotheosis"
	armor = list(
		MELEE = ARMOR_MELEE_MAJOR,
		BULLET = ARMOR_BALLISTIC_RIFLE,
		LASER = ARMOR_LASER_RIFLE,
		ENERGY = ARMOR_ENERGY_SMALL,
		BOMB = ARMOR_BOMB_RESISTANT,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SHIELDED
	)
	req_access = list()
	req_one_access = list()
	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_UTILITY
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/vision/nvg,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/storage,
		/obj/item/rig_module/recharger
	)

/obj/item/rig/ert/assetprotection
	name = "\improper heavy asset protection suit control module"
	desc = "A heavy suit worn by the highest level of Asset Protection, don't mess with the person wearing this. Armored and space ready."
	suit_type = "heavy asset protection"
	icon = 'icons/obj/item/clothing/rig/asset_protection.dmi'
	icon_state = "asset_protection_rig"
	icon_supported_species_tags = null
	armor = list(
		MELEE = ARMOR_MELEE_SHIELDED,
		BULLET = ARMOR_BALLISTIC_RIFLE,
		LASER = ARMOR_LASER_RIFLE,
		ENERGY = ARMOR_ENERGY_STRONG,
		BOMB = ARMOR_BOMB_PADDED,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SHIELDED
	)
	slowdown = 0
	emp_protection = 50
	boot_type =  /obj/item/clothing/shoes/magboots/rig/chonk
	species_restricted = list(BODYTYPE_HUMAN)

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
		/obj/item/rig_module/recharger
		)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA // all modules

/obj/item/rig/ert/assetprotection/empty
	initial_modules = list()

/obj/item/rig/ert/ntassetprotection
	name = "\improper heavy asset protection suit control module"
	desc = "A heavy suit worn by the highest level of Asset Protection, don't mess with the person wearing this. Armored and space ready."
	suit_type = "heavy asset protection"
	icon = 'icons/obj/item/clothing/rig/nt_asset_protection.dmi'
	icon_state = "asset_protection_rig"
	icon_supported_species_tags = null
	armor = list(
		MELEE = ARMOR_MELEE_SHIELDED,
		BULLET = ARMOR_BALLISTIC_RIFLE,
		LASER = ARMOR_LASER_HEAVY,
		ENERGY = ARMOR_ENERGY_SHIELDED,
		BOMB = ARMOR_BOMB_RESISTANT,
		BIO = ARMOR_BIO_SHIELDED,
		RAD = ARMOR_RAD_SHIELDED
	)
	slowdown = 0
	emp_protection = 50

	species_restricted = list(BODYTYPE_HUMAN)

	boot_type =  /obj/item/clothing/shoes/magboots/rig/chonk

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
		/obj/item/rig_module/recharger
		)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA // all modules

/obj/item/rig/ert/ntassetprotection/lead
	icon = 'icons/obj/item/clothing/rig/nt_asset_protection_commander.dmi'
	icon_state = "c_asset_protection_rig"
