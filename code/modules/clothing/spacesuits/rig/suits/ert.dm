/obj/item/clothing/head/helmet/space/rig/ert
	light_overlay = "helmet_light_dual"
	camera = /obj/machinery/camera/network/ert

/obj/item/rig/ert
	name = "ERT-C hardsuit control module"
	desc = "A suit worn by the commander of an Emergency Response Team. Has blue highlights."
	suit_type = "ERT commander"
	icon_state = "ert_commander_rig"
	emp_protection = 35
	helm_type = /obj/item/clothing/head/helmet/space/rig/ert
	req_access = list(access_cent_specops)
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 30, bio = 100, rad = 100)
	siemens_coefficient = 0.1
	allowed = list(
	/obj/item/device/flashlight, /obj/item/tank, /obj/item/device/t_scanner, /obj/item/rfd/construction, /obj/item/crowbar, \
	/obj/item/screwdriver, /obj/item/weldingtool, /obj/item/wirecutters, /obj/item/wrench, /obj/item/device/multitool, \
	/obj/item/device/radio, /obj/item/device/analyzer,/obj/item/storage/briefcase/inflatable, /obj/item/melee/baton, /obj/item/gun, \
	/obj/item/storage/firstaid, /obj/item/reagent_containers/hypospray, /obj/item/roller,/obj/item/material/twohanded/fireaxe)
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/vision/nvg,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/actuators/combat
		)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA

/obj/item/rig/ert/engineer
	name = "ERT-E suit control module"
	desc = "A suit worn by the engineering division of an Emergency Response Team. Has orange highlights. Less armored than the security variant, but offers full radiation protection."
	suit_type = "ERT engineer"
	icon_state = "ert_engineer_rig"
	emp_protection = 30
	armor = list(melee = 55, bullet = 45, laser = 30, energy = 15, bomb = 30, bio = 100, rad = 100)
	glove_type = /obj/item/clothing/gloves/rig/eva
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/mounted/plasmacutter,
		/obj/item/rig_module/device/rfd_c,
		/obj/item/rig_module/actuators
		)
	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_UTILITY

/obj/item/rig/ert/medical
	name = "ERT-M suit control module"
	desc = "A suit worn by the medical division of an Emergency Response Team. Has white highlights. Less armored than the security variant, but offers full radiation protection."
	suit_type = "ERT medic"
	icon_state = "ert_medical_rig"
	emp_protection = 30
	armor = list(melee = 55, bullet = 45, laser = 30, energy = 15, bomb = 30, bio = 100, rad = 100)
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/vision/medhud,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/chem_dispenser/injector,
		/obj/item/rig_module/actuators
		)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL

/obj/item/rig/ert/security
	name = "ERT-S suit control module"
	desc = "A suit worn by the security division of an Emergency Response Team. Has red highlights. Trades full radiation protection for a slightly better armor."
	suit_type = "ERT security"
	icon_state = "ert_security_rig"
	emp_protection = 30
	armor = list(melee = 65, bullet = 55, laser = 40, energy = 15, bomb = 30, bio = 100, rad = 80)
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/vision/sechud,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/actuators
		)
	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL

/obj/item/rig/ert/janitor
	name = "ERT-J suit control module"
	desc = "A suit worn by the janitoral division of an Emergency Response Team. Has purple highlights. Less armored than security the variant, but offers full radiation protection."
	suit_type = "ERT janitor"
	icon_state = "ert_janitor_rig"
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/fabricator/sign,
		/obj/item/rig_module/grenade_launcher/cleaner,
		/obj/item/rig_module/device/decompiler,
		/obj/item/rig_module/actuators
		)
	armor = list(melee = 55, bullet = 45, laser = 30, energy = 15, bomb = 30, bio = 100, rad = 100)
	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL

/obj/item/rig/ert/assetprotection
	name = "heavy asset protection suit control module"
	desc = "A heavy suit worn by the highest level of Asset Protection, don't mess with the person wearing this. Armored and space ready."
	suit_type = "heavy asset protection"
	icon_state = "asset_protection_rig"
	armor = list(melee = 80, bullet = 75, laser = 60, energy = 40, bomb = 80, bio = 100, rad =100)
	slowdown = 0
	emp_protection = 50

	species_restricted = list("Human")

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

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL | MODULE_MEDICAL | MODULE_UTILITY | MODULE_VAURCA // all modules

/obj/item/rig/ert/assetprotection/empty
	initial_modules = list()

/obj/item/rig/ert/assetprotection/einstein
	name = "apotheosis suit control module"
	desc = "A heavy suit with Einstein Engines branding coating it, not to mention the obvious colors."
	suit_type = "apotheosis"
	icon_state = "apotheosis"

	req_access = list()
	req_one_access = list()